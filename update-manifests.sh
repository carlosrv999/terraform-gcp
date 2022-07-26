#!/bin/bash

mysql_emoji_ip=$1
mysql_vote_ip=$2

sed -i "/MYSQL_HOST:/c\  MYSQL_HOST: ${mysql_emoji_ip}" ./manifests-voteapp/envs/emoji-db-access-configmap.yaml
sed -i "/MYSQL_HOST:/c\  MYSQL_HOST: ${mysql_vote_ip}" ./manifests-voteapp/envs/vote-db-access-configmap.yaml

git add .
git commit -m "👨‍💻 Automatic commit by Terraform"
git push origin master
