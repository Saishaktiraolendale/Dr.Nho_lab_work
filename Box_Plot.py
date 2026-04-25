import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# Timepoint columns
timepoints = ['BL_BrainAge', 'V2_BrainAge', 'V4_BrainAge']

# Set up plot
fig, axs = plt.subplots(1, 3, figsize=(16, 6), sharey=True)

# Loop through each timepoint and plot
for i, col in enumerate(timepoints):
    data = df[col].dropna()

    Q1 = data.quantile(0.25)
    Q3 = data.quantile(0.75)
    IQR = Q3 - Q1
    lower_whisker = Q1 - 1.5 * IQR
    upper_whisker = Q3 + 1.5 * IQR
    median = data.median()

    # Plot boxplot
    sns.boxplot(
        y=data,
        ax=axs[i],
        color='lightblue',
        fliersize=7,
        flierprops=dict(marker='o', markerfacecolor='red', markeredgecolor='red', markersize=6, linestyle='none')
    )

    # Draw horizontal lines for IQR and median
    axs[i].axhline(Q1, color='brown', linestyle='--', label='Q1')
    axs[i].axhline(Q3, color='brown', linestyle='--', label='Q3')
    axs[i].axhline(lower_whisker, color='red', linestyle=':', label='Lower Whisker')
    axs[i].axhline(upper_whisker, color='red', linestyle=':', label='Upper Whisker')
    axs[i].axhline(median, color='blue', linestyle='-', label='Median')

    axs[i].set_title(f'IQR Plot: {col}')
    axs[i].set_xlabel('')

    # Only add legend to first subplot
    if i == 0:
        axs[i].legend(loc='upper right')

# Add common y-axis label
fig.text(0.04, 0.5, 'Brain Age', va='center', rotation='vertical', fontsize=12)

plt.tight_layout()
plt.show()
