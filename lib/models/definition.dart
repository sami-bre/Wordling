enum Origin { created, downloaded }

class Definition {
  int id;
  String word;
  String definition;
  String example;
  Origin origin;
  int? n;
  double? eFactor;
  double? interval;
  double? lastStudyTime;

  Definition({
    required this.id,
    required this.word,
    required this.definition,
    required this.example,
    required this.origin,
    this.n,
    this.eFactor,
    this.interval,
    this.lastStudyTime,
  });

  Definition.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        word = map['word'],
        definition = map['definition'],
        example = map['example'],
        origin =
            (map['origin'] == 'created') ? Origin.created : Origin.downloaded,
        n = map['n'],
        eFactor = map['eFactor'],
        interval = map['interval'],
        lastStudyTime = map['lastStudyTime'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'example': example,
      'origin': origin.name,
      'n': n,
      'eFactor': eFactor,
      'interval': interval,
      'lastStudyTime': lastStudyTime,
    };
  }

  double? get intervalInDays {
    // 86400000 is the number of millisecons in a day.
    return (interval != null) ? interval! / 86400000 : null;
  }
}
