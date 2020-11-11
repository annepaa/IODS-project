#Anne Paakinaho
#09.11.2020
#Exercise 3:Logistic regression (IODS 2020).
#Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance
#The data are from two identical questionnaires related to secondary school student alcohol comsumption in Portugal.

setwd("C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/")

# read the datasets from data folder
por <- read.table("C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/student-por.csv", sep = ";", header=TRUE)
math <- read.table("C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/student-mat.csv", sep = ";", header=TRUE)

#let's check the structure and dimensions of the data por and math

str(por)
dim(por)
#por data has 649 observations, 33 variables
str(math)
dim(math)
#math data has 395 observations and 33 variables

#column names for both data:
colnames(math)
colnames(por)

#required library
library(dplyr)
# I want to combine the two datasets. I use partially the code that Reijo Sund gave: https://github.com/rsund/IODS-project/blob/master/data/create_alc.R

# Define own id for both datasets
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

# Which columns vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))

# Combine datasets to one long data
pormath <- por_id %>% 
  bind_rows(math_id) %>%
  # Aggregate data (more joining variables than in the example)  
  group_by(.dots=join_cols) %>%  
  # Calculating required variables from two obs  
  summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
  ) %>%
  # Remove lines that do not have exactly one obs from both datasets
  #   There must be exactly 2 observations found in order to joining be succesful
  #   In addition, 2 obs to be joined must be 1 from por and 1 from math
  #     (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2,
    high_use = alc_use > 2,
    cid=3000+row_number()
  )

#dimensions and the structure of the new combination data where is only the unique students, present in both data.
dim(pormath)
str(pormath)
#now there is 370 observations and 51 columns.
colnames(pormath)

#save the file to data folder.
write.csv(pormath,"C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/pormath.csv")

#it might be that after this, I am doing something wrong

#joined columns; these variables are the ones that we want to use in this exercise.
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# create a new data frame with only the joined columns
alc <- select(pormath, one_of(join_by))

# columns that were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'pormath' with the same original name
  two_columns <- select(pormath, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)

library(ggplot2)

alc <- mutate (alc, alc_use=(Dalc + Walc)/2)
g1 <- ggplot(data = alc, aes(x = alc_use))
g1 + geom_bar()

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)
# initialize a plot of 'high_use'
g2 <- ggplot(alc, aes(high_use))

# draw a bar plot of high_use by sex
g2 + facet_wrap("sex") + geom_bar()

library(tidyr)
glimpse(alc)
#there is 370 rows and 35 columns, it should be right. Having 384 rows would erroneous as it was said to us.

# use gather() to gather columns into key-value pairs and then glimpse() at the resulting data
gather(alc) %>% glimpse
# draw a bar plot of each variable
gather(alc) %>% ggplot(aes(value)) + facet_wrap("key", scales = "free") + geom_bar()

#save 'alc' to data folder.
write.csv(alc,"C:/Users/silve/OneDrive - University of Eastern Finland/IODS-project 2020/IODS-project/data/alc.csv")

