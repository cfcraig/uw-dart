---
title: "UW DART Workshop Plan"
author: "Colleen Craig"
date: "2022-09-12"
output: 
  html_document:
    keep_md: yes
---



<!-- # Part 1: GET USED TO R + RSTUDIO -->

<!-- This file is called a "script"; it contains a sequence of commands that we will give the computer, and some descriptive comments about those commands. The comment lines will all begin with the "\#" character <!-- (like these lines you're reading  -->

<!-- right now) -->

<!--  . Any lines that do not begin with "#" are commands we give the computer in the R programming language. -->

<!-- Place your cursor on each line of code below and press CTRL + ENTER at the same time. This tells the computer to execute the command. In R, it is standard to use `<-` as the variable assignment operator rather than the equals sign. (For more information about why see THAT ONE BLOG POST CFC RAN ACROSS WAY BACK WHEN.) When you are reading R code to yourself or out loud, you can use the term "gets" for the `<-` operator. For instance, below we could say "The variable `a` gets [ \<- ] the value 10." -->



<!-- Check your "Environment" tab in upper right quadrant. Do you see your variable values there? -->

<!-- Sometimes a line of code will also contain a comment to the right of the command. When you execute such a line of code, the computer will ignore the comment. Try this out below: -->



<!-- Write a command to calculate the product of `a` and `b` below and capture it in the variable `d` -->



<!-- # Part 2: THE ACTUAL WORKSHOP -->

# Data Analysis for Reflective Teaching Workshop

Our guiding questions:

-   How does student performance / attendance in a large-lecture introductory science course correlate with class standing?
-   How does student performance / attendance in a large-lecture introductory science course correlate with major?

------------------------------------------------------------------------

## Getting set up

R code introduced in this section:

-   `library()`
-   `tidyverse`

To write the commands for this workshop, we need to load a package of functions that aren't already part of the standard R language. (NOTE: We could perform all the tasks in this workshop without these functions, but they will make our work much easier.)

The package of functions we need is called the `tidyverse`, and the command we use to load it is `library()`. To run the code below, put your cursor on the line and type CRTL + ENTER at the same time.


```r
library(tidyverse)
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.2 --
## v ggplot2 3.3.6     v purrr   0.3.4
## v tibble  3.1.8     v dplyr   1.0.9
## v tidyr   1.2.0     v stringr 1.4.1
## v readr   2.1.2     v forcats 0.5.2
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

The tidyverse is an umbrella package which itself contains several packages. The tidyverse packages we will use in particular are:

-   `ggplot`: for data visualization
-   `dplyr`: for data wrangling
-   `magrittr`: for the "pipe" operator, `%>%`, a useful programming shortcut
-   `tibble`: for creating datasets in a fashion consistent with tidyverse functions

<!-- Should we bother to include `magrittr` and `tibble` in this list? -->

### Import the data

R code introduced in this section:

-   `dir()`
-   `read_csv()`, with the `name_repair` option
-   `glimpse()`
-   `<-`: the assignment operator

We will examine course data which is readily available from CANVAS gradebooks and the teaching tab on myUW. Sample data files are contained in the `data/` sub-directory. <!-- Include links to instructions for obtaing these data files for the participants. -->

You can view the contents of `data/` by clicking in to the directory in the lower right-hand panel in RStudio, or by running the following line of code:


```r
dir("data/") # list the contents of the data/ directory
```

```
## [1] "Grades_quarter1.csv" "myUW_quarter1.csv"
```

The data/ directory contains two files in the comma-separated values (csv) format:

-   "Grades_quarter1.csv": an anonymized and simplified subset of a real Canvas gradebook for an introductory STEM course at UW. <!--# (SAY: "IN THIS SUBSET OF DATA"…DON'T SAY "CLASS") -->

-   "myUW_quarter1.csv": an anonymized version of the MyUW classlist for the same course.

We will read in the data from each file using the `read_csv()` function. This function will create a two-dimensional data structure called a "dataframe" from the csv file. A dataframe is similar to a spreadsheet, in that each row contains values specific to a particular student for several different data fields, and the columns contain values specific to a particular data field for several different students. The columns will each have a header name which is taken from the first row of the csv file (by default).

Sometimes the column names from the csv file don't conform to R's expected syntax, but we can tell `read_csv()` to make any necessary adjustments by using the `name_repair` option.


```r
grades <- read_csv("data/Grades_quarter1.csv", name_repair = "universal")
```

```
## New names:
## Rows: 101 Columns: 16
## -- Column specification
## -------------------------------------------------------- Delimiter: "," chr
## (3): Student, SIS.Login.ID, Section dbl (13): wk2AttendPercent,
## wk3AttendPercent, wk4AttendPercent, wk5AttendPer...
## i Use `spec()` to retrieve the full column specification for this data. i
## Specify the column types or set `show_col_types = FALSE` to quiet this message.
## * `SIS Login ID` -> `SIS.Login.ID`
```

```r
myuw   <- read_csv("data/myUW_quarter1.csv", name_repair = "universal")
```

```
## Rows: 110 Columns: 5
## -- Column specification --------------------------------------------------------
## Delimiter: ","
## chr (3): UWNetID, Class, Major
## dbl (1): Credits
## lgl (1): Pronouns
## 
## i Use `spec()` to retrieve the full column specification for this data.
## i Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

