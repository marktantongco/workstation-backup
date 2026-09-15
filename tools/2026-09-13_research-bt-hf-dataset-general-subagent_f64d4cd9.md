# Research BT + HF dataset (@general subagent)

- **Session ID:** `ses_f64d4cd9bffeyH3hjIEUVv0Gry`
- **Directory:** /home/x3/workspace
- **Started:** 2026-09-13 22:28:14
- **Last activity:** 2026-09-13 22:32:16
- **Messages:** 14

---

### 🧑 User — 2026-09-13 22:28:15

Two research targets (public packages/data only, no scraping):

1. arena-rank Bradley-Terry: `pip show arena-rank` / `pip download arena-rank --no-deps -d /tmp/ar` then read its BT implementation (find .py files computing ratings). Report the exact math: win/tie weight handling, scale/offset (e.g. Elo-like 400 scale?), initialization, iteration method (MM algorithm? logistic regression?), convergence criteria, and how it orders models. Quote the core function (under 60 lines). If pip unavailable, use web_search + webfetch of github.com/lmarena/arena-rank source.

2. HuggingFace lmarena-ai/leaderboard-dataset: list files via `https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset` (curl + python3 json). Report: configs, file formats (parquet/csv/json?), file sizes, column names for the text leaderboard (need: model names + rating columns). Prefer smallest file giving model→rating mapping. Also check arena-human-preference-140k file list + columns (for bulk-import format reference only).

Facts + exact math/columns/sizes/URLs, under 1200 words. No repo changes.

---

### 🤖 Assistant — 2026-09-13 22:28:15

**tool:todowrite** (completed) 2 todos

```
todos=[{'content': 'Research arena-rank BT implementation', 'status': 'in_progress', '
--- output ---
[
  {
    "content": "Research arena-rank BT implementation",
    "status": "in_progress",
    "priority": "high"
  },
  {
    "content": "Research HF leaderboard-dataset files + columns",
    "status": "pending",
    "priority": "high"
  }
]
```

---

### 🤖 Assistant — 2026-09-13 22:28:20

Need bash tool, but only have default.* tools. Check available: default.bash exists. Use that.



**tool:bash** (completed) rtk pip show arena-rank 2>&1; echo "---DOWNLOAD---"; mkdir -p /tmp/ar && pip download arena-rank --no-deps -d /tmp/ar 2>&1 | tail -5; echo "---LIST---"; rtk ls -la /tmp/ar/

```
command=rtk pip show arena-rank 2>&1; echo "---DOWNLOAD---"; mkdir -p /tmp/ar && pip dow
--- output ---
WARNING: Package(s) not found: arena-rank
---DOWNLOAD---
Collecting arena-rank
  Downloading arena_rank-0.1.1-py3-none-any.whl.metadata (4.3 kB)
Downloading arena_rank-0.1.1-py3-none-any.whl (43 kB)
Saved /tmp/ar/arena_rank-0.1.1-py3-none-any.whl
Successfully downloaded arena-rank
---LIST---
664  arena_rank-0.1.1-py3-none-any.whl  42.2K
```

---

### 🤖 Assistant — 2026-09-13 22:28:26

**tool:bash** (completed) python3 -c "import zipfile; zipfile.ZipFile('/tmp/ar/arena_rank-0.1.1-py3-none-any.whl').extractall('/tmp/ar/pkg')"; find /tmp/ar/pkg -type f | head -30; echo "==="; pip show arena-rank 2>&1 | head -3; python3 -c "import arena_rank; print(arena_rank.__file__)" 2>&1

```
command=python3 -c "import zipfile; zipfile.ZipFile('/tmp/ar/arena_rank-0.1.1-py3-none-a
--- output ---
/tmp/ar/pkg/arena_rank-0.1.1.dist-info/RECORD
/tmp/ar/pkg/arena_rank-0.1.1.dist-info/licenses/LICENSE
/tmp/ar/pkg/arena_rank-0.1.1.dist-info/WHEEL
/tmp/ar/pkg/arena_rank-0.1.1.dist-info/METADATA
/tmp/ar/pkg/arena_rank/utils/math_utils.py
/tmp/ar/pkg/arena_rank/utils/data_utils.py
/tmp/ar/pkg/arena_rank/utils/__init__.py
/tmp/ar/pkg/arena_rank/models/rating_system.py
/tmp/ar/pkg/arena_rank/models/contextual_bradley_terry.py
/tmp/ar/pkg/arena_rank/models/bradley_terry.py
/tmp/ar/pkg/arena_rank/models/__init__.py
/tmp/ar/pkg/arena_rank/assets/logo.png
/tmp/ar/pkg/arena_rank/assets/logo-dark.png
/tmp/ar/pkg/arena_rank/__init__.py
===
WARNING: Package(s) not found: arena-rank
Traceback (most recent call last):
  File "<string>", line 1, in <module>
    import arena_rank; print(arena_rank.__file__)
    ^^^^^^^^^^^^^^^^^
ModuleNotFoundError: No module named 'arena_rank'
```

---

### 🤖 Assistant — 2026-09-13 22:28:31

**tool:read** (completed) ../../../tmp/ar/pkg/arena_rank/models/bradley_terry.py

