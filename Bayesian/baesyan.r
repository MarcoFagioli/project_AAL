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

bn.net(fit, debug = FALSE)

structure <- hc(data_fit)#, whitelist=arc.set)#, score = "bic-cg")#, whitelist=arc.set )
structure <- gs(data_fit)
structure = iamb(data_fit)


fit = bn.fit(structure, data)

plot.network(structure, ht = "600px")

