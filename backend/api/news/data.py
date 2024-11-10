import requests
from bs4 import BeautifulSoup as bs

class Data:
    def __init__(self):
        self.title = None
        self.summary = None
        self.content = ''
        self.linkImage = None
        self.linkArticle = None
    
    @staticmethod
    def get_link_Articles(url):
        res = []
        response = requests.get(url)
        doc = bs(response.text, 'html.parser')

        articles = doc.select('h3')
        for article in articles:
            link_a = 'https://baomoi.com'+ article.select_one('a').get('href')
            res.append(link_a)
        return res

    def set_summary(self, doc):
        temp = doc.select_one("meta[name=description]")
        self.summary = temp["content"] if temp else None

    def set_title(self, doc):
        temp = doc.select_one("h1")
        self.title = temp.text if temp else None

    def set_content(self, doc):
        ps = doc.select("p.text")
        if ps:
            self.content = "\n".join([e.text for e in ps])
        else:
            self.content = None

    def set_link_image(self, doc):
        meta_tag = doc.select_one("meta[property='og:image']")
        self.linkImage = meta_tag["content"] if meta_tag else None

    def check_null_or_empty(self):
        if not self.title or not self.content or not self.linkImage or not self.summary:
            return True
        return False