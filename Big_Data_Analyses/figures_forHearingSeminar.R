#Written By: Andrew Sivaprakasam
#Last Updated: 10/2023
#Description: Simple script to investigate preliminary correlations with age/hearing status

## Specifying data directory
data_dir <- "/media/asivapr/AndrewNVME/Pitch_Study/All_ARDC/CSV_for_R";
cwd <- getwd();

setwd(data_dir);

## Installing Dependencies & Importing Libraries
list.of.packages <- c('ggplot2', 'dplyr','corrplot','PerformanceAnalytics','nloptr','lme4')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

lapply(list.of.packages,library, character.only=TRUE);

## Load data
l_data <- read.csv("all_ardc_l.csv");
r_data <-  read.csv("all_ardc_r.csv");

#combine left and right
all_data <-rbind(l_data,r_data)

#truncate timestamps/IDs/Researcher
all_data <- all_data[4:38];

#Get correlation matrix
r_m <- cor(all_data, use="pairwise.complete.obs", method = "pearson");

#get significance
res1 <- cor.mtest(all_data, conf.level = 0.95);

#plot correlation matrix/clustering
corr_plot_noSig = corrplot(r_m,order='hclust', addrect = 5);
corr_plot_Sig = corrplot(r_m,order='hclust', addrect = 5,p.mat=res1$p, sig.level = 0.005);

setwd(cwd)
