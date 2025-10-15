# load libraries and data files 
# uncomment below if necessary
# source('R/00_loadpackages.R')

# 01 load data -----------------------------------------------------------------

## load all of the primary QAQC'd files for each station -----------------------
## primary QC'd files need to be place in the path listed below or modify folders to point to correct folder
PI <-
  list.files(path = here::here('data',
                               '2025',
                               'WQ',
                               'PI',
                               'data'),
             pattern = "*.csv", 
             full.names = T) %>% 
  map_df(~read_csv(., col_types = cols(.default = "c"))) 
  # rename_with(~ gsub("_", "", .x)) %>%
  # janitor::clean_names() 
  
SS <-
  list.files(path = here::here('data',
                               '2025',
                               'WQ',
                               'SS',
                               'data'),
             pattern = "*.csv", 
             full.names = T) %>% 
  map_df(~read_csv(., col_types = cols(.default = "c"))) 


FM <-
  list.files(path = here::here('data',
                               '2025',
                               'WQ',
                               'FM',
                               'data'),
             pattern = "*.csv", 
             full.names = T) %>% 
  map_df(~read_csv(., col_types = cols(.default = "c"))) 


PC <-
  list.files(path = here::here('data',
                               '2025',
                               'WQ',
                               'PC',
                               'data'),
             pattern = "*.csv", 
             full.names = T, 
             ignore.case = FALSE) %>% 
  map_df(~read_csv(., col_types = cols(.default = "c"))) 


# 02 change Date to POSIXCT and filter to only get quarterly data ------------------------------------------------
# inspect the data
dplyr::glimpse(PI)

dplyr::glimpse(SS)

dplyr::glimpse(FM)

dplyr::glimpse(PC)

## 02 rename parameters for outputs ------------------------------------------------
## edit parameter names to match CDMO

PI2 <- PI %>%
  dplyr::rename(Date = DATE,
                Time = TIME,
                fDOMQSU = FDOMQSU,
                fDOMRFU = FDOMRFU,
                ChlorophyllRFU = CHLOROPHYLLRFU)

SS2 <- SS %>%
  dplyr::rename(Date = DATE,
                Time = TIME,
                fDOMQSU = FDOMQSU,
                fDOMRFU = FDOMRFU,
                ChlorophyllRFU = CHLOROPHYLLRFU)

FM2 <- FM %>%
  dplyr::rename(Date = DATE,
                Time = TIME,
                fDOMQSU = FDOMQSU,
                fDOMRFU = FDOMRFU,
                ChlorophyllRFU = CHLOROPHYLLRFU)

PC2 <- PC %>%
  dplyr::rename(Date = DATE,
                Time = TIME,
                fDOMQSU = FDOMQSU,
                fDOMRFU = FDOMRFU,
                ChlorophyllRFU = CHLOROPHYLLRFU)

## change Date column from character to date
## filter for quarterly timeframe

PI3<-PI2 %>%
  dplyr::mutate(Date = as.Date(Date, format = "%m/%d/%Y")) %>%
        arrange(Date) %>%
        filter(between(Date, as.Date('2025-07-01'), as.Date('2025-09-30'))) #change these dates each quarter

SS3<-SS2 %>%
  dplyr::mutate(Date = as.Date(Date, format = "%m/%d/%Y")) %>%
        arrange(Date) %>%
        filter(between(Date, as.Date('2025-07-01'), as.Date('2025-09-30'))) #change these dates each quarter

FM3<-FM2 %>%
  dplyr::mutate(Date = as.Date(Date, format = "%m/%d/%Y")) %>%
        arrange(Date) %>%
        filter(between(Date, as.Date('2025-07-01'), as.Date('2025-09-30'))) #change these dates each quarter

PC3<-PC2 %>%
  dplyr::mutate(Date = as.Date(Date, format = "%m/%d/%Y")) %>%
        arrange(Date) %>%
        filter(between(Date, as.Date('2025-07-01'), as.Date('2025-09-30'))) #change these dates each quarter

# remove the NAs that will come through on file export
PI3[is.na(PI3)] <- ""

SS3[is.na(SS3)] <- ""

FM3[is.na(FM3)] <- ""