```
filePath=/tmp/ar/pkg/arena_rank/models/bradley_terry.py
--- output ---
<path>/tmp/ar/pkg/arena_rank/models/bradley_terry.py</path>
<type>file</type>
<content>
1: """Bradley-Terry rating system implementation in JAX."""
2: 
3: from functools import partial
4: import math
5: from copy import deepcopy
6: import multiprocessing as mp
7: from typing import Tuple, Dict, Any
8: import jax
9: import jax.nn as nn
10: import jax.numpy as jnp
11: from jax import jit, tree_util
12: from jaxtyping import PyTree
13: 
14: from arena_rank.models.rating_system import RatingSystem
15: from arena_rank.utils.data_utils import PairDataset
16: from arena_rank.utils.math_utils import assemble_parwise_matrix
17: 
18: jax.config.update("jax_enable_x64", True)
19: 
20: 
21: # needs to be at the top level to be pickle-able for multiprocessing
22: def fit_single_bootstrap_sample(
23:     boot_counts: jnp.ndarray,
24:     model: RatingSystem,
25:     dataset: PairDataset,
26: ) -> PyTree:
27:     """Helper function to fit a single bootstrap sample with given counts."""
28:     # opt_weights = counts * weights (combining occurrence counts and reweighting)
29:     boot_opt_weights = boot_counts * dataset.weights
30: 
31:     # Create bootstrap dataset with resampled counts
32:     boot_dataset = PairDataset(
33:         competitors=dataset.competitors,
34:         pairs=dataset.pairs,
35:         outcomes=dataset.outcomes,
36:         counts=boot_counts,
37:         weights=dataset.weights,
38:         opt_weights=boot_opt_weights,  # same dataset but with weights based on the bootstrap counts
39:     )
40: 
41:     boot_model = deepcopy(model)
42:     boot_model.params = {"ratings": jnp.zeros_like(boot_model.params["ratings"], dtype=model.dtype)}
43:     boot_model.fit(boot_dataset)
44:     return boot_model.params
45: 
46: 
47: class BradleyTerry(RatingSystem):
48:     """Bradley-Terry rating system implementation."""
49: 
50:     def __init__(
51:         self,
52:         n_competitors,
53:         scale: float = 400.0,
54:         base: float = 10.0,
55:         init_rating: float = 1000.0,
56:         hessian_reg: float = 1e-5,
57:         max_iter: int = 1000,
58:         ftol: float = 1e-9,
59:         gtol: float = 1e-9,
60:         dtype=jnp.float64,
61:         verbose: bool = False,
62:     ):
63:         self.n_competitors = n_competitors
64:         self.scale = scale
65:         self.base = base
66:         self.init_rating = init_rating
67:         self.hessian_reg = hessian_reg
68:         self.max_iter = max_iter
69:         self.ftol = ftol
70:         self.gtol = gtol
71:         self.dtype = dtype
72:         self.verbose = verbose
73:         self.fitted = False
74:         self.alpha = scale / math.log(base)
75:         self.params = {"ratings": jnp.zeros(n_competitors, dtype=dtype)}
76: 
77:     @staticmethod
78:     @jit
79:     def loss_function(params, data: PyTree) -> jnp.ndarray:
80:         ratings = params["ratings"]
81:         matchups = data["pairs"]
82:         weights = data["opt_weights"]
83:         outcomes = data["outcomes"]
84:         rating_diffs = ratings[matchups[:, 0]] - ratings[matchups[:, 1]]
85:         loss = -jnp.sum(weights * (outcomes * rating_diffs - nn.softplus(rating_diffs))) / jnp.sum(weights)
86:         return loss
87: 
88:     @staticmethod
89:     @partial(jit, static_argnames=["n_competitors"])
90:     def compute_hessian_and_covariance(
91:         ratings: jnp.ndarray,
92:         matchups: jnp.ndarray,
93:         outcomes: jnp.ndarray,
94:         counts: jnp.ndarray,
95:         opt_weights: jnp.ndarray,
96:         hessian_reg: float,
97:         n_competitors: int,
98:     ) -> Tuple[jnp.ndarray, jnp.ndarray]:
99:         """
100:         Computes the Hessian and Gradient Covariance matrices for the sandwich estimator in the Bradley-Terry framework.
101: 
102:         Args:
103:             ratings: Competitor ratings, shape (n_competitors,)
104:             matchups: Matchup pairs, shape (n_pairs, 2)
105:             outcomes: Outcomes of matchups, shape (n_pairs,)
106:             counts: Counts of each unique pair, shape (n_pairs,)
107:             opt_weights: Optimization weights for each matchup, incorporates both occurrence counts and reweighting, shape (n_pairs,)
108:             hessian_reg: Regularization term for Hessian diagonal.
109:             n_competitors: Total number of competitors.
110:         """
111:         matchup_ratings = ratings[matchups]
112:         logits = matchup_ratings[:, 0] - matchup_ratings[:, 1]
113:         probs = jax.nn.sigmoid(logits)
114: 
115:         grad_vals = (outcomes - probs) * opt_weights
116:         # variance per unique pair bucket
117:         var_grad_vals = (grad_vals**2) / counts
118:         hess_vals = probs * (1.0 - probs) * opt_weights
119: 
120:         idx_a = matchups[:, 0]
121:         idx_b = matchups[:, 1]
122: 
123:         hessian = jnp.zeros((n_competitors, n_competitors), dtype=ratings.dtype)
124:         grad_cov = jnp.zeros((n_competitors, n_competitors), dtype=ratings.dtype)
125: 
126:         hessian = assemble_parwise_matrix(hessian, hess_vals, idx_a, idx_b)
127:         grad_cov = assemble_parwise_matrix(grad_cov, var_grad_vals, idx_a, idx_b)
128: 
129:         # regularize the diagonal of the Hessian for numerical stability
130:         hessian = hessian + (jnp.eye(n_competitors) * hessian_reg)
131:         return hessian, grad_cov
132: 
133:     def compute_ratings_and_cis(
134:         self,
135:         dataset: PairDataset,
136:         significance_level: float = 0.05,
137:         ci_method: str = "sandwich",
138:         num_bootstrap: int = 100,
139:         seed: int = 42,
140:         n_jobs: int = -1,
141:     ) -> Dict[str, Any]:
142:         """
143:         Fits the model (if needed), calculates confidence intervals.
144: 
145:         Args:
146:             dataset: PairDataset containing the matchup data.
147:             significance_level: Significance level for confidence intervals.
148:             ci_method: "sandwich" for central limit theorem estimates or "bootstrap" for resampling.
149:             num_bootstrap: Number of bootstrap samples (only used if ci_method="bootstrap").
150:             seed: Random seed for bootstrapping.
151:             n_jobs: Number of workers for multiprocessing (only used if ci_method="bootstrap").
152:         """
153:         if not self.fitted:
154:             self.fit(dataset)
155: 
156:         ratings = self.params["ratings"]  # unscaled ratings from the fitted model
157: 
158:         alpha = self.alpha
159:         offset = self.init_rating
160: 
161:         def scale(x):
162:             return x * alpha + offset
163: 
164:         scaled_ratings = scale(ratings)
165:         rating_lower = None
166:         rating_upper = None
167:         scaled_variances = None
168: 
169:         total_battles = jnp.sum(dataset.counts)
170:         if ci_method == "sandwich":
171:             is_unweighted = jnp.allclose(dataset.weights, 1.0)
172:             reg_factor = jnp.where(is_unweighted, total_battles, 1.0)
173:             effective_reg = self.hessian_reg * reg_factor
174: 
175:             hessian, gradient_cov = self.compute_hessian_and_covariance(
176:                 ratings,
177:                 dataset.pairs,
178:                 dataset.outcomes,
179:                 dataset.counts,
180:                 dataset.opt_weights,
181:                 effective_reg,
182:                 self.n_competitors,
183:             )
184: 
185:             hessian_inv = jnp.linalg.inv(hessian)
186:             covariance_matrix = hessian_inv @ gradient_cov @ hessian_inv
187:             variances = jnp.diag(covariance_matrix)
188: 
189:             std_errs = jnp.sqrt(variances)
190:             z_score = jax.scipy.stats.norm.ppf(1 - significance_level / 2)
191:             interval_widths = z_score * std_errs
192: 
193:             rating_lower = scale(ratings - interval_widths)
194:             rating_upper = scale(ratings + interval_widths)
195:             scaled_variances = variances * (alpha**2)
196: 
197:         elif ci_method == "bootstrap":
```

