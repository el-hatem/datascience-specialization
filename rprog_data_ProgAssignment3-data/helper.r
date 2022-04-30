makeCacheDataframe <- function(x = data.frame()) {
	# set initial df to be null 
	df <- NULL
	# Getters & Setters for dataframe
	get <- function() x
	set <- function(arg) {
		x <<- arg
		df <- NULL
	}
	# Getters & Setters for loaded dataframe
	load <- function() df
	generate <- function(data) df <<- data

	# Return Special list
	list(set=set, get=get, load=load, generate=generate)
}


## Write a short comment describing this function

cacheload <- function(x, ...) {
    ## Return a dataframe that is cache-loaded

    # generate special dataframe
    # get dataframe of x
	df <- x$load()
	# if x inverse isn't exist, then calculate
	if(is.null(df)) {
		df <- read.csv('./outcome-of-care-measures.csv', header = TRUE)
		x$generate(df)
	}
	return(df)
}

filterforbestproblem <- function(df) {
	# rename columns
	names(df) <- c('hospital', 'rates')
	# filter data
	df <- df[!(df[2] == 'Not Available'), ]
	# change datatype 
	df[,2] <- as.numeric(as.character(df[,2]))

	df
}

# load dataframe
dtf <- read.csv('./outcome-of-care-measures.csv', header = TRUE)
sdf <- makeCacheDataframe(df)
ldf <- cacheload(sdf)
# get unique state abbrviations
states <- unique(ldf$State)
# list all outcomes
outcomes <- c('heart attack', 'heart failure', 'pneumonia')



