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


#Ejecución
##########
# Se asigna el directorio de trabajo, y la ubicación de los archivos originales
# en formato .csv dentro de este directorio.

#setwd("meduc30")

file1 <- "./data/Base maestra 2004-2011.csv"
file2 <- "./data/Base 2012.csv"
file3 <- "./data/Base 2013.csv"
file4 <- "./data/Base 2014.csv"

# Carga los archivos .csv como data frame tables, con el paquete dplyr

library(dplyr)
meduc_2004.2011 <- tbl_df(read.csv(file1))
meduc_2012 <- tbl_df(read.csv(file2))
meduc_2013 <- tbl_df(read.csv(file3))
meduc_2014 <- tbl_df(read.csv(file4))

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
               departamento = Departamento, pacientes = X.1, objetivos = X.2,
               evaluacion = X.3, comprension = X.4,
               promocion.autoaprendizaje = X.5, control.sesion = X.6,
               feedback = X.7, clima.aprendizaje = X.8) %>%
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
               departamento = DEPARTAMENTO, evaluacion = evaluaci.n,
               comprension = comprensi.n,
               promocion.autoaprendizaje = promocion.del.autoaprendizaje,
               control.sesion = control.sesi.n) %>%
        mutate(id = (n_2004.2013 + 1):(n_2004.2014))

# Se combinan las 4 bases de datos en una base única 2004 - 2014, se utilizan 2
# métodos con resultados idénticos registrados en data frame tables diferentes.

meduc30a <- meduc_2004.2011a %>%
        full_join(meduc_2012a) %>%
        full_join(meduc_2013a) %>%
        full_join(meduc_2014a)

meduc30b <- bind_rows(meduc_2004.2011a, meduc_2012a, meduc_2013a, meduc_2014a)

#Selecciona únicamente las variables con información (elimina "X.1", "X.2", etc)

meduc30c <- select(meduc30a, id, nombres:contacto.sem.al, departamento, 
                   division, X1:clima.aprendizaje)

# Exporta los datos como csv

write.csv(meduc30c, "./data/meduc30_raw.csv", row.names = FALSE)
