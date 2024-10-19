from flask import request, jsonify
import base64
import jwt
import os
from config import Config

def getIP():
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)

    return client_ip

def validate_token():
    bearer = request.headers.get('Authorization')
    
    if not bearer:
        return False
    else:
        token = bearer.split()[-1]
        try:
            validate = jwt.decode(token, key=Config.SECRET_KEY, algorithms='HS256')
            return True
        except:
            return False
        
def get_payload():
    bearer = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJyb2xlIjoiYWRtaW4iLCJleHAiOjE3MjkzMzIxNjd9.sQgt9eT1YA1uerCojaYDz5x-R0I3pu8yw28o5oYgROg'
    if not bearer:
        return False
    else:
        token = bearer.split()[-1]
        try:
            validate = jwt.decode(token, key=Config.SECRET_KEY, algorithms='HS256')
            return validate
        except:
            return False

get_payload()
        