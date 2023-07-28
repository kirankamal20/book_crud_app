import 'dart:convert';

class Book {
  final int id;
  final String title;
  final String author;
  Book({
    required this.id,
    required this.title,
    required this.author,
  });

  Book copyWith({
    int? id,
    String? title,
    String? author,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'author': author,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int,
      title: map['title'] as String,
      author: map['author'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Book(id: $id, title: $title, author: $author)';

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title && other.author == author;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ author.hashCode;
}
