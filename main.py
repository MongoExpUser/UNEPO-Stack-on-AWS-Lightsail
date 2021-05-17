#  *****************************************************************************************************************************************************
#  *                                                                                                                                                   *
#  * @License Starts                                                                                                                                   *
#  *                                                                                                                                                   *
#  * Copyright © 2015 - present. MongoExpUser.  All Rights Reserved.                                                                                   *
#  *                                                                                                                                                   *
#  * License: MIT - https://github.com/MongoExpUser/UNEPO-Stack-on-AWS-Lightsail/blob/main/README.md                                                   *
#  *                                                                                                                                                   *
#  * @License Ends                                                                                                                                     *
#  *****************************************************************************************************************************************************
#  *                                                                                                                                                   *
#  *  main.py implements a STACK (with Terraform Python CDK) for the deployment of resources, including:                                               *
#  *                                                                                                                                                   *
#  *  1) AWS Lightsail ssh key pair, assigned to instance(s) in Item 2 below.                                                                          *
#  *                                                                                                                                                   *
#  *  2) AWS Lightsail instance(s).                                                                                                                    *
#  *                                                                                                                                                   *
#  *  3) AWS Lightsail static ip(s) for the instance(s).                                                                                               *
#  *                                                                                                                                                   *
#  *  4) AWS Lightsail static ip attachhment(s) to the instance(s).                                                                                    *
#  *                                                                                                                                                   *
#  *  5) Bash launch/start-up script (user data) for the installation of software, on the instance(s), including:                                      *
#  *     Additional Ubuntu OS packages; NodeJS; ExpressJS web server framework; other Node.js packages; and PostgreSQL.                                *
#  *                                                                                                                                                   *                                                                                                                                                  *
#  *****************************************************************************************************************************************************


from constructs import Construct
from cdktf import App, TerraformStack, TerraformOutput
from imports.aws import AwsProvider, LightsailKeyPair, LightsailInstance, LightsailStaticIp, LightsailStaticIpAttachment


class LightsailStack(TerraformStack):
    def __init__(self, scope: Construct, ns: str, variables: dict):
        super().__init__(scope, ns)
        
        # define common variables
        self.var = variables
        self.longer_prefix_or_suffix = self.var.get("longer_prefix_or_suffix")
        self.deploy_ls_instances = self.var.get("deploy_lightsail_instances")
        self.provider = AwsProvider(self, 'Aws', region=self.var.get("region"), shared_credentials_file=self.var.get("shared_credentials_file"))
        
        if (self.deploy_ls_instances and self.provider):
            # create lightsail resoures (instance(s), static ip(s) and static ip attachment(s)) and their outputs
            # 1. define variables
            ls_ssh_private_key_and_name_list = []
            ls_ssh_key_pair_output_list = []
            ls_instance_output_list = []
            ls_static_ip_output_list = []
            ls_static_ip_attachment_output_list = []
            prefix = None
            if self.longer_prefix_or_suffix:
                prefix = "{}{}{}{}{}{}".format(self.var.get("org_name"), "-", self.var.get("project_name"), "-", self.var.get("environment"), "-")
            else:
                prefix = "{}{}".format(self.var.get("environment"), "-")
                
            # 2. confirm length of list variables, and then proceed with the creation of resources and outputs
            confirm_length = self.confirm_length_of_list_variables(variables=self.var)
            confirm = confirm_length.get("confirm")
            length = confirm_length.get("length")
            ls_ssh_key_pair = None
            ls_ssh_private_key = self.var.get("lightsail_server_ssh_private_key")
            if confirm:
                for index in range(length):
                    # a. resources
                    # i. lightsail ssh key pair - create ONLY one ssh key-pair for all instances
                    if index == 0:
                        ls_ssh_key_pair_value = "{}{}".format("ls_ssh_key_pair_", index+1)
                        ls_ssh_key_pair = LightsailKeyPair(self, ls_ssh_key_pair_value,
                            name="{}{}".format(prefix, self.var.get("lightsail_server_ssh_key_pair_name"))
                        )
                        ls_ssh_key_pair_output_list.append(ls_ssh_key_pair)
                        ls_ssh_private_key_and_name_list.append({ls_ssh_private_key : ls_ssh_key_pair.private_key})
                    
                    # ii. lightsail instance(s)
                    ls_instance_value = "{}{}".format("ls_instance_", index)
                    ls_instance = LightsailInstance(self, ls_instance_value,
                        name="{}{}{}{}".format(prefix, self.var.get("lightsail_server_names")[index], "-", index+1),
                        availability_zone=self.var.get("lightsail_server_availability_zone"),
                        blueprint_id=self.var.get("lightsail_server_blueprint_ids")[index],
                        bundle_id=self.var.get("lightsail_server_bundle_ids")[index],
                        key_pair_name=ls_ssh_key_pair_output_list[0].name,
                        user_data=open(self.var.get("user_data_file_path")).read(),
                        tags = {
                            self.var.get("lightsail_server_tags_keys_version_nodejs")[index] : self.var.get("lightsail_server_tags_empty_values")[index],
                            self.var.get("lightsail_server_tags_keys_version_postgresql")[index] : self.var.get("lightsail_server_tags_empty_values")[index],
                        },
                        depends_on=[ls_ssh_key_pair]
                    )
                    ls_instance_output_list.append(ls_instance)
                    
                    # iii. lightsail static ip(s)
                    ls_static_ip_value = "{}{}".format("ls_static_ip_", index)
                    ls_static_ip = LightsailStaticIp(self, ls_static_ip_value,
                        name="{}{}{}{}".format(prefix, self.var.get("lightsail_server_static_ip_names")[index], "-", index+1),
                        depends_on=[ls_instance]
                    )
                    ls_static_ip_output_list.append(ls_static_ip)
                    
                     # iv. lightsail static ip attachment(s)
                    ls_static_ip_attachment_value = "{}{}".format("ls_static_ip_attachment_", index)
                    ls_static_ip_attachment = LightsailStaticIpAttachment(self, ls_static_ip_attachment_value,
                        instance_name=ls_instance.name,
                        static_ip_name=ls_static_ip.name,
                        depends_on=[ls_instance, ls_static_ip]
                    )
                    ls_static_ip_attachment_output_list.append(ls_static_ip_attachment)
                    
                # b. outputs
                # i. -1- lightsail ssh key pair output
                ls_ssh_key_pair_output_value = "ls_ssh_key_pair_attributes"
                ls_ssh_key_pair_output = TerraformOutput(self, ls_ssh_key_pair_output_value,
                    value=ls_ssh_key_pair_output_list,
                    description="A list of the ONLY created lightsail ssh key pair, with its attributes."
                )
                
                # i. -2- lightsail ssh private key output -  to be used for ssh connection
                ls_ssh_private_key_output_value = "ls_ssh_private_key_values"
                ls_ssh_private_key_output = TerraformOutput(self, ls_ssh_private_key_output_value,
                    value=ls_ssh_private_key_and_name_list,
                    description="A list of the ONLY created lightsail ssh private key value, and the assigned name on the Lightsail dashboard."
                )
        
                # ii. light instance output(s)
                ls_instance_output_value = "ls_instance_attributes"
                ls_instance_output = TerraformOutput(self, ls_instance_output_value,
                    value=ls_instance_output_list,
                    description="A list of created lightsail instances, with their attributes."
                )
            
                # iii. lightsail static ip  output(s)
                ls_static_ip_output_value = "ls_static_ip_attributes"
                ls_static_ip_output = TerraformOutput(self, ls_static_ip_output_value,
                    value=ls_static_ip_output_list,
                    description="A list of created lightsail static ips, with their attributes."
                )
                
                # iv. lightsail static ip attachment output(s)
                ls_static_ip_attachment_output_value = "ls_static_ip_attachment_attributes"
                ls_static_ip_attachment_output = TerraformOutput(self, ls_static_ip_attachment_output_value,
                    value=ls_static_ip_attachment_output_list,
                    description="A list of created lightsail static ip attachments, with their attributes."
                )
    # End __init__() method
    
    def confirm_length_of_list_variables(self, variables=None):
        #  check that the length of the following list variables are thesame
        var = variables
        length = len(var.get("lightsail_server_names"))
        confirm_one = (length == len(var.get("lightsail_server_names")) == len(var.get("lightsail_server_blueprint_ids")))
        confirm_two = (len(var.get("lightsail_server_bundle_ids")) == len(var.get("lightsail_server_static_ip_names")))
        confirm_three = (len(var.get("lightsail_server_tags_keys_version_nodejs")) == len(var.get("lightsail_server_tags_keys_version_postgresql")))
        confirm_four = (len(var.get("lightsail_server_tags_keys_version_postgresql")) == len(var.get("lightsail_server_tags_empty_values")))
        return {"confirm" : (confirm_one == confirm_two == confirm_three == confirm_four), "length" : length }
    # End confirm_length_of_list_variables() method