PC3[is.na(PC3)] <- ""

# look at the file
dplyr::glimpse(PI3)

dplyr::glimpse(SS3)

dplyr::glimpse(FM3)

dplyr::glimpse(PC3)

## 03 select order for outputs ------------------------------------------------
## edit to modify parameters and output order

PI_cdmoFormat <- PI3 %>% 
  dplyr::select(Date, Time, F_Record, Temp, F_Temp,	SpCond,	F_SpCond,	Sal,	F_Sal,	DO_pct,	F_DO_pct,	DO_mgl,	F_DO_mgl,	Depth,	F_Depth,	pH,	F_pH,	Turb,	F_Turb,	ChlorophyllRFU,	ChlFluor,	F_ChlFluor,	fDOMQSU,	fDOMRFU
  ) 
PI_noFlags <- PI3 %>% 
  dplyr::select(Date, Time, Temp, SpCond,	Sal, DO_pct, DO_mgl, Depth,	pH,	Turb,	ChlorophyllRFU, ChlFluor, fDOMQSU, fDOMRFU
  ) 


SS_cdmoFormat <- SS3 %>% 
  dplyr::select(Date, Time, F_Record, Temp, F_Temp,	SpCond,	F_SpCond,	Sal,	F_Sal,	DO_pct,	F_DO_pct,	DO_mgl,	F_DO_mgl,	Depth,	F_Depth,	pH,	F_pH,	Turb,	F_Turb,	ChlorophyllRFU,	ChlFluor,	F_ChlFluor,	fDOMQSU,	fDOMRFU
  )
SS_noFlags <- SS3 %>% 
  dplyr::select(Date, Time, Temp, SpCond,	Sal, DO_pct, DO_mgl, Depth,	pH,	Turb,	ChlorophyllRFU, ChlFluor, fDOMQSU, fDOMRFU
  )


FM_cdmoFormat <- FM3 %>% 
  dplyr::select(Date, Time, F_Record, Temp, F_Temp,	SpCond,	F_SpCond,	Sal,	F_Sal,	DO_pct,	F_DO_pct,	DO_mgl,	F_DO_mgl,	Depth,	F_Depth,	pH,	F_pH,	Turb,	F_Turb,	ChlorophyllRFU,	ChlFluor,	F_ChlFluor,	fDOMQSU,	fDOMRFU
  )
FM_noFlags <- FM3 %>% 
  dplyr::select(Date, Time, Temp, SpCond,	Sal, DO_pct, DO_mgl, Depth,	pH,	Turb,	ChlorophyllRFU, ChlFluor, fDOMQSU, fDOMRFU
  )

PC_cdmoFormat <- PC3 %>% 
  dplyr::select(Date, Time, F_Record, Temp, F_Temp,	SpCond,	F_SpCond,	Sal,	F_Sal,	DO_pct,	F_DO_pct,	DO_mgl,	F_DO_mgl,	Level,	F_Level,	pH,	F_pH,	Turb,	F_Turb,	ChlorophyllRFU,	ChlFluor,	F_ChlFluor,	fDOMQSU,	fDOMRFU
  )
PC_noFlags <- PC3 %>% 
  dplyr::select(Date, Time, Temp, SpCond,	Sal, DO_pct, DO_mgl, Level,	pH,	Turb,	ChlorophyllRFU, ChlFluor, fDOMQSU, fDOMRFU
  )

## 04 subset into monthly files ------------------------------------------------
## Uncomment (ctrl, shift, c) months that you want monthly files for each station

# PIjan <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[1],]
# PIfeb <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[2],]
# PImar <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[3],]
# PIapr <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[4],]
# PImay <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[5],]
# PIjun <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[6],]
PIjuly <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[7],]
PIaug <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[8],]
PIsept <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[9],]
# PIoct <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[10],]
# PInov <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[11],]
# PIdec <- PI_noFlags[months(PI_noFlags$Date) %in% month.name[12],]

# SSjan <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[1],]
# SSfeb <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[2],]
# SSmar <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[3],]
# SSapr <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[4],]
# SSmay <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[5],]
# SSjun <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[6],]
SSjuly <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[7],]
SSaug <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[8],]
SSsept <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[9],]
# SSoct <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[10],]
# SSnov <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[11],]
# SSdec <- SS_noFlags[months(SS_noFlags$Date) %in% month.name[12],]

