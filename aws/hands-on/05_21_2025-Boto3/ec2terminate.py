import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('i-07fc775a83ddc518a').terminate() # put your instance id