# End LightsailStack() class

def main():
    variables = {
        # 0.  specify instance type to deploy
        "deploy_lightsail_instances" : True,
        # 1. provider's details
        "region" : "us-east-1",
        "shared_credentials_file" : "shared_credentials_file.txt",
        # 2. lightsail variables - ssh key pair, instance, static-ip and static-ip attachment
        "lightsail_server_availability_zone" : "us-east-1a",
        "lightsail_server_ssh_key_pair_name" : "server-ssh-key-pair",
        "lightsail_server_ssh_private_key" : "server-ssh-private-key",
        "lightsail_server_ssh_private_key_file_name" : "server-ssh-private-key",
         # note: length of the following lists must be equal to the number of instances to be deployed
        "lightsail_server_names" : ["server", "server"],
        "lightsail_server_blueprint_ids" : ["ubuntu_20_04", "ubuntu_20_04"],
        "lightsail_server_bundle_ids" : ["micro_2_0", "micro_2_0"],
        "lightsail_server_tags_keys_version_nodejs" : ["NodeJS 16.0.x", "NodeJS 16.0.x"],
        "lightsail_server_tags_keys_version_postgresql" : ["PostgreSQL 13.x", "PostgreSQL 13.x"],
        "lightsail_server_tags_empty_values" : ["", ""],
        "lightsail_server_static_ip_names" : ["static-ip", "static-ip"],
        # 3. launch or start-up script(s) variables
        # note 1: before running the cdk module, the bash file (launch/start-up script) must be in the CWD
        # note 2: the CWD is assumed to be the location of the main.tf file
        # note 3: the scripts installs: additional Ubuntu OS packages, node.js, express.js, other Node.js packages and postgresql
        "user_data_file_path" : "startup-script.sh",
        # 4. prefix/suffix, environmental and stack variables
        "longer_prefix_or_suffix" : True,
        "org_name" : "org",
        "project_name" : "proj",
        "environment" : "dev",
        "stack_name" :  "Deploys-Lightsail-Resources-on-AWS"
    }
    app = App()
    LightsailStack(app, variables.get("stack_name"), variables)
    app.synth()
# End main() function
    
if __name__ in ["__main__"]:
    main()
