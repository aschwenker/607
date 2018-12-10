install.packages(c("httr", "jsonlite"))
library(tidyverse)
library(httr)
library(jsonlite)
library(tidyr)
library(qdap)
library(dplyr)
library(DATA606)
library(ggmap)
customer_URL<-"https://raw.githubusercontent.com/aschwenker/607/master/MTA_Customer_Feedback_Data__Beginning_2014.csv"
subway_station_URL<-"https://raw.githubusercontent.com/aschwenker/607/master/DOITT_SUBWAY_STATION_01_13SEPT2010.csv"
head(subway_station_URL)
customer_feedback <- read.csv(customer_URL,stringsAsFactors=FALSE)
customer_feedback<-subset(customer_feedback,Year<2018)
head(customer_feedback)
unique(customer_feedback$Agency)
typeof(customer_feedback)
subway_customer_feedback<-subset(customer_feedback,Commendation.or.Complaint == "Complaint" & Agency == "Subways")
sort(table(subway_customer_feedback$Subject.Matter),decreasing = T)
barplot(sort(table(subway_customer_feedback$Subject.Matter),decreasing = T))
station_feedback<-subset(customer_feedback,Commendation.or.Complaint == "Complaint" & Subject.Matter =="Station /Bus Stop /Facility /Structure" &  Agency == "Subways")
station_subject_table<-sort(table(station_feedback$Subject.Detail),decreasing = T)
station_subject_table_subset<-subset(station_subject_table,>500)

Top_Complaint_Subjects<-c("Ticket Machines","Station - General","Platforms","Signage","Turnstiles","Track / Right-of-Way","Staircase","Elevators")
station_general_feedback<-subset(customer_feedback,Commendation.or.Complaint == "Complaint" & Subject.Matter =="Station /Bus Stop /Facility /Structure" & Subject.Detail == "Station - General" & Agency == "Subways")
station_Top_Complaints_feedback<-subset(customer_feedback,Commendation.or.Complaint == "Complaint" & Subject.Matter =="Station /Bus Stop /Facility /Structure" & Subject.Detail %in% Top_Complaint_Subjects  & Agency == "Subways")
station_Top_Complaints_feedback_table<-sort(table(station_Top_Complaints_feedback$Subject.Detail),decreasing = T)
lbls <- paste(names(station_Top_Complaints_feedback_table), "\n", station_Top_Complaints_feedback_table, sep="")
pie(station_Top_Complaints_feedback_table,labels=lbls,main = "TEST PIE")
head(station_Top_Complaints_feedback)
sort(table(station_feedback$Branch.Line.Route),decreasing = T)
barplot(sort(table(station_feedback$Branch.Line.Route),decreasing = T))
barplot(table(station_Top_Complaints_feedback$Subject.Detail))
unique(station_feedback$Issue.Detail)
unique(station_feedback$Subject.Detail)
table(subway_customer_feedback$Branch.Line.Route,subway_customer_feedback$Subject.Matter)
plot(table(subway_customer_feedback$Year,subway_customer_feedback$Subject.Matter),main= "Subway Customer Complaint Feedback Subject Proportions By Year",las=1)

stations <- read.csv(subway_station_URL,stringsAsFactors=FALSE)
head(stations)

Data_511<- read.csv("H:/CLASS/CUNY_SPS_MS_DS/Fall18_607/607/FINAL/511_NY_Events__Beginning_2010.csv")
URL<-"https://data.ny.gov/resource/hvwh-qtfg.csv"
entrances<-GET(URL)
entrances<-content(entrances)
entrances
head(entrances)

p <- ggmap(get_googlemap(center = c(lon = -122.335167, lat = 47.608013),
                         zoom = 11, scale = 2,
                         maptype ='terrain',
                         color = 'color'))
p + geom_point(aes(x = Longitude, y = entrance_latitu,  colour = Initial.Type.Group), data = entrances, size = 0.5) + 
  theme(legend.position="bottom")

unique(entrances$division)
unique(entrances[,c('division','line','route1',"route2",'route3','route4','route5','route6','route7','route8','route9','route10','route11')])
unique(entrances$station_name)

head(Data_511)
unique(Data_511$Organization.Name)
smaller <- subset(Data_511,Organization.Name == "MTA NYC Transit Subway" | Organization.Name == "MTA - New York City Transit")
unique(smaller$Facility.Name)
head(smaller)

head(entrances)

turnstiles<-read.csv("H:/CLASS/CUNY_SPS_MS_DS/Fall18_607/607/FINAL/Turnstile_Usage_Data__2017.csv")
turnstiles<-gather(turnstiles,'Entries','Exits',key="action",value="cumulative_register")
turnstiles$Date<-as.Date(turnstiles$Date, format = "%m/%d/%Y")
turnstiles_entries<-subset(turnstiles,action=="Entries")
arrange(turnstiles_entries,desc(cumulative_register))
