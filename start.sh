#!/bin/bash
KEY_FILE="key.pem"
HP_FILE="/opt/ml/input/config/hyperparameters.json"
if [ -f $HP_FILE ]; then
	KEY=$(jq -r '.SSH_KEY_BASE64 // empty' $HP_FILE)
	HOST=$(jq -r '.SSH_HOST // empty' $HP_FILE)
	USER=$(jq -r '.SSH_USER // empty' $HP_FILE)
fi

[ -z "${KEY}" ] && KEY=$SSH_KEY_BASE64
[ -z "${HOST}" ] && HOST=$SSH_HOST
[ -z "${USER}" ] && USER=$SSH_USER

if [[ -z "${KEY}" || -z "${HOST}" ]]; then
	echo "Missing SSH_KEY or SSH_HOST"
	exit 1
fi
/usr/sbin/sshd -D &
echo $KEY | base64 -d > $KEY_FILE
chmod 400 $KEY_FILE
echo "Connecting to $USER@$HOST" 
ssh -i $KEY_FILE -o StrictHostKeyChecking=no -o LogLevel=ERROR -N -R $MAPPED_PORT:127.0.0.1:$SSH_PORT $USER@$HOST &
echo "To connect from $HOST, run:
ssh -p $MAPPED_PORT aws@127.0.0.1"
wait
