#install.packages("dplyr")
#install.packages("readr")

library(dplyr)
library(readr)
#setwd(경로설정)

dir <- ("C:/Users/cross/Desktop/DM/Dataset")
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
data <- data.frame(lat, lon, ele, time, month, day, hour, weekdays)
num = 0

for(file in file_list){
  print(file)
  temp <- read.csv(paste(dir, file, sep ="\\"),header=TRUE, sep=",",stringsAsFactors=FALSE)
  att <- names(temp)

  for (name in att){
    if(name == "lat"){
      temp <- rename(temp, ele = ns1.ele)
      temp <- rename(temp, time = ns1.time)
      newTemp <- select(temp,c(lat,lon, ele, time))
      
      ### 흡연장의 고도 : 84~85 ### 
      ###공대의 1층 고도 : 89~90 ###
      ###멀관의 2층 고도 :68.09(평균산출 결과) -> 멀관 1층은 66정도? ###
      ###우정원의 층의 고도 : 74이하 ###
      #교외/멀관/공대 제외하는 코드
      newTemp <- newTemp %>% filter(newTemp$lat<=37.2480, newTemp$lat>= 37.2380 & newTemp$lon <=127.086,newTemp$lon>=127.0757 )
      newTemp <- newTemp %>% filter(newTemp$lat<37.2449 | newTemp$lon<127.07857 | newTemp$ele<85)
      newTemp <- newTemp %>% filter(newTemp$ele < 67 | newTemp$lat>37.24481 | newTemp$lat <37.243981 | newTemp$lon >127.076936 | newTemp$lon <127.075835) 
      
      ### 시간좌표 전처리 tzone 기능사용 ###
      attributes(newTemp$time)$tzone <- "Asia/Seoul"
      newTemp$month <- as.numeric(format(newTemp$time, '%m'))
      newTemp$day <- as.numeric(format(newtemp$time, '%d'))
      newTemp$hour <- as.numeric(format(newTemp$time, '%H'))
      newTemp$weekdays <- weekdays.POSIXt(newTemp$time,abbreviate=T)
      
      
      data <- rbind(data,newTemp)
      data <- data[-1,]
      write.csv(data, paste0("C:/Users/cross/Desktop/DM/NewDataset/dataset", num, ".csv"))
      num = num + 1
    }
    else if(name == "Latitude"){
      temp <- rename(temp, lat = Latitude)
      temp <- rename(temp, lon = Longitude)
      temp <- rename(temp, ele = Elevation)
      temp <- rename(temp, time = Timestamp)
      newTemp <- select(temp,c(lat,lon, ele, time))
      
      ### 흡연장의 고도 : 84~85 ### 
      ###공대의 1층 고도 : 89~90 ###
      ###멀관의 2층 고도 :68.09(평균산출 결과) -> 멀관 1층은 66정도? ###
      ###우정원의 층의 고도 : 74이하 ###
      #교외/멀관/공대 제외하는 코드
      newTemp <- newTemp %>% filter(newTemp$lat<=37.2480, newTemp$lat>= 37.2380 & newTemp$lon <=127.086,newTemp$lon>=127.0757 )
      newTemp <- newTemp %>% filter(newTemp$lat<37.2449 | newTemp$lon<127.07857 | newTemp$ele<85)
      newTemp <- newTemp %>% filter(newTemp$ele < 67 | newTemp$lat>37.24481 | newTemp$lat <37.243981 | newTemp$lon >127.076936 | newTemp$lon <127.075835) 
      
      ### 시간좌표 전처리 tzone 기능사용 ###
      newTemp$time<- as.POSIXct(newTemp$time)
      attributes(newTemp$time)$tzone <- "Asia/Seoul"
      newTemp$month <- as.numeric(format(newTemp$time, '%m'))
      newTemp$day <- as.numeric(format(newTemp$time, '%d'))
      newTemp$hour <- as.numeric(format(newTemp$time, '%H'))
      newTemp$weekdays <- weekdays.POSIXt(newTemp$time,abbreviate=T)


      data <- rbind(data,newTemp)
      data <- data[-1,]
      write.csv(data, paste0("C:/Users/cross/Desktop/DM/NewDataset/dataset", num, ".csv"))
      num = num + 1
    }
  }
}

