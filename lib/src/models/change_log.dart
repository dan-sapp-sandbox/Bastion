class ChangeLogEntry {
  String change, timestamp, changeType;
  int id;

  ChangeLogEntry(
      {required this.id,
      required this.change,
      required this.changeType,
      required this.timestamp});

  factory ChangeLogEntry.fromJSON(Map<String, dynamic> parsedJson) {
    return ChangeLogEntry(
      changeType: parsedJson['changeType'],
      change: parsedJson['change'],
      timestamp: parsedJson['timestamp'],
      id: parsedJson['id'],
    );
  }

  factory ChangeLogEntry.fromMap(Map<String, dynamic> map) {
    return ChangeLogEntry(
      id: map['id'],
      change: map['change'],
      changeType: map['changeType'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'change': change,
      'changeType': changeType,
      'timestamp': timestamp,
    };
  }
}
