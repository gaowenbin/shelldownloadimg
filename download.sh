#!/bin/sh
#Discribe 解析html 分离数据并生成url，根据url下载图片
#Name  make.sh
#Author gaowenbinmarr@gmail.com
#Time 2012-6-19

HOSTNAME="192.168.16.232" 
PORT="3306"
USERNAME="marr"
PASSWORD="marr"
DBNAME="ImgData"
select_sql="CALL getimghtml(@out_id,@out_cityname,@out_hotecode,@out_htmlcode);select @out_id,@out_cityname,@out_hotecode,@out_htmlcode"

while true
do
mysql -h${HOSTNAME}  -P${PORT}  -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${select_sql}">>mysql.txt
#awk解析html数据，并写入tem文本

#获得酒店id
eval $(awk '{HID=$1;CITY=$2;CODE=$3; print "hotelid="HID;print "city="CITY;print "code="CODE;}' mysql.txt)

dire=hotelimg/$city/
codedire=hotelimg/$city/$code

if [ -d "$dire" ];
then
	echo "create $dire"
else
	mkdir "$dire"
fi

if [ $code == "NULL" ]
then
	echo "code is NULL"
else

   if [ -d "$codedire" ]; 
   then
	echo "create $codedire"
   else
       mkdir "$codedire"
   fi
fi

awk 'split($0,a,"</a></li>") {for (i in a) print a[i]}' mysql.txt | awk -F\" '/data-key=/ {print "http://userimg.qunar.com/imgs/"$4"180.jpg"}'>>$codedire/tem.txt
rm -f  mysql.txt
cd $codedire



while read LINE
do
  wget $LINE
done<tem.txt
cd 
cd /home/gaowenbin/shell/
done



















