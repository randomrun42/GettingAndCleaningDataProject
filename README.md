README
================

There is only one script: **run\_analysis.R**

**The following Samsung data must be in your working directory:**

-   activity\_labels.txt
-   features.txt
-   test/subject\_test.txt
-   test/X\_test.txt
-   test/y\_test.txt
-   train/subject\_train.txt
-   train/X\_train.txt
-   train/y\_train.txt

The output is a tidy dataset: **tidy\_dataset.txt**

*Steps performed by the script:*

1.  Read in the subject, y, and X datasets
2.  Add a column to the “sub” datasets to indicate “test” or “train”
3.  Combine the test and train datasets together (separately for sub, y,
    and x)
4.  Read in the activity labels dataset
5.  Replace activity IDs with activity names
6.  Read in the features dataset
7.  Identify which features contain “mean()” or “std()”
8.  Extract the columns from dat\_x that correspond to the features
    identified above
9.  Rename the columns as the feature names (with replacement of
    undesired characters)
10. Combine dat\_sub, dat\_y, and extracted\_x
11. Convert subject and activity to factors
12. Create a tidy dataset (**dat\_avg**) with the mean of each variable
    per subject and activity
13. Write out the tidy dataset (**tidy\_dataset.txt**)
