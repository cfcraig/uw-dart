## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Part 1: GET USED TO R + RSTUDIO

# This file is called a "script"; it contains a sequence of commands that we will 
# give the computer, and some descriptive comments about those commands. The comment 
# lines will all begin with the "#" character (like these lines you're reading 
# right now). Any lines that do not begin with "#" are commands we give the computer
# in the R programming language.

# Place your cursor on each line of code below and press CTRL + ENTER at the same 
# time. This tells the computer to execute the command. In R, it is standard to 
# use `<-` as the variable assignment operator rather than the equals sign. (For 
# more information about why see THAT ONE BLOG POST CFC RAN ACROSS WAY BACK WHEN.)
# When you are reading R code to yourself or out loud, you can use the term "gets"
# for the `<-` operator. For instance, below we could say "The variable `a` gets [ <- ]
# the value 10."

a <- 10
b <- 36

# Check your "Environment" tab in upper right quadrant. Do you see your variable 
# values there?

# Sometimes a line of code will also contain a comment to the right of the command.
# When you execute such a line of code, the computer will ignore the comment. 
# Try this out below:

c <- a + b  # this is the sum of `a` and `b`

# Write a command to calculate the product of `a` and `b` below and capture it in the 
# variable `d`



## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Part 2: THE ACTUAL WORKSHOP

# Our guiding questions:
# 
#   * How does student performance / attendance in a large-lecture introductory 
#     science course correlate with class standing?
#   * How does student performance / attendance in a large-lecture introductory 
#     science course correlate with major?


### Getting set up ###

# R code introduced in this section:
#   
#   * `library()`
#   * `tidyverse`

# To write the commands for this workshop, we need to load a package of functions 
# that aren't already part of the standard R language. (NOTE: We could perform all 
# the tasks in this workshop without these functions, but they will make our work 
# much easier.) 
# 
# The package of functions we need is called the `tidyverse`, and the command we use 
# to load it is `library()`. To run the code below, put your cursor on the line and
# type CRTL + ENTER at the same time.

library(tidyverse)

# The tidyverse is an umbrella package which itself contains several packages. The 
# tidyverse packages we will use in particular are:
# 
#   `ggplot`:   for data visualization 
#   `dplyr`:    for data wrangling
#   `magrittr`: for the "pipe" operator, %>%, a useful programming shortcut
#   `tibble`:   for creating datasets in a fashion consistent with tidyverse functions


### Importing the data ###

# R code introduced in this section:
#   
#   * `dir()`
#   * `read_csv()`, with the `name_repair` option
#   * `glimpse()`

# We will examine course data which is readily available from CANVAS gradebooks 
# and also myUW. Sample data files are contained in the data/ sub-directory. 

# You can view the contents of data/ by clicking in to the directory in the lower
# right-hand panel in RStudio, or by running the following line of code:

dir("data/") # list the contents of the data/ directory

# The data/ directory contains two files in the comma-separated values (csv) format:
# 
#   "Grades_quarter1.csv": an anonymized and simplified version of a real Canvas 
#                          gradebook for a large-lecture introductory science 
#                          course at UW.   
#                          
#   "myUW_quarter1.csv":   an anonymized version of the MyUW classlist for the same 
#                          course.  
# 
# We will read in the data from each file using the `read_csv()` function. This 
# function will create a two-dimensional data structure called a "dataframe"
# from the csv file. A dataframe is similar to a spreadsheet, in that each row 
# contains values specific to a particular student for several different data 
# fields, and the columns contain values specific to a particular data field
# for several different students. The columns will each have a header name which 
# is taken from the first row of the csv file (by default). 
# 
# Sometimes the column names from the csv file don't conform to R's expected syntax,
# but we can tell `read_csv()` to make any necessary adjustments by using the 
# `name_repair` option. 

grades <- read_csv("data/Grades_quarter1.csv", name_repair = "universal")
myuw   <- read_csv("data/myUW_quarter1.csv", name_repair = "universal")

# In English: "The dataframe `grades` gets [ <- ] the result of reading the csv 
# file "data/Grades_quarter1.csv", with the universal name repair option enabled."

# Let's take a look at the contents of the dataframes using the `glimpse()` function 