**tool:read** (completed) ../../../tmp/ar/pkg/arena_rank/models/rating_system.py

```
filePath=/tmp/ar/pkg/arena_rank/models/rating_system.py
--- output ---
<path>/tmp/ar/pkg/arena_rank/models/rating_system.py</path>
<type>file</type>
<content>
1: """Base class for rating systems."""
2: 
3: from abc import ABC, abstractmethod
4: from functools import partial
5: from jaxtyping import PyTree
6: 
7: from arena_rank.utils.data_utils import BasePairDataset
8: from arena_rank.utils.math_utils import lbfgs_minimize
9: 
10: 
11: class RatingSystem(ABC):
12:     """Abstract base class for rating systems with differentiable loss functions optimized via L-BFGS in jax"""
13: 
14:     data: PyTree
15:     params: PyTree
16:     max_iter: int = 1000
17:     gtol: float = 1e-9
18:     ftol: float = 1e-9
19:     verbose: bool = False
20:     fitted: bool = False
21: 
22:     @abstractmethod
23:     def loss_function(self, params: PyTree, data: PyTree) -> float:
24:         """Each rating system must implement its own loss function."""
25: 
26:     @abstractmethod
27:     def compute_ratings_and_cis(self, dataset: BasePairDataset, alpha: float = 0.95) -> PyTree:
28:         """Compute ratings and confidence intervals given a dataset."""
29: 
30:     def fit(self, dataset: BasePairDataset):
31:         """Fit the rating system to the provided data."""
32:         initial_params = self.params
33:         opt_fn = partial(self.loss_function, data=dataset.as_dict())
34:         final_params, _ = lbfgs_minimize(
35:             function=opt_fn,
36:             initial_params=initial_params,
37:             max_iter=self.max_iter,
38:             gtol=self.gtol,
39:             ftol=self.ftol,
40:             verbose=self.verbose,
41:         )
42:         self.params = final_params
43:         self.fitted = True
44:         return self

(End of file - total 44 lines)
</content>
```

**tool:read** (completed) ../../../tmp/ar/pkg/arena_rank/utils/math_utils.py

```
filePath=/tmp/ar/pkg/arena_rank/utils/math_utils.py
--- output ---
<path>/tmp/ar/pkg/arena_rank/utils/math_utils.py</path>
<type>file</type>
<content>
1: """
2: Utility functions for mathematical operations.
3: """
4: 
5: from typing import Callable, Tuple
6: import jax
7: import jax.numpy as jnp
8: from jax import jit
9: from jaxtyping import PyTree
10: import optax
11: 
12: 
13: @jit
14: def assemble_parwise_matrix(mat, vals, idx_a, idx_b):
15:     """
16:     Accumulates row-level values into a parameter-level pairwise matrix for Hessian and gradient covariance calculations.
17:     Args:
18:         mat: The matrix to accumulate into, shape (n_competitors, n_competitors)
19:         vals: The values to accumulate, shape (n_pairs,)
20:         idx_a: Indices of competitor A in each pair, shape (n_pairs,)
21:         idx_b: Indices of competitor B in each pair, shape (n_pairs,)
22:     Returns:
23:         The updated matrix with accumulated values.
24:     """
25:     mat = mat.at[idx_a, idx_a].add(vals)
26:     mat = mat.at[idx_b, idx_b].add(vals)
27:     mat = mat.at[idx_a, idx_b].add(-vals)
28:     mat = mat.at[idx_b, idx_a].add(-vals)
29:     return mat
30: 
31: 
32: def lbfgs_minimize(
33:     function: Callable[[PyTree], jnp.ndarray],
34:     initial_params: PyTree,
35:     max_iter: int = 1000,
36:     gtol: float = 1e-6,
37:     ftol: float = 1e-9,
38:     verbose: bool = False,
39: ) -> Tuple[PyTree, PyTree]:
40:     """Minimize a differentiable function using the L-BFGS algorithm from Optax."""
41:     solver = optax.lbfgs()
42: 
43:     @jit
44:     def _run_optimization(init_params):
45:         value_and_grad_fun = optax.value_and_grad_from_state(function)
46: 
47:         # carry state: (params, solver_state, prev_loss, grad_inf_norm, rel_change)
48:         def step(carry: Tuple) -> Tuple:
49:             params, state, prev_loss, _, _ = carry
50:             value, grad = value_and_grad_fun(params, state=state)
51:             updates, state = solver.update(grad, state, params, value=value, grad=grad, value_fn=function)
52:             params = optax.apply_updates(params, updates)
53: 
54:             # extract metrics from state
55:             current_loss = optax.tree_utils.tree_get(state, "value", jnp.inf)
56:             current_grad = optax.tree_utils.tree_get(state, "grad", jnp.inf)
57: 
58:             # calculate infinity norm of grad to check against gtol
59:             leaf_maxes = jax.tree.map(lambda x: jnp.max(jnp.abs(x)), current_grad)
60:             grad_inf_norm = jax.tree_util.tree_reduce(jnp.maximum, leaf_maxes)
61: 
62:             # calculate relative loss change to check against ftol
63:             loss_change = jnp.abs(current_loss - prev_loss)
64:             max_loss = jnp.maximum(jnp.abs(current_loss), jnp.abs(prev_loss))
65:             denom = jnp.maximum(max_loss, 1.0)
66: 
67:             # handle first iteration where prev_loss is inf
68:             raw_rel_change = loss_change / denom
69:             rel_change = jnp.where(jnp.isinf(prev_loss), jnp.inf, raw_rel_change)
70: 
71:             return params, state, value, grad_inf_norm, rel_change
72: 
73:         def continuing_criterion(carry):
74:             _, state, _, grad_inf_norm, rel_change = carry
75: 
76:             # extract metrics from state
77:             iter_num = optax.tree_utils.tree_get(state, "count", 0)
78: 
79:             is_first_iter = iter_num == 0
80:             is_within_bounds = iter_num < max_iter
81:             is_not_converged = (grad_inf_norm >= gtol) & (rel_change >= ftol)
82:             return is_first_iter | (is_within_bounds & is_not_converged)
83: 
84:         # init with inf for metrics so loop starts correctly
85:         init_carry = (init_params, solver.init(init_params), jnp.inf, jnp.inf, jnp.inf)
86:         final_carry = jax.lax.while_loop(continuing_criterion, step, init_carry)
87:         return final_carry
88: 
89:     final_params, final_state, _, final_grad_norm, final_rel_change = _run_optimization(initial_params)
90: 
91:     # needed for accurate speed benchmarks
92:     # final_params = jax.tree.map(lambda x: x.block_until_ready(), final_params)
93: 
94:     final_iter = optax.tree_utils.tree_get(final_state, "count", 0)
95:     final_loss = optax.tree_utils.tree_get(final_state, "value", jnp.inf)
96: 
97:     if verbose:
98:         print(f"L-BFGS finished in {final_iter} iterations.")
99:         print(f"  Final Loss: {final_loss:.6f}")
100:         print(f"  Rel F Diff: {final_rel_change.item():.2e} (tol={ftol})")
101:         print(f"  Grad Norm:  {final_grad_norm.item():.2e} (tol={gtol})")
102: 
103:     return final_params, final_state

(End of file - total 103 lines)
</content>
```

