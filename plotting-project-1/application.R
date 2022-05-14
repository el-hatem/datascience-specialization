library(dplyr)
library(data.table)


options(scipen=999)

# create sub folder to store plots in
if(!dir.exists('./features')) {
	dir.create('./features')
}

# reading actual data
df <-  data.table::fread(input = "data.txt"
                             , na.strings="?"
                             )

# change datatype of Date
df[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# making pipline to setup selected features for Exploratory Analysis
df <- df %>%
		# change data types
		mutate(across(.cols = 3:8, .fns = as.numeric)) %>% 
		# replace null values with median, as most of them has skeweness, 
		## so that median will be more representative
		mutate(across(.cols = 3:8, .fns = ~replace(., NA, median(.)))) %>% 
		# add columns to my dataset
		mutate(day=strftime(Date,'%a'), month=month(Date), year=year(Date), 
			   dateTime=strptime(paste(Date, Time), format = "%Y-%m-%d %H:%M:%OS")) %>%
		# select only date are between 2007-02-01, and 2007-02-02
		filter(Date >= '2007-02-01' & Date <= '2007-02-02')

## display information about data
str(df)


# ##### Task1: Plot-1
png('./features/plot1.png', width = 480, height = 480)
hist(df$Global_active_power, xlab = 'Global Active Power (kilowatts)', main = 'Global Active Power', col = 'red')
dev.off()


# #### Task 2:
png('./features/plot2.png', width = 480, height = 480)
plot(df$dateTime, df$Global_active_power, type="l", xlab="", ylab = 'Global Active Power (kilowatts)')
dev.off()


# #### Task 3:
png('./features/plot3.png', width = 480, height = 480)
with(df, {
 	plot(dateTime, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
	lines(dateTime, Sub_metering_2, type="l", xlab="", col = 'red')
	lines(dateTime, Sub_metering_3, type="l", xlab="", col = 'blue')
	legend("topright", pch = 16, col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

})
dev.off()

#### Task 4:
png('./features/plot4.png', width = 480, height = 480)
par(mfrow = c(2, 2))
with(df, {
	# PLOT 1
	plot(dateTime, Global_active_power, type="l", xlab="", ylab = 'Global Active Power (kilowatts)')
	# PLOT 2
	plot(dateTime, Voltage, type="l", xlab="datetime", ylab = 'Voltage')
	# PLOT 3
	plot(dateTime, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
	lines(dateTime, Sub_metering_2, type="l", xlab="", col = 'red')
	lines(dateTime, Sub_metering_3, type="l", xlab="", col = 'blue')
	legend("topright", pch = 16, col = c("black", "blue", "red"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
	# PLOT 4
	plot(dateTime, Global_reactive_power, type="l", xlab="datetime", ylab = 'Global_reactive_power')
})
dev.off()

base::rm(list = ls())