In English: "The dataframe `grades` gets [ `<-`] the result of reading the csv file"data/Grades_quarter1.csv", with the universal name repair option enabled."

Let's take a look at the contents of the dataframes using the `glimpse()` function


```r
glimpse(grades)
```

```
## Rows: 101
## Columns: 16
## $ Student              <chr> "Points Possible", NA, NA, NA, NA, NA, NA, NA, NA~
## $ SIS.Login.ID         <chr> NA, "6eenuun", "mumhnhh6", "3umep7m", "en2nnpem",~
## $ Section              <chr> NA, "AA", "AA", "AA", "AA", "AA", "AA", "AA", "AA~
## $ wk2AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 75, ~
## $ wk3AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,~
## $ wk4AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,~
## $ wk5AttendPercent     <dbl> 100.00, 100.00, 100.00, 100.00, 100.00, 66.67, 10~
## $ wk6AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 75, 75, 100, 1~
## $ wk7AttendPercent     <dbl> 100, 100, 100, 75, 100, 75, 100, 100, 100, 100, 7~
## $ wk8AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 0, 100, 100, 1~
## $ wk9AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 75, 75, 100, 100, 7~
## $ wk10AttendPercent    <dbl> 100, 100, 100, 100, 100, 75, 100, 0, 100, 100, 75~
## $ PercentAttendedTotal <dbl> 100.00, 100.00, 100.00, 96.67, 100.00, 90.00, 96.~
## $ TotalExamPercent     <dbl> 100.00, 82.50, 76.50, 64.25, 70.50, 79.50, 86.75,~
## $ TotalNonExamPercent  <dbl> 100.00000, 99.19580, 98.31818, 95.04196, 98.35664~
## $ FinalPercent         <dbl> 104.00, 93.46, 89.60, 81.09, 86.11, 88.57, 94.95,~
```


```r
glimpse(myuw)
```

```
## Rows: 110
## Columns: 5
## $ UWNetID  <chr> "6eenuun", "mumhnhh6", "3umep7m", "en2nnpem", "8uhump", "n92u~
## $ Pronouns <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N~
## $ Credits  <dbl> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5~
## $ Class    <chr> "FRESHMAN", "JUNIOR", "FRESHMAN", "JUNIOR", "JUNIOR", "JUNIOR~
## $ Major    <chr> "PreSciences", "PreSciences", "PreHealthSciences", "ComputerS~
```

#### Questions:

1.  How many rows and columns are in each dataframe?
2.  What type of data does each dataframe contain?
3.  Are there any columns that appear to contain the same data?
4.  Are there any columns that appear to contain NO data?
5.  Are there any rows that seem irrelevant?

<!-- PARTICIPANTS SHOULD NOTICE THAT:  -->

<!--   * `SIS.Login.ID` FROM `grades` AND `UWNetID` FROM `myuw` CONTAIN THE SAME DATA -->

<!--   * `Student` IN `grades` AND `Pronouns` IN `myuw` BOTH CONTAIN MOSTLY NAs -->

