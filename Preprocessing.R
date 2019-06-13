#install.packages("dplyr")
#install.packages("readr")

library(dplyr)
library(readr)
#setwd(경로설정)

dir <- ("C:/Users/Sewoong/Desktop/Develop/Trajectory-Clustering/DatasetB")
file_list <- list.files(dir)
file_list
lat <- c()
lon <- c()
ele <- c()
time <- c()
month <- c()
day <- c()
hour <- c()
weekdays <- c()
data1 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
data2 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
data3 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
data4 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
data5 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)

FinalData1 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
FinalData2 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
FinalData3 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
FinalData4 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
FinalData5 <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
num = 0

for(file in file_list){
  print(file)
  temp <- read.csv(paste(dir, file, sep ="\\"),header=TRUE, sep=",",stringsAsFactors=FALSE)
  att <- names(temp)
  
  for (name in att){
    if(name == "Latitude"){
      temp <- rename(temp, lat = Latitude)
      temp <- rename(temp, lon = Longitude)
      temp <- rename(temp, ele = Elevation)
      temp <- rename(temp, time = Timestamp)
      newTemp <- select(temp,c(lat,lon, ele, time))
    }
    if(name == "lan"){
      temp <- rename(temp, ele = ns1.ele)
      temp <- rename(temp, time = ns1.time)
      newTemp <- select(temp,c(lat,lon, ele, time))
    }
  }
      
    ### 흡연장의 고도 : 84~85 ### 
    ###공대의 1층 고도 : 89~90 ###
    ###멀관의 2층 고도 :68.09(평균산출 결과) -> 멀관 1층은 66정도? ###
    ###우정원의 층의 고도 : 74이하 ###
    #교외/공대외각/도서관외각/국제학관아래 제외하는 코드
    newTemp <- newTemp %>% filter(newTemp$lat <= 37.2480, newTemp$lat>= 37.2380 & newTemp$lon <=127.086,newTemp$lon>=127.0757 )
    newTemp <- newTemp %>% filter(newTemp$lat < 37.242607 | newTemp$lon < 127.081834)
    newTemp <- newTemp %>% filter(newTemp$lat > 37.240400 | newTemp$lon > 127.079036)
    newTemp <- newTemp %>% filter(newTemp$lat > 37.240156)
      
      
    ### 시간좌표 전처리 tzone 기능사용 ###
    newTemp$time<- as.POSIXct(newTemp$time)
    attributes(newTemp$time)$tzone <- "Asia/Seoul"
    newTemp$month <- as.numeric(format(newTemp$time, '%m'))
    newTemp$day <- as.numeric(format(newTemp$time, '%d'))
    newTemp$hour <- as.numeric(format(newTemp$time, '%H'))
    newTemp$weekdays <- weekdays.POSIXt(newTemp$time,abbreviate=T)
      
    data1 <- newTemp %>% filter(newTemp$weekdays == '월')
    data2 <- newTemp %>% filter(newTemp$weekdays == '화')
    data3 <- newTemp %>% filter(newTemp$weekdays == '수')
    data4 <- newTemp %>% filter(newTemp$weekdays == '목')
    data5 <- newTemp %>% filter(newTemp$weekdays == '금')
      
    FinalData1 <- rbind(FinalData1, data1)
    FinalData2 <- rbind(FinalData2, data2)
    FinalData3 <- rbind(FinalData3, data3)
    FinalData4 <- rbind(FinalData4, data4)
    FinalData5 <- rbind(FinalData5, data5)
}

FinalData1 <- FinalData1[-1,]
FinalData2 <- FinalData2[-1,]
FinalData3 <- FinalData3[-1,]
FinalData4 <- FinalData4[-1,]
FinalData5 <- FinalData5[-1,]

FinalData1 <- FinalData1 %>% select(lat, lon)
FinalData2 <- FinalData2 %>% select(lat, lon)
FinalData3 <- FinalData3 %>% select(lat, lon)
FinalData4 <- FinalData4 %>% select(lat, lon)
FinalData5 <- FinalData5 %>% select(lat, lon)

write.csv(FinalData1, paste0("C:/Users/Sewoong/Desktop/Develop/Trajectory-Clustering/NewDatasetB/dataset1.csv"))
write.csv(FinalData2, paste0("C:/Users/Sewoong/Desktop/Develop/Trajectory-Clustering/NewDatasetB/dataset2.csv"))
write.csv(FinalData3, paste0("C:/Users/Sewoong/Desktop/Develop/Trajectory-Clustering/NewDatasetB/dataset3.csv"))
write.csv(FinalData4, paste0("C:/Users/Sewoong/Desktop/Develop/Trajectory-Clustering/NewDatasetB/dataset4.csv"))
write.csv(FinalData5, paste0("C:/Users/Sewoong/Desktop/Develop/Trajectory-Clustering/NewDatasetB/dataset5.csv"))

