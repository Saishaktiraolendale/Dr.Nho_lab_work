import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import pearsonr

# Step 1: Load the uploaded file
df = pd.read_csv("Merged_KBASE_Demographic_BrainAge.csv")  # Replace with actual filename

# Step 2: Drop rows with missing Age or Brain_Age
df = df.dropna(subset=["Age", "Brain_Age"])

# Step 3: Calculate Pearson correlation (R) and p-value
r_value, p_value = pearsonr(df["Age"], df["Brain_Age"])

# Step 4: Create regression plot
plt.figure(figsize=(8, 5))
sns.regplot(x="Age", y="Brain_Age", data=df, scatter_kws={"alpha": 0.6}, line_kws={"color": "red"})
plt.title("Linear Relationship Between Chronological Age and Predicted Brain Age")

# Add R and p-value text on the plot:
plt.text(
    0.05, 0.95, 
    f"R = {r_value:.3f}\nP = {p_value:.2e}",
    transform=plt.gca().transAxes,
    fontsize=12,
    verticalalignment='top',
    bbox=dict(boxstyle="round", facecolor="white", alpha=0.5)
)

plt.xlabel("Chronological Age")
plt.ylabel("Predicted Brain Age")
plt.tight_layout()
plt.show()
