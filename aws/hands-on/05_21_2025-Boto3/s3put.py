import boto3

# Use Amazon S3
s3 = boto3.resource('s3')

# Don't forget to change your s3 bucket name
# Upload a new file
data = open('test.jpg', 'rb')
s3.Bucket('betul-demo-boto3-bucket').put_object(Key='test.jpg', Body=data)
