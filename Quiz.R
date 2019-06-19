# Quiz. Second week
# Course: Getting and cleaning data
# Data Science Specialization
# Santiago Botero Sierra
# sboteros@unal.edu.co
# Date: 2019/06/19
# Encoding: UTF-8

# Variables
  WorkingDirectory <- "WorkindDirectoryHere!"
  Github_key <- "GithubKeyHere!"
  Github_secret <- "GithubSecretHere!"
  
  setwd(WorkingDirectory)
  
# 1. Register an application with the Github API here
# https://github.com/settings/applications. Access the API to get information on
# your instructors repositories (hint: this is the url you want
# "https://api.github.com/users/jtleek/repos"). Use this data to find the time
# that the datasharing repo was created. What time was it created?
# This tutorial may be useful
# (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). You may
# also need to run the code in the base R package and not R studio.

  if (!require("httr")) {
    install.packages("httr")
  }
  if (!require("httpuv")) {
    install.packages("httpuv")
  }
  library(httr)
  
  # Find OAuth settings for Github.
  oauth_endpoints("github")
  
  # Introduce data about my application (`gettingapidata`)
  myapp <- oauth_app("github", key = Github_key,
                     secret = Github_secret)
  
  # Get OAuth credentials
  github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
  
  # Use de API
  gtoken <- config(token = github_token)
  req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
  stop_for_status(req)
  content(req)[[1]]

  # When whas created the `datasharing` repo
  str(content(req))
  sapply(content(req), function(x) x["name"])
  c(content(req)[[16]]$name, content(req)[[16]]$created_at)
  
  # It was created "2013-11-07T13:25:07Z"
  
# 2. The sqldf package allows for execution of SQL commands on R data frames. We
# will use the sqldf package to practice the queries we might send with the
# dbSendQuery command in RMySQL.
# Download the American Community Survey data and load it into an R object
# called
  
  if (!require("sqldf")) {
    install.packages("sqldf")
  }
  library("sqldf")
  
  if (!dir.exists("./data")) {
    dir.create("./data")
  }
  if (!file.exists("./data/community.csv")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv",
                  "./data/community.csv")
  }
  
  acs <- read.csv("./data/community.csv")

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# Which of the following commands will select only the data for the probability
# weights pwgtp1 with ages less than 50?

  #sqldf("select pwgtp1 from acs")
  
  #sqldf("select * from acs where AGEP < 50")
  
  #sqldf("select * from acs")
  
  sqldf("select pwgtp1 from acs where AGEP < 50") # These one!


# 3. Using the same data frame you created in the previous problem, what is the
# equivalent function to unique(acs$AGEP)

  sqldf("select distinct AGEP from acs") # These one!
  
  #sqldf("select unique * from acs")
  
  #sqldf("select AGEP where unique from acs")
  
  #sqldf("select distinct pwgtp1 from acs")

# 4. How many characters are in the 10th, 20th, 30th and 100th lines of HTML
# from this page:
# http://biostat.jhsph.edu/~jleek/contact.html
# (Hint: the nchar() function in R may be helpful)

  con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
    webpage <- readLines(con)
    c(nchar(webpage[10]), nchar(webpage[20]), nchar(webpage[30]), 
      nchar(webpage[100]))
  close(con)

# 5. Read this data set into R and report the sum of the numbers in the fourth
# of the nine columns.
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for Original source
# of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
# (Hint this is a fixed width file format)
  
  if (!file.exists("./data/fixed.for")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for",
                  "./data/fixed.for")
  }
  fixed <- read.fwf("./data/fixed.for", c(15, 4, 4, 9, 4, 9, 4, 9, 4), skip = 4)
  sum(fixed[4])
  