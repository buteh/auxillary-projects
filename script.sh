#! /usr/bin/bash

FILE="names.csv"

if [ -f "$FILE" ]
then
	echo "Names csv exist"
else
	echo "Names csv does not exist"
fi

while IFS= read -r line; do
    echo "Text read from file: $line"
    isUserExist=$(sudo cat /etc/passwd | grep "$line")
    echo "$isUserExist"
    sudo useradd -m "$line" -p "$line"
    sudo usermod -a -G developers "$line"
    if [ -d /home/"$line"/.ssh ]
    then
	    echo "ssh folder exist for $line do nothing"
    else
	    echo "ssh folder does not exist for $line, creating new folder now"
	    sudo mkdir /home/"$line"/.ssh
	    sudo cp /home/ubuntu/.ssh/id_rsa.pub /home/"$line"/.ssh/
	    sudo mv /home/"$line"/.ssh/id_rsa.pub /home/"$line"/.ssh/authorized_keys
	    echo "Files created"
    fi
done < "$FILE"
