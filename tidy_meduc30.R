# Este es el tercer script de la serie para preparar los datos de medu30
# 2004-2014. Este último script toma como input la base de datos producida en
# el segundo 'clean_meduc30.R'.
# 
# El propósito de este script es lograr una configuración de bases de datos que
# cumpla con lo que se ha denominado 'Tidy data' (Wickham, 2014). Esta se define
# del siguiente modo:
#       - es la meta final del proceso de preparación de datos
#       - cada variable debiera estar en una columna
#       - cada observación de esa variable debiera estar en una fila diferente
#       - debiera haber una tabla diferente para cada tipo de variable
#               - si hay multiples tablas, debiera haber una columna para
#               vincularlas
#       - se debiera incluir una fila al comienzo de cada archivo con los
#       nombres de las variables; estos debieran hacer sentido
#       - en general, los datos debieran guardarse en un archivo por tabla
#       
# El resultado del script es guardado en:
#       'meduc30.csv'
#       'meduc30_tutores.csv'

library(dplyr)

if(!file.exists("./data/meduc30_clean.csv")) {
        setwd("meduc30")
}
meduc30 <- tbl_df(read.csv("./data/meduc30_clean.csv"))

# Creación de idtutor para cada observación, en base al rut
meduc30a <- meduc30
meduc30a$idtutor <- group_indices(meduc30a, rut)

# Creación de tabla de datos de tutores

meduc30_tutores <- select(meduc30a, idtutor, nombres, paterno, materno, sexo,
                          rut, dv) %>%
        filter(!duplicated(idtutor)) %>%
        arrange(paterno)

# Eliminación de variables de docente, excepto idtutor y sexo, de la tabla
# principal

meduc30b <- select(meduc30a, id, idtutor, sexo, curso:evglobal)

# Exportar las tablas
write.csv(meduc30_tutores, "./data/meduc30_tutores.csv", row.names = FALSE)
write.csv(meduc30b, "./data/meduc30.csv", row.names = FALSE)
