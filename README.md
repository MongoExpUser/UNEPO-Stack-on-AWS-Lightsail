# UNEPO-Stack-on-AWS-Lightsail

<br>
<strong>
Deploys Ubuntu, NodeJS, ExpressJS and PostgreSQL (UNEPO) Stack on AWS Lightsail with Terraform Python CDK.
</strong>
<br><br>
The  STACK deploys the following specific resources and software:

1) AWS Lightsail ssh key pair, assigned to instance(s) in Item 2 below.
                                                                                                                                                 
2) AWS Lightsail instance(s) with Ubuntu 20.04 LTS OS
                                                                                                                                                 
3) AWS Lightsail static ip(s) for the instance(s).
                                                                                                                                               
4) AWS Lightsail static ip attachhment(s) to the instance(s).

5) Bash launch or start-up script (user data) for the installation of software, on the instance(s), including:

   -  Additional Ubuntu OS Packages <br>
   -  NodeJS <br>
   -  ExpressJS Web Server Framework <br>
   -  Other Node.js Packages and <br>
   -  PostgreSQL


## DEPLOYING THE CDK STACK

### To deploy the stack  on ```AWS```, follow the steps in the following link:

<strong>CDK for Terraform Application</strong>: https://learn.hashicorp.com/tutorials/terraform/cdktf-build-python?in=terraform/cdktf
  
# License

Copyright © 2015 - present. MongoExpUser

Licensed under the MIT license.