<!--   * THE SECOND ROW IN `grades` CONTAINS ONLY THE MAX POINT VALUES FOR AN ASSIGMMENT... -->

<!--     IT'S NOT ACTUALLY STUDENT DATA. -->

To explore our guiding questions, we need to connect the course performance data in `grades` to the class standing and major data in `myuw`. We know that there is a common data field in both dataframes (`SIS.Login.ID` in `grades`; `UWNetID` from `myuw`) that will allow us to combine them into one (this process is similar to the VLOOKUP function in Excel). <!-- Link to VLOOKUP explanation. --> However, we should do a little data cleaning first to get rid of unnecessary columns and rows.

### Clean the Data

#### The `myUW` Dataframe

R code introduced in this section:

-   `select()`: get columns
-   `all_equal()`: test equality of two dataframes
-   `%>%`: the pipe operator, which takes the output of one function call and hands it to the next function call in a sequence
-   `-`: ???

Let's remove the unnecessary column from `myuw`. We can use the `select()` function to extract just the columns that we want.


```r
myuw_2 <- select(myuw, UWNetID, Credits, Class, Major)
```

**In English**: The dataframe `myuw_2` *gets* [`<-`] the result of selecting the columns `UWNetID`, `Credits`, `Class`, and `Major` from the `myuw` dataframe.

Alternatively, we can use `select()` to "subtract" the `Pronouns` column from the dataframe:


```r
myuw_3 <- select(myuw, -Pronouns)
```

You can convince yourself that these are identical dataframes using the `all_equal()` function, which will return `TRUE` if all elements in each dataframe are identical.


```r
all_equal(myuw_2, myuw_3)
```

```
## [1] TRUE
```

IF TIME: What happens if you send `myuw` and `myuw_2` to `all_equal()`?

Another way to use `select()`---and many other functions---is in conjunction with the "pipe" operator, `%>%`. Using the pipe helps to make your code more readable. We would say the line of code below as "The dataframe `myuw_4` *gets* [ `<-` ] the result of taking `myuw` and *then* [ `%>%` ] selecting all of the columns except [ `-` ] `Pronouns`.


```r
myuw_4 <- myuw %>% select(-Pronouns)
all_equal(myuw_2, myuw_4)
```

```
## [1] TRUE
```

#### The `grades` Dataframe

R code introduced in this section:

-   `filter()`: get rows
-   `is.na()`: logical test of whether a value is `NA` or not
-   `!`: the logical negation operator

To clean this dataframe, we need to remove the unnecessary "Points Possible" row and the empty "Student" column. Let's get rid of the column first.

**On Your Own**: Use the pipe operator (`%>%`) and the `select()` function to remove the empty "Student" column from the `grades` dataframe. Capture your result in the variable `grades_2`.


```r
# NOTE TO DART TEAM: This is the answer...it would not be shown in the real 
# workshop

grades_2 <- grades %>% select(-Student)
```

How would you "say" your line of code out loud in English?

Next, let's remove the remainder of the "Points Possible" row from `grades_2`. (Note that the "Points Possible" phrase itself was located in the `Student` column, and so it is not included in `grades_2`)

Let's take a `glimpse()` at `grades_2`:


```r
glimpse(grades_2)
```

```
## Rows: 101
## Columns: 15
## $ SIS.Login.ID         <chr> NA, "6eenuun", "mumhnhh6", "3umep7m", "en2nnpem",~
## $ Section              <chr> NA, "AA", "AA", "AA", "AA", "AA", "AA", "AA", "AA~
## $ wk2AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 75, ~
## $ wk3AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,~
## $ wk4AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,~
## $ wk5AttendPercent     <dbl> 100.00, 100.00, 100.00, 100.00, 100.00, 66.67, 10~
## $ wk6AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 75, 75, 100, 1~
## $ wk7AttendPercent     <dbl> 100, 100, 100, 75, 100, 75, 100, 100, 100, 100, 7~
## $ wk8AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 0, 100, 100, 1~
## $ wk9AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 75, 75, 100, 100, 7~
## $ wk10AttendPercent    <dbl> 100, 100, 100, 100, 100, 75, 100, 0, 100, 100, 75~
## $ PercentAttendedTotal <dbl> 100.00, 100.00, 100.00, 96.67, 100.00, 90.00, 96.~
## $ TotalExamPercent     <dbl> 100.00, 82.50, 76.50, 64.25, 70.50, 79.50, 86.75,~
## $ TotalNonExamPercent  <dbl> 100.00000, 99.19580, 98.31818, 95.04196, 98.35664~
## $ FinalPercent         <dbl> 104.00, 93.46, 89.60, 81.09, 86.11, 88.57, 94.95,~
```