**tool:read** (completed) ../../../tmp/ar/pkg/arena_rank/__init__.py

```
filePath=/tmp/ar/pkg/arena_rank/__init__.py
--- output ---
<path>/tmp/ar/pkg/arena_rank/__init__.py</path>
<type>file</type>
<content>


(End of file - total 0 lines)
</content>
```

---

### 🤖 Assistant — 2026-09-13 22:28:37

**tool:read** (completed) ../../../tmp/ar/pkg/arena_rank/utils/data_utils.py

```
filePath=/tmp/ar/pkg/arena_rank/utils/data_utils.py
--- output ---
<path>/tmp/ar/pkg/arena_rank/utils/data_utils.py</path>
<type>file</type>
<content>
1: from abc import ABC, abstractmethod
2: from typing import Dict, List, Callable
3: import pandas as pd
4: import jax.numpy as jnp
5: from typing import Tuple
6: 
7: 
8: def default_outcome_map(outcome: str) -> float:
9:     """Default outcome mapping function for standard arena results."""
10:     mapping = {
11:         "model_a": 1.0,
12:         "model_b": 0.0,
13:         "tie": 0.5,
14:         "both_bad": 0.5,
15:     }
16:     return mapping.get(outcome, 0.5)
17: 
18: 
19: def get_outcomes(df, outcome_col, outcome_map: Callable[[str], float], dtype=jnp.float64) -> jnp.ndarray:
20:     """Maps the str winner column used in lmarena datasets to float outcomes like 1.0, 0.0, 0.5"""
21:     outcomes = jnp.array(df[outcome_col].map(outcome_map).values, dtype=dtype)
22:     return outcomes
23: 
24: 
25: def get_matchups_and_competitors(df, competitor_cols: list = ["model_a", "model_b"]) -> Tuple[jnp.ndarray, List[str]]:
26:     """maps the str model_a, model_b columns used in lmarena datasets to integer indices and returns the list of unique competitors"""
27:     n_rows = len(df)
28:     competitor_indices, competitors = pd.factorize(
29:         pd.concat([df[competitor_cols[0]], df[competitor_cols[1]]]), sort=True
30:     )
31:     competitor_indices = jnp.array(competitor_indices, dtype=jnp.int32)
32:     matchups = jnp.column_stack([competitor_indices[:n_rows], competitor_indices[n_rows:]])
33:     return matchups, competitors.tolist()
34: 
35: 
36: class BasePairDataset(ABC):
37:     """Abstract base class for pairwise comparison datasets."""
38: 
39:     n_pairs: int
40:     n_competitors: int
41:     pairs: jnp.ndarray
42:     outcomes: jnp.ndarray
43:     weights: jnp.ndarray
44:     competitors: List[str]
45:     competitor_to_index: Dict[str, int]
46: 
47:     def __init__(
48:         self,
49:         competitors: List[str],
50:         pairs: jnp.ndarray,
51:         outcomes: jnp.ndarray,
52:         weights: jnp.ndarray,
53:     ):
54:         self.n_competitors = len(competitors)
55:         self.competitors = competitors
56:         self.competitor_to_index = {comp: idx for idx, comp in enumerate(competitors)}
57:         self.n_pairs = len(outcomes)
58:         self.pairs = pairs
59:         self.outcomes = outcomes
60:         self.weights = weights
61: 
62:     @abstractmethod
63:     def as_dict(self) -> Dict:
64:         """Return dataset as dictionary for model consumption."""
65:         pass
66: 
67:     @staticmethod
68:     @abstractmethod
69:     def from_pandas(df, **kwargs):
70:         """Create dataset from pandas DataFrame."""
71:         pass
72: 
73: 
74: class PairDataset(BasePairDataset):
75:     """Dataset class for standard Bradley-Terry model. Aggregates rows with the same (A,B,outcome) triplet for efficiency."""
76: 
77:     counts: jnp.ndarray  # shape (n_pairs,)
78:     opt_weights: jnp.ndarray  # shape (n_pairs,)
79: 
80:     def __init__(
81:         self,
82:         competitors: List[str],
83:         pairs: jnp.ndarray,
84:         outcomes: jnp.ndarray,
85:         counts: jnp.ndarray,
86:         weights: jnp.ndarray,
87:         opt_weights: jnp.ndarray,
88:     ):
89:         super().__init__(competitors, pairs, outcomes, weights)
90:         self.counts = counts
91:         self.opt_weights = opt_weights
92: 
93:     def as_dict(self) -> Dict:
94:         return {
95:             "pairs": self.pairs,
96:             "outcomes": self.outcomes,
97:             "opt_weights": self.opt_weights,
98:         }
99: 
100:     @staticmethod
101:     def from_pandas(
102:         df,
103:         competitor_cols: list = ["model_a", "model_b"],
104:         outcome_col: str = "winner",
105:         outcome_map: Callable[[str], float] = default_outcome_map,
106:         reweighted: bool = False,
107:         min_pair_count: int = 50,
108:     ) -> "PairDataset":
109:         matchups, competitors = get_matchups_and_competitors(df, competitor_cols)
110:         outcomes = get_outcomes(df, outcome_col, outcome_map)
111: 
112:         rows = jnp.column_stack([matchups.astype(jnp.float64), outcomes])
113:         unique_rows, unique_row_counts = jnp.unique(rows, return_counts=True, axis=0)
114: 
115:         unique_matchups = unique_rows[:, :2].astype(jnp.int32)
116:         unique_outcomes = unique_rows[:, 2]
117:         unique_row_counts = unique_row_counts.astype(jnp.float64)
118: 
119:         sorted_unique_matchups = jnp.sort(unique_matchups, axis=1)
120:         unique_pairs, unique_pair_indices = jnp.unique(sorted_unique_matchups, axis=0, return_inverse=True)
121: 
122:         unique_pair_sums = jnp.zeros(unique_pairs.shape[0], dtype=jnp.float64)
123:         unique_pair_sums = unique_pair_sums.at[unique_pair_indices].add(unique_row_counts)
124:         pair_counts = unique_pair_sums[unique_pair_indices]
125: 
126:         if reweighted:
127:             # do not divide by the mean here, since these weights are per-pair, not per-observation
128:             weights = 1.0 / jnp.maximum(pair_counts, min_pair_count)
129:         else:
130:             weights = jnp.ones_like(pair_counts, dtype=jnp.float64)
131: 
132:         return PairDataset(
133:             competitors=competitors,
134:             pairs=unique_matchups,
135:             outcomes=unique_outcomes,
136:             counts=unique_row_counts,
137:             weights=weights,
138:             opt_weights=weights * unique_row_counts,
139:         )
140: 
141: 
142: class ContextualPairDataset(BasePairDataset):
143:     """
144:     Dataset container for Contextual Bradley-Terry.
145:     Unlike PairDataset, this does NOT aggregate rows by matchup, because features vary per specific battle.
146:     """
147: 
148:     features: jnp.ndarray  # shape (n_rows, n_features)
149: 
150:     def __init__(
151:         self,
152:         competitors: List[str],
153:         pairs: jnp.ndarray,
154:         outcomes: jnp.ndarray,
155:         features: jnp.ndarray,
156:         weights: jnp.ndarray,
157:     ):
158:         super().__init__(competitors, pairs, outcomes, weights)
159:         self.features = features
160:         self.n_features = features.shape[1]
161: 
162:     def as_dict(self) -> Dict:
163:         return {
164:             "pairs": self.pairs,
165:             "outcomes": self.outcomes,
166:             "features": self.features,
167:             "weights": self.weights,
168:         }
169: 
170:     @staticmethod
171:     def from_pandas(
172:         df,
173:         feature_cols: List[str],
174:         competitor_cols: list = ["model_a", "model_b"],
175:         outcome_col: str = "winner",
176:         outcome_map: Callable[[str], float] = default_outcome_map,
177:         reweighted: bool = True,
178:         min_pair_count: int = 50,
179:         normalize_features: bool = True,
180:     ) -> "ContextualPairDataset":
181:         # extract matchups and outcomes
182:         matchups, competitors = get_matchups_and_competitors(df, competitor_cols)
183:         outcomes = get_outcomes(df, outcome_col, outcome_map)
184: 
185:         features = jnp.array(df[feature_cols].values.astype(float))
186:         if normalize_features:
187:             mean = features.mean(axis=0)
188:             std = features.std(axis=0)
189:             std = jnp.where(std == 0, 1.0, std)
190:             features = (features - mean) / std
191: 
192:         # reweighting assigns inverse propensity weights at the pair level
193:         if reweighted:
194:             # sort matchups so (A,B) and (B,A) are identified as the same pair
195:             sorted_matchups = jnp.sort(matchups, axis=1)
196: 
197:             # find unique pairs and the inverse indices mapping rows to those pairs
```

