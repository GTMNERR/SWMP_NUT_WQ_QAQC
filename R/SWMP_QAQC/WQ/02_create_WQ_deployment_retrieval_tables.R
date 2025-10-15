# load libraries and data files 
# uncomment below if necessary
# source('R/00_loadpackages.R')

# 01 load data --------------------------------------------------
## load lims_wide_final File
## this file should be in the 'data' folder
dPI <- read.csv(here::here('data', 
                           '2025',
                           'PI',
                           'gtm-pi-2025-summary.csv')) # this is where you'd want to rename the file
dSS <- read.csv(here::here('data', 
                           '2025',
                           'SS',
                           'gtm-ss-2025-summary.csv')) # this is where you'd want to rename the file
dFM <- read.csv(here::here('data', 
                           '2025',
                           'FM', 
                           'gtm-fm-2025-summary.csv')) # this is where you'd want to rename the file
dPC <- read.csv(here::here('data', 
                           '2025',
                           'PC',
                           'gtm-pc-2025-summary.csv')) # this is where you'd want to rename the file

# inspect the data
dplyr::glimpse(dPI)
dplyr::glimpse(dSS)
dplyr::glimpse(dFM)
dplyr::glimpse(dPC)

# Select only the rows with deployment datestimes and sensor types. The ratio collects rows of wanted data - starts at row 1 and ends at row 16.
# The last ratio number will change as the original data file grows with passing time.
# The last ration number will also be one less than the total number of rows the data is in. Example: if the data ends at row 19 you will put 18 for the second ratio value
dPI2 <- dplyr::slice(dPI, 1:10)
dSS2 <- dplyr::slice(dSS, 1:10)
dFM2 <- dplyr::slice(dFM, 1:10)
dPC2 <- dplyr::slice(dPC, 1:16)

# 02 merge columns
dPI3 <- dPI2 %>%
  tidyr::unite(col='DeploymentDateTime', c('Deploy.Date', 'Deploy.Time'), sep=', ') %>%
         unite(col='RetrievalDateTime', c('Retrieve.Date', 'Retrieve.Time'), sep=', ') %>%
         unite(col='DatasondeModelNumber', c('Sonde.Model.Number..Nickname.', 'EXO.Model.Number') , sep=' ')

dSS3 <- dSS2 %>%
  tidyr::unite(col='DeploymentDateTime', c('Deploy.Date', 'Deploy.Time'), sep=', ') %>%
  unite(col='RetrievalDateTime', c('Retrieve.Date', 'Retrieve.Time'), sep=', ') %>%
  unite(col='DatasondeModelNumber', c('Sonde.Model.Number..Nickname.', 'EXO.Model.Number') , sep=' ')

dFM3 <- dFM2 %>%
  tidyr::unite(col='DeploymentDateTime', c('Deploy.Date', 'Deploy.Time'), sep=', ') %>%
  unite(col='RetrievalDateTime', c('Retrieve.Date', 'Retrieve.Time'), sep=', ') %>%
  unite(col='DatasondeModelNumber', c('Sonde.Model.Number..Nickname.', 'EXO.Model.Number') , sep=' ')

dPC3 <- dPC2 %>%
  tidyr::unite(col='DeploymentDateTime', c('Deploy.Date', 'Deploy.Time'), sep=', ') %>%
  unite(col='RetrievalDateTime', c('Retrieve.Date', 'Retrieve.Time'), sep=', ') %>%
  unite(col='DatasondeModelNumber', c('Sonde.Model.Number..Nickname.', 'EXO.Model.Number') , sep=' ')

# 03 Select Order for output
PI_deployment <- dPI3 %>% 
  dplyr::select(DeploymentDateTime, RetrievalDateTime, DatasondeModelNumber, pH.Model.Number, roxDO.Model.Number, Turb.Model.Number, Cond.Model.Number, Chloro.Model.Number)

SS_deployment <- dSS3 %>% 
  dplyr::select(DeploymentDateTime, RetrievalDateTime, DatasondeModelNumber, pH.Model.Number, roxDO.Model.Number, Turb.Model.Number, Cond.Model.Number, Chloro.Model.Number)

FM_deployment <- dFM3 %>% 
  dplyr::select(DeploymentDateTime, RetrievalDateTime, DatasondeModelNumber, pH.Model.Number, roxDO.Model.Number, Turb.Model.Number, Cond.Model.Number, Chloro.Model.Number)

PC_deployment <- dPC3 %>% 
  dplyr::select(DeploymentDateTime, RetrievalDateTime, DatasondeModelNumber, pH.Model.Number, roxDO.Model.Number, Turb.Model.Number, Cond.Model.Number, Chloro.Model.Number)

  
# 04 Output table for metadata
write.csv(PI_deployment, here::here('output', 'wq', 'metadata', 'PI_deployment_retrieval.csv'), row.names = FALSE)
write.csv(SS_deployment, here::here('output', 'wq', 'metadata', 'SS_deployment_retrieval.csv'), row.names = FALSE)
write.csv(FM_deployment, here::here('output', 'wq', 'metadata', 'FM_deployment_retrieval.csv'), row.names = FALSE)
write.csv(PC_deployment, here::here('output', 'wq', 'metadata', 'PC_deployment_retrieval.csv'), row.names = FALSE)