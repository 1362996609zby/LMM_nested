# LMM_nested
评估组学的贡献度以及贡献度的显著性
1. Random_Effects_Contribution 表的解读
表示例：
grp	var1	var2	vcov	sdcor	Contribution (%)
Feature:Treatment	(Intercept)		3115.791636	55.81927656	75.16780279
Treatment	(Intercept)		0.217054056	0.465890605	0.005236382
Residual			1029.106	32.07968205	24.82696082
字段含义及作用：
1.	grp：
o	Feature:Treatment：表示特征（Feature）嵌套在处理（Treatment）下的随机效应，捕捉了组学特征在不同处理条件下对表型的变异性。
o	Treatment：表示处理本身的随机效应，反映实验处理的总体变异贡献。
o	Residual：模型的残差，表示模型未解释的部分。
2.	vcov（方差）：
o	每个随机效应的方差值，表示该效应对表型总变异的绝对贡献。
3.	sdcor（标准差）：
o	方差的平方根，用于描述效应的分布范围。
4.	Contribution (%)：
o	每个随机效应对总方差的相对贡献，计算公式： 贡献度=vcov总方差×100\text{贡献度} = \frac{\text{vcov}}{\text{总方差}} \times 100贡献度=总方差vcov×100
如何解读此表：
•	主要效应：
o	Feature:Treatment 的贡献度为 75.17%，说明组学特征在不同实验处理下是表型变异的主要来源。
o	生物学意义：特定组学特征（如基因或代谢物）受处理的显著影响，对表型有重要贡献。
•	次要效应：
o	Treatment 的贡献度为 0.0052%，说明实验处理的总体随机效应对表型的影响微乎其微。
o	生物学意义：处理条件的总体变异较小，可能需要进一步优化实验设计。
•	模型未解释的部分：
o	Residual 的贡献度为 24.83%，表示模型未能解释的变异仍然存在。
o	建议：可考虑引入额外的固定效应或随机效应以提高模型拟合度。
总结：
•	表型的主要变异来源是 Feature:Treatment（随机效应嵌套结构）。
•	处理本身的随机效应较小，表明其对表型的直接随机影响有限。
•	模型未解释的变异（Residual）需要进一步研究。
________________________________________
2. Random_Effects_Significance 表的解读
表示例：
npar	logLik	AIC	LRT	Df	Pr(>Chisq)
5	-545.6532001	1101.3064			
4	-591.9687454	1191.937491	92.63109063	1	6.30097E-22
4	-545.6532001	1099.3064	-3.15822E-10	1	1
字段含义及作用：
1.	npar：
o	模型的参数个数。
o	从 npar=5（完整模型）到 npar=4（简化模型），减少了一个随机效应。
2.	logLik（对数似然值）：
o	衡量模型对数据的拟合程度。
o	值越大，模型拟合越好。
3.	AIC（Akaike 信息准则）：
o	模型选择指标，值越小，模型越优。
o	对比完整模型与简化模型的 AIC 可评估随机效应的重要性。
4.	LRT（似然比检验值）：
o	测量随机效应对模型拟合的贡献。
o	公式： LRT=−2×(logLik of reduced model−logLik of full model)LRT = -2 \times (\text{logLik of reduced model} - \text{logLik of full model})LRT=−2×(logLik of reduced model−logLik of full model)
5.	Df（自由度）：
o	两个模型之间参数的差异。
6.	Pr(>Chisq)（p 值）：
o	显著性水平，判断随机效应是否显著：
	p<0.05p < 0.05p<0.05：随机效应显著。
	p≥0.05p \geq 0.05p≥0.05：随机效应不显著。
如何解读此表：
•	第一行：完整模型（npar=5）
o	包含所有随机效应的模型，logLik=-545.65，AIC=1101.31。
•	第二行：去掉 Feature:Treatment 后的模型（npar=4）
o	去掉嵌套随机效应后，logLik 明显下降（从 -545.65 降到 -591.97），AIC 明显增加（从 1101.31 增加到 1191.94）。
o	LRT=92.63，p = 6.3E-22：
	去掉 Feature:Treatment 后模型显著变差，说明 Feature:Treatment 是显著随机效应。
•	第三行：去掉 Treatment 后的模型（npar=4）
o	去掉处理的总体随机效应后，logLik 和完整模型一致，说明拟合质量没有变化。
o	LRT=-3.16E-10，p = 1：
	去掉 Treatment 后模型无显著变化，表明 Treatment 的随机效应不显著。
总结：
•	Feature:Treatment 是显著的随机效应，对模型拟合有重要贡献。
•	Treatment 的随机效应不显著，可考虑去掉以简化模型。
________________________________________
整体总结
1.	Random_Effects_Contribution 表：
o	提供随机效应对表型总变异的方差贡献比例。
o	主要随机效应是 Feature:Treatment，说明组学特征在不同实验处理下是表型的主要变异来源。
2.	Random_Effects_Significance 表：
o	提供随机效应显著性的统计检验结果。
o	Feature:Treatment 显著，表明该随机效应对模型拟合至关重要。
o	Treatment 不显著，可以在简化模型时忽略。


