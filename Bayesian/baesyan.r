if(!require(bnlearn)){
        install.packages("bnlearn")
        library("bnlearn")
}
if(!require(visNetwork)){
        install.packages("visNetwork")
        library("visNetwork")
}

plot.network <- function(structure, ht = "400px"){
        nodes.uniq <- unique(c(structure$arcs[,1], structure$arcs[,2]))
        nodes <- data.frame(id = nodes.uniq,
                            label = nodes.uniq,
                            color = "darkturquoise",
                            shadow = TRUE)
        
        edges <- data.frame(from = structure$arcs[,1],
                            to = structure$arcs[,2],
                            arrows = "to",
                            smooth = TRUE,
                            shadow = TRUE,
                            color = "black")
        
        return(visNetwork(nodes, edges, height = ht, width = "100%"))
}

nodi <- c("roll1_disc","accel1_disc","accel2_disc","roll2_disc","roll3_disc","pitch3_disc","pitch4_disc","accel_mean_disc","accel_std_disc", "sitting","sittingdown","walking","standing","standingup")
e = empty.graph(nodi)
class(e)
e

arc.set = matrix(c("accel1_disc","sitting",
                   "accel_mean_disc", "sitting",
                   "accel_mean_disc", "walking",
                   "roll1_disc","sittingdown",
                   "roll2_disc","standing",
                   "roll2_disc","sitting",
                   "roll3_disc","standingup",
                   "roll3_disc","sittingdown",
                   "pitch4_disc","standingup",
                   "accel_std_disc", "standing",
                   "pitch3_disc","standingup",
                   "pitch3_disc","walking",
                   "accel2_disc","walking"),
                 ncol = 2, byrow = TRUE,
                 dimnames = list(NULL, c("from", "to")))

arcs(e) = arc.set
e

train <- read.csv(file="../data/train_dataset.csv", header=TRUE, sep=";")
test <- read.csv(file="../data/test_dataset.csv", header=TRUE, sep=";")

for (col in nodi){
        train[[col]] <- factor(train[[col]])
}

train_fit <- train[nodi]

#fit = bn.fit(e, train_fit, method = "mle", debug = TRUE)
fit = bn.fit(e, train_fit, method = "bayes", debug = TRUE)

plot.network(e, ht = "600px")

nodi_test <- c(nodi, "class")
test_fit <- test[nodi_test]

class <- c("sitting", "sittingdown", "standing", "standingup", "walking")

confusion_matrix = matrix( 0L, nrow = length(class), ncol = length(class))
dimnames(confusion_matrix) = list( class, class)

for (i in 1:nrow(test_fit)) {
        row <- test_fit[i,]
        
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
                        pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 &
                        accel2_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob_sittingdown <- cpquery(fit, sittingdown == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                                        pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 &
                                        accel2_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob_standing <- cpquery(fit, standing == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                                            pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 &
                                            accel2_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob_standingup <- cpquery(fit, standingup == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                                            pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 &
                                            accel2_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob_walking <- cpquery(fit, walking == 1, roll1_disc == roll1 & roll2_disc == roll2 & roll3_disc == roll3 & 
                                           pitch3_disc == pitch3 & pitch4_disc == pitch4 & accel1_disc == accel1 &
                                           accel2_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob <- c(prob_sitting, prob_sittingdown, prob_standing, prob_standingup, prob_walking)
        
        prob_max_index <- which.max(prob)
        
        prob_max_class <- class[prob_max_index]
        
        confusion_matrix[prob_max_class,real_class] <- confusion_matrix[prob_max_class, real_class] + 1
}

recall_sitting <- confusion_matrix['sitting', 'sitting']/(sum(confusion_matrix[,'sitting']))
recall_sittingdown <- confusion_matrix['sittingdown', 'sittingdown']/(sum(confusion_matrix[,'sittingdown']))
recall_standing <- confusion_matrix['standing', 'standing']/(sum(confusion_matrix[,'standing']))
recall_standingup <- confusion_matrix['standingup', 'standingup']/(sum(confusion_matrix[,'standingup']))
recall_walking <- confusion_matrix['walking', 'walking']/(sum(confusion_matrix[,'walking']))
recall_all <- c(recall_sitting, recall_sittingdown, recall_standing, recall_standingup, recall_walking)

precision_sitting <- confusion_matrix['sitting', 'sitting']/(sum(confusion_matrix['sitting',]))
precision_sittingdown <- confusion_matrix['sittingdown', 'sittingdown']/(sum(confusion_matrix['sittingdown',]))
precision_standing <- confusion_matrix['standing', 'standing']/(sum(confusion_matrix['standing',]))
precision_standingup <- confusion_matrix['standingup', 'standingup']/(sum(confusion_matrix['standingup',]))
precision_walking <- confusion_matrix['walking', 'walking']/(sum(confusion_matrix['walking',]))
precision_all <- c(precision_sitting, precision_sittingdown, precision_standing, precision_standingup, precision_walking)

f_score_sitting <- 2*recall_sitting * precision_sitting/(recall_sitting + precision_sitting)
f_score_sittingdown <- 2*recall_sittingdown * precision_sittingdown/(recall_sittingdown + precision_sittingdown)
f_score_standing <- 2*recall_standing * precision_standing/(recall_standing + precision_standing)
f_score_standingup <- 2*recall_standingup * precision_standingup/(recall_standingup + precision_standingup)
f_score_walking <- 2*recall_walking * precision_walking/(recall_walking + precision_walking)
f_score_all <- c(f_score_sitting, f_score_sittingdown, f_score_standing, f_score_standingup, f_score_walking)


results = matrix(c(recall_all, precision_all, f_score_all), nrow = 3, ncol = 5, byrow = TRUE)
dimnames(results) = list( c('recall', 'precision', 'f-score'), class)
results

#salvo la rete
saveRDS(fit, file = "fit.rds")

                 