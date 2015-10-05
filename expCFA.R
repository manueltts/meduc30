# A continuación se registran los procedimientos exploratorios sobre la base 
# de datos
# de la Encuesta de Evaluaci?n de la Docencia Clinica por Estudiantes, a?os 
# 2004 a 2011.
#En primer lugar establecemos directorio de trabajo.

library(dplyr)
library(psych)
library(lavaan)
library(semTools)
library(semPlot)
library(MVN)


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

vars <- select(meduc30, x1:x29)
sample.vars <- select(sample.meduc, x1:x29)

## ######################### ##
## VERIFICACION DE SUPUESTOS ##
## ######################### ##

## KMO y Test de Esfericidad de Bartlett
poly.meduc <- polychoric(vars)
KMO(poly.meduc$rho)
cortest.bartlett(poly.meduc$rho, n = 22166)
## KMO = .97 [.95-.99]; Bartlett: chisq = 465476.3, df = 435, p < .001

## Muestra: KMO y Test de Esfericidad de Bartlett
poly.sample <- polychoric(sample.vars)
KMO(poly.sample$rho)
cortest.bartlett(poly.sample$rho, n = 600)
### KMO = .93 [.87-.97]; Bartlett = chisq = 22625.48, df = 406, p < .001

mardiaTest(vars, qqplot = T)

## ################ ##
## MODELOS BIFACTOR ##
## ################ ##

bifac.meduc6 <- ' # latent variable definitions
EVFB    =~  NA * x9 + x11 + x12 + x23 + x25
DCP     =~  NA * x1 + x2 + x3 + x4 + x5
CA      =~  NA * x10 + x24 + x26 + x27 + x28 + x29
PCPA    =~  NA * x13 + x14 + x15 + x16 + x17 + x18 + x19
O       =~  NA * x6 + x7 + x8
CS      =~  NA * x20 + x21 + x22
g       =~  NA * x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10 + x11 + x12 + 
x13 + x14 + x15 + x16 + x17 + x18 + x19 + x20 + x21 + x22 + x23 + x24 + 
x25 + x26 + x27 + x28 + x29
EVFB    ~~  1 * EVFB
DCP     ~~  1 * DCP
CA      ~~  1 * CA
PCPA    ~~  1 * PCPA
O       ~~  1 * O
CS      ~~  1 * CS
g       ~~  1 * g
'
fit.bifac6 <- cfa(bifac.meduc6, data = meduc30, estimator = "ULSMVS", 
                  orthogonal = TRUE, ordered = c("x1", "x2", "x3", "x4", "x5", "x6", 
                                                 "x7", "x8", "x9", "x10", "x11", "x12", 
                                                 "x13", 'x14', 'x15', 'x16', 'x17', 
                                                 'x18', 'x19', 'x20', 'x21', 'x22', 
                                                 'x23', 'x24', 'x25', 'x26', 'x27', 
                                                 'x28', 'x29'))
