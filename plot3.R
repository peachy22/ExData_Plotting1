#Check for lubridate and install if not present

.packages = c("lubridate")
.inst <- .packages %in% installed.packages()
if(length(.packages[!.inst]) > 0) install.packages(.packages[!.inst])
lapply(.packages, require, character.only=TRUE)
library("lubridate")

### Download data and unzip into working directory

fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL,destfile="./data.zip",method="curl")
unzip('./data.zip', files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, exdir = ".", unzip = "internal",setTimes = FALSE)

### Extract,combine, and format data for desired dates

feb107<-suppressWarnings(read.table('household_power_consumption.txt',skip=grep("1/2/2007", readLines('household_power_consumption.txt')),sep=";",nrows=1440))
feb207<-suppressWarnings(read.table('household_power_consumption.txt',skip=grep("2/2/2007", readLines('household_power_consumption.txt')),sep=";",nrows=1439))
data<-rbind(feb107,feb207)

names(data) <- c('date','time','global_active_pwr','global_reactive_pwr','voltage','global_intensity','sub_meter_1','sub_meter_2','sub_meter_3')
data$date<-dmy_hms(paste(data$date,data$time))
names(data)[1]<-'datetime'
data<- subset(data, select = -time)

### Plot and write to png

png("plot3.png")
plot(data$datetime,data$sub_meter_1, type = 'l',ylab="Energy sub metering",xlab="")
points(data$datetime,data$sub_meter_2, type = 'l',col='red')
points(data$datetime,data$sub_meter_3, type = 'l',col='blue')
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),lty = c(1, 1, 1), col = c("black", "red", "blue"))
dev.off()




