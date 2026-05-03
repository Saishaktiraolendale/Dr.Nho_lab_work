import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import pearsonr

# Step 1: Load the file
df = pd.read_csv("Merged_KBASE_Demographic_BrainAge.csv")

# Step 2: Drop missing values
df = df.dropna(subset=["Age", "Brain_Age"])

# Step 3: Calculate Delta Age
df["Delta_Age"] = df["Brain_Age"] - df["Age"]

# Step 4: Calculate Pearson correlation
r_value, p_value = pearsonr(df["Age"], df["Delta_Age"])

# Step 5: Plot
plt.figure(figsize=(8, 5))
sns.regplot(x="Age", y="Delta_Age", data=df, scatter_kws={"alpha": 0.6}, line_kws={"color": "red"})

plt.title("Relationship Between Chronological Age and Delta Age (Brain Age - Chronological Age)")

# Add R and p-value
plt.text(
    0.05, 0.95,
    f"R = {r_value:.3f}\nP = {p_value:.2e}",
    transform=plt.gca().transAxes,
    fontsize=12,
    verticalalignment='top',
    bbox=dict(boxstyle="round", facecolor="white", alpha=0.5)
)

plt.xlabel("Chronological Age")
plt.ylabel("Delta Age (Brain_Age - Age)")
plt.tight_layout()
plt.show()
