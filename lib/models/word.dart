class Word {
  int? id;
  String term;
  String definition;
  String example;

  Word({
    this.id,
    required this.term,
    required this.definition,
    required this.example,
  });

  Word.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        term = map['term'],
        definition = map['definition'],
        example = map['example'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'term': term,
      'definition': definition,
      'example': example,
    };
  }
}
