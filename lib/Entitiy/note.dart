class Note {
  final int id;
  final String title;
  final String content;
  final String color;
  final String createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      color: json['color'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'color': color,
      };
}
