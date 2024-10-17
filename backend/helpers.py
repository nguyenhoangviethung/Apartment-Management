from flask import request

def getIP():
    client_ip = request.headers.get('X-Forwarded-For', request.remote_addr)

    return client_ip
