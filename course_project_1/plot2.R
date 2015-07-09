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
February.Data$Datetime <- as.POSIXct(datetime)

## Plot 2
plot(February.Data$Global_active_power~February.Data$Datetime, type="l",
     ylab="Global Active Power (kilowatts)", xlab="")
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()