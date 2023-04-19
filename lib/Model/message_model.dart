class Message {
  String? type; // "image", "audio", or "text"
  dynamic data; // image file, audio file, or text message
  String? sender;
  DateTime timestamp;

  Message({
    this.type,
    required this.data,
    this.sender,
    required this.timestamp,
  });
}
