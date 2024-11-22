class Device {
  String type, name;
  int id;

  Device({required this.id, required this.type, required this.name});

  factory Device.fromJSON(Map<String, dynamic> parsedJson) {
    return Device(
      type: parsedJson['type'],
      name: parsedJson['name'],
      id: parsedJson['id'],
    );
  }
}