The remainder of the "Points Possible" row is the first row in the dataframe. Notice that the `SIS.Login.ID` and `Section` columns both contain `NA` in the first row. This makes sense, because these data fields don't represent assignments, and so they do not have an associated maximum possible points value. We can use this feature to remove remainder of the "Points Possible" row using the functions `filter()` and `is.na()`.

First, let's see if there are any other rows that contain `NA` in the `SIS.Login.ID` column.


```r
grades_2 %>% filter(is.na(SIS.Login.ID))
```

```
## # A tibble: 1 x 15
##   SIS.Login.ID Section wk2Atte~1 wk3At~2 wk4At~3 wk5At~4 wk6At~5 wk7At~6 wk8At~7
##   <chr>        <chr>       <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 <NA>         <NA>          100     100     100     100     100     100     100
## # ... with 6 more variables: wk9AttendPercent <dbl>, wk10AttendPercent <dbl>,
## #   PercentAttendedTotal <dbl>, TotalExamPercent <dbl>,
## #   TotalNonExamPercent <dbl>, FinalPercent <dbl>, and abbreviated variable
## #   names 1: wk2AttendPercent, 2: wk3AttendPercent, 3: wk4AttendPercent,
## #   4: wk5AttendPercent, 5: wk6AttendPercent, 6: wk7AttendPercent,
## #   7: wk8AttendPercent
```

**On Your Own**: Write a line of code that will test for the existence of `NA`s in the `Section` column.


```r
# NOTE TO DART TEAM: This is the answer...it would not be shown in the real 
# workshop

grades_2 %>% filter(is.na(Section))
```

```
## # A tibble: 1 x 15
##   SIS.Login.ID Section wk2Atte~1 wk3At~2 wk4At~3 wk5At~4 wk6At~5 wk7At~6 wk8At~7
##   <chr>        <chr>       <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl>
## 1 <NA>         <NA>          100     100     100     100     100     100     100
## # ... with 6 more variables: wk9AttendPercent <dbl>, wk10AttendPercent <dbl>,
## #   PercentAttendedTotal <dbl>, TotalExamPercent <dbl>,
## #   TotalNonExamPercent <dbl>, FinalPercent <dbl>, and abbreviated variable
## #   names 1: wk2AttendPercent, 2: wk3AttendPercent, 3: wk4AttendPercent,
## #   4: wk5AttendPercent, 5: wk6AttendPercent, 6: wk7AttendPercent,
## #   7: wk8AttendPercent
```

There is only one row for each of these columns that contain `NA`: the remainder of the "Points Possible" row.

**On Your Own**: Write a line of code that will filter out the row that contains `NA` in `SIS.Login.ID` (or `Section`, since it is the same row) from `grades_2`. Use `%>%`, `filter()`, `is.na()`, and `!`. Capture your result in `grades_3`.


```r
# NOTE TO DART TEAM: This is the answer...it would not be shown in the real 
# workshop

grades_3 <- grades_2 %>% filter(!is.na(Section))
```

### Join the `myuw` and `grades` Dataframes

R code introduced in this section

-   `left_join()`

Now we are ready to join the student data and course gradebook dataframes by matching the UW NETID in `myuw_4` with `SIS.Login.ID` in `grades_3`. However, note that `grades_3` contains 100 rows, whereas `myuw_4` contains 110. What does this imply?

<!-- ANS: 10 students dropped the class before the end of the quarter. -->

For this workshop, we are only interested in analyzing the performance of students who completed the course, so we can ignore then ten extra students in `myuw_4` and just pull in the registration data that matches the list of students in `grades_3`. An easy way to do this is with the `tidyverse` function `left_join()`. (This function is very similar in spirit to VLOOKUP in Excel.)