glimpse(grades)
glimpse(myuw)

# How many rows and columns are in each dataframe? What type of data does each 
# dataframe contain? Are there any columns that appear to contain the same data?
# Are there any columns that appear to contain NO data? Are there any rows that 
# seem irrelevant?

# PARTICIPANTS SHOULD NOTICE THAT: 
#   * `SIS.Login.ID` FROM `grades` AND `UWNetID` FROM `myuw` CONTAIN THE SAME DATA
#   * `Student` IN `grades` AND `Pronouns` IN `myuw` BOTH CONTAIN MOSTLY NAs
#   * THE SECOND ROW IN `grades` CONTAINS ONLY THE MAX POINT VALUES FOR AN ASSIGMMENT...
#     IT'S NOT ACTUALLY STUDENT DATA.

# To explore our guiding questions, we need to connect the course performance data
# in `grades` to the class standing and major data in `myuw`. We know that there 
# is a common data field in both dataframes (`SIS.Login.ID` in `grades`; `UWNetID`
# from `myuw`) that will allow us to combine them into one (this process is similar 
# to the VLOOKUP function in Excel). However, we should do a little data cleaning
# first to get rid of unnecessary columns and rows.


### Data Cleaning ###

# R code introduced in this section:
#   
#   * `select()`: get columns
#   * `all_equal()`: test equality of two dataframes
#   * `%>%` (the pipe operator): take the output of one function call and hand 
#                                it to the next function call
#   * `filter()`: get rows

# Let's remove the unnecessary column from `myuw`. We can use the `select()` 
# function to extract just the columns that we want.

myuw_2 <- select(myuw, UWNetID, Credits, Class, Major)

# Alternatively, we can use `select()` to "subtract" the `Pronouns` column from 
# the dataframe:

myuw_3 <- select(myuw, -Pronouns)

# You can convince yourself that these are identical dataframes using the 
# `all_equal()` function, which will return `TRUE` if all elements in each dataframe
# are identical.

all_equal(myuw_2, myuw_3)

# IF TIME: What happens if you send `myuw` and `myuw_2` to `all_equal()`?

# Another way to use `select()`---and many other functions---is in conjunction
# with the "pipe" operator, `%>%`. Using the pipe helps to make your code more
# readable. We would say the line of code below as "The dataframe `myuw_4` gets [ <- ] 
# the result # of taking `myuw` and then [ %>% ] selecting all of the columns 
# except [ - ] `Pronouns`.

myuw_4 <- myuw %>% select(-Pronouns)
all_equal(myuw_2, myuw_4)


#~~~~~~~~~~~~~~~~~~~~~~~~~~
# MORE TO COME (cfc 2022-08-15):
# 
# * COMPLETE DATA CLEANING OF OTHER DATAFRAME
# * JOIN THEM TOGETHER
# * PLOT THE SHIT OUT OF THEM
#~~~~~~~~~~~~~~~~~~~~~~~~~~

class_standing <- read_csv("data/myUW_quarter1.csv",
                           name_repair = "universal") %>% 
                  select(-Pronouns)

names(class_standing)


# and join them by matching the UW NETID in `class_standing` with `SIS.Login.ID` in `gradebook`. 

course_data <- gradebook %>% 
  left_join(class_standing, by = c("SIS.Login.ID" = "UWNetID"))

glimpse(course_data)


# 1. How do exam points and non exam points correlate by class standing? 
ggplot(data = course_data,
       mapping = aes(x = TotalNonExamPercent,
                     y = TotalExamPercent,
                     color = Class)) +
  geom_point()


# NOTES (08-15)
# * Filter out the low data point
# * add regression lines
# * transform data using a logit or arcsine


# 2. How do exam points and non exam points correlate by major? 
  
# ggplot(data = course_data,
#        mapping = aes(x = TotalNonExamPercent,
#                      y = TotalExamPercent,
#                      color = Major)) +
#   geom_point()


## CFC NOTES:
# * Group majors into buckets
# * Show table or bar chart of numbers/percent of students in each year/major
# * Box plots of exam/non-exam points by class standing/major
# * Include (somewhere) explanations of the anatomy of the Rmd file
# * Create metadata files for `class_standing` and `gradebook`