# FMjan <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[1],]
# FMfeb <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[2],]
# FMmar <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[3],]
# FMapr <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[4],]
# FMmay <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[5],]
# FMjun <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[6],]
FMjuly <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[7],]
FMaug <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[8],]
FMsept <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[9],]
# FMoct <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[10],]
# FMnov <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[11],]
# FMdec <- FM_noFlags[months(FM_noFlags$Date) %in% month.name[12],]

# PCjan <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[1],]
# PCfeb <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[2],]
# PCmar <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[3],]
# PCapr <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[4],]
# PCmay <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[5],]
# PCjun <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[6],]
PCjuly <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[7],]
PCaug <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[8],]
PCsept <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[9],]
# PCoct <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[10],]
# PCnov <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[11],]
# PCdec <- PC_noFlags[months(PC_noFlags$Date) %in% month.name[12],]

## 05 Output quarterly csv. Uncomment needed quarter ---------------------------

# write.csv(PI3, here::here('output', 'wq', 'data', quarterly', 'gtmpiwqQ1_allParameters.csv'), row.names = FALSE)
# write.csv(PI_cdmoFormat, here::here('output', 'data', 'wq', 'quarterly', 'gtmpiwqQ1_cdmoFormat.csv'), row.names = FALSE)
# write.csv(PI_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ1_noFlags.csv'), row.names = FALSE)
# 
# write.csv(SS3, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ1_allParameters.csv'), row.names = FALSE)
# write.csv(SS_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ1_cdmoFormat.csv'), row.names = FALSE)
# write.csv(SS_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ1_noFlags.csv'), row.names = FALSE)
# 
# write.csv(FM3, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ1_allParameters.csv'), row.names = FALSE)
# write.csv(FM_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly','gtmfmwqQ1_cdmoFormat.csv'), row.names = FALSE)
# write.csv(FM_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ1_noFlags.csv'), row.names = FALSE)
# 
# write.csv(PC3, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ1_allParameters.csv'), row.names = FALSE)
# write.csv(PC_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ1_cdmoFormat.csv'), row.names = FALSE)
# write.csv(PC_noFlags, here::here('output', 'wq', 'data','quarterly', 'gtmpcwqQ1_noFlags.csv'), row.names = FALSE)

# write.csv(PI3, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ2_allParameters.csv'), row.names = FALSE)
# write.csv(PI_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ2_cdmoFormat.csv'), row.names = FALSE)
# write.csv(PI_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ2_noFlags.csv'), row.names = FALSE)
# 
# write.csv(SS3, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ2_allParameters.csv'), row.names = FALSE)
# write.csv(SS_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ2_cdmoFormat.csv'), row.names = FALSE)
# write.csv(SS_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ2_noFlags.csv'), row.names = FALSE)
# 
# write.csv(FM3, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ2_allParameters.csv'), row.names = FALSE)
# write.csv(FM_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ2_cdmoFormat.csv'), row.names = FALSE)
# write.csv(FM_noFlags, here::here('output', 'data', 'wq', 'quarterly', 'gtmfmwqQ2_noFlags.csv'), row.names = FALSE)
# 
# write.csv(PC3, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ2_allParameters.csv'), row.names = FALSE)
# write.csv(PC_cdmoFormat, here::here('output', 'data', 'wq', 'quarterly','gtmpcwqQ2_cdmoFormat.csv'), row.names = FALSE)
# write.csv(PC_noFlags, here::here('output', 'data', 'wq', 'quarterly', 'gtmpcwqQ2_noFlags.csv'), row.names = FALSE)

