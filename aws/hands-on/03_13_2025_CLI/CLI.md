## AWS CLI Session 1 : 

- This hands on explains how to install and configure AWS CLI. We'll also see how to create and manipulate the resources in AWS via AWS CLI 

### References

- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
- https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
- https://docs.aws.amazon.com/linux/al2023/ug/get-started.html


## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- installing CLI on Windows, Linux or MAC O/S

- configuring CLI

- creating a resources with CLI

- working with Amazon Linux 2023 AMI

## Outline

- Part 1 - Installation

- Part 2 - Configuration

- Part 3 - Examples of the CLI commands

- Part 4 - Working with the latest Amazon Linux 2023 AMI


## Part 1 - Installation

### Step-1  Installation CLI on your "Local" 

- You can use the link below to install AWS CLI V2 according to your O/S.

- General page:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


- Windows:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


- Mac:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
https://graspingtech.com/install-and-configure-aws-cli/


- Linux:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip  #install "unzip" if not installed
unzip awscliv2.zip
sudo ./aws/install
```

### Step-2 Installation CLI on Linux (Ubuntu EC2)

#### Section-1 Creating an Ubuntu EC2

- Since  "Amazon Linux 2023" image is installed with "CLI Version 2" by default we create an EC2 instance with  "Ubuntu EC2" image so that we can practice how to install CLI V2. 

```text
-AMI             : Ubuntu 22.04
-Instance Type   : t2.micro
-Security Group  : SSH-22
```

#### Section-2 Install CLI Version 2 

- Check and Install AWS CLI Version 2
```
aws --version 

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

- install "unzip" if not installed than unzip 
```
sudo apt install unzip
unzip awscliv2.zip 
sudo ./aws/install
```

- Update the path accordingly if needed (AWS CLI Version 1 uses>>>> /usr/bin/aws)

```bash
export PATH=$PATH:/usr/local/bin/aws
```

!!!!
or you may type >>> "bash"


## Part-2  Configuration - Local

### Step-1 Creating Access Key ID and Secret Access Key

- Go to the IAM service

- From the left hand menu 

- Click Users ---->> Select user---->>Security Credential--->> Access keys --->>>Create Access key 


### Step-2 Configuring (!!!!!!We keep going with Local)

- Configure your terminal with AWS Access Key ID and Secret Access Key for CLI

```bash
aws configure
```

- than fill the information and hit the ENTER 

```bash

AWS Access Key ID [None]: ****************
AWS Secret Access Key [None]: ****************
Default region name [None]: us-east-1
Default output format [None]: yaml
```

- Show the file inside the ./aws folder

```bash
cat .aws/config
cat .aws/credentials

```

- Check the existing profiles:

```bash

aws configure list-profiles (list of the profiles )
aws sts get-caller-identity (Who am I)
```

- Show how to use CLI on single terminal with multiple user:

```bash
aws configure --profile user1 (Configure the terminal for additional user )
aws iam list-users --profile user1
aws s3 ls --profile user1

```
- Check the existing profiles again:

```bash
aws configure list-profiles 
```

- Switch the current profile to "custom user" profiles

```bash
export AWS_PROFILE=user1 
```

- Switch the current profile to "default" user profile again.

```bash
export AWS_PROFILE=default 
```

- try to use CLI after deactivate KEYs from IAM. 

## Part 3 Examples of the CLI commands: 

- talk about the anatomy of CLI commands anatomy.


### Step 1- IAM

- List and Create IAM user

```bash
aws iam list-users

aws iam list-users --output table 

aws iam create-user --user-name aws-cli-user

aws iam list-users | grep aws-cli-user

aws iam delete-user --user-name aws-cli-user
```

### Step 2 - S3

- check the existing S3 buckets and create a new bucket named "osvaldo-cli-bucket"

```bash
aws s3 ls
aws s3 mb s3://YOUR-NAME-cli-bucket-kaplan
```

- create a file in the existing directory and copy this file to newly created bucket 

```bash
touch in-class.yaml
aws s3 cp in-class.yaml s3://YOUR-NAME-cli-bucket-kaplan
```

- copy this file to new folder inside bucket 

```bash
aws s3 cp in-class.yaml s3://YOUR-NAME-cli-bucket-kaplan/new/in-class.yaml
aws s3 ls s3://YOUR-NAME-cli-bucket-kaplan/new/
```

- # show the example of the user data that we used in IAM session while covering ROLES. Since we don't have any AWS CLI configuration while launching an EC2, the CLI command inside the EC2 fetch the data via ROLES rather than CLI credentials. 

```bash

#!/bin/bash

yum update -y
yum install -y httpd
cd /var/www/html
aws s3 cp s3://osvaldo-pipeline-production/index.html .
aws s3 cp s3://osvaldo-pipeline-production/cat.jpg .
systemctl enable httpd
systemctl start httpd 
```

