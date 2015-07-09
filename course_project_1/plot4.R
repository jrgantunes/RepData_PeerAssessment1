# clean workspace
rm(list = ls(all = TRUE))
# my only file in the Working Directory
Dataset <- read.table(list.files()[1], header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
# package dplyr must be already installed in your PC
library(dplyr)
# transform Date and Time
Dataset$Date <- as.Date(Dataset$Date, format = "%d/%m/%Y")

#Filter the data between two dates
February.Data <- filter(Dataset,Date %in% as.Date(c("2007-02-01","2007-02-02")))

#Plotting
## Converting dates
datetime <- paste(as.Date(February.Data$Date), February.Data$Time)
February.Data$Datetime <- as.POSIXct(datetimee)

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(February.Data, {
        plot(Global_active_power~Datetime, type="l", 
             ylab="Global Active Power", xlab="")
        plot(Voltage~Datetime, type="l", 
             ylab="Voltage", xlab="")
        plot(Sub_metering_1~Datetime, type="l", 
             ylab="Energy sub metering", xlab="")
        lines(Sub_metering_2~Datetime,col='Red')
        lines(Sub_metering_3~Datetime,col='Blue')
        legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=, lwd=2, col=c("black", "red", "blue"), bty="n", pt.cex=1, cex=0.4 )
        plot(Global_reactive_power~Datetime, type="l", 
             ylab="Global_reactive_power",xlab="")
})

## Saving to file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()