class VideoData {
  final String videoSource;
  final String videoSourceUrl;
  final Map<String, dynamic>? videoSourceHeaders;

  VideoData({
    required this.videoSource,
    required this.videoSourceUrl,
    this.videoSourceHeaders,
  });

  factory VideoData.fromMap(Map<String, dynamic> map) {
    return VideoData(
      videoSource: map['videoSource'] ?? '',
      videoSourceUrl: map['videoSourceUrl'] ?? '',
    );
  }
}
