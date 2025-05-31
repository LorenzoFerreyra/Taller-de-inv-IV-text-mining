library(tidyverse)
library(jsonlite)
library(writexl)

data <- fromJSON("https://github.com/LorenzoFerreyra/reddit-data-extraction/raw/main/devsarg.json")
str(data)
# convert to tibble

# data type
data <- as.data.frame(data)

""" data <- as_tibble(data)
# to_excel 

# Save the data to an Excel file
print(data)
### write_xlsx(data, "###devsarg.xlsx")
""""""""