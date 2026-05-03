
# ----------------------------
# Linear Model: Gene Expression ~ Delta_Age + Covariates (No APOEGrp)
# Visit.Label == 4, Exclude DX == 1 (NC_Young)
# ----------------------------

# Step 1: Load libraries
library(tidyverse)
library(ggplot2)

# Step 2: Load RNA expression data
rna_df <- read.csv("cqn_tbl_total_fixed.csv")

# Step 3: Load metadata
meta <- read.csv("Merged_KBASE_Demographic_BrainAge.csv")

# Step 4: Filter metadata for Visit.Label == 4 and exclude NC_Young (DX == 1)
meta_filtered <- meta %>%
  filter(Visit.Label == 4, DX != 1) %>%
  mutate(Delta_Age = Brain_Age - Age) %>%
  drop_na(Delta_Age, Sex, Age, RIN.Value, Batch)

# Print total rows for confirmation
cat("Total rows for Visit 4 after filtering (excluding DX == 1):", nrow(meta_filtered), "\n")

# Step 5: Match barcodes with RNA columns
meta_filtered$Barcode_str <- paste0("X", meta_filtered$Barcode)
rna_sample_columns <- colnames(rna_df)[7:ncol(rna_df)]
valid_barcodes <- meta_filtered$Barcode_str[meta_filtered$Barcode_str %in% rna_sample_columns]

meta_final <- meta_filtered %>%
  filter(Barcode_str %in% valid_barcodes) %>%
  arrange(factor(Barcode_str, levels = valid_barcodes))
head(meta_final)
str(meta_final)

# Convert categorical variables to factors
meta_final$Sex <- as.factor(meta_final$Sex)
meta_final$Batch <- as.factor(meta_final$Batch)

head(meta_final)
str(meta_final)

# Step 6: Build expression matrix
expr_mat <- rna_df %>%
  select(Geneid, all_of(valid_barcodes))

rownames(expr_mat) <- expr_mat$Geneid
expr_mat <- expr_mat[, -1]

# Step 7: Run linear model per gene (No APOEGrp)
results_list <- apply(expr_mat, 1, function(gene_expr) {
  df <- cbind(meta_final, Expression = as.numeric(gene_expr))
  model <- lm(Expression ~ Delta_Age + Sex + Age + RIN.Value + Batch, data = df)
  coef_summary <- summary(model)$coefficients
  if ("Delta_Age" %in% rownames(coef_summary)) {
    c(Beta = coef_summary["Delta_Age", "Estimate"],
      P.Value = coef_summary["Delta_Age", "Pr(>|t|)"])
  } else {
    c(Beta = NA, P.Value = NA)
  }
})

# Step 8: Compile results
results_df <- as.data.frame(t(results_list)) %>%
  mutate(Gene = rownames(.),
         p.fdr = p.adjust(P.Value, method = "BH")) %>%
  select(Gene, Beta, P.Value, p.fdr)

# Step 9: Save all results
write.csv(results_df, "RNA_DeltaAge_lm_Results_Visit4_ExcludeNCYoung_NoAPOE.csv", row.names = FALSE)

# Step 10: Filter significant genes
sig_genes <- results_df %>% filter(p.fdr < 0.05)
write.csv(sig_genes, "RNA_DeltaAge_lm_SignificantGenes_FDR05_Visit4_ExcludeNCYoung_NoAPOE.csv", row.names = FALSE)

# Step 11: Barplot of Top Genes
top_genes <- results_df %>% arrange(p.fdr) %>% slice_head(n = 20)
ggplot(top_genes, aes(x = -log10(p.fdr), y = reorder(Gene, -log10(p.fdr)))) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Top 20 Genes Associated with Delta_Age (Visit 4, No APOE, DX != 1)",
       x = "-log10 Adjusted P-value (FDR)",
       y = "Gene") +
  theme_minimal()

# Step 12: Volcano Plot
results_df <- results_df %>%
  mutate(log10_p = -log10(P.Value),
         significance = case_when(
           p.fdr < 0.05 & Beta > 0.2  ~ "Upregulated",
           p.fdr < 0.05 & Beta < -0.2 ~ "Downregulated",
           TRUE ~ "Not Significant"
         ))

ggplot(results_df, aes(x = Beta, y = log10_p)) +
  geom_point(aes(color = significance), alpha = 0.7, size = 1.5) +
  scale_color_manual(values = c(
    "Upregulated" = "red",
    "Downregulated" = "blue",
    "Not Significant" = "gray"
  )) +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "blue") +
  geom_vline(xintercept = c(-0.1, 0.1), linetype = "dotted", color = "black") +
  labs(
    title = "Volcano Plot: Gene Expression vs Delta_Age (Visit 4, No APOE, Excl. NC_Young)",
    x = "Effect Size (Beta for Delta_Age)",
    y = "-log10(P-value)",
    color = "Significance"
  ) +
  theme_minimal()
