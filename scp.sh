#!/bin/bash

##################### OPTIONS #############################
TILDE="/home/YourAccountUsernameGoesHere"
PRIVKEY="~/.ssh/id_rsa"
PORT="22"
SRVIP="192.168.1.1"
SRVID="YourAccountUsernameGoesHereAgain"
###########################################################

## Menu
echo "Please select an option:
1. To (Local to Remote)
2. From (Remote to Local)
"

## Read selection
read TOFROM


## Copy file to a remote destination from local
if [ $TOFROM == "1" ]; then

	echo "You selected 'Copy to'"
	echo "Enter path to local file or directory:"
	read TOPATH
	TOPATH="${TOPATH/#\~/$HOME}"
	echo "Enter a remote target directory:"
	read TODIR
	TODIR="${TODIR/#\~/"$TILDE"}"
	scp -r -P $PORT -i $PRIVKEY $TOPATH $SRVID@$SRVIP:$TODIR
	exit

## Copy file from a remote destination to local
elif [ $TOFROM == "2" ]; then
        echo "You selected 'Copy From'"
        echo "Enter path to remote file or directory:"
        read FROMDIR
	FROMDIR="${FROMDIR/#\~/"$TILDE"}"
        echo "Enter a local target directory:"
        read FROMPATH
	FROMPATH="${FROMPATH/#\~/$HOME}"
        scp -r -P $PORT -i $PRIVKEY $SRVID@$SRVIP:$FROMDIR $FROMPATH
	exit


## Invalid choice exit
else

	echo "Please select either 1 or 2"
	read TOFROM
fi
