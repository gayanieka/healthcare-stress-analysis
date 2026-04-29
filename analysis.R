install.packages("dplyr")
install.packages("corrplot")
install.packages("car")
install.packages("MASS")
install.packages("brant")

library(dplyr)
library(corrplot)
library(car)
library(MASS)
library(brant)
library(lmtest)


data <- read.csv("./healthcare_exp_stress.csv")

head(data)

summary(data)

str(data)




# Convert categorical variables
data$stress_score <- factor(data$stress_score, levels = 1:5, ordered = TRUE)
data$hospital_stay <- factor(data$hospital_stay)
data$patient_id <- factor(data$patient_id)
data$depression_score <- factor(data$depression_score, levels = 0:8, ordered = TRUE)

str(data)

## Checking for Missing Values and duplicates

colSums(is.na(data))

sum(duplicated(data$patient_id))


## Handling Missing Values


data_clean = na.omit(data)

# Check structure
str(data_clean)
summary(data_clean)



# Descriptive stats for stress_score
cat("=== Stress Score Descriptive Statistics ===\n")
cat("Mean:   ", mean(as.numeric(data_clean$stress_score)), "\n")
cat("Median: ", median(as.numeric(data_clean$stress_score)), "\n")
cat("SD:     ", sd(as.numeric(data_clean$stress_score)), "\n")
cat("Min:    ", min(as.numeric(data_clean$stress_score)), "\n")
cat("Max:    ", max(as.numeric(data_clean$stress_score)), "\n")

# Mode (most frequent value)
mode_stress <- as.numeric(names(sort(table(data_clean$stress_score), decreasing=TRUE)[1]))
cat("Mode:   ", mode_stress, "\n")



# More detailed descriptive statistics

numeric_vars <- data_clean[, c("medical_cost", "doctor_visits", "nigths_at_hospital")]

descriptive_table <- data.frame(
  Variable = colnames(numeric_vars),
  Mean = sapply(numeric_vars, mean),
  Median = sapply(numeric_vars, median),
  SD = sapply(numeric_vars, sd),
  Variance = sapply(numeric_vars, var),
  Min = sapply(numeric_vars, min),
  Max = sapply(numeric_vars, max),
  Range = sapply(numeric_vars, function(x) max(x) - min(x)),
  IQR = sapply(numeric_vars, IQR)
)

print(descriptive_table)

# Frequency tables

table(data_clean$stress_score)
prop.table(table(data_clean$stress_score)) * 100

table(data_clean$depression_score)
prop.table(table(data_clean$depression_score)) * 100

table(data_clean$hospital_stay)
prop.table(table(data_clean$hospital_stay)) * 100


#Visualisations

par(mfrow = c(1, 1))

# Bar plot for stress score
barplot(table(data_clean$stress_score),
        main = "Frequency of Stress Score",
        xlab = "Stress Score",
        ylab = "Count",
        col = "skyblue")

# Bar plot for depression score
barplot(table(data_clean$depression_score),
        main = "Frequency of Depression Score",
        xlab = "Depression Score",
        ylab = "Count",
        col = "lightgreen")

# Bar plot for hospital stay
barplot(table(data_clean$hospital_stay),
        main = "Hospital Stay Distribution",
        xlab = "Hospital Stay (0 = No, 1 = Yes)",
        ylab = "Count",
        col = c("orange", "purple"))

# Pie chart for hospital stay
hospital_counts <- table(data_clean$hospital_stay)

pie(hospital_counts,
    main = "Proportion of Hospital Stay",
    col = c("gold", "tomato"),
    labels = paste(names(hospital_counts), "\n", round(prop.table(hospital_counts) * 100, 2), "%"))




# Boxplots




boxplot(data_clean$medical_cost, data = data_clean,
        main = "Boxplot of Medical cost",
        xlab = "Medical Cost")


boxplot(as.numeric(stress_score) ~ hospital_stay, data = data_clean,
        main = "Stress Level by Hospital Stay Status",
        xlab = "Hospital Stay (0=No, 1=Yes)", ylab = "Stress Score",
        col = c("lightblue", "orange"))


boxplot(as.numeric(stress_score) ~ depression_score, data = data_clean,
        main = "Stress Level by Depression Score",
        xlab = "Depression Score", ylab = "Stress Score", 
        col = "plum")

boxplot(as.numeric(data_clean$stress_score),
        main = "Distribution of Stress Score",
        ylab = "Stress Score (1–5)",
        col  = "lightcoral")


# Histograms

par(mfrow = c(2, 2)) 

hist(data_clean$medical_cost, col = "steelblue", 
     main = "Distribution of Medical Cost", xlab = "Medical Cost")

hist(data_clean$doctor_visits, col = "lightgreen", 
     main = "Distribution of Doctor Visits", xlab = "Number of Visits")

hist(data_clean$nigths_at_hospital, col = "salmon", 
     main = "Distribution of Hospital Nights", xlab = "Nights at Hospital")


# Scatter plots

par(mfrow = c(1, 1))

plot(data_clean$medical_cost, as.numeric(data_clean$stress_score),
     main = "Relationship: Medical Cost vs. Stress",
     xlab = "Medical Cost", ylab = "Stress Score", pch = 19, col = "blue")


# Mode (most frequent value)
mode_stress <- as.numeric(names(sort(table(data_clean$stress_score), decreasing=TRUE)[1]))
cat("Mode:   ", mode_stress, "\n")



# Handling Outliers for medical cost