**tool:bash** (completed) curl -s "https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset" | python3 -c "import json,sys; d=json.load(sys.stdin); print('siblings:',len(d.get('siblings',[]))); [print(s['rfilename']) for s in d.get('siblings',[])]; print('---'); print(json.dumps({k:d.get(k) for k in ['id','sha','lastModified','gated','private','tags','cardData'] if k in d}, indent=1)[:1500])"

```
command=curl -s "https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset" | p
--- output ---
siblings: 46
.gitattributes
README.md
agent/full-00000-of-00001.parquet
agent/latest-00000-of-00001.parquet
agent_bash_recovery_steps/full-00000-of-00001.parquet
agent_bash_recovery_steps/latest-00000-of-00001.parquet
agent_praise_complaint/full-00000-of-00001.parquet
agent_praise_complaint/latest-00000-of-00001.parquet
agent_steerability/full-00000-of-00001.parquet
agent_steerability/latest-00000-of-00001.parquet
agent_task_outcome_explicit/full-00000-of-00001.parquet
agent_task_outcome_explicit/latest-00000-of-00001.parquet
agent_tool_hallucination/full-00000-of-00001.parquet
agent_tool_hallucination/latest-00000-of-00001.parquet
document/full-00000-of-00001.parquet
document/latest-00000-of-00001.parquet
document_style_control/full-00000-of-00001.parquet
document_style_control/latest-00000-of-00001.parquet
image_edit/full-00000-of-00001.parquet
image_edit/latest-00000-of-00001.parquet
image_to_video/full-00000-of-00001.parquet
image_to_video/latest-00000-of-00001.parquet
search/full-00000-of-00001.parquet
search/latest-00000-of-00001.parquet
search_factuality/full-00000-of-00001.parquet
search_factuality/latest-00000-of-00001.parquet
search_style_control/full-00000-of-00001.parquet
search_style_control/latest-00000-of-00001.parquet
text/full-00000-of-00001.parquet
text/latest-00000-of-00001.parquet
text_factuality/full-00000-of-00001.parquet
text_factuality/latest-00000-of-00001.parquet
text_style_control/full-00000-of-00001.parquet
text_style_control/latest-00000-of-00001.parquet
text_to_image/full-00000-of-00001.parquet
text_to_image/latest-00000-of-00001.parquet
text_to_video/full-00000-of-00001.parquet
text_to_video/latest-00000-of-00001.parquet
video_edit/full-00000-of-00001.parquet
video_edit/latest-00000-of-00001.parquet
vision/full-00000-of-00001.parquet
vision/latest-00000-of-00001.parquet
vision_style_control/full-00000-of-00001.parquet
vision_style_control/latest-00000-of-00001.parquet
webdev/full-00000-of-00001.parquet
webdev/latest-00000-of-00001.parquet
---
{
 "id": "lmarena-ai/leaderboard-dataset",
 "sha": "b9c5e261b09333707d0bcc5823b0fd0d8cd1bab2",
 "lastModified": "2026-09-12T03:03:58.000Z",
 "gated": false,
 "private": false,
 "tags": [
  "license:cc-by-4.0",
  "size_categories:1M<n<10M",
  "format:parquet",
  "modality:tabular",
  "modality:text",
  "library:datasets",
  "library:pandas",
  "library:polars",
  "library:mlcroissant",
  "region:us"
 ],
 "cardData": {
  "configs": [
   {
    "config_name": "agent",
    "data_files": [
     {
      "split": "latest",
      "path": "agent/latest-*"
     },
     {
      "split": "full",
      "path": "agent/full-*"
     }
    ]
   },
   {
    "config_name": "agent_bash_recovery_steps",
    "data_files": [
     {
      "split": "latest",
      "path": "agent_bash_recovery_steps/latest-*"
     },
     {
      "split": "full",
      "path": "agent_bash_recovery_steps/full-*"
     }
    ]
   },
   {
    "config_name": "agent_praise_complaint",
    "data_files": [
     {
      "split": "latest",
      "path": "agent_praise_complaint/latest-*"
     },
     {
      "split": "full",
      "path": "agent_praise_complaint/full-*"
     }
    ]
   },
   {
    "config_name": "agent_steerability",
    "data_files": [
     {
      "split": "latest",
      "path": "agent_steerability/latest-*"
     },
     {
      "split": "full",
      "path": "agent_steerability/full-*"
     }
    ]
   },
   {
    "config_name": "agent_task_outcome_explicit",
    "data_files": [
     {
      "split": "latest",
```

