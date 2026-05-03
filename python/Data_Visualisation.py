import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the data
df = pd.read_csv("KBASE_MRI_BrainAge.csv")  # adjust path if needed

# Get min and max range across all columns for X-axis
brainage_cols = ["BL_BrainAge", "V2_BrainAge", "V4_BrainAge"]
global_min = df[brainage_cols].min().min()
global_max = df[brainage_cols].max().max()

# Plot
fig, axs = plt.subplots(1, 3, figsize=(18, 5), sharey=True)

for i, col in enumerate(brainage_cols):
    sns.histplot(df[col], kde=True, color='brown', bins=30, ax=axs[i])
    axs[i].set_xlim(global_min, global_max)  # set same x-axis
    axs[i].set_title(f"{col} Distribution with KDE")
    axs[i].set_xlabel("Brain Age")
    axs[i].set_ylabel("Count")

plt.tight_layout()
plt.show()