Below, the new dataframe `course_data` *gets* the `left_join()` of `grades_3` and `myuw_4`, by the common data values in the "SIS.Login.ID" and "UWNetID" columns.


```r
course_data <- left_join(grades_3, myuw_4, by = c("SIS.Login.ID" = "UWNetID"))
```

How many rows and columns does `course_data` have? Why do you think this function is called *left* join?

**Explore R**: How many rows and columns would the `left_join()` of `myuw_4` and `grades_3` have? Once you have a prediction, run the code below to see if you're right!


```r
tmp_df <- left_join(myuw_4, grades_3, by = c("UWNetID" = "SIS.Login.ID"))
glimpse(tmp_df)
```

```
## Rows: 110
## Columns: 18
## $ UWNetID              <chr> "6eenuun", "mumhnhh6", "3umep7m", "en2nnpem", "8u~
## $ Credits              <dbl> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5~
## $ Class                <chr> "FRESHMAN", "JUNIOR", "FRESHMAN", "JUNIOR", "JUNI~
## $ Major                <chr> "PreSciences", "PreSciences", "PreHealthSciences"~
## $ Section              <chr> "AA", "AA", "AA", "AA", "AA", "AA", "AA", "AA", "~
## $ wk2AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 75, 100, ~
## $ wk3AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,~
## $ wk4AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 75, ~
## $ wk5AttendPercent     <dbl> 100.00, 100.00, 100.00, 100.00, 66.67, 100.00, 10~
## $ wk6AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 75, 75, 100, 100, 1~
## $ wk7AttendPercent     <dbl> 100, 100, 75, 100, 75, 100, 100, 100, 100, 75, 75~
## $ wk8AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 0, 100, 100, 100, 1~
## $ wk9AttendPercent     <dbl> 100, 100, 100, 100, 100, 75, 75, 100, 100, 75, 10~
## $ wk10AttendPercent    <dbl> 100, 100, 100, 100, 75, 100, 0, 100, 100, 75, 100~
## $ PercentAttendedTotal <dbl> 100.00, 100.00, 96.67, 100.00, 90.00, 96.67, 76.6~
## $ TotalExamPercent     <dbl> 82.50, 76.50, 64.25, 70.50, 79.50, 86.75, 68.75, ~
## $ TotalNonExamPercent  <dbl> 99.19580, 98.31818, 95.04196, 98.35664, 91.66434,~
## $ FinalPercent         <dbl> 93.46, 89.60, 81.09, 86.11, 88.57, 94.95, 75.76, ~
```



------------------------------------------------------------------------

## Explore the joined data

### Descriptive Statistics

R code introduced in this section:

-   `skimr` library
-   `skim()` (from `skimr`): provides descriptive statistics and histograms for numerical dataframe columns
-   `contains()`


```r
library(skimr)
```

What are the attendance statistics?


```r
glimpse(course_data)
```

```
## Rows: 100
## Columns: 18
## $ SIS.Login.ID         <chr> "6eenuun", "mumhnhh6", "3umep7m", "en2nnpem", "8u~
## $ Section              <chr> "AA", "AA", "AA", "AA", "AA", "AA", "AA", "AA", "~
## $ wk2AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 75, 100, ~
## $ wk3AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,~
## $ wk4AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 75, ~
## $ wk5AttendPercent     <dbl> 100.00, 100.00, 100.00, 100.00, 66.67, 100.00, 10~
## $ wk6AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 75, 75, 100, 100, 1~
## $ wk7AttendPercent     <dbl> 100, 100, 75, 100, 75, 100, 100, 100, 100, 75, 75~
## $ wk8AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 0, 100, 100, 100, 1~
## $ wk9AttendPercent     <dbl> 100, 100, 100, 100, 100, 75, 75, 100, 100, 75, 10~
## $ wk10AttendPercent    <dbl> 100, 100, 100, 100, 75, 100, 0, 100, 100, 75, 100~
## $ PercentAttendedTotal <dbl> 100.00, 100.00, 96.67, 100.00, 90.00, 96.67, 76.6~
## $ TotalExamPercent     <dbl> 82.50, 76.50, 64.25, 70.50, 79.50, 86.75, 68.75, ~
## $ TotalNonExamPercent  <dbl> 99.19580, 98.31818, 95.04196, 98.35664, 91.66434,~
## $ FinalPercent         <dbl> 93.46, 89.60, 81.09, 86.11, 88.57, 94.95, 75.76, ~
## $ Credits              <dbl> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5~
## $ Class                <chr> "FRESHMAN", "JUNIOR", "FRESHMAN", "JUNIOR", "JUNI~
## $ Major                <chr> "PreSciences", "PreSciences", "PreHealthSciences"~
```