good.bifac6 <- {
        round(fitMeasures(fit.bifac6)[c('chisq.scaled', 'df.scaled', 
                                        'pvalue.scaled', 'cfi.scaled',
                                        'tli.scaled', 'rfi.scaled',
                                        'rmsea.scaled', 'rmsea.ci.lower.scaled', 
                                        'rmsea.ci.upper.scaled')], 3)
}
good.bifac6
summary(fit.bifac6, fit.measures = TRUE)
write.csv(round(reliability(fit.bifac6), 2))
write.csv(round(inspect(fit.bifac6, what = "std")$lambda, 2))
modin.bifac6 <- modindices(fit.bifac6)
head(modin.bifac6[order(modin.bifac6$mi.scaled, decreasing = TRUE), ], 14)
#
bifac.meduc4 <- ' # latent variable definitions
EVFB    =~  NA * x9 + x11 + x12 + x23 + x25
DCP     =~  NA * x1 + x2 + x3 + x4 + x5
CA      =~  NA * x10 + x24 + x26 + x27 + x28 + x29
OPCPACS =~  NA * x6 + x7 + x8 + x13 + x14 + x15 + x16 + x17 + x18 + x19 + x20 + 
x21 + x22
g       =~  NA * x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10 + x11 + x12 + 
x13 + x14 + x15 + x16 + x17 + x18 + x19 + x20 + x21 + x22 + x23 + 
x24 + x25 + x26 + x27 + x28 + x29
EVFB    ~~  1 * EVFB
DCP     ~~  1 * DCP
CA      ~~  1 * CA
OPCPACS ~~  1 * OPCPACS
g       ~~  1 * g
'
fit.bifac4 <- cfa(bifac.meduc4, data = meduc30, estimator = "ULSMVS", 
                  orthogonal = TRUE, ordered = c("x1", "x2", "x3", "x4", "x5", "x6", 
                                                 "x7", "x8", "x9", "x10", "x11", "x12", 
                                                 "x13", 'x14', 'x15', 'x16', 'x17', 
                                                 'x18', 'x19', 'x20', 'x21', 'x22', 
                                                 'x23', 'x24', 'x25', 'x26', 'x27', 
                                                 'x28', 'x29'))
good.bifac4 <- {
        round(fitMeasures(fit.bifac4)[c('chisq.scaled', 'df.scaled', 
                                        'pvalue.scaled', 'cfi.scaled',
                                        'tli.scaled', 'rfi.scaled',
                                        'rmsea.scaled', 'rmsea.ci.lower.scaled', 
                                        'rmsea.ci.upper.scaled')], 3)
}
good.bifac4
summary(fit.bifac4, fit.measures = TRUE)
write.csv(round(reliability(fit.bifac4), 2))
write.csv(round(inspect(fit.bifac4, what = "std")$lambda, 2))
modin.bifac4 <- modindices(fit.bifac4)
head(modin.bifac4[order(modin.bifac4$mi.scaled, decreasing = TRUE), ], 14)

## ################################### ##
## MODELOS DE FACTORES CORRELACIONADOS ##
## ################################### ##
## 
cor.meduc6 <- ' # latent variable definitions
EVFB    =~  NA * x9 + x11 + x12 + x23 + x25
DCP     =~  NA * x1 + x2 + x3 + x4 + x5
CA      =~  NA * x10 + x24 + x26 + x27 + x28 + x29
PCPA    =~  NA * x13 + x14 + x15 + x16 + x17 + x18 + x19
O       =~  NA * x6 + x7 + x8
CS      =~  NA * x20 + x21 + x22
EVFB    ~~  1 * EVFB
DCP     ~~  1 * DCP
CA      ~~  1 * CA
PCPA    ~~  1 * PCPA
O       ~~  1 * O
CS      ~~  1 * CS
'
fit.cor6 <- cfa(cor.meduc6, data = meduc30, estimator = "ULSMVS", 
                orthogonal = FALSE, ordered = c("x1", "x2", "x3", "x4", "x5", "x6", 
                                                "x7", "x8", "x9", "x10", "x11", "x12", 
                                                "x13", 'x14', 'x15', 'x16', 'x17', 
                                                'x18', 'x19', 'x20', 'x21', 'x22', 
                                                'x23', 'x24', 'x25', 'x26', 'x27', 
                                                'x28', 'x29'))
good.cor6 <- {
        round(fitMeasures(fit.cor6)[c('chisq.scaled', 'df.scaled', 
                                      'pvalue.scaled', 'cfi.scaled',
                                      'tli.scaled', 'rfi.scaled',
                                      'rmsea.scaled', 'rmsea.ci.lower.scaled', 
                                      'rmsea.ci.upper.scaled')], 3)
}
good.cor6
summary(fit.cor6, fit.measures = TRUE)
write.csv(round(reliability(fit.cor6), 2))
write.csv(round(inspect(fit.cor6, what = "std")$lambda, 2))
modin.cor6 <- modindices(fit.cor6)
head(modin.cor6[order(modin.cor6$mi.scaled, decreasing = TRUE), ], 14)

