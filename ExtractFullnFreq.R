## Load CRAN modules 
library(downloader)
library(plyr);
library(dplyr)
library(knitr)
library(tm)
library(stringi)
library(RWeka)
library(ggplot2)
library(slam)

options(mc.cores=1)

#-----Download DataSet-----#
## Check if directory already exists?
if(!file.exists("./projectData")){
  dir.create("./projectData")
}
Url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
## Check if zip has already been downloaded in projectData directory?
if(!file.exists("./projectData/Coursera-SwiftKey.zip")){
  download.file(Url,destfile="./projectData/Coursera-SwiftKey.zip",mode = "wb")
}
## Check if zip has already been unzipped?
if(!file.exists("./projectData/final")){
  unzip(zipfile="./projectData/Coursera-SwiftKey.zip",exdir="./projectData")
}
# Once the dataset is downloaded start reading it as this a huge dataset so we'll read line by line only the amount of data needed before doing that lets first list all the files in the directory
path <- file.path("./projectData/final" , "en_US")
files<-list.files(path, recursive=TRUE)

#-----Opening File Connections to Various Data Sets and obtain Files-----#
# Making file connection of the twitter data set
con <- file("./projectData/final/en_US/en_US.twitter.txt", "r") 
#lineTwitter<-readLines(con,encoding = "UTF-8", skipNul = TRUE)
lineTwitter<-readLines(con, skipNul = TRUE)
# Close the connection handle when you are done
close(con)

# Making file connection of the blog data set
con <- file("./projectData/final/en_US/en_US.blogs.txt", "r") 
#lineBlogs<-readLines(con,encoding = "UTF-8", skipNul = TRUE)
lineBlogs<-readLines(con, skipNul = TRUE)
# Close the connection handle when you are done
close(con)

# Making file connection of the news data set
con <- file("./projectData/final/en_US/en_US.news.txt", "r") 
#lineNews<-readLines(con,encoding = "UTF-8", skipNul = TRUE)
lineNews<-readLines(con, skipNul = TRUE)
# Close the connection handle when you are done
close(con)

# Get file sizes
lineBlogs.size <- file.info("./projectData/final/en_US/en_US.blogs.txt")$size / 1024 ^ 2
lineNews.size <- file.info("./projectData/final/en_US/en_US.news.txt")$size / 1024 ^ 2
lineTwitter.size <- file.info("./projectData/final/en_US/en_US.twitter.txt")$size / 1024 ^ 2

# Get words in files
lineBlogs.words <- stri_count_words(lineBlogs)
lineNews.words <- stri_count_words(lineNews)
lineTwitter.words <- stri_count_words(lineTwitter)


#--------------Summary of the data sets---------------#
data.frame(source = c("blogs", "news", "twitter"),
           file.size.MB <- c(lineBlogs.size, lineNews.size, lineTwitter.size),
           num.lines <- c(length(lineBlogs), length(lineNews), length(lineTwitter)),
           num.words <- c(sum(lineBlogs.words), sum(lineNews.words), sum(lineTwitter.words)),
           mean.num.words <- c(mean(lineBlogs.words), mean(lineNews.words), mean(lineTwitter.words)))

#--------------Cleaning of Data---------------#
# Obtain the 99.9% of data
set.seed(5000) 
data.sample <- c(sample(lineBlogs, length(lineBlogs) * 0.999), #note that this step takes a very long time to run!
                 sample(lineNews, length(lineNews) * 0.999),
                 sample(lineTwitter, length(lineTwitter) * 0.999))

# Create corpus and clean the data
corpus <- VCorpus(VectorSource(data.sample))
toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)
unicorpus <- tm_map(corpus, removeWords, stopwords("en"))


#--------------EDA---------------#
# Obtain frequencies of the word
getFreq <- function(tdm) {
  freq <- sort(rowSums(as.matrix(tdm)), decreasing = TRUE)
  return(data.frame(word = names(freq), freq = freq))
}

bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
quadgram <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
pentagram <- function(x) NGramTokenizer(x, Weka_control(min = 5, max = 5))
hexagram <- function(x) NGramTokenizer(x, Weka_control(min = 6, max = 6))

# Get frequencies of most common n-grams in data sample for ease of loading
freq1 <- getFreq(removeSparseTerms(TermDocumentMatrix(unicorpus), 0.999))
save(freq1, file="f1Data.RData")
freq2 <- getFreq(TermDocumentMatrix(unicorpus, control = list(tokenize = bigram, bounds = list(global = c(5, Inf)))))
save(freq2, file="f2Data.RData")
freq3 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = trigram, bounds = list(global = c(3, Inf)))))
save(freq3, file="f3Data.RData")
freq4 <- getFreq(TermDocumentMatrix(corpus, control = list(tokenize = quadgram, bounds = list(global = c(2, Inf)))))
save(freq4, file="f4Data.RData")

#------------Plotting of Histograms----------#

makeplot <- function(data, label) {
  ggplot(data[1:30,], aes(x= reorder(word, -freq), y=freq)) + 
    geom_bar(stat="identity", fill = "Gold") +
    xlab("Word") + ylab("Frequency") + # Set axis labels
    ggtitle(label) +     # Set title
    theme_classic(base_size = 16) +
    theme(axis.text.x=element_text(angle=60,hjust=1))
}

makeplot(freq1, "30 Most Common Uni-grams")
makeplot(freq2, "30 Most Common Bi-grams")
makeplot(freq3, "30 Most Common Tri-grams")
makeplot(freq4, "30 Most Common Quad-grams")
makeplot(freq5, "30 Most Common Pent-grams")
makeplot(freq6, "30 Most Common Hex-grams")

#------------Manipulate freq# Data sets----------#
#manipulate freq2,3,4 only

#changing to character
freq2$word  <- as.character(freq2$word)
#splitting word column
freq2 <- separate(freq2, 1, c("unigram", "bigram"))
rownames(freq2) <- NULL
#save
save(freq2, file="f2Data.RData")

#changing to character
freq3$word  <- as.character(freq3$word)
#splitting word column
freq3 <- separate(freq2, 1, c("unigram", "bigram", "trigram"))
rownames(freq3) <- NULL
#save
save(freq3, file="f3Data.RData")

#changing to character
freq4$word  <- as.character(freq4$word)
#splitting word column
freq4 <- separate(freq2, 1, c("unigram", "bigram", "quadgram"))
rownames(freq4) <- NULL
#save
save(freq4, file="f4Data.RData")