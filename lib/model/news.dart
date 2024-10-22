class News {
  const News(
      {required this.title,
      required this.image,
      required this.publishAt,
      required this.author,
      required this.id,
      required this.content});

  final String title;
  final String id;
  final String author;
  final String image;
  final String publishAt;
  final String content;

  Map<String, dynamic> toMap() {
    return {'title': title, 'image': image, 'publishAt': publishAt, 'id': id};
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
        title: map['title'],
        content: map['content'] ?? '',
        publishAt: map['publishAt'],
        id: map['id'],
        author: map['author'] ?? '',
        image: map['image']);
  }
}
