if (!file.exists("project1")) {
        dir.create("project1")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile <- "./project1/HPC_data.zip"
filename <- "./project1/household_power_consumption.txt"


#Checks if the file to download exists and if not downloads the file and unzips it 
#with mode = "curl" not working
if(!file.exists(zipfile)){
        download.file(fileUrl, destfile = zipfile, mode = "wb")   
}

if(!file.exists(filename)){
        unzip(zipfile, files = NULL, exdir="./project1")   
}

## Read Data
hpcData <- read.table(filename, header=T, sep=";", na.strings="?")

#subset Data
subsetData <- hpcData[hpcData$Date %in% c("1/2/2007","2/2/2007"),]

#convert the Date and Time variables to Date/Time classes 
#dateData <- as.Date(hpcData$Date)
#this next command does not work as time includes date
#timeData <- strptime(hpcData$Time, "%H:%M:%S")

#thus
dateData <-strptime(paste(subsetData$Date, subsetData$Time, sep=" "),"%d/%m/%Y %H:%M:%S")
finalData <- cbind(subsetData, dateData)

#Third plot
par(mfrow=c(1,1))
Sys.setlocale("LC_TIME", "en_US")
plot(finalData$dateData, finalData$Sub_metering_1, type="l", col="black", xlab="", ylab="Energy sub metering")
lines(finalData$dateData, finalData$Sub_metering_2, col="red")
lines(finalData$dateData, finalData$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty="solid")

#Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
#copy the plot to png file
dev.copy(png, file = "plot3.png")
#close the png device
dev.off()
