# A continuación se registran los procedimientos exploratorios sobre la base 
# de datos
# de la Encuesta de Evaluaci?n de la Docencia Clinica por Estudiantes, a?os 
# 2004 a 2011.
#En primer lugar establecemos directorio de trabajo.

library(dplyr)
library(psych)
library(lavaan)
library(semTools)


if(!file.exists("./data/meduc30.csv")) {
        setwd("meduc30")
}

#En seguida cargamos la base de datos

meduc30 <- tbl_df(read.csv("./data/meduc30.csv", header = TRUE, nrows = 23000))

#Dividimos la base aleatoriamente
#samp_EDC <- sample(data_EDC)
#data1_EDC <- samp_EDC[1:(nrow(samp_EDC)/2),]
#sdata2_EDC <- samp_EDC[(nrow(samp_EDC)/2):nrow(samp_EDC),]

for(i in 12:41) {
        meduc30[i] <- as.integer(meduc30[[i]])
}

set.seed(3)
sample.meduc <- sample_n(meduc30, 600)

#Definimos de momento las variables de inter?s para el An?lisis factorial 
#exploratorio

vars <- select(meduc30, x1:x29)
sample.vars <- select(sample.meduc, x1:x29)



#KMO y Test de Esfericidad de Bartlett
poly.meduc <- polychoric(vars)
KMO(poly.meduc$rho)
cortest.bartlett(poly.meduc$rho, n = 22166)
# KMO = .97 [.95-.99]; Bartlett: chisq = 465476.3, df = 435, p < .001
# #KMO y Test de Esfericidad de Bartlett
poly.sample <- polychoric(sample.vars)
KMO(poly.sample$rho)
cortest.bartlett(poly.sample$rho, n = 22166)

#Ejecutamos un an?lisis paralelo

para1_EDC <- fa.parallel(vars, cor = 'poly', fm = 'uls', fa = 'fa', 
                         quant = .99)
# El resultado nos ofrece 8 factores posibles con un primer eigenvalue 
# proporcionalmente
# mucho mayor. Reise (2012) sostiene esto como un indicio de estructura 
# bifactorial; y 
# en tanto lo que se mide es la calidad de la educaci?n como unidad, 
# pareciera ser una
# estructura viable. Exploramos a continuaci?n
omega1_EDC7 <- omega(vars_EDC, nfactors = 7, fm = 'minres', poly = TRUE)
omega1_EDC6 <- omega(vars, nfactors = 6, fm = 'minres', poly = TRUE)
omega1_EDC5 <- omega(vars_EDC, nfactors = 5, fm = 'minres', poly = TRUE)
omega1_EDC4 <- omega(vars, nfactors = 4, fm = 'minres', poly = TRUE)
omega1_EDC3 <- omega(vars_EDC, nfactors = 3, fm = 'minres', poly = TRUE)
omega1_EDC2 <- omega(vars_EDC, nfactors = 2, fm = 'minres', poly = TRUE)
omega1_EDC1 <- omega(vars_EDC, nfactors = 1, fm = 'minres', poly = TRUE)

write.csv(omega1_EDC7$schmid$sl[, 1:(ncol(omega1_EDC7$schmid$sl)-2)])
write.csv(omega1_EDC6$schmid$sl[, 1:(ncol(omega1_EDC6$schmid$sl)-2)])
write.csv(omega1_EDC5$schmid$sl[, 1:(ncol(omega1_EDC5$schmid$sl)-2)])
write.csv(omega1_EDC4$schmid$sl[, 1:(ncol(omega1_EDC4$schmid$sl)-2)])
write.csv(omega1_EDC3$schmid$sl[, 1:(ncol(omega1_EDC3$schmid$sl)-2)])
write.csv(omega1_EDC2$schmid$sl[, 1:(ncol(omega1_EDC2$schmid$sl)-2)])
write.csv(omega1_EDC1$schmid$sl[, 1:(ncol(omega1_EDC1$schmid$sl)-2)])


