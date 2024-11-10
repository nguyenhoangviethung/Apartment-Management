from .data import *
import requests
from bs4 import BeautifulSoup as bs
import json
class Crawl():
    def get_data(self,link_articles):
        data = []
        while True:
            temp = ""
            try:
                for link in link_articles:
                    temp = link
                    response = requests.get(link)
                    response.raise_for_status()
                    doc = bs(response.text, 'html.parser')

                    item = Data()
                    item.linkArticle = link
                    item.set_title(doc)
                    item.set_summary(doc)
                    item.set_content(doc)
                    item.set_link_image(doc)


                    if item.check_null_or_empty():
                        continue
                    data.append(item.__dict__)

            except requests.exceptions.RequestException as e:
                link_articles.remove(temp)
                pass

            return data
    @staticmethod
    def crawl_news(url):
        obj = Data()
        cr = Crawl()
        data = cr.get_data(obj.get_link_Articles(url))
        with open('backend\\api\\news\\news.json', 'w', encoding='utf_8') as fw:
            json.dump(data, fw, ensure_ascii = False, indent = 4)
        print('sc')