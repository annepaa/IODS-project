#Anne Paakinaho
#02.11.2020
#I start to do the exercise 2 (IODS 2020).

#Fist I install required packages
install.packages("tidyverse")


learning2014 <- read.delim("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header=T, sep="\t")
dim(learning2014)
str(learning2014)

#there is 183 observations and 60 variables in data learning2014

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

library(dplyr)

deep_columns <- select(learning2014,one_of(deep_questions))
learning2014$deep<-rowMeans(deep_columns)

surface_columns <- select(learning2014,one_of(surface_questions))
learning2014$surf<-rowMeans(surface_columns)

strategic_columns <- select(learning2014,one_of(strategic_questions))
learning2014$stra<-rowMeans(strategic_columns)


keep_columns<- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
learning2014<-select(learning2014, one_of(keep_columns))

#exclude where exam points variable is zero
learning2014 <- filter(learning2014, points>0)
dim(learning2014)
head(learning2014)
#now there is 166 observations ja 7 variables

#save data to 'data' folder as csv file
write.csv(learning2014,'C:/Users/annetp/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/learning2014.csv')

#let's test to read the file again
test<- read.csv('C:/Users/annetp/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/learning2014.csv')
dim(test)
str(test)
head(test)
