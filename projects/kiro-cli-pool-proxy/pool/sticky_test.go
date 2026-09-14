package pool

import (
	"encoding/json"
	"os"
	"testing"
	"time"

	"kiro-cli-pool-proxy/config"
)

func newStickyTestPool(t *testing.T, accounts ...config.Account) (*Pool, *config.Config) {
	t.Helper()
	path := t.TempDir() + "/config.json"
	cfgJSON := struct {
		ListenAddr string            `json:"listenAddr"`
		Strategy   string            `json:"strategy"`
		Accounts   []config.Account  `json:"accounts"`
	}{
		ListenAddr: "127.0.0.1:0",
		Strategy:   "round-robin",
		Accounts:   accounts,
	}
	data, err := json.Marshal(cfgJSON)
	if err != nil {
		t.Fatalf("marshal config: %v", err)
	}
	if err := os.WriteFile(path, data, 0600); err != nil {
		t.Fatalf("write config: %v", err)
	}
	cfg, err := config.Load(path)
	if err != nil {
		t.Fatalf("load config: %v", err)
	}
	return New(cfg), cfg
}

func TestStickyReusesSameAccountWithinTTL(t *testing.T) {
	p, _ := newStickyTestPool(t,
		config.Account{ID: "a", Enabled: true, AccessToken: "x"},
		config.Account{ID: "b", Enabled: true, AccessToken: "y"},
	)
	excluded := map[string]bool{}

	first := p.AccountForSticky("k1", excluded)
	if first == nil {
		t.Fatal("no account available")
	}
	p.SetSticky("k1", first.ID)

	for i := 0; i < 5; i++ {
		got := p.AccountForSticky("k1", excluded)
		if got == nil || got.ID != first.ID {
			t.Fatalf("sticky broke on turn %d: got %v, want %s", i, got, first.ID)
		}
	}
}

func TestStickyFallsBackWhenAccountDisabled(t *testing.T) {
	p, cfg := newStickyTestPool(t,
		config.Account{ID: "a", Enabled: true, AccessToken: "x"},
		config.Account{ID: "b", Enabled: true, AccessToken: "y"},
	)
	excluded := map[string]bool{}
	first := p.AccountForSticky("k1", excluded)
	p.SetSticky("k1", first.ID)

	cfg.DisableAccount(first.ID)
	got := p.AccountForSticky("k1", excluded)
	if got == nil || got.ID == first.ID {
		t.Fatalf("expected fallback after disable, got %v", got)
	}
}

func TestStickyFallsBackWhenAccountCooling(t *testing.T) {
	p, _ := newStickyTestPool(t,
		config.Account{ID: "a", Enabled: true, AccessToken: "x"},
		config.Account{ID: "b", Enabled: true, AccessToken: "y"},
	)
	excluded := map[string]bool{}
	first := p.AccountForSticky("k1", excluded)
	p.SetSticky("k1", first.ID)

	p.RecordFailure(first.ID, 429, "rate limited") // 30s cooldown
	got := p.AccountForSticky("k1", excluded)
	if got == nil || got.ID == first.ID {
		t.Fatalf("expected fallback while cooling, got %v", got)
	}
	// Cooldown expiry restores the binding.
	p.RecordSuccess(first.ID)
	got = p.AccountForSticky("k1", excluded)
	if got == nil || got.ID != first.ID {
		t.Fatalf("expected sticky restored after cooldown, got %v", got)
	}
}

func TestStickyExpiry(t *testing.T) {
	p, _ := newStickyTestPool(t,
		config.Account{ID: "a", Enabled: true, AccessToken: "x"},
		config.Account{ID: "b", Enabled: true, AccessToken: "y"},
	)
	excluded := map[string]bool{}
	first := p.AccountForSticky("k1", excluded)
	p.SetSticky("k1", first.ID)

	// Force expiry.
	p.mu.Lock()
	for k, e := range p.sticky {
		e.expiry = time.Now().Add(-time.Second)
		p.sticky[k] = e
	}
	p.mu.Unlock()

	got := p.AccountForSticky("k1", excluded)
	if got == nil {
		t.Fatal("expected fallback account after expiry")
	}
	// After expiry + fallback, a successful dispatch re-binds.
	p.SetSticky("k1", got.ID)
	if again := p.AccountForSticky("k1", excluded); again == nil || again.ID != got.ID {
		t.Fatalf("expected re-bind to %s, got %v", got.ID, again)
	}
}

func TestStickyReloadRemovesBindingsToRemovedAccounts(t *testing.T) {
	p, cfg := newStickyTestPool(t,
		config.Account{ID: "a", Enabled: true, AccessToken: "x"},
		config.Account{ID: "b", Enabled: true, AccessToken: "y"},
	)
	excluded := map[string]bool{}
	first := p.AccountForSticky("k1", excluded)
	p.SetSticky("k1", first.ID)

	// Remove the sticky account from config (exported field; single-threaded
	// test, Reload only reads the slice).
	kept := cfg.Accounts[:0]
	for _, acc := range cfg.Accounts {
		if acc.ID != first.ID {
			kept = append(kept, acc)
		}
	}
	cfg.Accounts = kept
	p.Reload()

	got := p.AccountForSticky("k1", excluded)
	if got == nil || got.ID == first.ID {
		t.Fatalf("expected fallback after account removal, got %v", got)
	}
}

func TestStickyNotUsedAcrossKeys(t *testing.T) {
	p, _ := newStickyTestPool(t,
		config.Account{ID: "a", Enabled: true, AccessToken: "x"},
		config.Account{ID: "b", Enabled: true, AccessToken: "y"},
	)
	excluded := map[string]bool{}
	first := p.AccountForSticky("k1", excluded)
	p.SetSticky("k1", first.ID)

	got := p.AccountForSticky("different-key", excluded)
	if got == nil {
		t.Fatal("expected rotation for unknown sticky key")
	}
}
