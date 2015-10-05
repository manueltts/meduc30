# Este es el primer script de una serie para preparar los datos de meduc30 entre
# los años 2004 y 2014 para el análisis.
# 
# En particular este script realiza los siguientes procedimientos:
#       1. Carga las bases de datos desde los archivos .csv exportados de Excel.
#       2. Asigna un id único a cada observación
#       3. Renombra todas las variables homogéneamente entre las bases de datos.
#       4. Combina las bases de datos
#       5. Selecciona y reordena sólo las variables con datos para al menos una
#       base de datos de entrada.
#       6. Exporta la base de datos unificadas como 'meduc30_raw.csv'

options(java.parameters = "-Xmx2048m") #esto es para evitar saturación de
#                                       procesador.
library(XLConnect)
library(dplyr)
library(tidyr)

#Ejecución
##########
# Se asigna el directorio de trabajo, y la ubicación de los archivos originales
# en formato .csv dentro de este directorio.

file1 <- "./data/Base maestra 2004-2011.xls"
file2 <- "./data/Base 2012.xlsx"
file3 <- "./data/Base 2013.xlsx"
file4 <- "./data/Base 2014.xlsx"

if(!file.exists(file1)) {
        setwd("meduc30")
}

# Carga los archivos .xls y .xlsx con el paquete XLConnnect

wb1 <- loadWorkbook(file1)
setMissingValue(wb1, value = c(""))
meduc_2004.2011 <- readWorksheet(wb1, sheet= 1, header=TRUE)

wb2 <- loadWorkbook(file2)
setMissingValue(wb2, value = c(""))
meduc_2012 <- readWorksheet(wb2, sheet= 1, header=TRUE)

wb3 <- loadWorkbook(file3)
setMissingValue(wb3, value = c(""))
meduc_2013 <- readWorksheet(wb3, sheet= 1, header=TRUE)

wb4 <- loadWorkbook(file4)
setMissingValue(wb4, value = c(""))
meduc_2014 <- readWorksheet(wb4, sheet= 1, header=TRUE)

# Transforma los data frames en data frame tables, con el paquete dplyr

meduc_2004.2011 <- tbl_df(meduc_2004.2011)
meduc_2012 <- tbl_df(meduc_2012)
meduc_2013 <- tbl_df(meduc_2013)
meduc_2014 <- tbl_df(meduc_2014)

# Eliminación de filas correspondientes al cálculo del promedio por grupo para
# algunas variables. Se usa la variable 'sexo' como discriminadora

meduc_2004.2011 <- filter(meduc_2004.2001, !is.na(sexo))
meduc_2012 <- filter(meduc_2012, !is.na(sexo))
meduc_2013 <- filter(meduc_2013, !is.na(sexo))
meduc_2014 <- filter(meduc_2014, !is.na(sexo))

# Se crean variables de n muestral para cada año desde 2012, y para la muestra
# total hasta 2011, 2012, 2013 y 2014 respectivamente

n_2004.2011 <- length(meduc_2004.2011$X1)
n_2012      <- length(meduc_2012$X1)
n_2004.2012 <- n_2004.2011 + n_2012
n_2013      <- length(meduc_2013$X1)
n_2004.2013 <- n_2004.2012 + n_2013
n_2014      <- length(meduc_2014$X1)
n_2004.2014 <- n_2004.2013 + n_2014

# Usando el encadenamiento que permite dplyr, se renombran todas las variables
# de manera homogenea para cada base de datos. Se ha procurado
#       - Usar sólo minúsculas
#       - Usar sólo _ y . como símbolos separadores
#       - no usar tildes ni otros signos no ASCII
#       - simplificar si fuera necesario
#       
# Ademas se crea la variable 'id' única para cada observación a través de las
# cuatro bases de datos.

meduc_2004.2011a <- meduc_2004.2011 %>%
        rename(nombres = Nombres, paterno = Paterno, materno = Materno,
               nombre.completo = NombreCompleto,
               contacto.sem.al = contacto..sem.al., departamento = DEPARTAMENTO,
               evaluacion = evaluación, comprension = comprensión,
               promocion.autoaprendizaje = promocion.del.autoaprendizaje,
               control.sesion = control.sesión) %>%
        arrange(fecha, semestre, curso, RUT) %>%
        mutate(id = 1:n_2004.2011)

