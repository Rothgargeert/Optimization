# Solving two LPs with the lpSolve package

#install.packages("lpSolve")
library ( lpSolve )

#defining parameters
obj.fun <- c(20 , 60)
constr <- matrix (c(30 , 20, 5, 10, 1, 1) , ncol = 2, byrow =  TRUE )
constr.dir <- c("<=", "<=", ">=")
rhs <- c(2700 , 850 , 95)

#solving model
prod.sol <- lp("max", obj.fun , constr , constr.dir , rhs ,compute.sens = TRUE )

prod.sol
str(prod.sol)
summary(prod.sol)

#accessing to R output
prod.sol$objval #objective function value
prod.sol$solution #decision variables values
prod.sol$duals #includes duals of constraints and reduced costs of variables

#sensitility analysis results
prod.sol$duals.from
prod.sol$duals.to
prod.sol$sens.coef.from
prod.sol$sens.coef.to


