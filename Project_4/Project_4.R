library(tm)
library(plyr)
library(class)
library(RTextTools)
spam.dir <- file.path("H:","CLASS","CUNY_SPS_MS_DS","Fall18_607","607","Project_4","spam_ham")
spam.dir
ham_path<- file.path(spam.dir,"easy_ham/")  
ham_path
all.file <- dir(ham_path)
all.file <- all.file[which(all.file!="cmds")]
all.file
readLines(file.path(ham_path,all.file[1]))
typeof(all.file)
msg.all <- sapply(all.file, function(p) readLines(file.path(ham_path,p)))
head(msg.all)

easy_ham.all    <- get.all(path.cat(spam.dir,"easy_ham/"))
easy_ham_2.all  <- get.all(paste0(spam.dir, "easy_ham_2/"))
spam.all        <- get.all.try(paste0(spam.dir, "spam/"))
spam_2.all      <- get.all(paste0(spam.dir, "spam_2/"))
easy_ham_df <-as.data.frame(msg.all)

corp<-Corpus(VectorSource(msg.all))
easy_ham_df <-DocumentTermMatrix(corp)
easy_ham_df
inspect(easy_ham_df)
typeof(easy_ham_df)
single_ham<-file.path(ham_path,"0997.df0c214721243248b9421e3c0ba9e453")
single_ham
text<-readLines(single_ham)
head(text)