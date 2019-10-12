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


#Top 10 US Stations With Highest Levels of CO
time awk -F, ' $2 == "US" && $7 == "co"{ print $0}' OFS=, airquality.csv | parallel --pipe --block 10M sort -k8 -n -r | head -10


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
awk -F, '$2 == "US" && $5 ~ "2018" && $7 == "co"{ $5=substr($5,1,7); print $2,$5,$7,$8}' OFS=, airquality.csv | awk -F, '{a[$2] += $4} END {for (i in a)print i,a[i]/NR}' | sort -k2 -r -n


#sources to read more on subject 
#Data Analysis from Command Line - https://www.datascienceatthecommandline.com/
