class Book {
  final String id;
  final String title;
  final String description;
  final String author;
  final String coverUrl;
  final String pdfUrl;
  //final String price;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.coverUrl,
    required this.pdfUrl,
    //required this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json, String id) => Book(
    id: id,
    title: json['title'],
    description: json['description'],
    author: json['author'],
    coverUrl: json['coverUrl'],
    pdfUrl: json['pdfUrl'],
    //price: json['price'],
  );

  Book toEntity() => Book(
    id: id,
    title: title,
    description: description,
    author: author,
    coverUrl: coverUrl,
    pdfUrl: pdfUrl,
    //price: price,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'author': author,
    'coverUrl': coverUrl,
    'pdfUrl': pdfUrl,
    //price: price,
  };
}
