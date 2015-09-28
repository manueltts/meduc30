

# A continuación se verifica las bases de datos originales están
# disponibles en "./data"
# 
# En caso contrario, las descarga en esa localización, creando el directorio
# si es necesario.
# 
# Se puede especificar otra ubicación y nombre de los archivos en las lineas
# que siguen. El script verificará y descargará según corresponda en la misma
# ubicación y con el mismo nombre de archivo definidos aquí.

file1 <- "./data/meduc30_2004-2011.xls"
file2 <- "./data/meduc30_2012.xlsx"
file3 <- "./data/meduc30_2013.xlsx"
file4 <- "./data/meduc30_2014.xlsx"

if(!dir.exists("./data")) {
        dir.create("./data")
}

if(!file.exists(file1)) {
        message('Descargando datos meduc30 2004-2011')
        fileUrl1 <- "https://www.dropbox.com/s/b7zi428wgyg2rip/Base%20maestra%202004-2011.xls?dl=0"
        download.file(fileUrl1, file1, mode = "wb")
} else {
        message('Encontrados datos meduc30 2004-2011')
}

if(!file.exists(file2)) {
        message('Descargando datos meduc30 2012')
        fileUrl2 <- "https://www.dropbox.com/s/8zgzknslga9domg/Base%202012.xlsx?dl=0"
        download.file(fileUrl2, file2, mode = "wb")
} else {
        message('Encontrados datos meduc30 2012')
}

if(!file.exists(file3)) {
        message('Descargando datos meduc30 2013')
        fileUrl3 <- "https://www.dropbox.com/s/mt5elphy0fsxy0b/Base%202013.xlsx?dl=0"
        download.file(fileUrl3, file3, mode = "wb")
} else {
        message('Encontrados datos meduc30 2013')
}

if(!file.exists(file4)) {
        message('Descargando datos meduc30 2014')
        fileUrl4 <- "https://www.dropbox.com/s/fk9vqawxzv60ke2/Base%202014.xlsx?dl=0"
        download.file(fileUrl3, file4, mode = "wb")
} else {
        message('Encontrados datos meduc30 2014')
}

#Carga los archivos .xls y .xlsx como 'data frames'
library(XLConnect)}
meduc_2004.2011 <- readWorksheetFromFile(file1, sheet = 1)
