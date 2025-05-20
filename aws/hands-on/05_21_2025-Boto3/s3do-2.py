import boto3

s3 = boto3.resource('s3')
s3.Bucket('betul-demo-boto3-bucket').objects.delete() # change your s3 bucket name

