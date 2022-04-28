load <- function(directory, id) {
	flag <- function(item, reps=0, flags='0', type='csv'){
		return(paste(strrep(flags, reps), item, '.', type, sep=''))
	}
	dfs <- data.frame()
	for (i in id) {
		file <- ifelse(i<10, flag(i, 2), ifelse(i<100, flag(i, 1), flag(i)))
		filepath <- paste(directory, file, sep = '')
		df <- read.csv(filepath, header=TRUE)
		
		dfs <- rbind(dfs, df)
	}
	return(dfs)
}