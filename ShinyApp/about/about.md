## Coursera Data Science Capstone Project


This application is the capstone project for the [Coursera: Data Science specialization](https://www.coursera.org/specializations/jhu-data-science) with Johns Hopkins University and jointly collaborated with SwiftKey.

******

### The Objective

The main goal of this capstone project is to build a shiny application with the ability to predict the next word. 

Utilizing skills acquired from the past 9 courses from the [Coursera: Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science), this capstone tests essential data science concepts such as:

* Data Processing
* Exploratory Data Analysis
* Natural Language Processing and Text Mining
* Predictive Modelling
* ShinyApp Development

All text data that is used to create the frequency dictionary comes from a corpus called [HC Corpora](https://web-beta.archive.org/web/20160930083655/http://www.corpora.heliohost.org/aboutcorpus.html) and can be downloaded [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip). 

A variety of R packages were used in the development of this application, namely: `RWeka` and `stringi`.

******

### Methodology

HC Corpora data namely from the **en_US Twitter, Blogs and News** textfiles were cleaned by conversion to lowercase. Punctuations, links, white spaces, numbers and all special characters were removed. This data sample was then [tokenized](http://en.wikipedia.org/wiki/Tokenization_%28lexical_analysis%29) into [*n*-grams](http://en.wikipedia.org/wiki/N-gram), using the `RWeka` package.
> In the fields of computational linguistics and probability, an *n*-gram is a contiguous sequence of n items from a given sequence of text or speech. ([Source](http://en.wikipedia.org/wiki/N-gram))

The frequencies of *n*-gram vectors are computed, sorted into the bi-, tri- and quad-gram matrices and tabulated. This formed the bedrock of the prediction algorithm.

From the frequencies of the *n*-grams table, text input by a user will be used to predict the next word.

******

### Future Plans

* Future work can be carried out to improve the accuracy and speed of next word prediction. 

* Training of Corpus can be optimized to improve the efficiency.

******

### Links 

* The next word prediction app is hosted on shinyapps.io: [https://javierngkh.shinyapps.io/WordPredictionApp/](https://javierngkh.shinyapps.io/WordPredictionApp/)

* The whole code of this application, as well as all the milestone report, related scripts, this presentation  etc. can be found in this GitHub repo: [https://github.com/remembrance1/Coursera_Capstone_JHU](https://github.com/remembrance1/Coursera_Capstone_JHU)

* This pitch deck is located here: [XXXX](XXXX)

### References

* [Text mining infrastructure in R](http://www.jstatsoft.org/v25/i05/)

* [Building Shiny Applications with R](http://rstudio.github.io/shiny/tutorial/)

* [Text mining with R](https://www.tidytextmining.com/)

*****

### In association with: 

![SwiftKey, Bloomberg & Coursera Logo](logos.png)
