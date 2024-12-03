class Device {
  String type, name, room;
  int id;
  bool isOn;

  Device(
      {required this.id,
      required this.type,
      required this.name,
      required this.room,
      required this.isOn});

  factory Device.fromJSON(Map<String, dynamic> parsedJson) {
    return Device(
      isOn: parsedJson['isOn'],
      type: parsedJson['type'],
      name: parsedJson['name'],
      room: parsedJson['room'],
      id: parsedJson['id'],
    );
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      room: map['room'],
      isOn: map['isOn'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'room': room,
      'type': type,
      'isOn': isOn,
    };
  }
}
