#Written By: Andrew Sivaprakasam
#Last Updated: 11/2023
#Description: Simple script to make some proof of concept figures

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
h_age = hist(l_data$Age, xlab = "Age (Years)", xaxt='n',ylab = "Count", freq = TRUE,col ="darkgoldenrod", breaks=c(0,17,35,60,90),main = paste("Age Distribution of ", toString(length(l_data$Age)), " ARDC Visits"))
text(h_age$mids,h_age$counts,labels=h_age$counts, adj=c(0.5, -0.5), cex = 1.5)
axis(side=1, at=c(0,18,35,60,90), labels=c(0,18,35,60,90))

#plot audiograms
freqs = c(250,500,1000,2000,4000,8000,16000)
freq_names = paste0("AC_",freqs)
  
l_aud_only = rbind(l_data$AC_250,l_data$AC_500,l_data$AC_1000,l_data$AC_2000,l_data$AC_4000,l_data$AC_8000,l_data$AC_16000)
l_qs = l_data$QuickSIN;
l_reflex = l_data$REFLEX_IPSI_4000;

r_aud_only = rbind(r_data$AC_250,r_data$AC_500,r_data$AC_1000,r_data$AC_2000,r_data$AC_4000,r_data$AC_8000,r_data$AC_16000)
r_qs = r_data$QuickSIN;
r_reflex = r_data$REFLEX_IPSI_4000;

age = l_data$Age;

#TODO: Maybe switch this to use ggplot2 instead of r base
plot_audio <- function(freqs, data_matrix, color = rgb(0,0,1), ylim = c(100,-20), title = 'Audiogram'){
  matplot(freqs,data_matrix,type = "l", lwd = 3, col = alpha(color, 0.15), lty=1, ylim = ylim, log = 'x',xlab = 'Frequency (Hz)', ylab = "Threshold (dB HL)", main = title, xaxt = "n", yaxt="n");
  par(new = TRUE)
  matplot(freqs,rowMeans(data_matrix, na.rm=T),type = "l", lwd = 5, col = color,lty=1, ylim = ylim, log = 'x', xaxt='n', xlab = "n", ylab = "Threshold (dB HL)");
  axis(side = 1, at = freqs)
  abline(h = seq(-20,100,by=20), col = "gray", lty = 2);
  abline(v = freqs, col = "gray", lty = 2);
}

l_aud_only_t = t(l_aud_only);
colnames(l_aud_only_t) = freq_names;

r_aud_only_t = t(r_aud_only);
colnames(r_aud_only_t) = freq_names;

plot_audio(freqs, l_aud_only, color = rgb(0,0,1), title = 'All Audiograms');
par(new=TRUE)
plot_audio(freqs, r_aud_only, color = rgb(1,0,0), title = '');

#Select only audios with 
max_thresh = 25;

#return row IDs with 250-8k < max_thresh
rows_nh_r<- which(rowSums(r_aud_only_t[, 1:ncol(r_aud_only_t)-1] < max_thresh) == (ncol(r_aud_only_t) - 1))
rows_nh_l<- which(rowSums(l_aud_only_t[, 1:ncol(l_aud_only_t)-1] < max_thresh) == (ncol(l_aud_only_t) - 1))

#Trim dataset to normal hearing and hearing loss, I realize rows is actually referring to columns. This could all be done much more efficiently
l_aud_nh = l_aud_only[,rows_nh_l];
l_age_nh = l_age[rows_nh_l];
l_qs_nh = l_qs[rows_nh_l];
l_ref_nh = l_reflex[rows_nh_l];

r_aud_nh = r_aud_only[,rows_nh_r];
r_age_nh = r_age[rows_nh_r];
r_qs_nh = r_qs[rows_nh_r];
r_ref_nh = r_reflex[rows_nh_r];

