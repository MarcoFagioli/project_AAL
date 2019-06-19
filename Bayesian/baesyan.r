install.packages("bnlearn")
install.packages("visNetwork")

library(bnlearn)
library(visNetwork)
library(lattice)
library(Rgraphviz)

nodi <- c("roll1_var","pitch1_var","accel1_module","roll2_var","pitch2_var","accel2_module","roll3_var","pitch3_var","accel3_module","roll4_var","pitch4_var","accel4_module","accel_mean","accel_std","sitting","sittingdown","walking","standing","standingup")
e = empty.graph(nodi)
class(e)
e

arc.set = matrix(c("accel_mean","sitting",
        "pitch4_var", "sitting",
        "accel4_module","sitting",
        "roll2_var","sittingdown",
        "pitch2_var","sittingdown",
        "accel_mean","sittingdown",
        "roll1_var","walking",
        "pitch1_var","walking",
        "accel1_module","walking",
        "roll2_var","walking",
        "roll1_var","standing",
        "pitch1_var","standing",
        "accel1_module","standing",
        "roll3_var","standing",
        "roll2_var","standingup",
        "pitch4_var","standingup",
        "pitch2_var","standingup"),
   ncol = 2, byrow = TRUE,
   dimnames = list(NULL, c("from", "to")))
arc.set

arcs(e) = arc.set
e

#___________________

nodi <- c("roll1_var","pitch1_var","accel1_module","roll2_var","pitch2_var","accel2_module","roll3_var","pitch3_var","accel3_module","roll4_var","pitch4_var","accel4_module","accel_mean","accel_std","sitting","sittingdown","walking","standing","standingup")
e = empty.graph(nodi)
class(e)
e

arc.set = matrix(c("accel1_module","sitting",
                   "accel_mean", "sitting",
                   "roll2_var","sitting",
                   "pitch4_var","sittingdown",
                   "roll2_var","standing",
                   "roll1_var","standing",
                   "pitch4_var","standingup",
                   "pitch2_var","standingup",
                   "roll3_var","standingup",
                   "pitch3_var","standingup",
                   "pitch3_var","walking",
                   "accel_mean","walking",
                   "pitch1_var","walking"),
                 ncol = 2, byrow = TRUE,
                 dimnames = list(NULL, c("from", "to")))

#_-------
nodi <- c("roll1_var_disc","pitch1_var_disc","accel1_module_disc","roll2_var_disc","pitch2_var_disc","roll3_var_disc","pitch3_var_disc","pitch4_var_disc","accel_mean_disc","sitting","sittingdown","walking","standing","standingup")
e = empty.graph(nodi)
class(e)
e

arc.set = matrix(c("accel1_module_disc","sitting",
                   "accel_mean_disc", "sitting",
                   "roll2_var_disc","sitting",
                   "pitch4_var_disc","sittingdown",
                   "roll2_var_disc","standing",
                   "roll1_var_disc","standing",
                   "pitch4_var_disc","standingup",
                   "pitch2_var_disc","standingup",
                   "roll3_var_disc","standingup",
                   "pitch3_var_disc","standingup",
                   "pitch3_var_disc","walking",
                   "accel_mean_disc","walking",
                   "pitch1_var_disc","walking"),
                 ncol = 2, byrow = TRUE,
                 dimnames = list(NULL, c("from", "to")))



arc.set

arcs(e) = arc.set
e




#data <- read.csv(file="../measure_for_r.csv", header=TRUE, sep=";")
data <- read.csv(file="../data/discrete_dataset.csv", header=TRUE, sep=";")

data$sitting <- factor(data$sitting)
data$sittingdown <- factor(data$sittingdown)
data$walking <- factor(data$walking)
data$standing <- factor(data$standing)
data$standingup <- factor(data$standingup)


data$accel1_module_disc <- factor(data$accel1_module_disc)
data$accel2_module_disc <- factor(data$accel2_module_disc)
data$accel3_module_disc <- factor(data$accel3_module_disc)
data$accel4_module_disc <- factor(data$accel4_module_disc)
data$accel_mean_disc <- factor(data$accel_mean_disc)
data$roll2_var_disc <- factor(data$roll2_var_disc)
data$pitch4_var_disc <- factor(data$pitch4_var_disc)
data$roll1_var_disc <- factor(data$roll1_var_disc)
data$roll3_var_disc <- factor(data$roll3_var_disc)
data$roll4_var_disc <- factor(data$roll4_var_disc)
data$pitch3_var_disc <- factor(data$pitch3_var_disc)
data$pitch2_var_disc <- factor(data$pitch2_var_disc)
data$pitch1_var_disc <- factor(data$pitch1_var_disc)


plot.network(e)

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

data_fit <- data[c("roll1_var_disc","pitch1_var_disc","accel1_module_disc","roll2_var_disc","pitch2_var_disc","roll3_var_disc","pitch3_var_disc","pitch4_var_disc","accel_mean_disc","sitting","sittingdown","walking","standing","standingup")]

fit = bn.fit(e, data_fit, method = "mle", debug = TRUE)
fit = bn.fit(e, data_fit, method = "bayes", debug = TRUE)
coefficients(fit)
modelstring(fit)
skeleton(e)
moral(e)

cv.nb = bn.cv(e, data = data_fit, runs = 10, method = "k-fold", folds = 10)

pp = graphviz.plot(e)


structure <- hc(data_fit)#, whitelist=arc.set)#, score = "bic-cg")#, whitelist=arc.set )
structure <- gs(data_fit)
structure = iamb(data_fit)


fit = bn.fit(structure, data)

plot.network(structure, ht = "600px")

