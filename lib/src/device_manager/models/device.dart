class Device {
  String type, name;
  int id;
  bool isOn;

  Device(
      {required this.id,
      required this.type,
      required this.name,
      required this.isOn});

  factory Device.fromJSON(Map<String, dynamic> parsedJson) {
    return Device(
      isOn: parsedJson['isOn'],
      type: parsedJson['type'],
      name: parsedJson['name'],
      id: parsedJson['id'],
    );
  }
}
