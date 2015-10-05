# Este es el segundo script de una serie para preparar los datos de
# meduc30 2004 - 2011. Este script utiliza como entrada la base de datos
# producida en el script anterior 'raw_meduc30.R'
# 
# En este script se procede a 'limpiar' los registros de cada variable, buscando
# por casos de valores extraños de cualquier tipo, y arreglándolos o fijando NAs
# según corresponda. Además, se fijan nombres de variables nuevos según
# corresponda.
# 
# Se siguen las siguientes reglas:
#       - Los nombres de las variables debieran:
#               - estar todos en minúsculas en cuanto sea posible
#               - ser descriptivos (i.e. legibles)
#               - únicos
#               - sin contener guiones bajos, puntos ni espacios
#       - Las variables con valores 'de texto' debieran:
#               - estar configuradas como variables 'factor'
#               - ser descriptivas
#               - usar TRUE/FALSE (VERDADERO/FALSO) en lugar de 1/0
#               - Usar Male/Female (Hombre/Mujer) en lugar de 1/0 o H/M
#       
#       *Estas reglas están adoptadas de los consejos sintetizados por Jeff
#       Leek, Investigador de la Bloomberg School of Public Health en John
#       Hopkins Univertisy; co-editor del blog simplystatistics.com; y
#       profesor de la Data Science Specialization de John Hopkins University en
#       Coursera.

#Cargar la base de datos producto del script previo 'meduc30_raw.csv'

library(dplyr)
library(tidyr)
options(java.parameters = "-Xmx4096m")  # esto asigna mayor memoria de trabajo
#                                       a los procesos de java (que usa el 
#                                       paquete XLConnect para archivos excel.
#                                       Si 2048m es inadecuado para tu
#                                       computadora, asigna más o menos memoria
#                                       según convenga.
library(xlsx)

if(!file.exists("./data/meduc30_raw.csv")) {
        setwd("meduc30")
}

meduc_30 <- tbl_df(read.csv("./data/meduc30_raw.csv"))

# Eliminación de valores de variables X1 a ev.global mayores a 4; y
# de valores 99 en contacto.sem.al
for(i in 17:46) {
        meduc_30[i][meduc_30[i] > 4] <- NA
}

meduc_30$contacto.sem.al[meduc_30$contacto.sem.al > 35] <- NA
meduc_30$fecha[meduc_30$fecha > 2014] <- NA

#Conversion a factor de variables de respuesta:

for(i in 17:46) {
        meduc_30[i] <- as.ordered(meduc_30[[i]])
        levels(meduc_30[[i]]) <- c("1.Casi nunca", "2.A veces", "3.Con frecuencia", 
                                   "4.Casi siempre")
}

# Conversion a 'factor' de 'id', 'RUT'

meduc_30[meduc_30$paterno == "Aizman", "RUT"] <- 
        meduc_30[meduc_30$paterno == "Aizman", "RUT"][1, ]
meduc_30[meduc_30$paterno == "Aizman", "DV"] <- "8"

#meduc_30$rut <- replace(meduc_30$rut, (meduc_30$paterno == "Aizman"), 8532363)
#meduc_30$dv <- replace(meduc_30$dv, (meduc_30$paterno == "Aizman"), 8)

meduc_30 <- mutate(meduc_30, id = as.factor(id), RUT = as.factor(RUT))

# Reetiquetar sexo como 'Hombre' y 'Mujer' en lugar de H y M

levels(meduc_30$sexo) <- c("Hombre", "Mujer")

# Renombrar las variables: breves, descriptivas, minusculas, sin signos de
# puntuacion

meduc_30 <- rename(meduc_30, nombre = nombre.completo, rut = RUT, dv = DV, 
                   especialidad = especialidad.curso, campo = campo.clinico.,
                   semanas = contacto.sem.al, evglobal = ev.global,
                   promocion = promocion.autoaprendizaje,
                   control = control.sesion, clima = clima.aprendizaje,
                   x1 = X1, x2 = X2, x3 = X3, x4 = X4, x5 = X5, x6 = X6,
                   x7 = X7, x8 = X8, x9 = X9, x10 = X10, x11 = X11, x12 = X12,
                   x13 = X13, x14 = X14, x15 = X15, x16 = X16, x17 = X17,
                   x18 = X18, x19 = X19, x20 = X20, x21 = X21, x22 = X22,
                   x23 = X23, x24 = X24, x25 = X25, x26 = X26, x27 = X27,
                   x28 = X28, x29 = X29)

# Eliminación de las variables 'calculadas'; promedio de las variables
# observadas agrupadas según factores teóricos.

meduc_30 <- select(meduc_30, -c(pacientes, objetivos, evaluacion, comprension,
                                promocion, control, feedback, clima))

write.csv(meduc_30, "./data/meduc30_clean.csv", row.names = FALSE)


meduc_30df <- as.data.frame(meduc_30)
for(i in 17:46) {
        meduc_30df[i] <- as.integer(meduc_30[[i]])
}
write.xlsx2(meduc_30df, "./data/meduc30_clean.xlsx", row.names = FALSE)
