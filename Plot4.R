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

# do Plot 4
png(filename="Plot4.png",width = 480, height = 480)
old.par <- par(mfrow=c(2,2),mar=c(4,4,2,1), oma=c(0,0,2,0))
#1
plot(epcFull$DateTime, epcFull$Global_active_power, type="l",xlab="Day of the Week",ylab="Global Active Power (kilowatts)")
#2
plot(epcFull$DateTime, epcFull$Voltage, type="l",xlab="Day of the Week",ylab="Voltage")
#3
plot(epcFull$DateTime, epcFull$Sub_metering_1, type="l",xlab="Day of the Week",ylab="Energy sub metering (kilowatts)")
lines(epcFull$DateTime,epcFull$Sub_metering_2,col="red")
lines(epcFull$DateTime,epcFull$Sub_metering_3,col="blue")
legend("topright", 1:3, cex=0.8,legend=c("sub meter 1","sub meter 2","sub meter 3"), pch=-1,lty=1,col=c("black","red","blue"))
#4
plot(epcFull$DateTime, epcFull$Global_reactive_power, type="l",xlab="Day of the Week",ylab="Global reactive Power (kilowatts)")
title("Power Consumption Feb 1 and 2, 2007",outer=T)
par(old.par)
dev.off()



