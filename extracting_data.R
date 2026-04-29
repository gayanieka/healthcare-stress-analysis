library(haven)
library(dplyr)


hrs_data <- read_dta("randhrs1992_2022v1.dta")



hrs_subset <- hrs_data %>%
  select(
    hhidpn,                    # Unique Patient ID
    matches("R[0-9]+CESD"),    # Depressive symptoms 
    matches("R[0-9]+OOPMD"),   # Out-of-pocket costs
    matches("R[0-9]+HOSP"),    # Hospital stay (Yes/No)
    matches("R[0-9]+HSPT"),    # Total nights in hospital
    matches("R[0-9]+DOCTIM")   # Doctor visits
)

rm(hrs_data)

head(hrs_subset)


hrs_phyco <- read_dta("H_HRS_d.dta")

stress_subset <- hrs_phyco %>%
  select(
    hhidpn,                                      
    matches("stress", ignore.case = TRUE)        
)

head(stress_subset)

colnames(hrs_phyco)


# library(labelled)
# stress_variables <- look_for(hrs_phyco, "stress")
# View(stress_variables)


final_combined_data <- hrs_subset %>%
  left_join(stress_subset, by = "hhidpn")


dim(final_combined_data)


one_wave <- final_combined_data %>%
  select(
    hhidpn,         
    r14cesd,        # Depression score
    r14oopmd,       # Out-of-pocket medical costs
    r14hosp,        # Hospital stay (yes/no)
    r14hsptim,      # Total nights in hospital
    r14doctim,      # Doctor visits
    r14ydstress     # Stress score
  ) %>%
  filter(!is.na(r14ydstress))

dim(one_wave)

head(one_wave)


cleaned_data <- one_wave %>% 
                rename(
                  patient_id = hhidpn,
                  depression_score = r14cesd,
                  medical_cost = r14oopmd,
                  hospital_stay = r14hosp,
                  nigths_at_hospital = r14hsptim,
                  doctor_visits = r14doctim,
                  stress_score = r14ydstress
                )

write.csv(cleaned_data, "healthcare_exp_stress.csv", row.names = FALSE)







