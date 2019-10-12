#quick introspection 
wc -l 
head -1
head -3


#check for cardinality of columns (uniqueness of column values)
#associative arrays, arrays build from streaming data 
# for e.g. types of particulate matters in air 
awk -F, '{ a[$7] } END { for (i in a) print i}' airquality.csv >> list_of_pollutants.txt
# for e.g. observation for which countries are available 
awk -F, '{ a[$2] } END { for (i in a) print i}' airquality.csv >> list_of_countries.txt
#cities covered for a given country
awk -F, '$2== "US" { a[$1] } END { for (i in a) print i}' airquality.csv >> list_of_cities.txt


#Top 20 readings for a particular parameter 
time awk -F, '$7 == "co" { print $1,$2,$5,$7,$8}' OFS=, airquality.csv | sort -t ',' -k5 -n -r | head -20 >> top20_co_reading.txt


#running calculations 
#average value for a parameter for a country for a given month 
#awk filters, more granular analysis 
time awk -F, '$2 == "US" && $5 ~ "2018-01" && $7 == "co"{ $5=substr($5,1,10); print $2,$5,$7,$8}' OFS=, airquality.csv | awk -F, '{ total = total + $4;} END { print total/NR;}'


#How does that vary across each month
#use of associative array 
#calculate the average value of a parameter for each month for a given country 
#e.g.
#US,2018-01,co,0.44
#US,2018-02,co,0.42
awk -F, '$2 == "US" && $5 ~ "2018" && $7 == "co"{ $5=substr($5,1,7); print $2,$5,$7,$8}' OFS=, airquality.csv | awk -F, '{a[$2] += $4} END {for (i in a)print i,a[i]/NR}' 



#Avg value for each month per parameter 
#similar to SQL nested subqueries (Loop within a loop)
#US,2018-01,co,0.44
#US,2018-01,so2,0.34
# awk -F, '$2 == "US" && $5 ~ "2018"{ $5=substr($5,1,7); print $2,$5,$7,$8}' OFS=, airquality.csv | awk -F, '{b[$5]} {a[$3] += $4} END {for (i in b)print i,b[i],a/NR}' 



#sources to read more on subject 
#Data Analysis from Command Line - https://www.datascienceatthecommandline.com/
