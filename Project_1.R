library(dplyr)
library(stringr)
library(tidyr)
#Project 1

#OUTPUT : CSV WITH : Player's Name, Player's State, Total Number of Points, Player's Pre-Rating, and Average Pre Chess Rating of Opponents
# AVG PRE-Chess rating : 1605 was calculated by sum the pre-tournament opponents' ratings and dividing by the total number of games played.


scores_table_raw<-"https://raw.githubusercontent.com/aschwenker/607/master/Scores.txt"

scores_table<-read.delim(scores_table_raw,header = FALSE,sep = "|",stringsAsFactors =FALSE)
scores_table
sapply(scores_table, class)

scores_table$V1<-str_replace_all(scores_table$V1,"-","")
scores_table
sapply(scores_table, class)


scores_table_sub_removed<-scores_table %>% dplyr::filter(row_number()%%3 != 1) ## Delete every 3rd row starting from 1
head(scores_table_sub_removed)
scores_table_sub_removed <- scores_table_sub_removed[-c(1:2), ]
scores_table_sub_removed<- cbind(scores_table_sub_removed[-nrow(scores_table_sub_removed),], scores_table_sub_removed[-1,])
names(scores_table_sub_removed) <- c("PairNum","PlayerName","TotalPts","Rd1","Rd2","Rd3","Rd4","Rd5","Rd6","Rd7","NA","State","USCF_ID","Info","X1","X2","X3","X4","X5","X6","X7","NA2")
rownames(scores_table_sub_removed) <- 1:nrow(scores_table_sub_removed)
head(scores_table_sub_removed)
scores_table_sub_removed$PairNum<-as.numeric(scores_table_sub_removed$PairNum)
scores_table_sub_removed_again<-scores_table_sub_removed %>% dplyr::filter(row_number() %%2 == 1) ## Delete every 2nd row starting from 1
head(scores_table_sub_removed_again)
scores_table_sub_removed_again<-scores_table_sub_removed_again %>% separate(USCF_ID, c("USCF ID", "Pre_Post"),sep="/")
scores_table_sub_removed_again

scores_table_sub_removed_again$Pre_Post <- gsub('\\s+', '', scores_table_sub_removed_again$Pre_Post)
scores_table_sub_removed_again$Pre_Post <- gsub('R:', '', scores_table_sub_removed_again$Pre_Post)
scores_table_sub_removed_again<-scores_table_sub_removed_again %>% separate(sep_col_2, c("Pre", "Post"),sep="->")
scores_table_sub_removed_again

scores_table_sub_removed_again<-scores_table_sub_removed_again %>% separate(Pre, c("Pre", "Remove"), sep = "P")
scores_table_sub_removed_again


for (i in 4:10) {
  scores_table_sub_removed_again[, i] <- str_trim(str_extract(scores_table_sub_removed_again[, i], "[[:space:]]+[[:digit:]]{1,2}"))
}


for (i in 1:nrow(scores_table_sub_removed_again)) {
  print(i)
  for(j in 4:10) {
    print(scores_table_sub_removed_again[i,j])
    print(scores_table_sub_removed_again[i,1])
    scores_table_sub_removed_again[i,j] <- scores_table_sub_removed_again[scores_table_sub_removed_again$PairNum == scores_table_sub_removed_again[i,j],scores_table_sub_removed_again$Pre]
    print(scores_table_sub_removed_again[i,j])
    # [1] at end avoids error from NAs
  }
}
scores_table_sub_removed_again