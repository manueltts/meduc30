

# A continuación se verifica las bases de datos originales están
# disponibles en "./data"
# 
# En caso contrario, las descarga en esa localización, creando el directorio
# si es necesario.
# 
# Se puede especificar otra ubicación y nombre de los archivos en las lineas
# que siguen. El script verificará y descargará según corresponda en la misma
# ubicación y con el mismo nombre de archivo definidos aquí.

setwd("meduc30")

file1 <- "./data/Base maestra 2004-2011.csv"
file2 <- "./data/Base 2012.csv"
file3 <- "./data/Base 2013.csv"
file4 <- "./data/Base 2014.csv"


#Carga los archivos .xls y .xlsx como 'data frames'
library(XLConnect)
library(dplyr)
meduc_2004.2011 <- tbl_df(read.csv(file1))
meduc_2012 <- tbl_df(read.csv(file2))
meduc_2013 <- tbl_df(read.csv(file3))
meduc_2014 <- tbl_df(read.csv(file4))

meduc_2004.2011a <- meduc_2004.2011 %>%
        rename(nombres = Nombres, paterno = Paterno, materno = Materno,
               nombre.completo = NombreCompleto,
               contacto.sem.al = contacto..sem.al., departamento = DEPARTAMENTO,
               evaluacion = evaluación, comprension = comprensión,
               promocion.autoaprendizaje = promocion.del.autoaprendizaje,
               control.sesion = control.sesión)

meduc_2012a <- meduc_2012 %>%
        rename(nombres = Nombres, paterno = Paterno, materno = Materno,
               nombre.completo = NombreCompleto, fecha = Fecha,
               contacto.sem.al = contacto..sem.al.,
               departamento = Departamento, pacientes = X.1, objetivos = X.2,
               evaluacion = X.3, comprension = X.4,
               promocion.autoaprendizaje = X.5, control.sesion = X.6,
               feedback = X.7, clima.aprendizaje = X.8)


meduc_2013a <- meduc_2013 %>%
        rename(nombres = Nombres, paterno = Paterno, materno = Materno,
               nombre.completo = NombreCompleto, fecha = Fecha,
               departamento = DEPARTAMENTO, evaluacion = evaluación,
               comprension = comprensión,
               promocion.autoaprendizaje = promocion.del.autoaprendizaje,
               control.sesion = control.sesión)


meduc_2014a <- meduc_2014


meduc_names <- rbind(colnames(meduc_2004.2011), colnames(meduc_2012),
                     colnames(meduc_2013), colnames(meduc_2014))


meduc_2004.2012 <- tbl_df(rbind(meduc_2004.2011, meduc_2012))
meduc_2013.2014 <- tbl_df(rbind(meduc_2013, meduc_2014))
