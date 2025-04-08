class VideoData {
  final String videoSource;
  final String videoSourceUrl;

  VideoData({
    required this.videoSource,
    required this.videoSourceUrl,
  });

  factory VideoData.fromMap(Map<String, dynamic> map) {
    return VideoData(
      videoSource: map['videoSource'] ?? '',
      videoSourceUrl: map['videoSourceUrl'] ?? '',
    );
  }
}
