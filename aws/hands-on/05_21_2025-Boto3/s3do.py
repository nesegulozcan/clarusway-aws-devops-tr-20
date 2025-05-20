import boto3

s3 = boto3.resource('s3')
bucket = s3.Bucket('betul-demo-boto3-bucket') # change s3 bucket name
bucket.objects.delete()