###
cor.meduc4 <- ' # latent variable definitions
EVFB    =~  NA * x9 + x11 + x12 + x23 + x25 + x27
DCP     =~  NA * x1 + x2 + x3 + x4 + x5
CA      =~  NA * x10 + x24 + x26 + x28 + x29
OPCPACS =~  NA * x6 + x7 + x8 + x13 + x14 + x15 + x16 + x17 + x18 + x19 + x20 + 
x21 + x22 + x27
EVFB    ~~  1 * EVFB
DCP     ~~  1 * DCP
CA      ~~  1 * CA
OPCPACS ~~  1 * OPCPACS
'
fit.cor4 <- cfa(cor.meduc4, data = meduc30, estimator = "ULSMVS", 
                orthogonal = FALSE, ordered = c("x1", "x2", "x3", "x4", "x5", "x6", 
                                                "x7", "x8", "x9", "x10", "x11", "x12", 
                                                "x13", 'x14', 'x15', 'x16', 'x17', 
                                                'x18', 'x19', 'x20', 'x21', 'x22', 
                                                'x23', 'x24', 'x25', 'x26', 'x27', 
                                                'x28', 'x29'))
good.cor4 <- {
        round(fitMeasures(fit.cor4)[c('chisq.scaled', 'df.scaled', 
                                      'pvalue.scaled', 'cfi.scaled',
                                      'tli.scaled', 'rfi.scaled',
                                      'rmsea.scaled', 'rmsea.ci.lower.scaled', 
                                      'rmsea.ci.upper.scaled')], 3)
}
good.cor4
summary(fit.cor4, fit.measures = TRUE)
write.csv(round(reliability(fit.cor4), 2))
write.csv(round(inspect(fit.cor4, what = "std")$lambda, 2))
modin.cor4 <- modindices(fit.cor4)
head(modin.cor4[order(modin.cor4$mi.scaled, decreasing = TRUE), ], 14)

## ################################ ##
## DIAGRAMAS DE MODELOS DE MEDICION ##
## ################################ ##

### Diagrama bifactor con 6 factores especificos
semPaths(fit.bifac6, rotation = 1, exoCov = F, optimizeLatRes = F, 
         intercepts = F, residuals = F, reorder = T,
         layout = "tree2", bifactor = "g", centerLevels = T, sizeMan = 2, 
         sizeMan2 = 2, nCharNodes = 0, sizeLat = 5, sizeLat2 = 5, plot = T)

### Diagrama bifactor con 4 factores especificos
semPaths(fit.bifac4, rotation = 1, exoCov = F, optimizeLatRes = F, 
         intercepts = F, residuals = F, reorder = T,
         layout = "tree2", bifactor = "g", centerLevels = T, sizeMan = 2, 
         sizeMan2 = 2, nCharNodes = 0, sizeLat = 5, sizeLat2 = 5, plot = T)

### Diagrama 6 factores correlacionados
semPaths(fit.cor6, rotation = 1, exoCov = F, optimizeLatRes = F, 
         intercepts = F, residuals = F, reorder = T,
         layout = "tree2", centerLevels = F, sizeMan = 2, 
         sizeMan2 = 2, nCharNodes = 0, sizeLat = 5, sizeLat2 = 5, plot = T)

### Diagrama 4 factores correlacionados
semPaths(fit.cor4, rotation = 1, exoCov = F, optimizeLatRes = F, 
         intercepts = F, residuals = F, reorder = T,
         layout = "tree2", centerLevels = F, sizeMan = 2, 
         sizeMan2 = 2, nCharNodes = 0, sizeLat = 5, sizeLat2 = 5, plot = T)





## 
## 
## 
## 
## 
## 
## 
## 
## 
## 
## 
#Modelo bifactor con todas las variables.

