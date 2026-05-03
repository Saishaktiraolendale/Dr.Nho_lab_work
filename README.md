# 🧠 Alzheimer Research KBASE

This project focuses on analyzing brain aging patterns using neuroimaging, clinical data, and statistical modeling techniques. The goal is to understand the relationship between predicted brain age, chronological age, and delta age (brain age gap).

---

## 📊 Data Visualization

### 🔹 Brain Age Distribution
- Shows distribution of Brain Age across different visits (BL, V2, V4)
- Helps understand overall population trends

👉 Code: [`python/Data_Visualisation.py`](python/Data_Visualisation.py)

![Brain Age Distribution](images/Data_Distribution_Graph.png)

---

### 🔹 Box Plot Analysis
- Visualizes spread and variability in brain age
- Helps identify outliers and differences across groups

👉 Code: [`python/Box_Plot.py`](python/Box_Plot.py)

![Box Plot](images/Box_Plot.png)

---

### 🔹 Scatter Plot – Model Validation (MOST IMPORTANT)
- Relationship between **Predicted Brain Age vs Chronological Age**
- Strong correlation (R ≈ 0.81) validates model performance

👉 Code: [`python/Scatter_Plot_2.py`](python/Scatter_Plot_2.py)

![Brain Age Prediction](images/Scatter_Plot_2.png)

---

### 🔹 Scatter Plot – Delta Age Analysis
- Shows relationship between **Delta Age vs Chronological Age**
- Highlights regression-to-mean bias and age-related trends

👉 Code: [`python/Scatter_Plot.py`](python/Scatter_Plot.py)

![Delta Age Analysis](images/Scatter_Plot_1.png)

---

## 🧬 R-Based Statistical Analysis

Advanced statistical modeling performed using R:

- **Linear Mixed Effects Models (LMER)** for longitudinal analysis  
- **WGCNA** for gene co-expression network analysis  
- **Elastic Net / LASSO** for feature selection  

👉 Code: [`r_analysis/lmer_model.R`](r_analysis/lmer_model.R)

---

## 🛠️ Technologies Used

- **Languages:** Python, R, SQL  
- **Visualization:** Matplotlib, Seaborn  
- **Statistical Modeling:** lme4, WGCNA  
- **Data Handling:** Pandas, NumPy  

---

## 🚀 Key Insights

- Strong correlation between predicted and chronological age confirms model validity  
- Delta Age shows age-dependent bias, indicating need for model calibration  
- Statistical models help uncover associations between gene expression and brain aging  

---

## 📁 Project Structure
