import json
import boto3

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # Get the bucket and object key from the event
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    source_key = event['Records'][0]['s3']['object']['key']
    
    if not source_key.endswith('/'):
        destination_key = source_key.replace('uploads/', 'processed/')
        
        # Copy the object to the "processed/" directory
        s3_client.copy_object(
            Bucket=source_bucket,
            CopySource={'Bucket': source_bucket, 'Key': source_key},
            Key=destination_key
        )
        
        # Delete the original object (the specific file, not the directory)
        s3_client.delete_object(Bucket=source_bucket, Key=source_key)

    return {
        'statusCode': 200,
        'body': json.dumps('File moved successfully')
    }
