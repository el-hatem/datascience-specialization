## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function

makeCacheMatrix <- function(x = matrix()) {
	# set initial inverse to be null 
	xinv <- NULL
	# Getters & Setters for Matrix
	get <- function() x
	set <- function(arg) {
		x <<- arg
		xinv <- NULL
	}
	# Getters & Setters for Matrix Inverse
	getinv <- function() xinv
	setinv <- function(inv) xinv <<- inv

	# Return Special list
	list(set=set, get=get, getinv=getinv, setinv=setinv)
}


## Write a short comment describing this function

cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'

    # generate special matrix
    # get inverse of x
	inv <- x$getinv()
	# if x inverse isn't exist, then calculate
	if(is.null(inv)) {
		inv <- solve(x$get())
		x$setinv(inv)
	}
	return(inv)
}

# generate inversable Matrix
x <- 2000
m <- matrix(rnorm(x^2), x)
c <- makeCacheMatrix(m)
t <- system.time(cacheSolve(c))
# test performance before cashing
t <- system.time(cacheSolve(c))
t
# test performance after caching
t <- system.time(cacheSolve(c))
t

# clear memory
base::rm(list = ls())