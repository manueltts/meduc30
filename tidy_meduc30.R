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
#       'meduc30_cursos.csv'
#       'tutor_id.csv'
#       'curso_id.csv'

meduc30e <- meduc30d
meduc30e$tutor <- group_indices(meduc30d, RUT)

# Separa datos del tutor en identificadores por un lado, y sexo por otro.

# Separar datos de los cursos

# Consolidar puntuaciones sin puntajes por factor: id, tutor, curso y respuestas.