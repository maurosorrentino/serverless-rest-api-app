import os
import logging

# CRITICAL = 50
# ERROR = 40
# WARNING = 30
# INFO = 20
# DEBUG = 10
# NOTSET = 0
log_level = os.environ.get("LOG_LEVEL") or 20
h1_content = os.environ.get("H1_CONTENT") or "Hello World"

logger = logging.getLogger()
logger.setLevel(int(log_level))

def lambda_handler(event, context):
    logger.info("Lambda function started.")
    
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "text/html"},
        "body": f"<html><body><h1>{h1_content}</h1></body></html>"
    }
