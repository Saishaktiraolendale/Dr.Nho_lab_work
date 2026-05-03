# 🧠 Alzheimer Research KBASE

This project explores brain aging using neuroimaging, clinical data, and multi-omics analysis. It combines Python-based visualization with advanced statistical modeling in R to understand relationships between predicted brain age, chronological age, and gene expression patterns.

---

## 📊 Data Visualization (Python)

### 🔹 Brain Age Distribution
Visualizes distribution across visits (BL, V2, V4) to understand population trends.

👉 Code: [`python/Data_Visualisation.py`](python/Data_Visualisation.py)  
![Brain Age Distribution](images/Data_Distribution_Graph.png)

---

### 🔹 Box Plot Analysis
Highlights variability, spread, and potential outliers in brain age.

👉 Code: [`python/Box_Plot.py`](python/Box_Plot.py)  
![Box Plot](images/Box_Plot.png)

---

### 🔹 Model Validation (MOST IMPORTANT)
Relationship between **Predicted Brain Age vs Chronological Age**

- Strong correlation (R ≈ 0.81)
- Confirms model reliability

👉 Code: [`python/Scatter_Plot_2.py`](python/Scatter_Plot_2.py)  
![Brain Age Prediction](images/Scatter_Plot_2.png)

---

### 🔹 Delta Age Analysis
Relationship between **Delta Age vs Chronological Age**

- Reveals regression-to-mean bias  
- Indicates need for calibration

👉 Code: [`python/Scatter_Plot.py`](python/Scatter_Plot.py)  
![Delta Age Analysis](images/Scatter_Plot_1.png)

---

## 🧬 R-Based Statistical Analysis

### 🔹 Linear Mixed Effects Model (LMER)
Used for longitudinal modeling of repeated measures data to study association between gene expression and Delta Age.

👉 Code: [`r_analysis/lmer_model.R`](r_analysis/lmer_model.R)

---

### 🔹 WGCNA (Gene Co-expression Analysis)
Identifies gene modules and clusters associated with brain aging.

- Co-expression network construction  
- Module detection  
- Biological interpretation  

👉 Code:
- `r_analysis/deep4.mean.merge...softpower_10.R`

📊 Example Output:
![WGCNA Dendrogram](images/deep4.mean.merge0.20.min20.max14000_SD_Q1above.softpower_10.png)

---

### 🔹 Mean vs SD Plot (Gene Filtering)
Used to evaluate variance stabilization and gene selection.

![Mean vs SD](images/Mean_vs_SD_VST_proteinCoding.png)

---

### 🔹 Group Comparison Analysis
Comparison of brain aging patterns across groups (e.g., ApoE status / control groups)

![Group Comparison](images/lm_model_withoutApoe_&_without_NC_Young_visitable_4.png)

---

## 🛠️ Technologies Used

- **Languages:** Python, R, SQL  
- **Visualization:** Matplotlib, Seaborn  
- **Statistical Modeling:** lme4 (LMER), WGCNA  
- **Data Processing:** Pandas, NumPy  

---

## 🚀 Key Insights

- Strong correlation between predicted and chronological age validates model performance  
- Delta Age shows age-dependent bias (regression-to-mean effect)  
- WGCNA identifies gene modules associated with brain aging  
- LMER models capture longitudinal relationships between gene expression and brain aging  

---

## 📁 Project Structure



---

## 📌 Notes

- This project integrates multi-modal data: neuroimaging, clinical, and gene expression  
- Combines machine learning + statistical modeling approaches  
- Designed for research in neurodegeneration and aging  

---

## 🤝 Contact / Collaboration

If you're interested in healthcare analytics, brain aging research, or collaboration — feel free to connect!