```r
course_data %>% select(contains("Attend")) %>% skim()
```


Table: Data summary

|                         |           |
|:------------------------|:----------|
|Name                     |Piped data |
|Number of rows           |100        |
|Number of columns        |10         |
|_______________________  |           |
|Column type frequency:   |           |
|numeric                  |10         |
|________________________ |           |
|Group variables          |None       |


**Variable type: numeric**

|skim_variable        | n_missing| complete_rate|  mean|    sd| p0|    p25|    p50| p75| p100|hist                                     |
|:--------------------|---------:|-------------:|-----:|-----:|--:|------:|------:|---:|----:|:----------------------------------------|
|wk2AttendPercent     |         0|             1| 90.50| 23.51|  0| 100.00| 100.00| 100|  100|▁▁▁▁▇ |
|wk3AttendPercent     |         0|             1| 94.00| 22.79|  0| 100.00| 100.00| 100|  100|▁▁▁▁▇ |
|wk4AttendPercent     |         0|             1| 89.25| 25.93|  0| 100.00| 100.00| 100|  100|▁▁▁▁▇ |
|wk5AttendPercent     |         0|             1| 88.00| 26.17|  0| 100.00| 100.00| 100|  100|▁▁▁▂▇ |
|wk6AttendPercent     |         0|             1| 85.75| 29.78|  0|  93.75| 100.00| 100|  100|▁▁▁▁▇ |
|wk7AttendPercent     |         0|             1| 84.50| 25.57|  0|  75.00| 100.00| 100|  100|▁▁▁▃▇ |
|wk8AttendPercent     |         0|             1| 82.00| 38.61|  0| 100.00| 100.00| 100|  100|▂▁▁▁▇ |
|wk9AttendPercent     |         0|             1| 81.25| 31.46|  0|  75.00| 100.00| 100|  100|▁▁▁▂▇ |
|wk10AttendPercent    |         0|             1| 79.75| 32.70|  0|  75.00| 100.00| 100|  100|▂▁▁▃▇ |
|PercentAttendedTotal |         0|             1| 85.93| 22.69|  0|  83.33|  96.67| 100|  100|▁▁▁▁▇ |

How about exam and non-exam points?


```r
glimpse(course_data)
```

```
## Rows: 100
## Columns: 18
## $ SIS.Login.ID         <chr> "6eenuun", "mumhnhh6", "3umep7m", "en2nnpem", "8u~
## $ Section              <chr> "AA", "AA", "AA", "AA", "AA", "AA", "AA", "AA", "~
## $ wk2AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 75, 100, ~
## $ wk3AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 100,~
## $ wk4AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 100, 100, 100, 75, ~
## $ wk5AttendPercent     <dbl> 100.00, 100.00, 100.00, 100.00, 66.67, 100.00, 10~
## $ wk6AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 75, 75, 100, 100, 1~
## $ wk7AttendPercent     <dbl> 100, 100, 75, 100, 75, 100, 100, 100, 100, 75, 75~
## $ wk8AttendPercent     <dbl> 100, 100, 100, 100, 100, 100, 0, 100, 100, 100, 1~
## $ wk9AttendPercent     <dbl> 100, 100, 100, 100, 100, 75, 75, 100, 100, 75, 10~
## $ wk10AttendPercent    <dbl> 100, 100, 100, 100, 75, 100, 0, 100, 100, 75, 100~
## $ PercentAttendedTotal <dbl> 100.00, 100.00, 96.67, 100.00, 90.00, 96.67, 76.6~
## $ TotalExamPercent     <dbl> 82.50, 76.50, 64.25, 70.50, 79.50, 86.75, 68.75, ~
## $ TotalNonExamPercent  <dbl> 99.19580, 98.31818, 95.04196, 98.35664, 91.66434,~
## $ FinalPercent         <dbl> 93.46, 89.60, 81.09, 86.11, 88.57, 94.95, 75.76, ~
## $ Credits              <dbl> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5~
## $ Class                <chr> "FRESHMAN", "JUNIOR", "FRESHMAN", "JUNIOR", "JUNI~
## $ Major                <chr> "PreSciences", "PreSciences", "PreHealthSciences"~
```

