#!/bin/bash

figlet PW-Hash Checker
echo "\n This checks the strength of password, if hash is likely to be md5 or sha256 and whether it's malicious"

#This function contains a case to allow users to choose whether to check Password or Hash
function HC()
{	
echo -e "\n"
read -p "Would you like to check password (P) or hash (H)?" PHE
case $PHE in
	#If the user choose to check password, it will get the password from the user and proceeds to check the length, uppercase, numeric and special characters in the password
	P) 
		read -p "Please enter a password:" pw
		len=$(echo -n "$pw" | wc -c)
		up=$(echo -n "$pw" | grep -o "[A-Z]" | wc -c)
		num=$(echo -n "$pw" | grep -o "[0-9]" | wc -c)
		special=$(echo -n "$pw" | grep -o "[%^&*()\.\!\@\#]" | wc -c)

		if [ "$len" -ge 8 ]
		then
			if [ "$up" != 0 ]
			then
				if [ "$num" != 0 ]
				then
					if [ "$special" != 0 ]
					then 
						echo -e "\n[*]Password is pretty strong [*]"
					else
						echo -e "\n[*]Missing Special Characters [*]"
					fi
				else
					echo -e "\n[*]Missing Number and Special Characters [*]"
				fi
			else
				echo -e "\n[*]Missing Uppercase, Number and Special Characters [*]"
			fi
		else
			echo -e "\n[*]Password too short [*]"
		fi
		HC	
	;;
	
	#If user chooses to check Hash, it will check if it ts md5sum or sha-256, and proceeds to verify if it is malicious. 
	#Internet connection is required for this
	H)
		echo -e "\nPlease enter the hash (md5/sha256): "
		read hashvalue
		hashlength=$(echo -n "$hashvalue" | wc -c)
		echo -e "\n[*]This hash has $hashlength characters [*]"
		
		if [ "$hashlength" == 32 ]
		then
			echo -e "\n[*]This is a MD5 hash [*]"

		elif [ "$hashlength" == 64 ]
		then 
			echo -e "\n[*] This is SHA-256 [*]"
		else
			echo -e "\n[*] Hash type Not Found [*]"
		fi
		
		avhitrate=$(whois -h hash.cymru.com "$hashvalue" | awk '{print $3}')

		if [ ! -z "$avhitrate" ]
		then
			echo -e "\n[*] This hash has a "$avhitrate"% chance it is malicious [*]"
		else
			echo "This hash is safe"
		fi
		HC
	;;
	
	E)
		exit
	;;
	esac 
}

HC
	


