unzip the terraform-capp.zip
cd terraform-capp

 cd 0-utils/
 terraform apply -auto-approve
 cd ..

 cd 1-security/
 terraform apply -auto-approve
 cd ..

 cd 3-compute/
 terraform apply -auto-approve
 cd ..

cd 4-database/
 terraform apply -auto-approve
 terraform output db_details
 

then form my sql command from the output example below.

terraform output

{
  "cappdb" = {
    "endpoint" = "capp-db.cmn32gpdtr3y.ap-southeast-1.rds.amazonaws.com"
    "password" = "password"
    "port" = 3306
    "username" = "cappmasteruser"
  }
}

form the mysql cli command 

 mysql -u cappmasteruser -ppassword -h capp-db.cmn32gpdtr3y.ap-southeast-1.rds.amazonaws.com -P 3306