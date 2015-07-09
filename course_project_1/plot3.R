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

## Plot 3
with(February.Data, {
        plot(Sub_metering_1~Datetime, type="l",
             ylab="Global Active Power (kilowatts)", xlab="")
        lines(Sub_metering_2~Datetime,col='Red')
        lines(Sub_metering_3~Datetime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Saving to file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()