```r
course_data %>% select(contains("Exam"), contains("Final") ) %>% skim()
```


Table: Data summary

|                         |           |
|:------------------------|:----------|
|Name                     |Piped data |
|Number of rows           |100        |
|Number of columns        |3          |
|_______________________  |           |
|Column type frequency:   |           |
|numeric                  |3          |
|________________________ |           |
|Group variables          |None       |


**Variable type: numeric**

|skim_variable       | n_missing| complete_rate|  mean|    sd|   p0|   p25|   p50|   p75|  p100|hist                                     |
|:-------------------|---------:|-------------:|-----:|-----:|----:|-----:|-----:|-----:|-----:|:----------------------------------------|
|TotalExamPercent    |         0|             1| 73.01| 15.39| 0.00| 67.94| 77.12| 83.00| 89.50|▁▁▁▃▇ |
|TotalNonExamPercent |         0|             1| 86.03| 17.77| 4.48| 83.28| 92.16| 96.22| 99.91|▁▁▁▂▇ |
|FinalPercent        |         0|             1| 82.44| 15.75| 5.87| 78.44| 87.91| 92.41| 96.76|▁▁▁▂▇ |

### Plots

#### Bar Charts

How many students are there in each year?


```r
ggplot(data = course_data,
       mapping = aes(x = Class)) +
  geom_bar()
```

![](uw-dart-ws-plan_files/figure-html/unnamed-chunk-24-1.png)<!-- -->

**On Your Own**: Create a bar chart showing how many students there are in each type of major.

#### Histograms ???

#### Box Plots

Box plots provide us with a "top down" view of the histogram for a particular numerical variable.

What is the distribution of total exam percent for each year in school?


```r
ggplot(data = course_data,
       mapping = aes(x = factor(Class), 
                     y = TotalExamPercent)) +
  geom_boxplot()
```

![](uw-dart-ws-plan_files/figure-html/unnamed-chunk-25-1.png)<!-- -->

What is the distribution of total *non*-exam percent for each year in school?


```r
ggplot(data = course_data,
       mapping = aes(x = factor(Class), 
                     y = TotalNonExamPercent)) +
  geom_boxplot()
```

![](uw-dart-ws-plan_files/figure-html/unnamed-chunk-26-1.png)<!-- -->

**On Your Own**: Create box plots showing the distributions of total exam and non-exam percent for each type of major.

#### Scatterplots and Regression Lines

How do exam points and non exam points correlate by class standing?


```r
ggplot(data = course_data,
       mapping = aes(x = TotalNonExamPercent,
                     y = TotalExamPercent,
                     color = Class)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
```

```
## `geom_smooth()` using formula 'y ~ x'
```

![](uw-dart-ws-plan_files/figure-html/unnamed-chunk-27-1.png)<!-- -->

**On Your Own**: Create scatterplots with regression lines showing of total exam percent (y-axis) versus and total non-exam percent (x-axis) for each type of major.

<!-- NOTES (08-15) -->

<!-- * Filter out the low data point -->

<!-- * X add regression lines -->

<!-- * transform data using a logit or arcsine -->

<!-- CFC NOTES: -->

<!-- * Group majors into buckets -->

<!-- * Show table or bar chart of numbers/percent of students in each year/major -->

<!-- * Box plots of exam/non-exam points by class standing/major -->

<!-- * Include (somewhere) explanations of the anatomy of the Rmd file -->

<!-- * Create metadata files for `class_standing` and `gradebook` -->
