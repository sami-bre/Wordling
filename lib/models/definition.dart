enum Origin { created, downloaded }

class Definition {
  int id;
  String word;
  String definition;
  String example;
  Origin origin;

  Definition({
    required this.id,
    required this.word,
    required this.definition,
    required this.example,
    required this.origin,
  });

  Definition.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        word = map['word'],
        definition = map['definition'],
        example = map['example'],
        origin = (map['origin'] == 'created') ? Origin.created : Origin.downloaded;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'example': example,
      'origin': origin.name,
    };
  }
}
