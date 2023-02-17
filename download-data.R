library(tidyverse)

#s3 <- arrow::s3_bucket("biodiversity-metrics", endpoint_override="https://minio.thelio.carlboettiger.info")


download.file("https://data.nhm.ac.uk/resources/bfdf010d2e694995d9e0812a0fb5c9de-9386-1676501318.zip", "predicts-columns.zip")
predicts_refs <- readr::read_csv("predicts-references.csv")



biotime_refs <- read_csv("https://zenodo.org/record/5026943/files/BioTIMECitations_24_06_2021.csv?download=1")