---

### 🤖 Assistant — 2026-09-13 22:28:42

**tool:bash** (completed) curl -s "https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset" | python3 -c "
import json,sys
d=json.load(sys.stdin)
ss=d.get('siblings',[])
import urllib.request
# get parquet metadata via HEAD? use hf resolve sizes via api parquet reader? Just print siblings
print(len(ss))
"; echo "---sizes via HF parquet viewer---"; curl -sL "https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet" | head -c 3000; echo; echo "---text parquet head---"; python3 -c "
import pandas as pd
for p in ['https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/latest-00000-of-00001.parquet','https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/full-00000-of-00001.parquet']:
    try:
        df=pd.read_parquet(p, engine='pyarrow')
        print(p.split('/')[-2:]); print('shape',df.shape); print(list(df.columns)); print(df.head(2).to_dict('records'))
        print('---')
    except Exception as e: print('ERR',p,e)
"

```
command=curl -s "https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset" | p
--- output ---
46
---sizes via HF parquet viewer---
{"agent":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent/latest/0.parquet"]},"agent_bash_recovery_steps":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_bash_recovery_steps/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_bash_recovery_steps/latest/0.parquet"]},"agent_praise_complaint":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_praise_complaint/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_praise_complaint/latest/0.parquet"]},"agent_steerability":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_steerability/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_steerability/latest/0.parquet"]},"agent_task_outcome_explicit":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_task_outcome_explicit/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_task_outcome_explicit/latest/0.parquet"]},"agent_tool_hallucination":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_tool_hallucination/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/agent_tool_hallucination/latest/0.parquet"]},"document":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/document/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/document/latest/0.parquet"]},"document_style_control":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/document_style_control/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/document_style_control/latest/0.parquet"]},"image_edit":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/image_edit/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/image_edit/latest/0.parquet"]},"image_to_video":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/image_to_video/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/image_to_video/latest/0.parquet"]},"search":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/search/full/0.parquet"],"latest":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/search/latest/0.parquet"]},"search_factuality":{"full":["https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset/parquet/search_f
---text parquet head---
Traceback (most recent call last):
  File "<string>", line 2, in <module>
    import pandas as pd
ModuleNotFoundError: No module named 'pandas'
```

---

### 🤖 Assistant — 2026-09-13 22:28:48

**tool:bash** (completed) pip install -q pandas pyarrow 2>&1 | tail -2
python3 -c "
import pandas as pd
for p in ['https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/latest-00000-of-00001.parquet','https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/full-00000-of-00001.parquet']:
    df=pd.read_parquet(p)
    print(p.split('main/')[1]); print('shape',df.shape); print(list(df.columns)); print(df.head(3).to_string()[:2000]); print('---')
"

```
command=pip install -q pandas pyarrow 2>&1 | tail -2
python3 -c "
import pandas as pd
fo
--- output ---
note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.
Traceback (most recent call last):
  File "<string>", line 2, in <module>
    import pandas as pd
ModuleNotFoundError: No module named 'pandas'
```

---

### 🤖 Assistant — 2026-09-13 22:28:54

**tool:bash** (completed) pip install -q --break-system-packages pandas pyarrow 2>&1 | tail -2
python3 -c "
import pandas as pd
for p in ['https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/latest-00000-of-00001.parquet']:
    df=pd.read_parquet(p)
    print(p.split('main/')[1]); print('shape',df.shape); print(list(df.columns))
    print(df.head(3).to_string()[:3000])
"

```
command=pip install -q --break-system-packages pandas pyarrow 2>&1 | tail -2
python3 -c 
--- output ---
text/latest-00000-of-00001.parquet
shape (10581, 11)
['model_name', 'organization', 'license', 'rating', 'rating_lower', 'rating_upper', 'variance', 'vote_count', 'rank', 'category', 'leaderboard_publish_date']
             model_name organization      license       rating  rating_lower  rating_upper   variance  vote_count  rank category leaderboard_publish_date
0  claude-fable-5.1-max    anthropic  Proprietary  1510.463127   1502.088968   1518.837287  18.255187      5447.0   1.0  overall               2026-09-11
1    claude-opus-5-high    anthropic  Proprietary  1505.270740   1501.013063   1509.528416   4.718991     41777.0   2.0  overall               2026-09-11
2     claude-opus-5-max    anthropic  Proprietary  1504.064412   1498.566946   1509.561879   7.867360     20296.0   3.0  overall               2026-09-11
```

---

### 🤖 Assistant — 2026-09-13 22:29:17