##########################
#FACTORES CORRELACIONADOS#
##########################

fa1_EDC8 <- fa(vars_EDC, cor = 'poly', nfactors = 8, fm = 'uls')
fa1_EDC7 <- fa(vars_EDC, cor = 'poly', nfactors = 7, fm = 'uls')
fa1_EDC6 <- fa(vars_EDC, cor = 'poly', nfactors = 6, fm = 'uls')
fa1_EDC5 <- fa(vars_EDC, cor = 'poly', nfactors = 5, fm = 'uls')
fa1_EDC4 <- fa(vars_EDC, cor = 'poly', nfactors = 4, fm = 'uls')
fa1_EDC3 <- fa(vars_EDC, cor = 'poly', nfactors = 3, fm = 'uls')
fa1_EDC2 <- fa(vars_EDC, cor = 'poly', nfactors = 2, fm = 'uls')
fa1_EDC1 <- fa(vars_EDC, cor = 'poly', nfactors = 1, fm = 'uls')

#Imprimimos tabla de cargas factoriales y comunalidades
write.csv(cbind(fa1_EDC8$loadings, fa1_EDC8$communality))
write.csv(cbind(fa1_EDC7$loadings, fa1_EDC7$communality))
write.csv(cbind(fa1_EDC6$loadings, fa1_EDC6$communality))
write.csv(cbind(fa1_EDC5$loadings, fa1_EDC5$communality))
write.csv(cbind(fa1_EDC4$loadings, fa1_EDC4$communality))
write.csv(cbind(fa1_EDC3$loadings, fa1_EDC3$communality))
write.csv(cbind(fa1_EDC2$loadings, fa1_EDC2$communality))
write.csv(cbind(fa1_EDC1$loadings, fa1_EDC1$communality))

#Imprimimos varianza explicada
Vaccounted8 <- print(fa1_EDC8)
expvar_EDC8 <- Vaccounted8$Vaccounted[3, length(Vaccounted8$Vaccounted[3, ])]
Vaccounted7 <- print(fa1_EDC7)
expvar_EDC7 <- Vaccounted7$Vaccounted[3, length(Vaccounted7$Vaccounted[3, ])]
Vaccounted6 <- print(fa1_EDC6)
expvar_EDC6 <- Vaccounted6$Vaccounted[3, length(Vaccounted6$Vaccounted[3, ])]
Vaccounted5 <- print(fa1_EDC5)
expvar_EDC5 <- Vaccounted5$Vaccounted[3, length(Vaccounted5$Vaccounted[3, ])]
Vaccounted4 <- print(fa1_EDC4)
expvar_EDC4 <- Vaccounted4$Vaccounted[3, length(Vaccounted4$Vaccounted[3, ])]
Vaccounted3 <- print(fa1_EDC3)
expvar_EDC3 <- Vaccounted3$Vaccounted[3, length(Vaccounted3$Vaccounted[3, ])]
Vaccounted2 <- print(fa1_EDC2)
expvar_EDC2 <- Vaccounted2$Vaccounted[3, length(Vaccounted2$Vaccounted[3, ])]
Vaccounted1 <- print(fa1_EDC1)
expvar_EDC1 <- Vaccounted1$Vaccounted[2, length(Vaccounted1$Vaccounted[2, ])]

expvar_EDC8
expvar_EDC7
expvar_EDC6
expvar_EDC5
expvar_EDC4
expvar_EDC3
expvar_EDC2
expvar_EDC1
# En base a la baja comunalidad de los ?tems 1, 5 y 22 los omitiremos de 
# los an?lisis,
# y volveremos a ejecutar el exploratorio

vars2_EDC <- subset(vars_EDC, select = c(-X1, -X5, -X22))
para2_EDC <- fa.parallel(vars2_EDC, cor = 'poly', fm = 'uls', fa = 'fa', 
                         quant = .99)
omega2_EDC <- omega(vars2_EDC, nfactors = 7, fm = 'minres', poly = TRUE)
fa2_EDC <- fa(vars2_EDC, cor = 'poly', nfactors = 7, fm = 'uls')

