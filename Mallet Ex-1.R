install.packages("mallet")
library(mallet)

Dir <- "C:/mallet/sample-data/web/en"
documents <- mallet.read.dir(Dir)

#Import text documents into Mallet format
mallet.instances <- mallet.import(documents$id, documents$text, "C:/mallet/stoplists/en.txt",
                                  token.regexp = "\\p{L}[\\p{L}\\p{P}]+\\p{L}")

## Create a topic trainer object.
topic.model <- MalletLDA(num.topics=20)

## Load the documents
topic.model$loadDocuments(mallet.instances)

## Get the vocabulary  .
## These may be useful in further curating the stopword list.
vocabulary <- topic.model$getVocabulary()
vocabulary

#word frequencies
word.freqs <- mallet.word.freqs(topic.model)
word.freqs

#Optimize hyperparamaters every 20 iterations, after 50 burn-in iterations
topic.model$setAlphaOptimization(20,50)

#Train a model
topic.model$train(200)

#run through a few iterations where we pick the best topic for each token,
#rather than sampling from the posterior distribution.
topic.model$maximize(10)

### Get the probability of topics in documents and the probability of words in topics.
## By default, these functions return raw word counts. Here we want probabilities,
## so we normalize, and add "smoothing" so that nothing has exactly 0 probability.
doc.topics  <- mallet.doc.topics(topic.model, smoothed=T, normalized=T)
topic.words <- mallet.topic.words(topic.model, smoothed=T, normalized=T)

#Top words in topic 7
topic.seven <- mallet.top.words(topic.model, topic.words[7,])
topic.seven

## Show the first few documents with at least 5
head(documents[ doc.topics[7,] > 0.05 & doc.topics[10,] > 0.05, ])
          smoothed=T , normalized=T )

