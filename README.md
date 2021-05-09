# UNEPO-Stack-on-AWS-Lightsail

<br>
<strong>
Deploys Ubuntu, NodeJS, ExpressJS and PostgreSQL (UNEPO) Stack on AWS Lightsail with Python Terraform CDK.
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
