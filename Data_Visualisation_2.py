import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the data
df = pd.read_csv("Merged_KBASE_Demographic_BrainAge.csv")

# Drop rows with missing values
df = df.dropna(subset=["Age", "Brain_Age", "Collection_time"])

# Calculate Delta Age
df["Delta_Age"] = df["Brain_Age"] - df["Age"]

# Define the three timepoints
timepoints = ["BL", "V2", "V4"]

# Set up the figure
plt.figure(figsize=(16, 5))

# Plot one subplot per timepoint
for i, tp in enumerate(timepoints, 1):
    subset = df[df["Collection_time"] == tp]
    plt.subplot(1, 3, i)
    sns.histplot(subset["Delta_Age"], bins=30, kde=True, edgecolor="black", color="brown")
    plt.title(f"{tp} - Delta Age Distribution")
    plt.xlabel("Delta Age (Brain_Age - Age)")
    plt.ylabel("Frequency")

plt.tight_layout()
plt.show()
