library(devtools)
install_github("twitteR", username="geoffjentry/twitteR")
library(twitteR)
api_key <- "lEEY4OERu1vv2bQvvyczCfOeO"

api_secret <- "2GEY6821cbPAZxrwEzLp0dLRCarr24ork5JosPhYHUvzypZHLN"

access_token <- "161630695-CMtQqI1U52OGffAD5I18K52EMHhZ1ND6kCvMzHVs"

access_token_secret <- "XStgcz6hsf1j1aUAOAEXLE50RVHTUdgybLlqW8sSotZ2R"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#p <- searchTwitter("Twegos_COM")
r <- searchTwitter("VDAB", n=1500)
df <- twListToDF(r)
summary(df$retweetCount)
df[df, df$retweetCount == 17561]
top <- subset(df, retweetCount >= 10)
top$text
#install.packages("tm")
library(tm)
review_text <- paste(top$text, collapse=" ")
review_text <- sapply(review_text,function(row) iconv(row, "latin1", "ASCII", sub=""))
review_source <- VectorSource(review_text)
head(review_source)
corpus <- Corpus(review_source)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords("dutch"))
#stopwords("dutch")
dtm <- DocumentTermMatrix(corpus)
dtm2 <- as.matrix(dtm)
frequency <- colSums(dtm2)
frequency <- sort(frequency, decreasing=TRUE)
#install.packages('wordcloud')
library(wordcloud)
words <- names(frequency)
wordcloud(words[1:50], frequency[1:50])
#linkedin
library(Rlinkedin)
require(devtools)
app_name <- "TestSNA"
consumer_key <- "77rpzmqwnqiy8h"
consumer_secret <- "cT01uTDVUn0SMKCc"

in.auth <- inOAuth(app_name, consumer_key, consumer_secret)
my.connections <- getMyConnections(in.auth)
text <- toString(my.connections$industry)

in.auth <- inOAuth()
my.connections <- getMyConnections(in.auth)



