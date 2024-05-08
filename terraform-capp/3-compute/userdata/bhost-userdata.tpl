#!/bin/bash


mkdir /sw
cd /sw
aws s3 cp s3://capps3-software-backup-store/mysql-client-cli/ . --recursive

rpm -ivh mysql-community-common-8.3.0-1.el9.x86_64.rpm
rpm -ivh mysql-community-client-plugins-8.3.0-1.el9.x86_64.rpm
rpm -ivh mysql-community-libs-8.3.0-1.el9.x86_64.rpm
rpm -ivh mysql-community-client-8.3.0-1.el9.x86_64.rpm
