#Anne Paakinaho
#30.11.2020
#Exercise 6: Analysis of longitudinal data

#I download datasets BPRS (brief psychiatric rating scale) and RATS into R.
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep=" ", header=T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep='\t', header=T)

names(BPRS)
names(RATS)
str(BPRS)
str(RATS)
dim(BPRS) #40 observations, 11 variables
dim(RATS) #16 observations, 13 variables

#summaries
summary(BPRS)
#in BPRS, there is two treatment groups and in total 20 participants in both treatment groups
# so there are in total of 40 participants (all are male, as said in Kimmo's book)
#brief psychiatric rating scale is measured before treatment and during following 8 weeks.

summary(RATS)
#RATS include data from nutrition study; there are three distinct groups of rats that had different diets
#other variables, such as WD1 or WD22 describe the day when the body weight was measured (in grams)

# Access the packages dplyr and tidyr
library(dplyr)
library(tidyr)

#categorical variables of both data sets into factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Convert the data sets to long form. Add a week variable to BPRS
# Convert to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)

# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL) #360 rows, 5 columns

#RATS to long form and add Time variable
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4)))
# Glimpse the data
glimpse(RATSL)#176 rows, 5 columns

#looking the new datasets.
#now the BRPSL and RATSL are in long form.
summary(BPRSL)
#there were in BPRS 40 observations, 11 variables but in long form, now all the observations are listed below to each other
#there should be 40*9(0+8weeks)=360 rows, as there is at the moment
summary(RATSL)
#there were in RATS 16 observations, 13 variables, but now in long form:
#16*11(11 measurements in different days)=176 rows

str(BPRSL) #treatment and subject are now factors
str(RATSL) #likewise in RATSL, ID and group are factors
#also the new variables week and time exists
names(BPRSL)
names(RATSL)

#Access the package ggplot2
library(ggplot2)
#Plotting BPRSL
ggplot(BPRSL, aes(x = week, y = bprs, linetype = subject)) +
  geom_line() +
  scale_linetype_manual(values = rep(1:10, times=4)) +
  facet_grid(. ~ treatment, labeller = label_both) +
  theme(legend.position = "none") + 
  scale_y_continuous(limits = c(min(BPRSL$bprs), max(BPRSL$bprs)))

#plotting RATSL
ggplot(RATSL, aes(x = Time, y = Weight, group = ID)) +
  geom_line(aes(linetype = Group)) +
  scale_x_continuous(name = "Time (days)", breaks = seq(0, 60, 10)) +
  scale_y_continuous(name = "Weight (grams)") +
  theme(legend.position = "top")

#It is important to have the data in long form, so all the observations per person are listed in separate rows one below another.
#This is because the observations are stemming from repeated measures in the same person, 
#there is probably correlation within subject. So the observations are not independent.
#in order to do the analyses with longitudinal data, making the data into long form is crucial.

#lets save the datasets in long form to data folder
write.table(BPRSL,"C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/BPRSL.txt")
write.table(RATSL,"C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/RATSL.txt")
