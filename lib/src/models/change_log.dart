class ChangeLogEntry {
  String change;
  int id;
  String timestamp;

  ChangeLogEntry(
      {required this.id, required this.change, required this.timestamp});

  factory ChangeLogEntry.fromJSON(Map<String, dynamic> parsedJson) {
    return ChangeLogEntry(
      change: parsedJson['change'],
      timestamp: parsedJson['timestamp'],
      id: parsedJson['id'],
    );
  }

  factory ChangeLogEntry.fromMap(Map<String, dynamic> map) {
    return ChangeLogEntry(
      id: map['id'],
      change: map['change'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'change': change,
      'timestamp': timestamp,
    };
  }
}
