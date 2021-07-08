#!/bin/bash
yum -y update
amazon-linux-extras install -y nginx1
systemctl enable nginx.service
index_body=`hostname`
echo "<h2> Webserver hostname is : $index_body </h2><br> Terraform lessons" > /usr/share/nginx/html/index.html
whoami > /usr/share/nginx/html/whoami
systemctl start nginx.service