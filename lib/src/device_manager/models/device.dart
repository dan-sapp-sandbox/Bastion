class Device {
  String type, name;

  Device({required this.type, required this.name});

  factory Device.fromJSON(Map<String, dynamic> parsedJson) {
    return Device(
      type: parsedJson['type'],
      name: parsedJson['name'],
    );
  }
}
