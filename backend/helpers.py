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
    if not validate_token():
        return None
    
    bearer = request.headers.get('Authorization')
    token = bearer.split()[-1]
    payload = jwt.decode(token, key=Config.SECRET_KEY, algorithms='HS256')

    return payload

        