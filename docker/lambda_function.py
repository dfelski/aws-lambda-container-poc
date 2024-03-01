import subprocess
import logging
import boto3
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    dockerImage = ""

    try:
        dockerImage = event['dockerImage']        
    except KeyError as e:
        logger.error("unsifficient data:")
        logger.error(event)
        return

    imageFileName = importImage(dockerImage)

    if imageFileName is None:
        return

    # upload
    uploadImage(imageFileName)

    # delete file
    logger.info("delete temp file '"+imageFileName+"'")
    os.remove(imageFileName) 

    return {
        "statusCode" : 201
    }

def importImage(dockerImage):
    logger.info("import '"+dockerImage+"'")
    imageFileName = "/tmp/test.tar"

    command = "skopeo copy --tmpdir /tmp docker://"+dockerImage+" docker-archive:"+imageFileName
    logger.info("execute '"+command+"'")

    result = subprocess.run([command], shell=True) 
    logger.info("return_code: "+str(result.returncode))

    if result.returncode == 1:
        logger.error("unexpected error during import")
        return
    
    return imageFileName

def uploadImage(imageFileName):
    logger.info("upload '"+imageFileName+"'")
    s3_client = boto3.client('s3')
    s3_client.upload_file(imageFileName, "docker-image-import", "test.tar.gz")