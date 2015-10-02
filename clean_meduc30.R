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

#setwd("meduc30")

meduc_raw <- tbl_df(read.csv("./data/meduc30_raw.csv"))

#Limpiar variable RUT, y establecerla como factor

meduc_raw1 <- meduc30_raw %>%
        mutate(RUT = gsub("-[0-9]","", meduc_raw$RUT)) %>%
        mutate(RUT = as.factor(gsub("[a-zA-z ,.]","", RUT)))

# Limpiar y homogeneizar nombres y apellidos; ignorar nombre completo pues
# puede ser compuesto (o viceversa).

# recodificar sexo como Hombre/Mujer

# Renombrar curso como 'sigla', para crear variable id de curso.

# Renombrar X1-X29 con minusculas, y factores sin "."

# Hacer de todas las categóricas un factor (incluidos X1 a factores)

