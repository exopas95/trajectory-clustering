#install.packages("dplyr")
#install.packages("readr")

library(dplyr)
library(readr)
#setwd(경로설정)

dir <- ("C:/Users/cross/Desktop/DM/Dataset")
file_list <- list.files(dir)
file_list
lat <- c(0)
lon <- c(0)
data <- data.frame(lat, lon)

for(file in file_list){
  print(file)
  temp <- read.csv(paste(dir, file, sep ="\\"),header=TRUE, sep=",",stringsAsFactors=FALSE)
  att <- names(temp)
  for (name in att){
    if(name == "lat"){
      newTemp <- select(temp,c(lat,lon))
      
      #공대/교외 제외하는 코드
      newTemp <- newTemp %>% filter(newTemp$lat <=37.2480,newTemp$lat >=37.2380  & newTemp$lon <=127.086,newTemp$lon>=127.0757 )
      newTemp <- newTemp %>% filter(newTemp$lat< 37.2449 | newTemp$lon<127.07857)
      
      data <- rbind(data,newTemp)
    }
    else if(name == "Latitude"){
      temp <- rename(temp, lat = Latitude)
      temp <- rename(temp, lon = Longitude)
      newTemp <- select(temp,c(lat,lon))
      
      #여기만 수정해주세요
      newTemp <- newTemp %>% filter(newTemp$lat<=37.2480, newTemp$lat>= 37.2380 & newTemp$lon <=127.086,newTemp$lon>=127.0757 )
      newTemp <- newTemp %>% filter(newTemp$lat<37.2449 | newTemp$lon<127.07857)
      
      data <- rbind(data,newTemp)
    }
  }
}


n1<-nrow(data)
n2<-nrow(data)
n3<-nrow(data)
n4<-nrow(data)
n5<-nrow(data)
n6<-nrow(data)
n8<-nrow(data)

rank_team <- data.frame(team = c(1,2,3,4,5,6,8), number = c(n1,n2,n3,n4,n5,n6,n8))
rank_team <- rank_team %>% arrange(desc(rank_team$number))