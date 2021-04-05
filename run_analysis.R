library(tidyverse)

# Read in the subject, y, and X datasets
dat_sub_test <- read_table2("test/subject_test.txt", col_names = "subject")
dat_y_test <- read_table2("test/y_test.txt", col_names = "y")
dat_x_test <- read_table2("test/X_test.txt", col_names = FALSE)
dat_sub_train <- read_table2("train/subject_train.txt", col_names = "subject")
dat_y_train <- read_table2("train/y_train.txt", col_names = "y")
dat_x_train <- read_table2("train/X_train.txt", col_names = FALSE)

# Add a column to the "sub" datasets to indicate "test" or "train"
dat_sub_test <- dat_sub_test %>% mutate(dataset = "test") %>% select(dataset, everything())
dat_sub_train <- dat_sub_train %>% mutate(dataset = "train") %>% select(dataset, everything())

# Combine the test and train datasets together (separately for sub, y, and x)
dat_sub <- bind_rows(dat_sub_test, dat_sub_train);
dat_y <- bind_rows(dat_y_test, dat_y_train);
dat_x <- bind_rows(dat_x_test, dat_x_train);

# Remove environment data no longer needed
rm(dat_sub_test)
rm(dat_sub_train)
rm(dat_y_test)
rm(dat_y_train)
rm(dat_x_test)
rm(dat_x_train)

# Read in the activity labels dataset
activity_labels <- read_table2("activity_labels.txt", col_names = c("row", "activity")) 

# Replace activity IDs with activity names
dat_y <- dat_y %>%
    mutate(activity = pull(activity_labels[match(y, activity_labels$row), "activity"]), y) %>%
    select(-y)

# Remove environment data no longer needed
rm(activity_labels)

# Read in the features dataset
features <- read_table2("features.txt", col_names = c("row", "feature")) 

# Identify which features contain "mean()" or "std()"
mean_std_logical <- str_detect(features$feature, "mean\\(\\)|std\\(\\)")

# Extract the columns from dat_x that correspond to the features identified above
extracted_x <- dat_x %>%
    select(which(mean_std_logical))

# Remove environment data no longer needed
rm(dat_x)

# Rename the columns as the feature names (with replacement of undesired characters)
extracted_x <- extracted_x %>%
    rename_with(~ str_replace_all(features$feature[mean_std_logical],
                                  c("-" = ".", "\\(" = "", "\\)" = "")))

# Remove environment data no longer needed
rm(features, mean_std_logical)

# Combine dat_sub, dat_y, and extracted_x
dat <- bind_cols(dat_sub, dat_y, extracted_x)

# Remove environment data no longer needed
rm(dat_sub, dat_y, extracted_x)

# Convert subject and activity to factors
dat$subject <- as.factor(dat$subject)
dat$activity <- as.factor(dat$activity)

# Create a tidy dataset with the mean of each variable per subject and activity (dat_avg)
dat_avg = dat %>%
    select(-dataset) %>%
    group_by(subject, activity) %>%
    summarize(across(everything(), mean))

# Write out the tidy dataset (tidy_dataset.txt)
write.table(dat_avg, "tidy_dataset.txt", row.names = FALSE)