write.csv(PI3, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ3_allParameters.csv'), row.names = FALSE)
write.csv(PI_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ3_cdmoFormat.csv'), row.names = FALSE)
write.csv(PI_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ3_noFlags.csv'), row.names = FALSE)

write.csv(SS3, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ3_allParameters.csv'), row.names = FALSE)
write.csv(SS_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ3_cdmoFormat.csv'), row.names = FALSE)
write.csv(SS_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ3_noFlags.csv'), row.names = FALSE)

write.csv(FM3, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ3_allParameters.csv'), row.names = FALSE)
write.csv(FM_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ3_cdmoFormat.csv'), row.names = FALSE)
write.csv(FM_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ3_noFlags.csv'), row.names = FALSE)

write.csv(PC3, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ3_allParameters.csv'), row.names = FALSE)
write.csv(PC_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ3_cdmoFormat.csv'), row.names = FALSE)
write.csv(PC_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ3_noFlags.csv'), row.names = FALSE)

# write.csv(PI3, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ4_allParameters.csv'), row.names = FALSE)
# write.csv(PI_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ4_cdmoFormat.csv'), row.names = FALSE)
# write.csv(PI_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmpiwqQ4_noFlags.csv'), row.names = FALSE)
# 
# write.csv(SS3, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ4_allParameters.csv'), row.names = FALSE)
# write.csv(SS_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ4_cdmoFormat.csv'), row.names = FALSE)
# write.csv(SS_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmsswqQ4_noFlags.csv'), row.names = FALSE)
# 
# write.csv(FM3, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ4_allParameters.csv'), row.names = FALSE)
# write.csv(FM_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ4_cdmoFormat.csv'), row.names = FALSE)
# write.csv(FM_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmfmwqQ4_noFlags.csv'), row.names = FALSE)
# 
# write.csv(PC3, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ4_allParameters.csv'), row.names = FALSE)
# write.csv(PC_cdmoFormat, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ4_cdmoFormat.csv'), row.names = FALSE)
# write.csv(PC_noFlags, here::here('output', 'wq', 'data', 'quarterly', 'gtmpcwqQ4_noFlags.csv'), row.names = FALSE)

## 06 Output monthly csv files. Uncomment need monthly files --------------------

# write.csv(PIjan, here::here('output', 'wq', 'data', 'monthly', 'PIJan2025.csv'), row.names = FALSE)
# write.csv(PIfeb, here::here('output', 'wq', 'data', 'monthly', 'PIFeb2025.csv'), row.names = FALSE)
# write.csv(PImar, here::here('output', 'wq', 'data', 'monthly', 'PIMar2025.csv'), row.names = FALSE)
# 
# write.csv(SSjan, here::here('output', 'wq', 'data', 'monthly', 'SSJan2025.csv'), row.names = FALSE)
# write.csv(SSfeb, here::here('output', 'wq', 'data', 'monthly', 'SSFeb2025.csv'), row.names = FALSE)
# write.csv(SSmar, here::here('output', 'wq', 'data', 'monthly', 'SSMar2025.csv'), row.names = FALSE)
# 
# write.csv(FMjan, here::here('output', 'wq', 'data', 'monthly', 'FMJan2025.csv'), row.names = FALSE)
# write.csv(FMfeb, here::here('output', 'wq', 'data', 'monthly', 'FMFeb2025.csv'), row.names = FALSE)
# write.csv(FMmar, here::here('output', 'wq', 'data', 'monthly', 'FMMar2025.csv'), row.names = FALSE)
# 
# write.csv(PCjan, here::here('output', 'wq', 'data', 'monthly', 'PCJan2025.csv'), row.names = FALSE)
# write.csv(PCfeb, here::here('output', 'wq', 'data', 'monthly', 'PCFeb2025.csv'), row.names = FALSE)
# write.csv(PCmar, here::here('output', 'wq', 'data', 'monthly', 'PCMar2025.csv'), row.names = FALSE)

# write.csv(PIapr, here::here('output', 'wq', 'data', 'monthly', 'PIApr2025.csv'), row.names = FALSE)
# write.csv(PImay, here::here('output', 'wq', 'data', 'monthly', 'PIMay2025.csv'), row.names = FALSE)
# write.csv(PIjun, here::here('output', 'wq', 'data', 'monthly', 'PIJun2025.csv'), row.names = FALSE)
# 
# write.csv(SSapr, here::here('output', 'wq', 'data', 'monthly', 'SSApr2025.csv'), row.names = FALSE)
# write.csv(SSmay, here::here('output', 'wq', 'data', 'monthly', 'SSMay2025.csv'), row.names = FALSE)
# write.csv(SSjun, here::here('output', 'wq', 'data', 'monthly', 'SSJun2025.csv'), row.names = FALSE)
# 
# write.csv(FMapr, here::here('output', 'wq', 'data', 'monthly', 'FMApr2025.csv'), row.names = FALSE)
# write.csv(FMmay, here::here('output', 'wq', 'data', 'monthly', 'FMMay2025.csv'), row.names = FALSE)
# write.csv(FMjun, here::here('output', 'wq', 'data', 'monthly', 'FMJun2025.csv'), row.names = FALSE)
# 
# write.csv(PCapr, here::here('output', 'wq', 'data', 'monthly', 'PCApr2025.csv'), row.names = FALSE)
# write.csv(PCmay, here::here('output', 'wq', 'data', 'monthly', 'PCMay2025.csv'), row.names = FALSE)
# write.csv(PCjun, here::here('output', 'wq', 'data', 'monthly', 'PCJun2025.csv'), row.names = FALSE)

write.csv(PIjuly, here::here('output', 'wq', 'data', 'monthly', 'PIJuly2025.csv'), row.names = FALSE)
write.csv(PIaug, here::here('output', 'wq', 'data', 'monthly', 'PIAug2025.csv'), row.names = FALSE)
write.csv(PIsept, here::here('output', 'wq', 'data', 'monthly', 'PISept2025.csv'), row.names = FALSE)
#
write.csv(SSjuly, here::here('output', 'wq', 'data', 'monthly', 'SSJuly2025.csv'), row.names = FALSE)
write.csv(SSaug, here::here('output', 'wq', 'data', 'monthly', 'SSAug2025.csv'), row.names = FALSE)
write.csv(SSsept, here::here('output', 'wq', 'data', 'monthly', 'SSSept2025.csv'), row.names = FALSE)
#
write.csv(FMjuly, here::here('output', 'wq', 'data', 'monthly', 'FMJuly2025.csv'), row.names = FALSE)
write.csv(FMaug, here::here('output', 'wq', 'data', 'monthly', 'FMAug2025.csv'), row.names = FALSE)
write.csv(FMsept, here::here('output', 'wq', 'data', 'monthly', 'FMSept2025.csv'), row.names = FALSE)
#
write.csv(PCjuly, here::here('output', 'wq', 'data', 'monthly', 'PCJuly2025.csv'), row.names = FALSE)
write.csv(PCaug, here::here('output', 'wq', 'data', 'monthly', 'PCAug2025.csv'), row.names = FALSE)
write.csv(PCsept, here::here('output', 'wq', 'data', 'monthly', 'PCSept2025.csv'), row.names = FALSE)
#
# write.csv(PIoct, here::here('output', 'wq', 'data', 'monthly', 'PIOct2024.csv'), row.names = FALSE)
# write.csv(PInov, here::here('output', 'wq', 'data', 'monthly', 'PINov2024.csv'), row.names = FALSE)
# write.csv(PIdec, here::here('output', 'wq', 'data', 'monthly', 'PIDec2024.csv'), row.names = FALSE)
# 
# write.csv(SSoct, here::here('output', 'wq', 'data', 'monthly', 'SSOct2024.csv'), row.names = FALSE)
# write.csv(SSnov, here::here('output', 'wq', 'data', 'monthly', 'SSNov2024.csv'), row.names = FALSE)
# write.csv(SSdec, here::here('output', 'wq', 'data', 'monthly', 'SSDec2024.csv'), row.names = FALSE)
# 
# write.csv(FMoct, here::here('output', 'wq', 'data', 'monthly', 'FMOct2024.csv'), row.names = FALSE)
# write.csv(FMnov, here::here('output', 'wq', 'data', 'monthly', 'FMNov2024.csv'), row.names = FALSE)
# write.csv(FMdec, here::here('output', 'wq', 'data', 'monthly', 'FMDec2024.csv'), row.names = FALSE)
# 
# write.csv(PCoct, here::here('output', 'wq', 'data', 'monthly', 'PCOct2024.csv'), row.names = FALSE)
# write.csv(PCnov, here::here('output', 'wq', 'data', 'monthly', 'PCNov2024.csv'), row.names = FALSE)
# write.csv(PCdec, here::here('output', 'wq', 'data', 'monthly', 'PCDec2024.csv'), row.names = FALSE)