bifac1_EDC7 <- ' # latent variable definitions
PCPA =~ NA * X13 + X14 + X15 + X16 + X17 + X19
CA =~   NA * X10 + X24 + X26 + X27 + X28 + X29
DCP =~  NA * X1 + X2 + X3 + X4 + X5
FB =~   NA * X18  + X23 + X25
CS =~   NA * X20 + X21 + X22
O =~    NA * X6 + X7 + X8
EV =~   NA * X9 + X11 + X12
g =~    NA * X1+ X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9 + X10 + X11 + X12 + X13
+ X14 + X15 + X16 + X17 + X18 + X19 + X20 + X21 + X22 + X23 +
X24 + X25 + X26 + X27 + X28 + X29
FB ~~   1 * FB
DCP ~~  1 * DCP
CA ~~   1 * CA
PCPA ~~ 1 * PCPA
O ~~    1 * O
CS ~~   1 * CS
EV ~~   1 * EV
g ~~    1 * g
'
fit1_EDC7 <- cfa(
        bifac1_EDC7, data = data_EDC, estimator = "ULSMVS", orthogonal = TRUE, 
        ordered = c("X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9", "X10",
                    "X11", "X12", "X13", 'X14', 'X15', 'X16', 'X17', 'X18', 
                    'X19', 'X20', 'X21', 'X22', 'X23', 'X24', 'X25', 'X26',
                    'X27', 'X28', 'X29'))
std1_EDC7 <- {
        round(fitMeasures(fit1_EDC7)[c('chisq.scaled', 'df.scaled', 
                                       'pvalue.scaled', 'cfi.scaled',
                                       'tli.scaled', 'rfi.scaled',
                                       'rmsea.scaled', 'rmsea.ci.lower.scaled', 
                                       'rmsea.ci.upper.scaled')], 3)
}
std1_EDC7
summary(fit1_EDC, fit.measures = TRUE)
write.csv(round(reliability(fit1_EDC), 2))
write.csv(round(inspect(fit1_EDC, what = "std")$lambda, 2))
modin1_EDC <- modindices(fit1_EDC)
head(modin1_EDC[order(modin1_EDC$mi.scaled, decreasing = TRUE), ], 14)






#Modelo bifactor con variables de baja carga extra?das (pre-ordered)
library(semTools)
bifac2_EDC <- ' # latent variable definitions
EVFB =~ NA*X9 + X11 + X12 + X23 + X25
DCP =~ NA*X2 + X3 + X4
CA =~ NA*X26 + X28 + X29
PC =~ NA*X13 + X14 + X15
O =~ NA*X6 + X7 + X8
g =~ NA*X2 + X3 + X4 + X6 + X7 + X8 + X9 + X11 + X12 + X13 + X14 + 
X15 + X23 + X25 + X26 + X28 + X29
EVFB ~~ 1*EVFB
DCP ~~ 1*DCP
CA ~~ 1*CA
PC ~~ 1*PC
O ~~ 1*O
g ~~ 1*g
'
fit2_EDC <- cfa(bifac2_EDC, data = data_EDC, estimator = "ULSMVS", orthogonal = TRUE, 
                ordered = c("X2", "X3", "X6", "X7", "X8", "X9", "X11", "X12", "X13", 
                            'X14', 'X15', 'X23', 'X25', 'X26', 'X28', 'X29'))
std2_EDC <- {
        round(fitMeasures(fit2_EDC)[c('chisq.scaled', 'df.scaled', 
                                      'pvalue.scaled', 'cfi.scaled',
                                      'tli.scaled', 'rfi.scaled',
                                      'rmsea.scaled', 'rmsea.ci.lower.scaled', 
                                      'rmsea.ci.upper.scaled')], 3)
}
std2_EDC
summary(fit2_EDC, fit.measures = TRUE)
write.csv(round(reliability(fit2_EDC), 2))
write.csv(round(inspect(fit2_EDC, what = "std")$lambda, 2))
modin2_EDC <- modindices(fit2_EDC)
head(modin2_EDC[order(modin2_EDC$mi.scaled, decreasing = TRUE), ], 14)

#######################
#MODELO CORRELACIONADO#
#######################

