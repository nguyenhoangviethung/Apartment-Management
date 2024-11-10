from api.news import news_bp
from api.news.crawl import *
from flask import jsonify

@news_bp.route('/')
def index():
    return 'hello index'

@news_bp.get('get-data')
def get_data():
    obj = Data()
    cr = Crawl()
    data = cr.get_data(obj.get_link_Articles('https://baomoi.com/'))
    # Crawl().crawl_news('https://baomoi.com/')
    # with open('backend\\api\\news\\news.json','r', encoding = 'utf_8') as f:
    #     data = json.load(f)
    response = jsonify(data)
    response.headers['Content-Type'] = 'application/json; charset=utf-8'
    return response