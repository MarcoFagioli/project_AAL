#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

if(!require(bnlearn)){
   install.packages("bnlearn")
   library("bnlearn")
}

path <- args[1]
path_query <- args[2]

fit <- readRDS("../Bayesian/fit.rds")
test <- read.csv(file=path, header=TRUE, sep=";")

nodi <- c("roll1_disc","accel1_disc","accel2_disc","roll2_disc","roll3_disc","pitch3_disc","pitch4_disc","accel_mean_disc","accel_std_disc", "sitting","sittingdown","walking","standing","standingup")

# nodi pearson
#nodi <- c("accel1_disc","accel2_disc","accel3_disc", "accel4_disc", "roll2_disc","roll3_disc","pitch2_disc", "pitch3_disc","pitch4_disc","accel_mean_disc","accel_std_disc", "sitting","sittingdown","walking","standing","standingup")
nodi_test <- c(nodi, "class")
test_fit <- test[nodi_test]
#print(test_fit)

class <- c("sitting", "sittingdown", "standing", "standingup", "walking")

row <- test_fit[1,]
real_class <- row$class

roll1 <- row$roll1_disc
roll2 <- row$roll2_disc
roll3 <- row$roll3_disc
pitch3 <- row$pitch3_disc
pitch4 <- row$pitch4_disc
accel1 <- row$accel1_disc
accel2 <- row$accel2_disc
accel_mean <- row$accel_mean_disc
accel_std <- row$accel_std_disc


prob_sitting <- cpquery(fit, sitting == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                           pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 & accel2_disc == accel2 &
                           accel_mean_disc == accel_mean & accel_std_disc == accel_std)

prob_sittingdown <- cpquery(fit, sittingdown == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                               pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 & accel2_disc == accel2 &
                               accel_mean_disc == accel_mean & accel_std_disc == accel_std)

prob_standing <- cpquery(fit, standing == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                            pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 & accel2_disc == accel2 &
                            accel_mean_disc == accel_mean & accel_std_disc == accel_std)

prob_standingup <- cpquery(fit, standingup == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                              pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 & accel2_disc == accel2 &
                              accel_mean_disc == accel_mean & accel_std_disc == accel_std)

prob_walking <- cpquery(fit, walking == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                           pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 & accel2_disc == accel2 &
                           accel_mean_disc == accel_mean & accel_std_disc == accel_std)

#_________
# approccio pearson
#accel1 <- row$accel1_disc
#accel2 <- row$accel2_disc
#accel3 <- row$accel3_disc
#accel4 <- row$accel4_disc
#roll2 <- row$roll2_disc
#roll3 <- row$roll3_disc
#pitch2 <- row$pitch2_disc
#pitch3 <- row$pitch3_disc
#pitch4 <- row$pitch4_disc
#
#accel_mean <- row$accel_mean_disc
#accel_std <- row$accel_std_disc
#
#
#prob_sitting <- cpquery(fit, sitting == 1, accel1_disc == accel1 & accel2_disc == accel2 & accel3_disc == accel3 & accel4_disc == accel4 &
#                           roll2_disc == roll2 & roll3_disc == roll3 & pitch2_disc == pitch2 & pitch3_disc == pitch3 & pitch4_disc == pitch4 &
#                           accel_mean_disc == accel_mean & accel_std_disc == accel_std)
#
#prob_sittingdown <- cpquery(fit, sittingdown == 1, accel1_disc == accel1 & accel2_disc == accel2 & accel3_disc == accel3 & accel4_disc == accel4 &
#                               roll2_disc == roll2 & roll3_disc == roll3 & pitch2_disc == pitch2 & pitch3_disc == pitch3 & pitch4_disc == pitch4 &
#                               accel_mean_disc == accel_mean & accel_std_disc == accel_std)
#
#prob_standing <- cpquery(fit, standing == 1, accel1_disc == accel1 & accel2_disc == accel2 & accel3_disc == accel3 & accel4_disc == accel4 &
#                            roll2_disc == roll2 & roll3_disc == roll3 & pitch2_disc == pitch2 & pitch3_disc == pitch3 & pitch4_disc == pitch4 &
#                            accel_mean_disc == accel_mean & accel_std_disc == accel_std)
#
#prob_standingup <- cpquery(fit, standingup == 1, accel1_disc == accel1 & accel2_disc == accel2 & accel3_disc == accel3 & accel4_disc == accel4 &
#                              roll2_disc == roll2 & roll3_disc == roll3 & pitch2_disc == pitch2 & pitch3_disc == pitch3 & pitch4_disc == pitch4 &
#                              accel_mean_disc == accel_mean & accel_std_disc == accel_std)
#
#prob_walking <- cpquery(fit, walking == 1, accel1_disc == accel1 & accel2_disc == accel2 & accel3_disc == accel3 & accel4_disc == accel4 &
#                           roll2_disc == roll2 & roll3_disc == roll3 & pitch2_disc == pitch2 & pitch3_disc == pitch3 & pitch4_disc == pitch4 &
#                           accel_mean_disc == accel_mean & accel_std_disc == accel_std)
#____________
prob <- c(prob_sitting, prob_sittingdown, prob_standing, prob_standingup, prob_walking)

prob_max_index <- which.max(prob)

prob_max_class <- class[prob_max_index]
query = 0
if(real_class == prob_max_class)
{
   query = 1
} else {
   query = 0
}
#print(real_class)
#print(prob_max_class)
#print(query)
output = data.frame(query, prob_max_class)
write.csv2(output, file = path_query)