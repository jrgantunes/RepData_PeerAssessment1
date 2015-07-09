# clean workspace
rm(list = ls(all = TRUE))
# my only file in the Working Directory
Dataset <- read.table(list.files()[1], header=TRUE, sep=";", stringsAsFactors=FALSE, dec=".")
# package dplyr must be already installed in your PC
library(dplyr)
# transform Date and Time
Dataset$Date <- as.Date(Dataset$Date, format = "%d/%m/%Y")
#Dataset$Time <- strptime(Dataset$Time, format = "%H:%M:%S")
#Filter the data between two dates
February.Data <- filter(Dataset,Date %in% as.Date(c("2007-02-01::2007-02-02")))

#Plotting
globalActivePower <- as.numeric(February.Data$Global_active_power)
png("plot1.png", width=480, height=480)
hist(globalActivePower, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()