**tool:bash** (completed) curl -sI "https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/latest-00000-of-00001.parquet" | grep -i content-length; curl -sI "https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/full-00000-of-00001.parquet" | grep -i content-length
echo "---full shape---"
python3 -c "
import pandas as pd
df=pd.read_parquet('https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/full-00000-of-00001.parquet')
print('shape',df.shape); print(list(df.columns)); print(df['category'].value_counts().head(10).to_string())
"
echo "---140k---"
curl -s "https://huggingface.co/api/datasets/lmarena-ai/arena-human-preference-140k" | python3 -c "import json,sys; d=json.load(sys.stdin); [print(s['rfilename']) for s in d.get('siblings',[])][:20]; print('total',len(d.get('siblings',[])))"

```
command=curl -sI "https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve
--- output ---
content-length: 1038
content-length: 1028
---full shape---
shape (1125317, 11)
['model_name', 'organization', 'license', 'rating', 'rating_lower', 'rating_upper', 'variance', 'vote_count', 'rank', 'category', 'leaderboard_publish_date']
category
overall                  52170
english                  51224
exclude_ties             50932
coding                   50708
hard_prompts_english     50270
multi_turn               49213
instruction_following    49189
longer_query             49026
chinese                  48251
math                     48141
---140k---
.gitattributes
README.md
data/train-00000-of-00007.parquet
data/train-00001-of-00007.parquet
data/train-00002-of-00007.parquet
data/train-00003-of-00007.parquet
data/train-00004-of-00007.parquet
data/train-00005-of-00007.parquet
data/train-00006-of-00007.parquet
total 9
```

---

### 🤖 Assistant — 2026-09-13 22:29:33

**tool:bash** (completed) python3 -c "
import urllib.request
for u in ['https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/latest-00000-of-00001.parquet','https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/text/full-00000-of-00001.parquet']:
    r=urllib.request.urlopen(u)
    data=r.read()
    print(u.split('main/')[1], len(data),'bytes =', round(len(data)/1024,1),'KB')
"
echo "---140k cols---"
python3 -c "
import pandas as pd
df=pd.read_parquet('https://huggingface.co/datasets/lmarena-ai/arena-human-preference-140k/resolve/main/data/train-00000-of-00007.parquet')
print('shape',df.shape); print(list(df.columns))
print(df.head(1).to_string()[:2000])
"

```
command=python3 -c "
import urllib.request
for u in ['https://huggingface.co/datasets/lm
--- output ---
text/latest-00000-of-00001.parquet 588060 bytes = 574.3 KB
text/full-00000-of-00001.parquet 55910290 bytes = 54599.9 KB
---140k cols---
shape (19377, 14)
['id', 'model_a', 'model_b', 'winner', 'evaluation_session_id', 'evaluation_order', 'conversation_a', 'conversation_b', 'full_conversation', 'conv_metadata', 'category_tag', 'language', 'is_code', 'timestamp']
                                     id         model_a                                  model_b   winner                 evaluation_session_id  evaluation_order
```

---

### 🤖 Assistant — 2026-09-13 22:30:54

**tool:bash** (completed) python3 -c "
import pandas as pd
df=pd.read_parquet('https://huggingface.co/datasets/lmarena-ai/arena-human-preference-140k/resolve/main/data/train-00000-of-00007.parquet')
print(df['winner'].value_counts().to_string())
print('---model_a sample---', df['model_a'].head(3).tolist())
print('---conversation_a type---', type(df['conversation_a'].iloc[0]))
import json
c=df['conversation_a'].iloc[0]
print(str(c)[:800])
"
echo "===METADATA==="
cat /tmp/ar/pkg/arena_rank-0.1.1.dist-info/METADATA | head -20
echo "===grep order/sort in pkg==="
grep -rn "sort\|argsort\|rank\|order" /tmp/ar/pkg/arena_rank --include="*.py" | head -10

```
command=python3 -c "
import pandas as pd
df=pd.read_parquet('https://huggingface.co/data
--- output ---
winner
model_b     7132
model_a     6952
tie         3129
both_bad    2164
---model_a sample--- ['gemini-2.5-pro', 'claude-3-5-haiku-20241022', 'o3-mini']
---conversation_a type--- <class 'numpy.ndarray'>
[{'role': 'user', 'content': array([{'type': 'text', 'text': 'Compare Tormenta20 with DnD5e', 'image': None, 'mimeType': None}],
       dtype=object)}
 {'role': 'assistant', 'content': array([{'type': 'text', 'text': 'Excellent question! Comparing **Tormenta20 (T20)** and **Dungeons & Dragons 5th Edition (D&D 5e)** is a fantastic way to understand different approaches to the d20 system. While they share a common ancestor (D&D 3rd Edition), they have evolved in vastly different directions.\n\nHere is a detailed comparison, broken down by key aspects of the games.\n\n---\n\n### **High-Level Philosophy**\n\n*   **D&D 5e:** Aims for **accessibility, streamlined play, and heroic fantasy**. It simplifies many of the complex rules of older editions to be welcoming to new players. Its design philo
===METADATA===
Metadata-Version: 2.4
Name: arena-rank
Version: 0.1.1
Summary: Ranking methodology powering the LMArena leaderboard.
Project-URL: Homepage, https://lmarena.ai
Project-URL: Repository, https://github.com/lmarena/arena-rank
Project-URL: Issues, https://github.com/lmarena/arena-rank/issues
Author-email: Clayton Thorrez <clayton@lmarena.ai>
License: Apache 2.0
License-File: LICENSE
Classifier: License :: OSI Approved :: Apache Software License
Classifier: Programming Language :: Python :: 3
Classifier: Programming Language :: Python :: 3.11
Classifier: Programming Language :: Python :: 3.12
Requires-Python: >=3.11
Requires-Dist: datasets
Requires-Dist: jax==0.8.1
Requires-Dist: jaxtyping
Requires-Dist: numpy==2.3.3
Requires-Dist: optax
===grep order/sort in pkg===
/tmp/ar/pkg/arena_rank/utils/data_utils.py:29:        pd.concat([df[competitor_cols[0]], df[competitor_cols[1]]]), sort=True
/tmp/ar/pkg/arena_rank/utils/data_utils.py:119:        sorted_unique_matchups = jnp.sort(unique_matchups, axis=1)
/tmp/ar/pkg/arena_rank/utils/data_utils.py:120:        unique_pairs, unique_pair_indices = jnp.unique(sorted_unique_matchups, axis=0, return_inverse=True)
/tmp/ar/pkg/arena_rank/utils/data_utils.py:194:            # sort matchups so (A,B) and (B,A) are identified as the same pair
/tmp/ar/pkg/arena_rank/utils/data_utils.py:195:            sorted_matchups = jnp.sort(matchups, axis=1)
/tmp/ar/pkg/arena_rank/utils/data_utils.py:198:            _, pair_idx, pair_counts = jnp.unique(sorted_matchups, axis=0, return_inverse=True, return_counts=True)
/tmp/ar/pkg/arena_rank/models/rating_system.py:7:from arena_rank.utils.data_utils import BasePairDataset
/tmp/ar/pkg/arena_rank/models/rating_system.py:8:from arena_rank.utils.math_utils import lbfgs_minimize
/tmp/ar/pkg/arena_rank/models/contextual_bradley_terry.py:14:from arena_rank.models.rating_system import RatingSystem
/tmp/ar/pkg/arena_rank/models/contextual_bradley_terry.py:15:from arena_rank.utils.data_utils import ContextualPairDataset
```

