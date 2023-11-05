#Written By: Andrew Sivaprakasam
#Last Updated: 10/2023
#Description: Simple script to investigate preliminary correlations with age/hearing status

## Specifying data directory
data_dir <- "/media/sivaprakasaman/AndrewNVME/Pitch_Study/All_ARDC/CSV_for_R";
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

#make some simple figures

#age histogram
line<-par(lwd=2)
h_age = hist(l_data$Age, xlab = "Age (Years)", xaxt='n',ylab = "Count", freq = TRUE,col ="darkgoldenrod", breaks=c(0,18,35,60,90),main = paste("Age Distribution of ", toString(length(l_data$Age)), " ARDC Visits"))
text(h_age$mids,h_age$counts,labels=h_age$counts, adj=c(0.5, -0.5), cex = 1.5)
axis(side=1, at=c(0,18,35,60,90), labels=c(0,18,35,60,90))

#plot audiograms
freqs = c(250,500,1000,2000,4000,8000,16000)
l_aud_only = rbind(l_data$AC_250,l_data$AC_500,l_data$AC_1000,l_data$AC_2000,l_data$AC_4000,l_data$AC_8000,l_data$AC_1600)
r_aud_only = rbind(r_data$AC_250,r_data$AC_500,r_data$AC_1000,r_data$AC_2000,r_data$AC_4000,r_data$AC_8000,r_data$AC_1600)

plot_audio <- function(freqs, data_matrix, color = rgb(0,0,1), ylim = c(100,-20), title = 'Audiogram'){
  matplot(freqs,data_matrix,type = "l", lwd = 2, col = alpha(color, 0.25), lty=1, ylim = ylim, log = 'x',xlab = 'Frequency (Hz)', ylab = "Threshold (dB HL)", main = title, xaxt = "n");
  axis(side = 1, at = freqs)
  abline(h = seq(-20,100,by=20), col = "gray", lty = 2);
  abline(v = freqs, col = "gray", lty = 2);
}

plot_audio(freqs, l_aud_only, color = rgb(0,0,1));
plot_audio(freqs, r_aud_only, color = rgb(1,0,0));


setwd(cwd)
