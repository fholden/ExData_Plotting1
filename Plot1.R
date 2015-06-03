# Start with a clean slate
rm(list=ls())

# Check to see if the target data file exists where it is supposed to be
# If not then download it and unzip it
fileName <- "DataSources/household_power_consumption.txt"
if (!file.exists(fileName)) {
     dsURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
     download.file(dsURL,destfile="epc.zip",method="curl")
     unzip("epc.zip")
}

#use sqldf to select the Feb 1st and 2nd 2007 data.  Check if it is installed first
if("sqldf" %in% rownames(installed.packages()) == FALSE) {install.packages("sqldf")} 
library(sqldf)
epcFull <- read.csv.sql(fileName,sep=";",sql="Select * from file where Date in ('1/2/2007','2/2/2007')",eol="\n")
closeAllConnections()
# make new column with date time for plotting
DateTime <- paste(epcFull$Date,epcFull$Time)
# add to df
epcFull <- cbind(DateTime,epcFull)

# set up Date, Time and DateTime fields as POSIXlt classes
library(lubridate)
epcFull$Time <- strptime(epcFull$Time,format="%H:%M:%S")
epcFull$Date <- strptime(epcFull$Date,format= "%d/%m/%Y")
epcFull$DateTime <- strptime(epcFull$DateTime,format="%d/%m/%Y %H:%M:%S")

# do Plot 1
png(filename="Plot1.png",width = 480, height = 480)
hist(epcFull$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)",col="red" )
dev.off()



