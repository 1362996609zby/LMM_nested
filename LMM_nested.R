# 加载必要的包
library(readxl)    # 读取Excel文件
library(tidyr)     # 数据转换
library(dplyr)     # 数据操作
library(lme4)      # 构建混合模型
library(lmerTest)  # 提供显著性检验
library(writexl)   # 导出Excel文件

# Step 1: 读取表型数据 ----
phenotype_data <- read_excel("PHENOTYPE.xlsx")

# Step 2: 读取并分析单个组学 ----
# 设置要分析的组学数据文件
omics_file <- "TAIL_GENE.xlsx"  # 替换为需要分析的组学文件

# 读取组学数据
omics_data <- read_excel(omics_file)

# 替换数据中的分号为小数点
omics_data <- omics_data %>%
  mutate(across(-c(Sample_ID, group), ~ as.numeric(gsub(";", ".", .))))

# 转换为长表格格式
omics_data <- omics_data %>%
  pivot_longer(-c(Sample_ID, group), names_to = "Feature", values_to = "Value") %>%
  mutate(Omics = "omics1")  # 为该组学添加标识

# 合并表型数据
omics_data <- omics_data %>%
  left_join(phenotype_data, by = "Sample_ID")

# 使用现有的 `group` 列作为实验处理信息
omics_data <- omics_data %>%
  rename(Treatment = group.x)

# 转换Value列为数值格式
omics_data$Value <- as.numeric(as.character(omics_data$Value))

# Step 1: 构建模型 ----
model_lmm <- lmer(Value ~ Treatment + (1|Treatment/Feature), data = omics_data)

# Step 2: 计算嵌套随机效应的贡献度 ----
# 提取随机效应方差
random_effects_variance <- as.data.frame(VarCorr(model_lmm))

# 计算总方差
total_variance <- sum(random_effects_variance$vcov)

# 计算贡献度
random_effects_variance <- random_effects_variance %>%
  mutate(Contribution = vcov / total_variance * 100)

# 输出随机效应方差和贡献度
cat("随机效应方差和贡献度：\n")
print(random_effects_variance)

# Step 3: 显著性检验 ----
# 检验随机效应的显著性
random_effects_significance <- rand(model_lmm)

# 输出随机效应显著性结果
cat("随机效应显著性检验结果：\n")
print(random_effects_significance)

# Step 4: 条件 R² 计算 ----
r2_values <- r2(model_lmm)
cat("条件 R² 值：\n")
print(r2_values)

# Step 5: 导出结果 ----
# 导出方差贡献和显著性检验结果
write_xlsx(list(
  Random_Effects_Contribution = random_effects_variance,
  Random_Effects_Significance = as.data.frame(random_effects_significance)
), "Omics_Analysis_Result.xlsx")

# 提示用户
cat("结果已导出到 'Omics_Analysis_Result.xlsx'。\n")
