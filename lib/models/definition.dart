class Definition {
  int id;
  String word;
  String definition;
  String example;

  Definition({
    required this.id,
    required this.word,
    required this.definition,
    required this.example,
  });

  Definition.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        word = map['word'],
        definition = map['definition'],
        example = map['example'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'example': example,
    };
  }
}
