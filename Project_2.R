library(dplyr)
library(tidyr)
library(tidyverse)
family_justice_foreign_Born <- read.csv(file="H:/CLASS/CUNY_SPS_MS_DS/Fall18_607/OCDV_Family_Justice_Center_Foreign_Born_Report.csv", header=TRUE, sep=",")
family_justice_foreign_Born

restructured<-family_justice_foreign_Born %>%
  gather(Intake_Question,response_count,-Visit_Year,)
restructured_clean <-restructured[!(is.na(restructured$response_count) | restructured$response_count==""), ]
restructured_clean%>%group_by(Visit_Year,Intake_Question)%>% summarise(Total_Response_Count=sum(response_count))
Intimate_Partner_Violence <- read.csv(file="H:/CLASS/CUNY_SPS_MS_DS/Fall18_607/2017_Intimate_Partner_Violence_Related_Snapshots__New_York_City_Community_Board_Districts.csv", header=TRUE, sep=",")
Intimate_Partner_Violence
Intimate_Partner_Violence_clean <- Intimate_Partner_Violence[!(is.na(Intimate_Partner_Violence$Comm_Dist_.Boro) | Intimate_Partner_Violence$Comm_Dist_.Boro==""), ]
Intimate_Partner_Violence_clean <-Intimate_Partner_Violence_clean[!(is.na(Intimate_Partner_Violence_clean$Comm_District) | Intimate_Partner_Violence_clean$Comm_District==""), ]
Intimate_Partner_Violence_clean
restruct_Intimate_Partner_Violence_clean <- Intimate_Partner_Violence_clean %>% 
  gather(incident, reporting_count,IPV_DIR:DV_Rape,-Comm_Dist_.Boro)
  
restruct_Intimate_Partner_Violence_clean%>%group_by(Comm_Dist_.Boro,incident)%>% summarise(Total_reporting_count=sum(reporting_count))
NYC_Pop_By_Boro <-read.csv(file="H:/CLASS/CUNY_SPS_MS_DS/Fall18_607/New_York_City_Population_by_Borough__1950_-_2040.csv", header=TRUE, sep=",")
NYC_Pop_By_Boro
united<-NYC_Pop_By_Boro%>%
  unite(x1950,X1950,X1950...Boro.share.of.NYC.total,sep="_")%>%
  unite(x1960,X1960,X1960...Boro.share.of.NYC.total,sep="_")%>%
  unite(x1970,X1970,X1970...Boro.share.of.NYC.total,sep="_")%>%
  unite(x1980,X1980,X1980...Boro.share.of.NYC.total,sep="_")%>%
  unite(x1990,X1990,X1990...Boro.share.of.NYC.total,sep="_")%>%
  unite(x2000,X2000,X2000...Boro.share.of.NYC.total,sep="_")%>%
  unite(x2010,X2010,X2010...Boro.share.of.NYC.total,sep="_")%>%
  unite(x2020,X2020,X2020...Boro.share.of.NYC.total,sep="_")%>%
  unite(x2030,X2030,X2030...Boro.share.of.NYC.total,sep="_")%>%
  unite(x2040,X2040,X2040...Boro.share.of.NYC.total,sep="_")
united
restructured_NYC_Pop_By_Boro<-united%>%
  gather(year,population,-Age.Group,-Borough)
restructured_NYC_Pop_By_Boro
separated<-restructured_NYC_Pop_By_Boro %>%
  separate(population,c("population","percent_total"),sep = "_")
separated

pop_1950<-subset(separated,year=="x1950"|year=="x2000",select=Borough:population)
pop_1950