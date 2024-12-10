class News{
  String? content;
  String? linkArticle;
  String? linkImage;
  String? summary;
  String? title;

  News(
      {this.content,
      this.linkArticle,
      this.linkImage,
      this.summary,
      this.title}
      );

  News.fromJson(Map<String,dynamic> json){
    content= json['content'];
    linkArticle= json['linkArticle'];
    linkImage=json['linkImage'];
    summary= json['summary'];
    title= json['title'];
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'linkArticle': linkArticle,
      'linkImage': linkImage,
      'summary': summary,
      'title': title,
    };
  }
}