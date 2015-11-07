## This code assumes that the zipped file containing the data set is
## downloaded to the working directory and extracted there. This process
## creates the subdirectory /exdata_data_household_power_consumption/ which 
## contains the big data file 'household_power_consumption.txt' used in 
## this R code.

## Read a subset of the big data file - all the rows for two dates: 2-1-2007
## and 2-2-2007. The 2880 rows after the row containing "31/1/2007;23:59:00"
## are read in. Note there are 2*(24*60) = 2880 rows - 
## 2 days, 24 hours in a day, 60 minutes per hour.

text_file <- "./exdata_data_household_power_consumption/household_power_consumption.txt"
subset_file <- read.table(text_file, header = FALSE, sep = ";", na.strings = "?",
           colClasses = c("character","character", "numeric", "numeric", "numeric",
           "numeric", "numeric", "numeric", "numeric"), 
           skip = grep("31/1/2007;23:59:00", readLines(text_file)), nrows = 2880)

## Rename the header to meaningful variable names
names(subset_file) <- c("date", "time", "global_active_power",
           "global_reactive_power", "voltage", "global_intensity",
           "sub_metering_1", "sub_metering_2", "sub_metering_3")

## Create "datetime" column, class POSIXlt, with format - YYYY-MM-DD HH:MM:SS.
## Convert "date" column into Date class - YYYY-MM-DD.
## Note: When datetime column is created, date and time are both character.
subset_file$datetime <- strptime(paste(subset_file$date, subset_file$time, 
           sep = " "), format = "%d/%m/%Y %T" )
subset_file$date <- as.Date(subset_file$date, "%d/%m/%Y")

## Initialize a plot to be written to a png file.
png(filename = "plot3.png")

## Create line plots of datetime vs sub_metering_1, sub_metering_2 and
## sub_metering_3. First line plot is created and the rest are super-imposed
## on the same axes.
with(subset_file, plot(datetime, sub_metering_1, type = "l", xlab = "",
          ylab = "Energy sub metering"))
with(subset_file, lines(datetime, sub_metering_2, col = "red"))
with(subset_file, lines(datetime, sub_metering_3, col = "blue"))

## Create a legend on the top right corner of the plot.
legend("topright", lty = 1, col = c("black", "red", "blue"),
          legend = c("Sub_metering_1", "Sub_metering_2",
          "Sub_metering_3"))

## Close the PNG device.
dev.off()