cpquery(fit, c("sitting","sittingdown","walking","standing","standingup"), c("roll1_var_disc","pitch1_var_disc","accel1_module_disc","roll2_var_disc","pitch2_var_disc","roll3_var_disc","pitch3_var_disc","pitch4_var_disc","accel_mean_disc"))








#________________

nodi <- c("roll1_var_disc","accel1_module_disc","accel2_module_disc","roll2_var_disc","roll3_var_disc","pitch3_var_disc","pitch4_var_disc","accel_mean_disc","accel_std_disc", "sitting","sittingdown","walking","standing","standingup")
e = empty.graph(nodi)
class(e)
e

arc.set = matrix(c("accel1_module_disc","sitting",
                   "accel_mean_disc", "sitting",
                   "accel_mean_disc", "walking",
                   "roll1_var_disc","sittingdown",
                   "roll2_var_disc","standing",
                   "roll2_var_disc","sitting",
                   "roll3_var_disc","standingup",
                   "roll3_var_disc","sittingdown",
                   "pitch4_var_disc","standingup",
                   "accel_std_disc", "standing",
                   "pitch3_var_disc","standingup",
                   "pitch3_var_disc","walking",
                   "accel2_module_disc","walking"),
                 ncol = 2, byrow = TRUE,
                 dimnames = list(NULL, c("from", "to")))



arc.set

arcs(e) = arc.set
e




#data <- read.csv(file="../measure_for_r.csv", header=TRUE, sep=";")
data <- read.csv(file="../data/train_dataset.csv", header=TRUE, sep=";")
test <- read.csv(file="../data/test_dataset.csv", header=TRUE, sep=";")

for (col in nodi){
        data[[col]] <- factor(data[[col]])
        #test[[col]] <- factor(test[[col]])
}

data_fit <- data[nodi]

fit = bn.fit(e, data_fit, method = "mle", debug = TRUE)
fit = bn.fit(e, data_fit, method = "bayes", debug = TRUE)

plot.network(e, ht = "600px")

nodi_test <- c(nodi, "class")

test_fit <- test[nodi_test]

#evidence = c("roll1_var_disc","roll2_var_disc","roll3_var_disc","pitch3_var_disc","pitch4_var_disc","accel1_module_disc","accel2_module_disc","accel_mean_disc","accel_std_disc")

class <- c("sitting", "sittingdown", "standing", "standingup", "walking")



confusion_matrix = matrix( 0L, nrow = length(class), ncol = length(class))

dimnames(confusion_matrix) = list( class, class)

#cpquery(fit, (sitting == 0), TRUE)
#cpquery(fit, event = quote(sitting=='0'), TRUE)

#cpquery(fit, (sitting == 0), roll1_var_disc == 0 & accel1_module_disc == 4)

for (i in 1:nrow(test_fit)) {
        row <- test_fit[i,]
        
        real_class = row$class
        
        roll1 = row$roll1_var_disc
        roll2 = row$roll2_var_disc
        roll3 = row$roll3_var_disc
        pitch3 = row$pitch3_var_disc
        pitch4 = row$pitch4_var_disc
        accel1 = row$accel1_module_disc
        accel2 = row$accel2_module_disc
        accel_mean = row$accel_mean_disc
        accel_std = row$accel_std_disc
        
        
        prob_sitting <- cpquery(fit, sitting == 1, roll1_var_disc == roll1 & roll2_var_disc == roll2 & roll3_var_disc == roll3 & 
                        pitch3_var_disc == pitch3 & pitch4_var_disc == pitch4 & accel1_module_disc == accel1 &
                        accel2_module_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob_sittingdown <- cpquery(fit, sittingdown == 1, roll1_var_disc == roll1 & roll2_var_disc == roll2 & roll3_var_disc == roll3 & 
                                        pitch3_var_disc == pitch3 & pitch4_var_disc == pitch4 & accel1_module_disc == accel1 &
                                        accel2_module_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob_standing <- cpquery(fit, standing == 1, roll1_var_disc == roll1 & roll2_var_disc == roll2 & roll3_var_disc == roll3 & 
                                            pitch3_var_disc == pitch3 & pitch4_var_disc == pitch4 & accel1_module_disc == accel1 &
                                            accel2_module_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob_standingup <- cpquery(fit, standingup == 1, roll1_var_disc == roll1 & roll2_var_disc == roll2 & roll3_var_disc == roll3 & 
                                            pitch3_var_disc == pitch3 & pitch4_var_disc == pitch4 & accel1_module_disc == accel1 &
                                            accel2_module_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob_walking <- cpquery(fit, walking == 1, roll1_var_disc == roll1 & roll2_var_disc == roll2 & roll3_var_disc == roll3 & 
                                           pitch3_var_disc == pitch3 & pitch4_var_disc == pitch4 & accel1_module_disc == accel1 &
                                           accel2_module_disc == accel2 & accel_mean_disc == accel_mean & accel_std_disc == accel_std)
        
        prob <- c(prob_sitting, prob_sittingdown, prob_standing, prob_standingup, prob_walking)
        
        prob_max_index <- which.max(prob)
        
        prob_max_class <- class[prob_max_index]
        
        confusion_matrix[prob_max_class,real_class] <- confusion_matrix[prob_max_class, real_class] + 1
}

recall_sitting <- confusion_matrix['sitting', 'sitting']/(sum(confusion_matrix[,'sitting']))

precision_sitting <- confusion_matrix['sitting', 'sitting']/(sum(confusion_matrix['sitting',]))

f_score_sitting <- 2*recall_sitting * precision_sitting/(recall_sitting + precision_sitting)
