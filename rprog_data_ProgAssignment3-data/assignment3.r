source('./helper.r')


rankhospital <- function(state, outcome, rank='best') {
	# security checks if inputs are valid
	state <- toupper(state)
	outcome <- tolower(outcome)
	# check if state abbriviation in states
	stopifnot(state %in% states)
	# check if out come messurment is valid
	stopifnot(outcome %in% outcomes)


	df <- ldf[ldf$State == state, ]
	if(outcome == 'heart attack') {
		df <- df[, c('Hospital.Name', 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack')]
	} else if(outcome == 'heart failure') {
		df <- df[, c('Hospital.Name', 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure')]
	} else {
		df <- df[, c('Hospital.Name', 'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')]

	}
	df <- filterforbestproblem(df)
	# return best hospital
	if(rank == 'best') {
		df[order(df$rates, df$hospital), 'hospital'][1]
	} else if (rank == 'worst') {
		tail(df[order(df$rates, df$hospital), 'hospital'], 1)
	} else {
		stopifnot(is.numeric(rank))
		df[order(df$rates, df$hospital), 'hospital'][rank]
	}
		
}


rankall <- function(outcome, rank='best') {
	# security checks if outcome is valid
	outcome <- tolower(outcome)
	stopifnot(outcome %in% outcomes)
	# split data for each state
	groups <- split(ldf, ldf$State)
	if(outcome == 'heart attack') {
		groups <- lapply(groups, function(group) group[, c('Hospital.Name', 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack')])
	} else if(outcome == 'heart failure') {
		groups <- lapply(groups, function(group) group[, c('Hospital.Name', 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure')])
	} else {
		groups <- lapply(groups, function(group) group[, c('Hospital.Name', 'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia')])

	}

	groups <- lapply(groups, function(group) filterforbestproblem(group))

	if(rank == 'best') {
		groups <- lapply(groups, function(group) group[order(group$rates, group$hospital), 'hospital'][1])
	} else if (rank == 'worst') {
		groups <- lapply(groups, function(group) tail(group[order(group$rates, group$hospital), 'hospital'], 1))
	} else {
		stopifnot(is.numeric(rank))
		groups <- lapply(groups, function(group) group[order(group$rates, group$hospital), 'hospital'][rank])
	}
	groups

}