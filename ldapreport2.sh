#!/bin/bash


ldapsearch -x "(objectClass=totalOfficeGroup)" | grep cn= | awk -F "=|," '{print $2}' > groups.txt

if [ -s "output.csv" ]; then
        rm output.csv
        echo "Already existing output file deleted"
fi
echo "Creating new output file"

while read line
do
	echo "$line:" >> output.csv
	ldapsearch -x cn=$line | grep maildrop |  awk '{print "\011",$2}' >> output.csv
done < groups.txt
rm groups.txt
echo "New output.csv file created"
echo "Remember to use Tab as the delimiter when opening in Excel"
echo "Thank you!"
echo "The output file is mailed"

cp output.csv /tmp/
(uuencode /tmp/output.csv output.csv; echo "PFA the groups list along with its users") | mailx -s "Group-wise listing of LDAP users" -a "From:toadmin@yukthi.com" "cariappa.ba@yukthi.com"

	

