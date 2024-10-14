from flask import request, redirect
import os
from dotenv import load_dotenv
from random import randint
from vnpay import VNPAY
from api.pay import pay_bp

load_dotenv()

        
        