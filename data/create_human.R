#Anne Paakinaho
#16.11.2020
#Creating dataset human

#Read the “Human development” and “Gender inequality” datas into R.

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

#I should rename the variables, but I don't know yet how should I rename them.

#creating new variables
gii$var1 <- gii$Population.with.Secondary.Education..Female./gii$Population.with.Secondary.Education..Male.

#the second one...

gii$var2<-gii$Labour.Force.Participation.Rate..Female./gii$Labour.Force.Participation.Rate..Male.
summary(gii$var2)
#by country???

#merge

combo <- merge(x=gii$var1,y=gii$var2,by="country")
combo= gii$var1 %>% inner_join(gii$var2,by="country")

#I have no idea how to do this...
