library ( lpSolve )
#defining parameters
#origins run i in 1:m
5 #destinations run j in 1:n
obj.fun <- c(8, 6, 3, 2, 4, 9)
m <- 2
n <- 3
10
constr <- matrix (0, n+m, n*m)
for (i in 1:m){
  for (j in 1:n){
    constr [i, n*(i -1) + j] <- 1
    constr [m+j, n*(i -1) + j] <- 1
  }
}

constr.dir <- c(rep("<=", m), rep(">=", n))
rhs <- c(70 , 40, 40, 35, 25)

#solving LP model
prod.trans <- lp("min", obj.fun , constr , constr.dir , rhs ,
                      compute.sens = TRUE )
str(prod.trans)

#LP solution
prod.trans$objval
sol <- matrix ( prod.trans$solution , m, n, byrow = TRUE )

prod.trans$duals

#sensitivity analysis of LP
prod.trans$duals.from
prod.trans$duals.to
prod.trans$sens.coef.from
prod.trans$sens.coef.to

