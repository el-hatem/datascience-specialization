source('./helper.r')


# Task 1
pollutantmean <- function (df, pollutant='both') {
	ifelse(
		pollutant == 'both',
		return(c(mean(df[['nitrate']], na.rm=TRUE), mean(df[['sulfate']], na.rm=TRUE)))
		,
		return(mean(df[[pollutant]], na.rm=TRUE))
	)
	
} 


# Task 2
complete <- function (df) {
	unq_id = unique(df$ID)
	ids <- c()
	nobs <- c()
	for(i in unq_id) {
		tmpdf <- df[df$ID == i,]
		case <- tmpdf[complete.cases(tmpdf), ]
		ids <- c(ids, i)
		nobs <- c(nobs, nrow(case))
	}

	return(data.frame(id=ids, nobs=nobs))
}


# Task 3
corr <- function(df, threshold=0) {
	# get completed data
	completecases <- complete(df)
	cases <- completecases[completecases$nobs>=threshold, ]
	# filter data
	data <- subset(df, ID %in% cases$id)
	data <- data[complete.cases(data), ]
		
	groups <- split(data, data$ID)
	mapply(function(g) cor(g$sulfate, g$nitrate), groups, SIMPLIFY = TRUE)
}