fac1_EDC6 <- ' # latent variable definitions
DCP =~  NA * X1 + X2 + X3 + X4 + X5
PCPA =~ NA * X13 + X14 + X15 + X16 + X17 + X18 + X19
CA =~   NA * X10 + X24 + X26 + X27 + X28 + X29
O =~    NA * X6 + X7 + X8
EVFB =~ NA * X9 + X11 + X12 + X23 + X25
CS =~   NA * X20 + X21 + X22
DCP ~~  1 * DCP
O ~~    1 * O
EVFB ~~ 1 * EVFB
PCPA ~~ 1 * PCPA
CS ~~   1 * CS
CA ~~   1 * CA
'
fit1_EDC6 <- cfa(
        fac1_EDC6, data = data_EDC, estimator = "ULSMVS", 
        ordered = c("X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9", "X10",
                    "X11", "X12", "X13", 'X14', 'X15', 'X16', 'X17', 'X18',
                    'X19', 'X20', 'X21', 'X22', 'X23', 'X24', 'X25', 'X26', 
                    'X27', 'X28', 'X29'))
std1_EDC6 <- {
        round(fitMeasures(fit1_EDC6)[c('chisq.scaled', 'df.scaled', 
                                       'pvalue.scaled', 'cfi.scaled',
                                       'tli.scaled', 'rfi.scaled',
                                       'rmsea.scaled', 'rmsea.ci.lower.scaled', 
                                       'rmsea.ci.upper.scaled')], 3)
}
std1_EDC6
summary(fit1_EDC, fit.measures = TRUE)
write.csv(round(reliability(fit1_EDC), 2))
write.csv(round(inspect(fit1_EDC, what = "std")$lambda, 2))
modin1_EDC <- modindices(fit1_EDC)
head(modin1_EDC[order(modin1_EDC$mi.scaled, decreasing = TRUE), ], 14)




fa_EDC <- fa(vars_EDC, nfactors = 8, fm = 'minres', cor = 'poly')
library(lavaan)
fac1_EDC <- ' # latent variable definitions
DCP =~  NA * X1 + X2 + X3 + X4 + X5
PCPA =~ NA*X13 + X14 + X15 + X16 + X17 + X18 + X19
O =~    NA * X6 + X7 + X8
EVFB =~ NA*X9 + X10 + X11 + X12 + X23 + X24 + X25
CS =~ NA*X20 + X21 + X22
CA =~ NA*X10 + X24 + X26 + X28 + X29
DCP ~~ 1*DCP
O ~~ 1*O
EVFB ~~ 1*EVFB
PCPA ~~ 1*PCPA
CS ~~ 1*CS
CA ~~ 1*CA
'
fit1_EDC <- cfa(
        fac1_EDC, data = data_EDC, estimator = "ULSMVS", 
        ordered = c("X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8", "X9", "X10", 
                    "X11", "X12", "X13", 'X14', 'X15', 'X16', 'X17', 'X18', 
                    'X19', 'X20', 'X21', 'X22', 'X23', 'X24', 'X25', 'X26', 
                    'X27', 'X28', 'X29'))
std1_EDC <- {
  round(fitMeasures(fit1_EDC)[c('chisq.scaled', 'df.scaled', 
                                'pvalue.scaled', 'cfi.scaled',
                                'tli.scaled', 'rfi.scaled',
                                'rmsea.scaled', 'rmsea.ci.lower.scaled', 
                                'rmsea.ci.upper.scaled')], 3)
}
std1_EDC
summary(fit1_EDC, fit.measures = TRUE)
write.csv(round(reliability(fit1_EDC), 2))
write.csv(round(inspect(fit1_EDC, what = "std")$lambda, 2))
modin1_EDC <- modindices(fit1_EDC)
head(modin1_EDC[order(modin1_EDC$mi.scaled, decreasing = TRUE), ], 14)

#Incorporar puntajes de factor a la base de datos
data2_scores <- lavPredict(fit2_EDC)
ids_fit2 <- inspect(fit2_EDC, "case.idx")
data2_cfa <- data2_EDC[ids_fit2,]
data2_full <- cbind.data.frame(data2_cfa, data2_scores)
