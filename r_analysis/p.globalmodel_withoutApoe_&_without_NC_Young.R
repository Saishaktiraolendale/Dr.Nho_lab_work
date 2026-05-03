# ----------------------------
# Load Libraries
# ----------------------------
library(tidyverse)
library(lmerTest)
library(furrr)
library(future)

# ----------------------------
# Load Data
# ----------------------------
rna_df <- read.csv("cqn_tbl_total_fixed.csv")
meta <- read.csv("Merged_KBASE_Demographic_BrainAge.csv")

# ----------------------------
# Prepare Metadata
# ----------------------------
rna_sample_columns <- colnames(rna_df)[7:ncol(rna_df)]

meta_all <- meta %>%
  filter(Visit.Label %in% c(0, 2, 4), DX != 1) %>%
  mutate(
    Delta_Age = Brain_Age - Age,
    Barcode_str = paste0("X", Barcode),
    Subject_ID = Last.Name
  ) %>%
  filter(Barcode_str %in% rna_sample_columns) %>%
  drop_na(Delta_Age, Sex, Age, RIN.Value, Batch, Subject_ID)

# Inspect BEFORE factor conversion
cat("Before factor conversion:\n")
print(head(meta_all[, c("Sex", "Batch")]))
str(meta_all[, c("Sex", "Batch")])

# Convert Sex and Batch to factors
meta_all <- meta_all %>%
  mutate(
    Sex = as.factor(Sex),
    Batch = as.factor(Batch)
  )

# Inspect AFTER factor conversion
cat("\nAfter factor conversion:\n")
print(head(meta_all[, c("Sex", "Batch")]))
str(meta_all[, c("Sex", "Batch")])

# ----------------------------
# Prepare Expression Matrix (No Filtering)
# ----------------------------
expr_mat <- rna_df %>%
  select(Geneid, all_of(meta_all$Barcode_str)) %>%
  column_to_rownames("Geneid") %>%
  mutate(across(everything(), as.numeric)) %>%
  as.matrix()

# Align metadata to expression matrix columns
meta_all <- meta_all %>%
  arrange(match(Barcode_str, colnames(expr_mat)))
expr_mat <- expr_mat[, meta_all$Barcode_str]

cat("\n✅ Number of genes included:", nrow(expr_mat), "\n")

# ----------------------------
# Setup Parallel Plan
# ----------------------------
plan(multisession, workers = parallel::detectCores() - 1)

# ----------------------------
# LMM Function without APOEGrp
# ----------------------------
run_lmm_for_gene <- function(i) {
  gene_expr <- expr_mat[i, ]
  gene_name <- rownames(expr_mat)[i]
  
  df <- meta_all %>%
    mutate(expression = as.numeric(gene_expr[Barcode_str]))
  
  model <- tryCatch({
    lmer(expression ~ Delta_Age + Sex + Age + RIN.Value + Batch + (1 | Subject_ID), data = df)
  }, error = function(e) return(NULL))
  
  if (is.null(model)) return(NULL)
  
  coef_table <- summary(model)$coefficients
  if (!"Delta_Age" %in% rownames(coef_table)) return(NULL)
  
  tibble(
    Gene = gene_name,
    Beta = coef_table["Delta_Age", "Estimate"],
    SE = coef_table["Delta_Age", "Std. Error"],
    t = coef_table["Delta_Age", "t value"],
    P.Value = coef_table["Delta_Age", "Pr(>|t|)"]
  )
}

# ----------------------------
# Run Models in Parallel
# ----------------------------
system.time({
  results_all <- future_map_dfr(1:nrow(expr_mat), run_lmm_for_gene, .progress = TRUE)
})

# ----------------------------
# Adjust for Multiple Testing
# ----------------------------
results_all <- results_all %>%
  mutate(p.fdr = p.adjust(P.Value, method = "BH"))

# ----------------------------
# Save Results
# ----------------------------
write.csv(results_all, "RNA_LMM_DeltaAge_NoAPOE_Excl_NC_Young_AllGenes.csv", row.names = FALSE)
cat("✅ DONE: Results saved to RNA_LMM_DeltaAge_NoAPOE_Excl_NC_Young_AllGenes.csv\n")

# ----------------------------
# Volcano Plot
# ----------------------------
results_df <- read.csv("RNA_LMM_DeltaAge_NoAPOE_Excl_NC_Young_AllGenes.csv")

results_df <- results_df %>%
  mutate(
    log10_p = -log10(P.Value),
    significance = case_when(
      p.fdr < 0.05 & Beta > 0  ~ "Upregulated",
      p.fdr < 0.05 & Beta < 0 ~ "Downregulated",
      TRUE ~ "Not Significant"
    )
  )

ggplot(results_df, aes(x = Beta, y = log10_p)) +
  geom_point(aes(color = significance), alpha = 0.6, size = 1.2) +
  scale_color_manual(values = c(
    "Upregulated" = "red",
    "Downregulated" = "blue",
    "Not Significant" = "gray"
  )) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  geom_vline(xintercept = c(-0.05, 0.05), linetype = "dotted", color = "black") +
  labs(
    title = "Volcano Plot: LMM (Delta_Age Effect, All Visits, No APOE, Excl. NC_Young)",
    x = "Effect Size (Beta for Delta_Age)",
    y = "-log10(P-value)",
    color = "Significance"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    axis.title = element_text(size = 12),
    legend.title = element_text(size = 11)
  )
