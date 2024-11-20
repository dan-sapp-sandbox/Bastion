class Light {
  bool controllable;
  String device, deviceName, model;

  Light(
      {required this.controllable,
      required this.device,
      required this.deviceName,
      required this.model});

  factory Light.fromJSON(Map<String, dynamic> parsedJson) {
    return Light(
      controllable: parsedJson['controllable'],
      device: parsedJson['device'],
      deviceName: parsedJson['deviceName'],
      model: parsedJson['model'],
    );
  }
}
