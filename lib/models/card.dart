enum Origin { created, downloaded }

class Card {
  int id;
  String front;
  String back;
  Origin origin;
  int? n;
  double? eFactor;
  double? interval;
  double? lastStudyTime;

  Card({
    required this.id,
    required this.front,
    required this.back,
    required this.origin,
    this.n,
    this.eFactor,
    this.interval,
    this.lastStudyTime,
  });

  Card.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        front = map['front'],
        back = map['back'],
        origin =
            (map['origin'] == 'created') ? Origin.created : Origin.downloaded,
        n = map['n'],
        eFactor = map['eFactor'],
        interval = map['interval'],
        lastStudyTime = map['lastStudyTime'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front': front,
      'back': back,
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