- Check inside of the newly created bucket.

```bash

aws s3 ls s3://YOUR-NAME-cli-bucket-kaplan
```

- delete the object inside the bucket 

```bash

aws s3 rm s3://YOUR-NAME-cli-bucket-kaplan/new/in-class.yaml
```

- remove the bucket

```bash
aws s3 rb s3://YOUR-NAME-cli-bucket-kaplan --force
```

### Step 3 - EC2

- check the available commands for ec2 

```bash

aws ec2 help
```

- list the EC2 instances

```bash
aws ec2 describe-instances
```

- list the EC2 instances in specific region

```bash

aws ec2 describe-instances --region us-east-1 --output table 
```

- Launch an EC2 instance (Note that this command may not work in PowerShell because of the different meaning of "\" )

```bash

aws ec2 run-instances \
   --image-id ami-08b5b3a93ed654d19 \
   --count 1 \
   --instance-type t2.micro \
   --key-name YOUR-KEY-NAME #put your key name without ".pem" 
   
```

- List the instances filtering with " key name " and " image id ".

```bash

aws ec2 describe-instances \
   --filters "Name = key-name, Values = YOUR-KEY-NAME"   # put your key name

aws ec2 describe-instances \
   --filters "Name = image-id, Values = ami-08b5b3a93ed654d19"   # image id of EC2
```

- List the instances only with specific attribute. This command list the " Public IP addresses " of all EC2

```bash

aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress[]" --output text
```

- You can combine "filtering and query"  !!!! #put your key name without .pem

```bash
aws ec2 describe-instances \
   --filters "Name = key-name, Values = YOUR-KEY-NAME" --query "Reservations[].Instances[].PublicIpAddress[]" 
```

- List the instances filtering with " InstanceId "

```bash
aws ec2 describe-instances \
   --filters "Name = instance-type, Values = t2.micro" --query "Reservations[].Instances[].InstanceId[]"
```

!!!
- --output text

```bash
aws ec2 describe-instances \
   --filters "Name = instance-type, Values = t2.micro" --query "Reservations[].Instances[].InstanceId[]" --output text
```

- You may want to call multiple values under the single attribute. For example under the "Instances" attribute I need both "InstanceId and PublicIpAddress":

!!!! #put your key name without .pem

```bash
aws ec2 describe-instances  \
  --filters "Name = instance-type, Values = t2.micro" "Name = key-name, Values = YOUR-KEY-NAME" \
  --query "Reservations[].Instances[].{myinstanceid:InstanceId, mypublicip:PublicIpAddress}" 
```

- Let's stop and terminate the instance (manuelly get instance id)

```bash

aws ec2 stop-instances --instance-ids INSTANCE_ID_HERE 

```

- or first you may fetch the instance id than use in command. 

```bash

aws ec2 describe-instances  \
  --filters "Name = instance-type, Values = t2.micro" "Name = key-name, Values = YOUR-KEY-NAME" \
  --query "Reservations[].Instances[].InstanceId[]" --output text


than ....

aws ec2 stop-instances --instance-ids $(aws ec2 describe-instances --filters "Name = instance-type, Values = t2.micro" "Name = key-name, Values = YOUR-KEY-NAME" --query "Reservations[].Instances[].InstanceId[]" --output text)
```

- Terminate instance :

```bash

aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --filters "Name = instance-type, Values = t2.micro" "Name = key-name, Values = YOUR-KEY-NAME" --query "Reservations[].Instances[].InstanceId[]" --output text)

```

- ## Part-4 ssm-parameter service and Working with the latest Amazon Linux 2023 AMI

- Call the latest version of AL2023

```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --region us-east-1
```

- Filter the image ID of latest AL2023

```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query 'Parameters[0].[Value]' --output text
```

- ## A variable that is only valid for the current terminal session: "local (session-scoped) variable" or simply "temporary variable"

```bash

ImageId=$(aws ssm get-parameters --names "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64" --query 'Parameters[0].[Value]' --output text)

- echo $ImageId
```

# You can make the variable an environment variable by adding the export command

```bash
export ImageId=$(aws ssm get-parameters --names "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64" --query 'Parameters[0].[Value]' --output text)


- echo $ImageId

aws ec2 run-instances \
--image-id $ImageId \
--count 1 \
--instance-type t2.micro \
--key-name YOUR-KEY-NAME # Do not write your key pair with ".pem ", be careful !!!

```

- For the gitbash - (Gitbash can not run ssm-paramreter command so try this option)

```bash
aws ssm get-parameters --names "//aws\service\ami-amazon-linux-latest\al2023-ami-kernel-default-x86_64" --region us-east-1 --query "Parameters[0].Value" --output text

export ImageId=$(aws ssm get-parameters --names "//aws\service\ami-amazon-linux-latest\al2023-ami-kernel-default-x86_64" --region us-east-1 --query "Parameters[0].Value" --output text)

- echo $ImageId
```

## Launching EC2 instance with latest AL2023 AMI. 

- for linux (ubuntu or AL2023)

```bash
aws ec2 run-instances \
   --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query 'Parameters[0].[Value]' --output text) \
   --count 1 \
   --key-name YOUR-KEY-NAME \
   --instance-type t2.micro
```

## Gitbash can not run ssm-paramreter command so try the powershell option or try this command for git-bash

- for git-bash

```bash
aws ssm get-parameters --names "//aws\service\ami-amazon-linux-latest\al2023-ami-kernel-default-x86_64" --query \
   'Parameters[0].[Value]' --output text

aws ec2 run-instances \
   --image-id $(aws ssm get-parameters --names "//aws\service\ami-amazon-linux-latest\al2023-ami-kernel-default-x86_64" --query \
   'Parameters[0].[Value]' --output text) \
   --count 1 \
   --key-name YOUR-KEY-NAME \
   --instance-type t2.micro   
```

- for powershell

```powershell
$ImageId = $(aws ssm get-parameters --names "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64" --query 'Parameters[0].[Value]' --output text)

aws ec2 run-instances `
   --image-id $ImageId `
   --count 1 `
   --key-name "YOUR-KEY-NAME" `
   --instance-type "t2.micro"
```

## Gitbash can not run ssm-paramreter command so you can  try the gitbash option

```bash
aws ec2 run-instances \
   --image-id $(aws ssm get-parameters --names "//aws\service\ami-amazon-linux-latest\al2023-ami-kernel-default-x86_64" --query \
   'Parameters[0].[Value]' --output text) \
   --count 1 \
   --instance-type t2.micro\
   --key-name YOUR-KEY-NAME \
   --security-group-ids your sec grp grp-id \ 
```

- delete the instance you have created

```bash
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --filters "Name = instance-type, Values = t2.micro" "Name = key-name, Values = #YOUR-KEY-NAME" --query "Reservations[].Instances[].InstanceId[]" --output text)
```

- Create instance with userdata.

- First create a script.txt in your local/ec2 

```bash
- vim script.txt

```

- paste the folowing code inside the script.txt

```bash

#! /bin/bash
#update os
dnf update -y
#install apache server
dnf install -y httpd
# get date and time of server
DATE_TIME=`date`
# create a custom index.html file
echo "<html>
<head>
    <title> My First Web Server</title>
</head>
<body>
    <h1>Hello to Everyone from YOUR-NAME-Kaplan Web Server</h1>
    <p>This instance is created at <b>$DATE_TIME</b></p>
</body>
</html>" > /var/www/html/index.html
# start apache server
systemctl start httpd
systemctl enable httpd

```

- check your directory where you run command and get  your "security group id" from consol

- linux-mac

```bash
aws ec2 run-instances \
   --image-id $(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query \
   'Parameters[0].[Value]' --output text) \
   --count 1 \
   --instance-type t2.micro\
   --key-name YOUR-KEY-NAME\
   --security-group-ids your sec grp grp-id\
   --user-data file://script.txt
```

- powershell windows

```powershell
$ImageId = $(aws ssm get-parameters --names "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64" --query 'Parameters[0].[Value]' --output text)

aws ec2 run-instances `
   --image-id $ImageId `
   --count 1 `
   --instance-type "t2.micro" `
   --key-name "YOUR-KEY-NAME" `
   --security-group-ids "sg-your sec grp grp-id" `
   --user-data "file://script.txt"

```

- gitbash windows

```bash
aws ec2 run-instances \
   --image-id $(aws ssm get-parameters --names "//aws\service\ami-amazon-linux-latest\al2023-ami-kernel-default-x86_64" --query \
   'Parameters[0].[Value]' --output text) \
   --count 1 \
   --instance-type t2.micro\
   --key-name YOUR-KEY-NAME\
   --security-group-ids your sec grp grp-id \
   --user-data file://script.txt
```


- check the ec2 than terminate it :

```bash

aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --filters "Name = instance-type, Values = t2.micro" "Name = key-name, Values = YOUR-KEY-NAME" --query "Reservations[].Instances[].InstanceId[]" --output text)

```

- ## for ubuntu and bash

```bash

aws ec2 run-instances \
--image-id $ImageId \
--count 1 \
--instance-type t2.micro \
--key-name YOUR-KEY-NAME \
--security-group-ids "your sec grp grp-id" \
--user-data "file://script.txt"

```

- ## terminate the instance - bash -ubuntu (linux)

```bash
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --filters "Name = instance-type, Values = t2.micro" "Name = key-name, Values = YOUR-KEY-NAME" --query "Reservations[].Instances[].InstanceId[]" --output text)