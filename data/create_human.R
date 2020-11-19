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