# primeras impresiones:
# - Notoria estructura bifactorial
# - Cargas cruzadas: X10, X24, X27, ev.global. En tanto esto no se puede 
# sostener en estructura
# bifactorial es necesario tomar una decisi?n.
# - Bajas cargas (< .30): X8, X17, X18, X21
# Omega_g = .90, Omega_s= .09:.47
vars3_EDC <- subset(vars2_EDC, select = c(-X10, -X24, -X27))
para3_EDC <- fa.parallel(vars3_EDC, cor = 'poly', fm = 'uls', fa = 'fa', 
                         quant = .99)
omega3_EDC <- omega(vars3_EDC, nfactors = 6, fm = 'minres', poly = TRUE)

# - Bajas cargas (< .30): X8, X17, X18* X19*, ev.global
# Omega_g = .91, Omega_s= .09:.46
vars4_EDC <- subset(vars3_EDC, select = c(-X18, -X19))
para4_EDC <- fa.parallel(vars4_EDC, cor = 'poly', fm = 'uls', fa = 'fa', 
                         quant = .99)
omega4_EDC <- omega(vars4_EDC, nfactors = 6, fm = 'minres', poly = TRUE)

# - Bajas cargas (< .30): X8, X17, ev.global
# Omega_g = .91, Omega_s= .11:.46
vars5_EDC <- subset(vars4_EDC, select = c(-X8, -X17, -ev.global))
para5_EDC <- fa.parallel(vars5_EDC, cor = 'poly', fm = 'uls', fa = 'fa', 
                         quant = .99)
omega5_EDC <- omega(vars5_EDC, nfactors = 5, fm = 'minres', poly = TRUE)

# - Bajas cargas (< .30): X20, X21
# Omega_g = .89, Omega_s= .11:.45
vars6_EDC <- subset(vars5_EDC, select = c(-X20, -X21))
para6_EDC <- fa.parallel(vars6_EDC, cor = 'poly', fm = 'uls', fa = 'fa', 
                         quant = .99)
omega6_EDC <- omega(vars6_EDC, nfactors = 5, fm = 'minres', poly = TRUE)

# - Bajas cargas (< .30): X16
# Omega_g = .89, Omega_s= .11:.45
vars7_EDC <- subset(vars6_EDC, select = c(-X16))
para7_EDC <- fa.parallel(vars7_EDC, cor = 'poly', fm = 'uls', fa = 'fa', 
                         quant = .99)
omega7_EDC <- omega(vars7_EDC, nfactors = 5, fm = 'minres', poly = TRUE)
#KMO y Test de Esfericidad de Bartlett
poly7_EDC <- polychoric(vars7_EDC)
KMO(poly7_EDC$rho)
cortest.bartlett(poly7_EDC$rho, n = 14161)
# KMO = .94 [.91-.97]; Bartlett: chisq = 227982.1, df = 120, p < .001

# - Bajas cargas (< .30): X16
# Omega_g = .89, Omega_s= .11:.45
vars8_EDC <- subset(vars_EDC, select = c(-X1, -X5, -X10, -X16, -X17, -X18,
                                         -X19, -X20, -X21, -X22, -X24, -X27))
para8_EDC <- fa.parallel(vars8_EDC, cor = 'poly', fm = 'uls', fa = 'fa',
                         quant = .99)
omega8_EDC <- omega(vars8_EDC, nfactors = 5, fm = 'minres', poly = TRUE)
fa8_EDC <- fa(vars8_EDC, nfactors = 6, fm = 'minres', cor = 'poly')
#KMO y Test de Esfericidad de Bartlett
poly8_EDC <- polychoric(vars8_EDC)
KMO(poly8_EDC$rho)
cortest.bartlett(poly8_EDC$rho, n = 14161)
# KMO = .94 [.91-.97]; Bartlett: chisq = 227982.1, df = 120, p < .001
