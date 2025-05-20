import boto3

# Use Amazon S3
client = boto3.client('s3')
response = client.delete_bucket(
    Bucket='betul-demo-boto3-bucket',
)

print(response)
