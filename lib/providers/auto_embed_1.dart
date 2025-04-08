import 'package:dio/dio.dart';
import 'package:streamora_provider/data/video_data.dart';

class AutoEmbed1 {
  final List<VideoData> videoDataList = [];
  final String baseUrl = "https://nono.autoembed.cc/api/getVideoSource";
  final String decryptUrl = "https://nono.autoembed.cc/api/decryptVideoSource";

  final Dio dio = Dio(
    BaseOptions(
      headers: {
        'Referer': 'https://nono.autoembed.cc',
        'Origin': 'https://nono.autoembed.cc',
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
      final videoSource = decryptedResponse.data['videoSource'];
      if (videoSource != null &&
          !videoDataList
              .any((element) => element.videoSourceUrl == videoSource)) {
        videoDataList.add(
          VideoData(
            videoSource: "AUTOEMBED1_${videoDataList.length + 1}",
            videoSourceUrl: videoSource,
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
    return videoDataList;
  }
}
