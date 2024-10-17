from flask import request

def getIP():
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)

    return client_ip

def validate_token():
    bearer = request.headers.get('Authorization')

    if not bearer:
        return False
    else:
        token = bearer[7:]
        [headers, payload, signature] = bearer.split('.')
        print(headers, payload, signature)
        