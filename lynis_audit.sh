#!/bin/bash

#This script logs into a remote host using ssh and then downloads lynis, audits the system, and then removes lynis or keeps it installed.

#IMPORTANT: In order to copy the remote audit files to the local machine, ssh keys will need to be generated and placed in both machines.

#Variables
directory=lynis
var=0
ssh_key=0
option=0

#Notify user to add ssh keys to the local and remote host
echo "IMPORTANT: In order to copy the remote audit files to the local machine, ssh keys will need to be generated and placed in both machines. The program will still run without the keys."
echo

#Add remote user and localhost variables
read -p "Enter username of remote host: " u
echo
read -p "Enter remote host address (ipv4): " u_host
echo
read -p "Enter ssh port of remote host: " u_port
echo
echo "This program will copy the audit files from the remote machine and securely transfer them to your local machine.This program utilizes ssh and needs the username, address, and port # of your local account to transfer the audit files"
echo
read -p "Enter username of local account: " local_u
echo
read -p "Enter address of local account (ipv4): " local_host
echo
read -p "Enter the port your local system uses for ssh: " local_port
echo
#Specify a location on the local machine to copy the audit files from the remote machine
read -p "Enter the local location where the audit files will be stored (End your location with a '/', for example: /home/$local_u/) :" file_location
echo
#Prompt user to determine which option of lynis scan they want to execute
while [ "$option" != 1 ] || [ "$option" != 2 ] || [ "$option" != 3 ] || [ -z "$option" ];
do
	read -n 1 -p "Enter which option of lynis you want to execute. Type 1 and press Enter for default audit. Type 2 and Enter for a pentest audit. Type 3 and Enter for a forensic audit: " option
	if [ "$option" = 1 ]; then
		echo
		echo
		echo "Proceeding with default audit"
		break
	elif [ "$option" = 2 ]; then
		echo
		echo
		echo "Proceeding with pentest audit"
		break
	elif [ "$option" = 3 ]; then
		echo
		echo
		echo "Proceeding with forensic audit"
		break
	else
		echo
		echo "ERROR: Please choose one of these options: 1, 2, or 3"
		echo
	fi
done

#Prompt the user to determine if lynis is to remained installed on the remote system
echo
while [ "$var" != y ] || [ "$var" != Y ] || [ "$var" != n ] || [ "$var" != N ];
do
	read -n 1 -p "Press y and then Enter to purge lynis from remote system after the audit. Or press n and then Enter to keep lynis installed on the remote system: " var

	if [ "$var" = y ] || [ "$var" = Y ]; then
        	echo
		echo
		echo "Lynis will be purged after the audit"
		echo
		break
	elif [ "$var" = n ] || [ "$var" = N ]; then
		echo
		echo
        	echo "Lynis will remained installed after the audit"
		echo
		break
	else
		echo
		echo "ERROR: Please enter a valid option..."
		echo
	fi
done

stty -echo

#Execute remote commands
echo
ssh -p $u_port $u@$u_host bash -c "'
if [ -d $directory ]; then
	cd $directory && echo "Directory $directory exits, entering $directory"
	echo
else
	mkdir $directory && cd $directory && echo "Created the $directory directory and entered the $directory"
	echo
fi

#Install lynis on remote system
sudo -S apt install lynis -y
echo
echo "Executing audit on remote system......."
echo
#Execute audit type
if [ $option = 1 ]; then
	lynis audit system
elif [ $option = 2 ]; then
	lynis audit system --pentest
else
	lynis audit system --forensics
fi
echo
echo "Copying audit files to local machine......."
echo
#Copy audit files from remote machine to the local machine
scp -P $local_port ~/lynis.log $local_u@$local_host:$file_location/lynis-$u@$u_host.log && scp -P $local_port ~/lynis-report.dat $local_u@$local_host:$file_location/lynis-report-$u@$u_host.dat

#Either purge lynis or leave it installed.
if [ $var = y ] || [ $var = Y ]; then
        #Purge lynis
	echo
	echo "Now purging lynis"
	echo
        sudo apt purge lynis -y
elif [ $var = n ] || [ $var = N ]; then
        #Keeps lynis on ths remote host
        echo
	echo "exiting remote host...lynis remains installed"
	echo
fi
'"

echo

echo "Audit complete"
