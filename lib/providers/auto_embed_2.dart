import 'package:dio/dio.dart';
import 'package:streamora_provider/data/video_data.dart';

class AutoEmbed2 {
  final List<VideoData> videoDataList = [];
  final String baseUrl = "https://hin.autoembed.cc/api/getVideoSource";
  final String decryptUrl = "https://hin.autoembed.cc/api/decryptVideoSource";

  final Dio dio = Dio(
    BaseOptions(
      headers: {
        'Referer': 'https://hin.autoembed.cc/',
        'Origin': 'https://hin.autoembed.cc',
      },
    ),
  );

  Future<List<VideoData>> scrape({
    required String imdbId,
    required String mediaType,
    required String title,
    required String year,
    int? season,
    int? episode,
  }) async {
    try {
      String finalUrl = "$baseUrl?type=$mediaType&id=$imdbId";
      if (mediaType == "tv" && season != null && episode != null) {
        finalUrl += "/$season/$episode";
      }
      final encodedResponse = await dio.get(finalUrl);
      final encodedData = encodedResponse.data;
      final decryptedResponse = await dio.post(
        decryptUrl,
        data: encodedData,
      );
      final data = decryptedResponse.data;
      if (data is Map<String, dynamic> && data.containsKey("audioTracks")) {
        final List<dynamic> audioTracks = data["audioTracks"];
        for (var track in audioTracks) {
          if (track is Map<String, dynamic>) {
            final label = track["label"] ?? "Unknown";
            final fileUrl = track["file"];
            if (fileUrl != null &&
                !videoDataList
                    .any((element) => element.videoSourceUrl == fileUrl)) {
              videoDataList.add(
                VideoData(
                  videoSource:
                      "AUTOEMBED2_${videoDataList.length + 1} ($label)",
                  videoSourceUrl: fileUrl,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    }

    return videoDataList;
  }
}
