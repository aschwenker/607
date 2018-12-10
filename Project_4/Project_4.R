library(tm)
library(plyr)
library(class)
library(RTextTools)

options(stringASFactors = FALSE)

spam.dir <- file.path("H:","CLASS","CUNY_SPS_MS_DS","Fall18_607","607","Project_4","spam_ham")
spam.dir
ham_path<- file.path(spam.dir,"easy_ham/")
spam_path <-file.path(spam.dir,"spam_2/")
all_ham.file <- dir(ham_path)
all_ham.file <- all.file[which(all.file!="cmds")]
all_spam.file <- dir(spam_path)
all_spam.file <- all_spam.file[which(all_spam.file!="cmds")]
ham_msg.all <- sapply(all_ham.file, function(p) readLines(file.path(ham_path,p)))

spam_msg.all<- sapply(all_spam.file, function(p) readLines(file.path(spam_path,p)))
length(spam_msg.all)
length(ham_msg.all)
ham_corp<-Corpus(VectorSource(ham_msg.all))
meta(ham_corp, "classification") <- "ham"
colnames(ham_corp)
spam_corp<-Corpus(VectorSource(spam_msg.all))
meta(spam_corp, "classification") <- "spam"
ALL_CORP <- tm:::c.VCorpus(ham_corp,spam_corp,recursive = FALSE)
ALL_CORP
ham_corp
##FILTERING
filteropt <- list(removePunctuation=TRUE, removeNumbers=TRUE, stripWhitespace=TRUE, tolower=TRUE, stopwords=TRUE, minWordLength = 2)
DTM <-DocumentTermMatrix(ALL_CORP,control=filteropt)
easy_spam_DTM <-DocumentTermMatrix(spam_corp,control=filteropt)


ham_df<-as.data.frame(as.table(easy_ham_TDM))
spam_df<-as.data.frame(as.table(easy_spam_TDM))
ham_df$spam_ham<-"HAM"
spam_df$spam_ham<-"SPAM"
colnames(ham_df) <- c('DOCS','TERM','FREQ', 'HAM_SPAM')
ham_df <- subset(ham_df, select = c('TERM','FREQ', 'HAM_SPAM') )
ham_df$FREQ[is.na(ham_df$FREQ)] <- '0'
ham_df <- ddply(ham_df, .(TERM, HAM_SPAM), summarize, FREQ = sum(as.numeric(FREQ)))

colnames(spam_df) <- c('DOCS','TERM','FREQ', 'HAM_SPAM')
spam_df <- subset(spam_df, select = c('TERM','FREQ', 'HAM_SPAM') )
spam_df$FREQ[is.na(spam_df$FREQ)] <- '0'
spam_df <- ddply(spam_df, .(TERM, HAM_SPAM), summarize, FREQ = sum(as.numeric(FREQ)))
all_df <- merge(x = ham_df, y = spam_df, by="TERM", all = TRUE)
all_df$FREQ.y[is.na(all_df$FREQ.y)] <- '0'
all_df$HAM_SPAM.y[is.na(all_df$HAM_SPAM.y)] <- 'SPAM'
all_df$FREQ.x[is.na(all_df$FREQ.x)] <- '0'
all_df$HAM_SPAM.x[is.na(all_df$HAM_SPAM.x)] <- 'HAM'
all_df[is.na(all_df)] <- '0'
colnames(all_df)
all_df$SPAM_WEIGHT <- as.numeric(all_df$FREQ.y) - as.numeric(all_df$FREQ.x)
head(all_df)



file_names_ham <- list.files(ham_path)
file_names_spam <- list.files(spam_path)
tmp <- readLines(str_c(file_dir_spam, file_names_spam[1]))
tmp <- str_c(tmp, collapse = "")
txt_corpus <- Corpus(VectorSource(tmp))
meta(txt_corpus[[1]], "classification") <- "spam"

n <- 1
for (i in 2:length(file_names_spam)) {
  tmp <- readLines(str_c(file_dir_spam, file_names_spam[i]))
  tmp <- str_c(tmp, collapse = "")
  
  n <- n + 1
  tmp_corpus <- Corpus(VectorSource(tmp))
  txt_corpus <- c(txt_corpus, tmp_corpus)
  meta(txt_corpus[[n]], "classification") <- "spam"
}
txt_corpus

for (i in 1:length(file_names_ham)) {
  HAM_FILES <- readLines(str_c(ham_path, file_names_ham[i]))
  HAM_FILES <- str_c(HAM_FILES, collapse = "")
  
  n <- n + 1
  tmp_corpus <- Corpus(VectorSource(HAM_FILES))
  txt_corpus <- c(txt_corpus, tmp_corpus)
  meta(txt_corpus[[n]], "classification") <- "ham"
  
}
txt_corpus

txt_corpus <- tm_map(txt_corpus, removeNumbers)
txt_corpus <- tm_map(txt_corpus, content_transformer(str_replace_all), pattern = "[[:punct:]]", replacement = " ")
txt_corpus <- tm_map(txt_corpus, removeWords, words = stopwords("en"))
txt_corpus <- tm_map(txt_corpus, content_transformer(tolower))
txt_corpus <- tm_map(txt_corpus, stemDocument)

tdm <- TermDocumentMatrix(txt_corpus)
tdm

tdm <- removeSparseTerms(tdm, 0.2)
tdm

classification_labels <- unlist(meta(txt_corpus, "classification"))
N <- length(classification_labels)
container <- create_container(dtm,
                              labels = classification_labels,
                              trainSize = 1:1100,
                              testSize = 1101:n,
                              virgin = FALSE)

slotNames(container)


svm_model <- train_model(container, "SVM")
tree_model <- train_model(container, "TREE")
maxent_model <- train_model(container, "MAXENT")

svm_out <- classify_model(container, svm_model)
tree_out <- classify_model(container, tree_model)
maxent_out <- classify_model(container, maxent_model)

head(svm_out)

head(tree_out)