meduc_2012a <- meduc_2012 %>%
        rename(nombres = Nombres, paterno = Paterno, materno = Materno,
               nombre.completo = NombreCompleto, fecha = Fecha,
               contacto.sem.al = contacto..sem.al.,
               departamento = Departamento, pacientes = Col44, 
               objetivos = Col45,
               evaluacion = Col46, comprension = Col47,
               promocion.autoaprendizaje = Col48, control.sesion = Col49,
               feedback = Col50, clima.aprendizaje = Col51) %>%
        mutate(id = (n_2004.2011 + 1):(n_2004.2012))

meduc_2013a <- meduc_2013 %>%
        rename(nombres = Nombres, paterno = Paterno, materno = Materno,
               nombre.completo = NombreCompleto, fecha = Fecha,
               contacto.sem.al = contacto..sem.al.,
               departamento = DEPARTAMENTO, evaluacion = evaluación,
               comprension = comprensión,
               promocion.autoaprendizaje = promocion.del.autoaprendizaje,
               control.sesion = control.sesión) %>%
        mutate(id = (n_2004.2012 + 1):(n_2004.2013))

meduc_2014a <- meduc_2014 %>%
        rename(nombres = Nombres, paterno = Paterno, materno = Materno,
               nombre.completo = NombreCompleto, fecha = Fecha,
               contacto.sem.al = contacto..sem.al.,
               departamento = DEPARTAMENTO, evaluacion = evaluación,
               comprension = comprensión,
               promocion.autoaprendizaje = promocion.del.autoaprendizaje,
               control.sesion = control.sesión) %>%
        mutate(id = (n_2004.2013 + 1):(n_2004.2014))

# Se hacen algunos ajustes a ciertas variables para homogeneizar las clases, y
# así poder combinar los datos en una sola tabla 2004-2014.

meduc_2004.2011b <- meduc_2004.2011a
meduc_2004.2011b[, 13:42] = apply(meduc_2004.2011a[, 13:42], 2, 
                                  function(x) extract_numeric(x))

meduc_2012b <- meduc_2012a %>%
        mutate(RUT = gsub("-[0-9]","", meduc_2012$RUT)) %>%
        mutate(RUT = as.numeric(gsub("[a-zA-z ,.]","", RUT)),
               X1 = extract_numeric(X1), X13 = extract_numeric(X13))

meduc_2013b <- meduc_2013a %>%
        mutate(X13 = extract_numeric(X13))

meduc_2014b <- meduc_2014a %>%
        mutate(RUT = gsub("-[0-9]","", meduc_2014$RUT)) %>%
        mutate(RUT = as.numeric(gsub("[a-zA-z ,.]","", RUT)),
               ev.global = extract_numeric(ev.global))

# Calculo de los NA generados, para comprobar inocuidad de transformaciones
# 
a.NA <- sum(is.na(meduc_2004.2011a), is.na(meduc_2012a), is.na(meduc_2013a), 
            is.na(meduc_2014a))
b.NA <-  sum(is.na(meduc_2004.2011b), is.na(meduc_2012b), is.na(meduc_2013b),
              is.na(meduc_2014b))

#    deltaNA    / (  n   * vars)
# (b.NA - a.NA) / (22880 * 30  ) = 0.12%


# Se combinan las 4 bases de datos en una base única 2004 - 2014, se utilizan 2
# métodos con resultados idénticos registrados en data frame tables diferentes.

meduc30a <- meduc_2004.2011b %>%
        full_join(meduc_2012b) %>%
        full_join(meduc_2013b) %>%
        full_join(meduc_2014b)

meduc30b <- bind_rows(meduc_2004.2011b, meduc_2012b, meduc_2013b, meduc_2014b)

#Selecciona únicamente las variables con información (elimina "X.1", "X.2", etc)

meduc30_raw <- select(meduc30a, id, nombres:contacto.sem.al, departamento, 
                   division, X1:clima.aprendizaje)

# Exporta los datos como csv

write.csv(meduc30_raw, "./data/meduc30_raw.csv", row.names = FALSE)
#rm(wb1, wb2, wb3, wb4, meduc_2004.2011, meduc_2004.2011a, meduc_2004.2011b, meduc_2012, meduc_2012a,
#   meduc_2012b, meduc_2013, meduc_2013a, meduc_2013b, meduc_2014, meduc_2014a,
#   meduc_2014b, meduc30a, meduc30b)
