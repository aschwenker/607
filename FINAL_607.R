install.packages(c("httr", "jsonlite"))
library(tidyverse)
library(httr)
library(jsonlite)
library(tidyr)
library(qdap)
library(plyr)
library(dplyr)
library(DATA606)
library(ggmap)
library(rvest)
library(ggplot2)
library(treemap)
library(data.table)
library(RSocrata)
library(sqldf)
library(leafletR)
library(tm)


#Began restricting to stations thinking this would help associate complaints to stations
station_feedback<-subset(customer_feedback,Commendation.or.Complaint == "Complaint" & Subject.Matter =="Station /Bus Stop /Facility /Structure" &  Agency == "Subways")
subway_customer_feedback_matter_table<-sort(table(subway_customer_feedback$Subject.Matter),decreasing = T)
station_detail_table<-sort(table(station_feedback$Subject.Detail),decreasing = T)

#Read Customer Complaint Data 
customer_URL<-"https://raw.githubusercontent.com/aschwenker/607/master/MTA_Customer_Feedback_Data__Beginning_2014.csv"
customer_feedback <- read.csv(customer_URL,stringsAsFactors=FALSE)

#Subway Complaints Data Manipulation and Subsetting to Top 10
#Subset to complaints related to subways where line value isn't blank
subway_customer_feedback<-subset(customer_feedback,Commendation.or.Complaint == "Complaint" & Agency == "Subways" & Branch.Line.Route != 'No Value')
#Create table of counts and gather
subway_customer_feedback_line_table<-sort(table(subway_customer_feedback$Branch.Line.Route),decreasing=T)
line_table_df <-data.frame(rbind(subway_customer_feedback_line_table))

line_table_df_gathered<-line_table_df %>% gather(line,occurence)
#Remove leading X from numbered lines
gathered_clean<-c('X')
line_table_df_gathered$line<-gsub(paste0(gathered_clean,collapse = "|"),"", line_table_df_gathered$line)
#subset to top 10 by count of complaints related
line_top_10<-line_table_df_gathered %>% top_n(10)
#Plot top 10 by count descending order
p1<-ggplot(data=line_top_10, aes(x=reorder(line, -occurence), y=occurence, fill=line)) +
  geom_bar(position = 'dodge',stat="identity")+ theme(legend.position="none")+xlab(label="Subway Line")+
  ylab(label="Count of Related Complaints")+ggtitle("Top Ten Subways By Complaint Count")
p1
#RANK
#restrict to top 10
customer_line_ranked<-rank(subway_customer_feedback_table[1:10],ties.method= "first")
customer_line_ranked_df <-data.frame(rbind(customer_line_ranked))
customer_line_ranked_df_gathered<-customer_line_ranked_df %>% gather(line,occurence)
#Remove leading X from numbered lines
gathered_clean<-c('X')
customer_line_ranked_df_gathered$line<-gsub(paste0(gathered_clean,collapse = "|"),"", customer_line_ranked_df_gathered$line)
customer_line_ranked_df_gathered
#Revieiwing Top Complaint content
top_10_line_subset_customer<-unique(line_top_10$line)

customer_top_10<-subset(subway_customer_feedback,Branch.Line.Route %in% top_10_line_subset_customer & Subject.Detail != "No Value")

subway_customer_feedback_matter_table<-sort(table(customer_top_10$Subject.Matter),decreasing = T)
subway_customer_feedback_matter_table_df <-data.frame(rbind(subway_customer_feedback_matter_table))
subway_customer_feedback_matter_table_df_gathered<-subway_customer_feedback_matter_table_df%>% gather(subject_matter,occurence)
subway_customer_feedback_matter_table_df_gathered_top_10<-subway_customer_feedback_matter_table_df_gathered %>% top_n(10)
subway_customer_feedback_matter_table_df_gathered_top_10
#Plot top ten events happening on top ten highest incident lines
pcustomer_subject_matter<-ggplot(data=subway_customer_feedback_matter_table_df_gathered_top_10, aes(x=reorder(subject_matter, -occurence), y=occurence, fill=subject_matter)) +
  geom_bar(position = 'dodge',stat="identity")+xlab(label="Subject Matter")+theme(legend.position="none")+
  ylab(label="Count of Related MTA Customer Complaints")+ggtitle("Top Ten MTA Customer Complaint Subject Matters Occuring on Top 10 highest incident subway lines By MTA Customer Complaint Count")+ coord_flip()
