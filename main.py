import requests
import json
from google.cloud import storage
from datetime import datetime
import pytz
import functions_framework
import logging

def request_api_data() -> dict:

    '''
    Requests data from the fantasy premer league api

    Args:
    None

    Returns: 
    dict: Full api response 
    '''
    
    url = "https://fantasy.premierleague.com/api/bootstrap-static/"
    print(f'starting request to {url}')

    response = requests.request("GET", url)

    if response.ok:
        logging.info(f'response to {url} suceeded.')
        response_text = response.text
    
    else:
        raise ValueError(f'Response to {url} failed with status code of {response.status_code}.')

    return json.loads(response_text)



def upload_json_to_gcs(json_object, bucket_name, object_name):
    """
    Uploads a JSON object to Google Cloud Storage.

    Args:
    json_object (dict): The JSON object to be uploaded.
    bucket_name (str): The name of the Google Cloud Storage bucket.
    object_name (str): The name of the object to be created in the bucket.

    Returns:
    str: The GCS URL of the uploaded JSON object.
    """
    json_string = json.dumps(json_object)
    client = storage.Client()

    bucket = client.bucket(bucket_name)
    blob = bucket.blob(object_name)

    blob.upload_from_string(json_string, content_type='application/json')
    logging.info(f'uploaded {blob.name}')

    return blob.name



@functions_framework.http
def main(request) -> str:

    '''
    Main entry point for cloud functoin. Requests data from fantasy epl api and uploads to cloud storage.

    Initiated by cloud scheduler HTTP requst.

    Args:
    request: flask request
    returns: (str): valid flask status code
    '''


    logging.info(f'received {request}.')

    bucket_name = 'transfer-data-raw'
    extract_timestamp_utc = datetime.now(pytz.utc).strftime("%Y-%m-%d_%H:%M:%S_%Z")
    extrct_date_utc = datetime.now(pytz.utc).strftime("%Y-%m-%d")


    resp = request_api_data()

    for table in resp.keys():
        
        object_name = f'{table}/{extrct_date_utc}/{table}_raw_{extract_timestamp_utc}.json'
        json_object = resp.get(table)

        upload_json_to_gcs(json_object=json_object, bucket_name = bucket_name, object_name = object_name)

    return '200'