Q1_medical_cost = quantile(data_clean$medical_cost, 0.25) 
Q3_medical_cost = quantile(data_clean$medical_cost, 0.75)
IQR_value = Q3_medical_cost - Q1_medical_cost
outlier_condition = data_clean$medical_cost < (Q1_medical_cost - 1.5 * IQR_value) | data_clean$medical_cost > (Q3_medical_cost + 1.5 * IQR_value)

data_clean = data_clean[!outlier_condition, ]

dim(data_clean)



# Handling Outliers for stress score
Q1_stress = quantile(as.numeric(data_clean$stress_score), 0.25)
Q3_stress = quantile(as.numeric(data_clean$stress_score), 0.75)
IQR_stress = Q3_stress - Q1_stress

outlier_condition_stress = as.numeric(data_clean$stress_score) < (Q1_stress - 1.5 * IQR_stress) |
  as.numeric(data_clean$stress_score) > (Q3_stress + 1.5 * IQR_stress)

data_clean_stress = data_clean[!outlier_condition_stress, ]

dim(data_clean_stress)


#after hadling outliers stress score
boxplot(as.numeric(stress_score) ~ hospital_stay, data = data_clean_stress,
        main = "Stress Level by Hospital Stay Status",
        xlab = "Hospital Stay (0=No, 1=Yes)", ylab = "Stress Score",
        col = c("lightblue", "orange"))

boxplot(as.numeric(data_clean_stress$stress_score),
        main = "Distribution of Stress Score",
        ylab = "Stress Score (1–5)",
        col  = "lightcoral")


# Handling Outliers for depression 
Q1_depression = quantile(as.numeric(data_clean$depression_score), 0.25)
Q3_depression = quantile(as.numeric(data_clean$depression_score), 0.75)
IQR_depression = Q3_depression - Q1_depression

outlier_condition_depression = as.numeric(data_clean$depression_score) < (Q1_depression - 1.5 * IQR_depression) |
  as.numeric(data_clean$depression_score) > (Q3_depression + 1.5 * IQR_depression)

data_clean_depression = data_clean[!outlier_condition_depression, ]

dim(data_clean_depression)

#after hadling outliers depression
boxplot(as.numeric(stress_score) ~ depression_score, data = data_clean_depression,
        main = "Stress Level by Depression Score",
        xlab = "Depression Score", ylab = "Stress Score", 
        col = "plum")



#INFERENTIAL ANALYSIS

#Normality test
shapiro.test(as.numeric(data_clean$stress_score))

#p-value < 2.2e-16 : Stress score is not normally distributed


# t test

# Convert stress score to numeric only for the t-test
t_test_result <- t.test(
  as.numeric(stress_score) ~ hospital_stay,
  data = data_clean,
  var.equal = FALSE
)

print(t_test_result)


### SPEARMAN CORRELATION


#Create numeric dataset
num_data <- data.frame(
  cost       = data_clean$medical_cost,
  visits     = data_clean$doctor_visits,
  nights     = data_clean$nigths_at_hospital,
  stress     = as.numeric(data_clean$stress_score),
  depression = as.numeric(data_clean$depression_score)
)

# Spearman correlation matrix
cor_matrix_spearman <- cor(num_data, use = "complete.obs", method = "spearman")


corrplot(
  cor_matrix_spearman,
  method      = "color",
  type        = "upper",
  order       = "hclust",
  addCoef.col = "black",
  number.cex  = 0.8,
  tl.col      = "black",
  tl.srt      = 45,
  col         = colorRampPalette(c("#4575b4", "white", "#d73027"))(200),
  diag        = FALSE,
  mar         = c(0, 0, 2, 0),
  title       = "Spearman Correlation Matrix"
)



# Final Spearman analysis block

spearman_results <- list(
  stress_vs_depression = cor.test(
    as.numeric(data_clean$stress_score),
    as.numeric(data_clean$depression_score),
    method = "spearman"
  ),
  
  stress_vs_cost = cor.test(
    as.numeric(data_clean$stress_score),
    data_clean$medical_cost,
    method = "spearman"
  ),
  
  stress_vs_visits = cor.test(
    as.numeric(data_clean$stress_score),
    data_clean$doctor_visits,
    method = "spearman"
  ),
  
  stress_vs_nights = cor.test(
    as.numeric(data_clean$stress_score),
    data_clean$nigths_at_hospital,
    method = "spearman"
  )
)

spearman_results




#PREDICTIVE ANALYSIS

###multiple linear regression


cat("\n=== SECTION 4: Predictive Analytics (MLR) ===\n")

# Convert stress_score to numeric for regression
data_clean$stress_num <- as.numeric(data_clean$stress_score)

# Fit Multiple Linear Regression
mlr_model <- lm(stress_num ~ medical_cost + doctor_visits + nigths_at_hospital +
                  hospital_stay + as.numeric(depression_score),
                data = data_clean)

summary(mlr_model)

# =========================
# ASSUMPTION CHECKING
# =========================

cat("\n--- Assumption Checking ---\n")

# 1. Independence
cat("\n1. Durbin-Watson Test:\n")
dwtest(mlr_model)

# 2. Multicollinearity
cat("\n2. VIF:\n")
vif(mlr_model)

# 3. Normality of residuals
cat("\n3. Shapiro Test:\n")
shapiro.test(residuals(mlr_model)[1:4000])

# 4. Plots
par(mfrow = c(2,2))

# Residuals vs Fitted
plot(fitted(mlr_model), residuals(mlr_model),
     main="Residuals vs Fitted", xlab="Fitted", ylab="Residuals")
abline(h=0, col="red")

# QQ Plot
qqnorm(residuals(mlr_model))
qqline(residuals(mlr_model), col="red")

# Other diagnostic plots
plot(mlr_model, which = c(3,4))





