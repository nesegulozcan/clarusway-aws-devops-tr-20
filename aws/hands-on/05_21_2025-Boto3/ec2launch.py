import boto3
ec2 = boto3.resource('ec2')

# create a new EC2 instance
instances = ec2.create_instances(
     ImageId='ami-084568db4383264d4', # ubuntu  ami id
     MinCount=1,
     MaxCount=1,
     InstanceType='t2.micro',
     KeyName='your-key' #yourkeypair without .pem
 )
