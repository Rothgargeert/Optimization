obj <- c(3, 1, 3)
mat <- matrix(c(-1, 0, 1, 2, 4, -3, 1, -3, 2), nrow = 3)
dir <- c("<=", "<=", "<=")
rhs <- c(4, 2, 3)
max <- TRUE
types <- c("I", "C", "I")
Rsymphony_solve_LP(obj, mat, dir, rhs, types = types, max = max)
## Same as before but with bounds replaced by
## -Inf < x_1 <= 4
## 0 <= x_2 <= 100
## 2 <= x_3 < Inf
bounds <- list(lower = list(ind = c(1L, 3L), val = c(-Inf, 2)),
               upper = list(ind = c(1L, 2L), val = c(4, 100)))
Rsymphony_solve_LP(obj, mat, dir, rhs, types = types, max = max,
                   bounds = bounds)

A simple example:
  
  library(dplyr)
library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)

result <- MIPModel() %>%
  add_variable(x, type = "integer") %>%
  add_variable(y, type = "continuous", lb = 0) %>%
  set_bounds(x, lb = 0) %>%
  set_objective(x + y, "max") %>%
  add_constraint(x + y <= 11.25) %>%
  solve_model(with_ROI(solver = "glpk")) 
get_solution(result, x)
get_solution(result, y)

API

These functions currently form the public API. More detailed docs can be found in the package function docs or on the website

DSL
.MIPModel() create an empty mixed integer linear model (the old way)
.MILPModel() create an empty mixed integer linear model (the new way; experimental, especially suitable for large models)
.add_variable() adds variables to a model
.set_objective() sets the objective function of a model
.set_bounds()sets bounds of variables
.add_constraint() add constraints
.solve_model() solves a model with a given solver
.get_solution() returns the solution of a solved model for a given variable or group of variables

Backends

There are currently two backends. A backend is the function that initializes an empty model.
.MIPModel() is the standard MILP Model
.MILPModel() is a new backend specifically optimized for linear models and is about 1000 times faster than MIPModel(). It has slightly different semantics, as it is vectorized. Currently experimental, but it will replace the MIPModel eventually.

Solver

Solvers are in different packages. ompr.ROI uses the ROI package which offers support for all kinds of solvers.
.with_ROI(solver = "glpk") solve the model with GLPK. Install ROI.plugin.glpk
.with_ROI(solver = "symphony") solve the model with Symphony. Install ROI.plugin.symphony
.with_ROI(solver = "cplex") solve the model with CPLEX. Install ROI.plugin.cplex
.... See the ROI package for more plugins.

Further Examples

Please take a look at the docs for bigger examples.

Knapsack

library(dplyr)
library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)
max_capacity <- 5
n <- 10
weights <- runif(n, max = max_capacity)
MIPModel() %>%
  add_variable(x[i], i = 1:n, type = "binary") %>%
  set_objective(sum_expr(weights[i] * x[i], i = 1:n), "max") %>%
  add_constraint(sum_expr(weights[i] * x[i], i = 1:n) <= max_capacity) %>%
  solve_model(with_ROI(solver = "glpk")) %>% 
  get_solution(x[i]) %>% 
  filter(value > 0)

Bin Packing

An example of a more difficult model solved by symphony.

library(dplyr)
library(ROI)
library(ROI.plugin.symphony)
library(ompr)
library(ompr.roi)
max_bins <- 10
bin_size <- 3
n <- 10
weights <- runif(n, max = bin_size)
MIPModel() %>%
  add_variable(y[i], i = 1:max_bins, type = "binary") %>%
  add_variable(x[i, j], i = 1:max_bins, j = 1:n, type = "binary") %>%
  set_objective(sum_expr(y[i], i = 1:max_bins), "min") %>%
  add_constraint(sum_expr(weights[j] * x[i, j], j = 1:n) <= y[i] * bin_size, i = 1:max_bins) %>%
  add_constraint(sum_expr(x[i, j], i = 1:max_bins) == 1, j = 1:n) %>%
  solve_model(with_ROI(solver = "symphony", verbosity = 1)) %>% 
  get_solution(x[i, j]) %>%
  filter(value > 0) %>%
  arrange(i)

License

Currently GPL.

Contributing

Please post an issue first before sending a PR.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms.