#loss
l_aud_hl = l_aud_only[,-rows_nh_l];
l_age_hl = l_age[-rows_nh_l];
l_qs_hl = l_qs[-rows_nh_l];
l_ref_hl = l_reflex[-rows_nh_l];

r_aud_hl = r_aud_only[,-rows_nh_r];
r_age_hl = r_age[-rows_nh_r];
r_qs_hl = r_qs[-rows_nh_r];
r_ref_hl = r_reflex[-rows_nh_r];

color_plt = 'cyan4';
color_hl = 'brown';

plot_audio(freqs,cbind(l_aud_only,r_aud_only),color='black', title="All Audiograms");
plot_audio(freqs,cbind(l_aud_nh,r_aud_nh),color = color_plt,title = 'Data Grouped by Hearing Status');
par(new = TRUE)
plot_audio(freqs,cbind(l_aud_hl,r_aud_hl),color = color_hl, title = '');
legend('bottomleft',c('Normal Hearing', 'Hearing Loss'),col = c(color_plt,color_hl),lwd=5,cex=1.5,y.intersp=1.25);

#making a df assigning hearing status, age, quicksin, etc.
df_grouped_nh <- data.frame(QuickSin=append(l_qs_nh,r_qs_nh), Age=append(l_age_nh,r_age_nh), Reflex = append(l_ref_nh,r_ref_nh));
df_grouped_nh$hearingStatus = "Normal Hearing";
 
df_grouped_hl <- data.frame(QuickSin=append(l_qs_hl,r_qs_hl),Age=append(l_age_hl,r_age_hl), Reflex = append(l_ref_hl,r_ref_hl));
df_grouped_hl$hearingStatus = "Hearing Loss";

merged_frame = rbind(df_grouped_nh,df_grouped_hl);
plot_age <- ggplot(merged_frame,aes(x=factor(hearingStatus, level = c("Normal Hearing", "Hearing Loss")),y=Age, fill = hearingStatus, color = hearingStatus));
plot_age+geom_boxplot(alpha=0.3) + xlab('Hearing Status')+ geom_jitter(size=2,width = 0.35)+scale_color_manual(values=c(color_hl, color_plt))+scale_fill_manual(values=c(color_hl, color_plt))+theme(text=element_text(size=20))+theme(legend.position = "none");

plot_quickSin <- ggplot(merged_frame,aes(x=factor(hearingStatus, level = c("Normal Hearing", "Hearing Loss")),y=QuickSin, fill = hearingStatus, color = hearingStatus));
plot_quickSin+ylab("QuickSin (SNR Loss)")+geom_boxplot(alpha=0.3) + xlab('Hearing Status')+ geom_jitter(size=2,width = 0.35)+scale_color_manual(values=c(color_hl, color_plt))+scale_fill_manual(values=c(color_hl, color_plt))+theme(text=element_text(size=20))+theme(legend.position = "none");

plot_reflex <- ggplot(merged_frame,aes(x=factor(hearingStatus, level = c("Normal Hearing", "Hearing Loss")),y=Reflex, fill = hearingStatus, color = hearingStatus));
plot_reflex+geom_boxplot(alpha=0.3) + xlab('Hearing Status')+ geom_jitter(size=2,width = 0.35)+scale_color_manual(values=c(color_hl, color_plt))+scale_fill_manual(values=c(color_hl, color_plt))+theme(text=element_text(size=20))+theme(legend.position = "none");


#use this later 
# save_plot_as_png <- function(plot, file_name, width = 7, height = 5, dpi = 300) {
#   if (inherits(plot, "gg")) {
#     ggsave(
#       plot,
#       filename = file_name,
#       width = width,
#       height = height,
#       dpi = dpi
#     )
#   } else if (is.function(plot)) {
#     # Assuming it's a base R plot function
#     png(file_name, width = width, height = height, res = dpi)
#     plot()
#     dev.off()
#   } else {
#     stop("Unsupported plot type. Only ggplot2 or base R plots are supported.")
#   }
# }




setwd(cwd)