pcustomer_subject_matter


#Subject Detail
station_detail_table<-sort(table(customer_top_10$Subject.Detail),decreasing = T)
station_detail_table
station_detail_table_df <-data.frame(rbind(station_detail_table))
station_detail_table_df_gathered<-station_detail_table_df%>% gather(subject_detail,occurence)
station_detail_table_df_gathered_top_10<-station_detail_table_df_gathered %>% top_n(10)
station_detail_table_df_gathered_top_10
#Plot top ten events happening on top ten highest incident lines
pcustomer_subject_detail<-ggplot(data=station_detail_table_df_gathered_top_10, aes(x=reorder(subject_detail, -occurence), y=occurence, fill=subject_detail)) +
  geom_bar(position = 'dodge',stat="identity")+xlab(label="Subject Detail")+theme(legend.position="none")+
  ylab(label="Count of Related MTA Customer Complaints")+ggtitle("Top Ten MTA Customer Complaint Subject Details Occuring on Top 10 highest incident subway lines By MTA Customer Complaint Count")+ coord_flip()
pcustomer_subject_detail

#Subway stations & Entrances, intended to associate to data and create map to highlight high areas
subway_station_URL<-"https://raw.githubusercontent.com/aschwenker/607/master/DOITT_SUBWAY_STATION_01_13SEPT2010.csv"
stations <- read.csv(subway_station_URL,stringsAsFactors=FALSE)
head(stations)
URL<-"https://data.ny.gov/resource/hvwh-qtfg.csv"
entrances<-GET(URL)
entrances<-content(entrances)
unique(entrances$station_name)

#511 reports
#read in 511 data from socrata api
Data_511<-read.socrata("https://data.ny.gov/resource/gvhy-7eph.csv")
head(Data_511)
#list organizations to determine subsetting
unique(Data_511$organization_name)
smaller <- subset(Data_511,organization_name == "MTA NYC Transit Subway" | organization_name == "MTA - New York City Transit")
unique(smaller$facility_name)
#Clean up names of subway lines
remove_words<-c("Epress",'Select',' es ','some','Linees','Lines','lines', 'Line','line','Trains','trains', 'Train','train', '  ','Tains', '#', ',','liine','and','&')
x <-smaller$facility_name        #Company column data
smaller$facility_name<- removeWords(x,remove_words)     #Remove stopwords
unique(smaller$facility_name)
smaller$facility_name<-gsub("&","",smaller$facility_name)
smaller$facility_name<-gsub("#","",smaller$facility_name)
smaller$facility_name<-gsub(",","",smaller$facility_name)

smaller<-smaller %>% 
  mutate(facility_name = strsplit(as.character(facility_name), " ")) %>% 
  unnest(facility_name)
head(smaller)
smaller<-smaller[!(is.na(smaller$facility_name) | smaller$facility_name==""), ]

Data_511_facility_name_table<-sort(table(smaller$facility_name),decreasing = T)
Data_511_facility_name_table
Data_511_facility_name_table <-data.frame(rbind(Data_511_facility_name_table))
Data_511_facility_name_table_gathered<-Data_511_facility_name_table%>% gather(line,occurence)
gathered_clean<-c('V','X')
Data_511_facility_name_table_gathered$line<-gsub(paste0(gathered_clean,collapse = "|"),"", Data_511_facility_name_table_gathered$line)
Data_511_facility_name_table_gathered_top_10<-Data_511_facility_name_table_gathered %>% top_n(10)
top_10_line_subset<-unique(Data_511_facility_name_table_gathered_top_10$line)

p511<-ggplot(data=Data_511_facility_name_table_gathered_top_10, aes(x=reorder(line, -occurence), y=occurence, fill=line)) +
  geom_bar(position = 'dodge',stat="identity")+ theme(legend.position="none")+xlab(label="Subway Line")+
  ylab(label="Count of Related 511 Incidents")+ggtitle("Top Ten Subways By 511 Incident Count")
p511

