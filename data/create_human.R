#Anne Paakinaho
#16.11.2020
#Creating dataset human

#Read the “Human development” and “Gender inequality” datas into R.
library(tidyverse)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Here is the meta file: http://hdr.undp.org/en/content/human-development-index-hdi
#and here is some technical notes: http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

#Let's explore the datasets

str(hd) #195 observations and 8 variables
str(gii) #195 observations and 10 variables
dim(hd)
dim(gii)
summary(hd)
summary(gii)
#columnn names for both datasets
colnames(hd)
colnames(gii)

#I should rename the variables. I rename some.
library(dplyr)
gii=rename(gii, Edu2.F=Population.with.Secondary.Education..Female.)
gii=rename(gii, Edu2.M=Population.with.Secondary.Education..Male.)

#I check that I succeeded
colnames(gii) #it seems to be working, names have changed
#I continue, I rename more
gii=rename(gii, LabF=Labour.Force.Participation.Rate..Female.)
gii=rename(gii, LabM=Labour.Force.Participation.Rate..Male.)

colnames(gii)

#creating new variables
gii <-gii %>% mutate(var1=Edu2.F/Edu2.M)
gii<- gii %>% mutate(var2=LabF/LabM)


#merge
human <- inner_join(hd, gii, by="Country")

colnames(human)
summary(human)
dim(human)

#there is 195 observations and 19 variables, it should be correct now.

#saving to data folder

write.table(human,'C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/human.txt')


#I continued on 23.11.2020 with Exercise 5
#I will download the human data from the internet, I want to be sure that data is correct although I did the human data by myself last week.

human <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep=",", header=T)

#The 'human' dataset originates from the United Nations Development Programme
#here is more information about the data: http://hdr.undp.org/en/content/human-development-index-hdi
#and here is more about how human development indices are calculated: http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

dim(human) #195 obs and 19 variables, as should be
str(human) #dataframe
summary(human)

#In the data 'human', human development and gender inequality datasets are joined together by country.
#so only those countries are kept in human data, which were present in both datasets.
#there are two combination variables Edu2.FM and Labo.FM: they are formed from the following variables:
#"Edu2.F" = Proportion of females with at least secondary education
#"Edu2.M" = Proportion of males with at least secondary education
#"Labo.F" = Proportion of females in the labour force
#"Labo.M" " Proportion of males in the labour force
#so the combinations are:
#"Edu2.FM" = Edu2.F / Edu2.M
#"Labo.FM" = Labo2.F / Labo2.M

#here is more info about the variables: https://raw.githubusercontent.com/TuomoNieminen/Helsinki-Open-Data-Science/master/datasets/human_meta.txt

#column names
colnames(human)

#libraries
library(dplyr)
library(tidyr)
library(tidyverse)
library(stringr)

#string manipulation and making GNI (Gross National Income) variable into numeric
str(human$GNI) #it was character variable,comma as separator (we need to get rid of commas)
str_replace(human$GNI, pattern=",", replace ="")%>%as.numeric

#excluding unwanted variables
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns and put them into human data
human <- dplyr::select(human, one_of(keep))
str(human)
summary(human)

#removing all rows with missing values

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))
#I believe it is FALSE, if there are missing values (NA)
# filter out all rows with NA values
human_ <- filter(human, complete.cases(human))

#"human_" is the new file without any NA values

#removing observation from Country variable which refers to region instead of country
# look at the last 10 observations of human_
tail(human_, n=10)
# define the last indice we want to keep
last <- nrow(human_) - 7
human_ <- human_[1:last,]


# add countries as rownames
rownames(human_) <- human_$Country
rownames(human_)
#remove the Country variable
human_ <- select(human_, -Country)
colnames(human_) #Country is gone
dim(human_)

#data "human_" have now 155 observations and 8 variables as it should. Everything is OK.

#I will save the file into data folder with a name human_ with row names

write.table(human_,'C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/human_.txt',sep=",", row.names=TRUE)

