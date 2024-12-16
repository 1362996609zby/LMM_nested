# 加载必要的包
library(readxl)    
library(tidyr)     
library(dplyr)     
library(lme4)      
library(lmerTest)  
library(performance)
library(writexl)   

# Step 1: 读取表型数据 ----
phenotype_data <- read_excel("PHENOTYPE2.xlsx") %>%
  select(Sample_ID, Value)  # 仅保留 Sample_ID 和因变量 Value

# Step 2: 读取组学数据 ----
omics_file <- "TAIL_GENE.xlsx"
omics_data <- read_excel(omics_file)

# 替换数据中的分号为小数点，并转换为长表格格式
omics_data <- omics_data %>%
  mutate(across(-c(Sample_ID, group), ~ as.numeric(gsub(";", ".", .)))) %>%
  pivot_longer(-c(Sample_ID, group), names_to = "Feature", values_to = "Value_omics")

# 将表型数据与组学数据合并，确保因变量（Value）正确引入
omics_data <- omics_data %>%
  left_join(phenotype_data, by = "Sample_ID") %>% 
  rename(Treatment = group)  # 重命名 group 为 Treatment

# 检查合并后的数据
cat("数据合并完成：\n")
print(head(omics_data))

# Step 3: 构建混合效应模型 ----
# 使用 Value 作为因变量，Treatment 作为固定效应，Feature 作为嵌套随机效应
model_lmm <- lmer(Value ~ Treatment + (1 | Treatment/Feature), data = omics_data)

# Step 4: 提取随机效应的方差和贡献度 ----
random_effects_variance <- as.data.frame(VarCorr(model_lmm))
total_variance <- sum(random_effects_variance$vcov)

random_effects_variance <- random_effects_variance %>%
  mutate(Contribution = vcov / total_variance * 100)

# 输出随机效应方差和贡献度
cat("随机效应方差和贡献度：\n")
print(random_effects_variance)

# Step 5: 随机效应显著性检验 ----
random_effects_significance <- rand(model_lmm)
cat("随机效应显著性检验结果：\n")
print(random_effects_significance)

# Step 6: 计算 R² ----
r2_values <- performance::r2(model_lmm)
cat("条件 R² 值：\n")
print(r2_values)

# Step 7: 导出结果 ----
write_xlsx(list(
  Random_Effects_Contribution = random_effects_variance,
  Random_Effects_Significance = as.data.frame(random_effects_significance)
), "Omics_Analysis_Result.xlsx")

cat("结果已导出到 'Omics_Analysis_Result.xlsx'。\n")
