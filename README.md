# 🏥 Healthcare Stress Analysis  
### Statistical Modelling Project (IT3011)

## 📌 Overview
This project investigates whether **positive healthcare experiences reduce patient stress levels** using real-world healthcare data.

The study was conducted as part of the *Theory and Practices in Statistical Modelling* module at **SLIIT**, applying statistical techniques learned in the course.

---

## 🎯 Objective
To evaluate the statement:

> *"Positive healthcare experiences reduce patient stress levels"*

using:
- Descriptive Analytics  
- Inferential Analytics  
- Predictive Modelling  

---

## 📊 Dataset
- Source: Health and Retirement Study (HRS)  
- Records: 5,000+ patients  
- Variables include:
  - Stress Score (1–5)
  - Depression Score (0–8)
  - Doctor Visits
  - Medical Cost
  - Hospital Stay
  - Nights at Hospital  

---

## 🔍 Methodology

### 1. Data Preprocessing
- Removed missing values (`na.omit`)
- Outlier detection using IQR method
- Verified no duplicate records
- Converted variables to appropriate types

### 2. Descriptive Analysis
- Summary statistics (mean, median, standard deviation)
- Histograms and boxplots
- Distribution analysis

### 3. Inferential Analysis
- Shapiro-Wilk test (normality check)
- Welch t-test (group comparison)
- Spearman correlation (relationship strength)

### 4. Predictive Analysis
- Multiple Linear Regression model
- Assumption testing:
  - Durbin-Watson (independence)
  - VIF (multicollinearity)
  - Residual analysis (normality & homoscedasticity)

---

## 📈 Key Findings
- Stress levels were generally low across patients  
- Data was **not normally distributed**  
- **Depression score showed the strongest relationship with stress (r = 0.31)**  
- Medical cost was **not statistically significant**  
- Model performance:
  - R² = 0.147 (14.7% variance explained)
  - RMSE ≈ 0.97  

---

## ⚠️ Conclusion
The statement:

> *"Positive healthcare experiences reduce patient stress levels"*

is **not strongly supported** by this analysis.

This suggests that patient stress is influenced by more complex factors, particularly mental health indicators.

---

## 🛠️ Tools & Technologies
- R Programming  
- Statistical Modelling  
- Data Analysis  
- Data Visualization  

---

## 👥 Team Code-Wizard
- Ilangakoon I.P.S.H  
- Mewanya B.A.B  
- Samarakoon S.M.L.K  
- Ekanayake E.M.G.I  

---

## 🙏 Acknowledgement
We sincerely thank our lecturer(s) for their guidance and support throughout this project.

---

## 📂 Project Files
- `analysis.R` → Main analysis code  
- `extracting_data.R` → Data preprocessing  
- `README.md` → Project documentation  

---

## 🔗 Note
This project is developed strictly following statistical modelling principles taught in the module.
