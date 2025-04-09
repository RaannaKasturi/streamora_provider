import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:streamora_provider/data/video_data.dart';

class Vidzee {
  Future<List<VideoData>> scrape({
    required String imdbId,
    required String tmdbId,
    required String mediaType,
    required String title,
    required String year,
    final int? season,
    final int? episode,
  }) async {
    final baseUrl =
        "https://vidzee.wtf/$mediaType/player.php?id=$tmdbId${mediaType == 'tv' ? '&season=$season&episode=$episode' : ''}";
    final List<VideoData> videoDataList = [];
    final Dio dio = Dio();

    try {
      Response response = await dio.get(baseUrl);
      if (response.statusCode != 200) {
        return videoDataList;
      }
      final data = response.data.toString();
      List<dynamic> servers = jsonDecode(
          "${data.split("data-stream-sources='")[1].split("]'")[0]}]");
      for (var server in servers) {
        var videoLabel = server['label'];
        var videoUrl = server['url'];
        videoDataList.add(
          VideoData(
            videoSource: 'VIDZEE_${videoDataList.length + 1} ($videoLabel)',
            videoSourceUrl: videoUrl,
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
    }
    return videoDataList;
  }
}