#RANK
Data_511_facility_name_ranked<-rank(Data_511_facility_name_table[1:10],ties.method= "first")
Data_511_facility_name_ranked_df <-data.frame(rbind(Data_511_facility_name_ranked))
Data_511_facility_name_ranked_df_gathered<-Data_511_facility_name_ranked_df %>% gather(line,occurence)
#Remove leading X from numbered lines
gathered_clean<-c('X')
Data_511_facility_name_ranked_df_gathered$line<-gsub(paste0(gathered_clean,collapse = "|"),"", Data_511_facility_name_ranked_df_gathered$line)
Data_511_facility_name_ranked_df_gathered

#Selecting events occuring on lines in top 10
smaller_top_10<-subset(smaller,facility_name %in% top_10_line_subset)
#Data clean up
smaller_top_10<-data.frame(lapply(smaller_top_10, function(v) {
  if (is.character(v)) return(toupper(v))
  else return(v)
}))

#Top events on these lines
smaller_top_10_event_type_table<-sort(table(smaller_top_10$event_type),decreasing = T)
smaller_top_10_event_type_table_df <-data.frame(rbind(smaller_top_10_event_type_table))
smaller_top_10_event_type_table_df_gathered<-smaller_top_10_event_type_table_df%>% gather(event_type,occurence)
smaller_top_10_events_top_10<-smaller_top_10_event_type_table_df_gathered %>% top_n(10)
#Plot top ten events happening on top ten highest incident lines
p511_events<-ggplot(data=smaller_top_10_events_top_10, aes(x=reorder(event_type, -occurence), y=occurence, fill=event_type)) +
  geom_bar(position = 'dodge',stat="identity")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+xlab(label="Event")+
  ylab(label="Count of Related 511 Incidents")+ggtitle("Top Ten 511 Events Occuring on Top 10 highest incident subway lines By 511 Incident Count")
p511_events


#Turnstile Data below, chose not to use for ridership
turnstiles<-read.csv("H:/CLASS/CUNY_SPS_MS_DS/Fall18_607/607/FINAL/Turnstile_Usage_Data__2017.csv")
turnstiles<-gather(turnstiles,'Entries','Exits',key="action",value="cumulative_register")
turnstiles$Date<-as.Date(turnstiles$Date, format = "%m/%d/%Y")
turnstiles_entries<-subset(turnstiles,action=="Entries")
arrange(turnstiles_entries,desc(cumulative_register))

#screen scrape
ridership_url<-("http://web.mta.info/nyct/facts/ridership/ridership_sub_annual.htm")
webpage <- read_html(ridership_url)
ridership <- ridership_url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="subway"]') %>%
  html_table()
ridership<-ridership[1]
ridership <- data.frame(ridership)
ridership_subset<-c("Station..alphabetical.by.borough.","X2017.Rank")
ridership<-ridership[ridership_subset]
ridership<-ridership[!(is.na(ridership$X2017.Rank) | ridership$X2017.Rank==""), ]
ridership$X2017.Rank<-as.numeric(ridership$X2017.Rank)
ridership_sorted<-ridership[order(ridership$X2017.Rank),]
head(ridership_sorted)
excluded_columns<-names(ridership) %in% c("X2016.2017.Change","X2016.2017.Change.1","X2017.Rank")
ridership<-ridership[!excluded_columns]
ridership%>%
  gather(year,ridership,X2012:X2017)

#Find Shared Values between two Top Ten Lists
customer_complaints_top_10<-customer_line_ranked_df_gathered$line
Data_511_top_10<-Data_511_facility_name_ranked_df_gathered$line
Shared_Top_Ten<-Reduce(intersect, list(Data_511_top_10,customer_complaints_top_10))
#Subset each to just shared values
Shared_Top_Customer<-subset(customer_line_ranked_df_gathered,line %in%Shared_Top_Ten)
Shared_Top_511<-subset(Data_511_facility_name_ranked_df_gathered,line %in%Shared_Top_Ten)
#Order by Line
Shared_Top_511_Sorted <- Shared_Top_511[order(Shared_Top_511$line),] 
Shared_Top_Customer_Sorted <- Shared_Top_Customer[order(Shared_Top_Customer$line),] 
#Create Combined Rank
Shared_Top_511_Sorted$Combined_Rank<-(Shared_Top_Customer_Sorted$occurence+Shared_Top_511_Sorted$occurence)/2
#Final Combined Rank
Final <- c("line", "Combined_Rank")
Combined_Rank<-Shared_Top_511_Sorted[Final]
Combined_Rank