---

### 🤖 Assistant — 2026-09-13 22:32:00

**tool:todowrite** (completed) 0 todos

```
todos=[{'content': 'Research arena-rank BT implementation', 'status': 'completed', 'pr
--- output ---
[
  {
    "content": "Research arena-rank BT implementation",
    "status": "completed",
    "priority": "high"
  },
  {
    "content": "Research HF leaderboard-dataset files + columns",
    "status": "completed",
    "priority": "high"
  }
]
```

---

### 🤖 Assistant — 2026-09-13 22:32:06

## 1. arena-rank BT (`arena_rank-0.1.1`, Apache-2.0, repo `github.com/lmarena/arena-rank`, deps `jax==0.8.1 optax numpy==2.3.3 datasets jaxtyping`, py>=3.11)

**Outcome weights** (`utils/data_utils.py:default_outcome_map`): `model_a=1.0`, `model_b=0.0`, `tie=0.5`, `both_bad=0.5`, unknown default `0.5`. No fractional tie-break; tie = half-win each side.

**Aggregation**: rows grouped by unique `(A,B,outcome)` triplet. `counts` = triplet frequency. Default `weights=1`, `opt_weights=counts*weights`. Optional `reweighted=True`: `weights=1/max(pair_count,50)` per unordered pair (A,B and B,A merged via sort).

**Scale/offset** (`models/bradley_terry.py:50-75`): `scale=400, base=10, init_rating=1000`, `alpha=scale/ln(base)` ≈173.72. Fit in logit space, display `R=theta*alpha+1000`. Standard Elo 400 scale: `P(A beats B)=sigmoid(theta_a-theta_b)=1/(1+10^(-(R_a-R_b)/400))`.

**Init**: `params={"ratings": zeros(n)}` float64. Zero-centered; offset added only at display.

**Iteration**: NOT MM. Weighted logistic regression via `optax.lbfgs()` custom loop (`utils/math_utils.py:lbfgs_minimize`). `max_iter=1000, ftol=1e-9, gtol=1e-9` (grad inf-norm + relative loss change, `jax.lax.while_loop`, jitted, float64). No regularization in fit; `hessian_reg=1e-5` used only for sandwich CI diagonal.

**Convergence**: stop when `iter>=max_iter` OR (`grad_inf_norm<gtol` AND `rel_change<ftol` fails — code uses `&`, so both must pass). Verbose prints final loss, rel-change, grad norm.

**Core loss** (exact, 9 lines):
```python
@staticmethod
@jit
def loss_function(params, data: PyTree) -> jnp.ndarray:
    ratings = params["ratings"]
    matchups = data["pairs"]
    weights = data["opt_weights"]
    outcomes = data["outcomes"]
    rating_diffs = ratings[matchups[:, 0]] - ratings[matchups[:, 1]]
    loss = -jnp.sum(weights * (outcomes * rating_diffs - nn.softplus(rating_diffs))) / jnp.sum(weights)
    return loss
```
Weighted negative log-likelihood of Bernoulli(logit=d). CI via `compute_ratings_and_cis`: `sandwich` (Hessian + grad-covariance, `H^-1 G H^-1`, z=`norm.ppf(1-a/2)`) or `bootstrap` (multinomial resample counts, default 100 reps, seed 42, refit each).

**Ordering**: library returns dict `{competitors, ratings, rating_lower/upper, variances}` unsorted. Caller sorts scaled ratings descending → rank. Competitor index alphabetical (`pd.factorize(sort=True)`).

## 2. `lmarena-ai/leaderboard-dataset` (gated false, CC-BY-4.0, sha `b9c5e26`, updated 2026-09-12)

**Files**: 46 parquet + README + .gitattributes. 23 configs (`text`, `vision`, `search`, `agent`, `document`, `image_edit`, `webdev`, etc.) × 2 splits (`latest`, `full`). Pattern `{config}/{split}-00000-of-00001.parquet`. API: `https://huggingface.co/api/datasets/lmarena-ai/leaderboard-dataset`. Resolve: `https://huggingface.co/datasets/lmarena-ai/leaderboard-dataset/resolve/main/{config}/{split}-00000-of-00001.parquet`.

**Text leaderboard**:
- `text/latest`: 574KB, 10,581 rows × 11 cols.
- `text/full`: 54.6MB (55,910,290 bytes), 1,125,317 rows × 11 cols (one row per model×category: overall/english/exclude_ties/coding/hard_prompts_english/multi_turn/instruction_following/longer_query/chinese/math... ~50k each).
- Columns: `model_name, organization, license, rating, rating_lower, rating_upper, variance, vote_count, rank, category, leaderboard_publish_date`.
- Top row 2026-09-11: `claude-fable-5.1-max` 1510.46 (CI 1502.09–1518.84, votes 5447, rank 1, overall).
- Smallest model→rating mapping: `text/latest-00000-of-00001.parquet` (574KB). Filter `category==overall`, take `model_name, rating, rank`.

**`lmarena-ai/arena-human-preference-140k`** (bulk-import reference): 7 shards `data/train-00000-of-00007.parquet` … `00006`, ~19,377 rows/shard (~140k total). 14 cols: `id, model_a, model_b, winner, evaluation_session_id, evaluation_order, conversation_a, conversation_b, full_conversation, conv_metadata, category_tag, language, is_code, timestamp`. `winner` ∈ `model_a/model_b/tie/both_bad` (shard 0: 6952/7132/3129/2164). Conversations = nested role/content arrays (`user`/`assistant`, typed text/image parts). Import format: `model_a, model_b, winner` strings map direct to `arena_rank` `competitor_cols=["model_a","model_b"], outcome_col="winner"`.


---
