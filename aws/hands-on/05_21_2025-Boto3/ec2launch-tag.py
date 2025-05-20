import boto3
ec2 = boto3.resource('ec2')

# create a new EC2 instance with tag "Name=betul"
instances = ec2.create_instances(
    ImageId='ami-084568db4383264d4',  # Ubuntu AMI ID
    MinCount=1,
    MaxCount=1,
    InstanceType='t2.micro',
    KeyName='betul',  # your keypair name without .pem
    TagSpecifications=[
        {
            'ResourceType': 'instance',
            'Tags': [
                {
                    'Key': 'Name',
                    'Value': 'betul' # your keypair name without .pem 
                }
            ]
        }
    ]
)
