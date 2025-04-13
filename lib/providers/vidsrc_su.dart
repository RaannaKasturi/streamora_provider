import 'package:dio/dio.dart';
import 'package:streamora_provider/data/video_data.dart';

class VidsrcSu {
  List<String> extractUrls(String input) {
    final regex = RegExp(
        r"url:\s*'(https?://[^\']+)'"); // Match URLs starting with http or https
    final matches = regex.allMatches(input);
    return matches.map((match) => match.group(1)!).toList();
  }

  Future<List<VideoData>> scrape({
    required String imdbId,
    required String tmdbId,
    required String mediaType,
    required String title,
    required String year,
    int? season,
    int? episode,
  }) async {
    List<VideoData> videoDataList = [];
    final baseUrl = "https://vidsrc.su/embed";
    final headers = {
      'accept': '*/*',
    };

    final Dio dio = Dio();
    final path =
        "$baseUrl/${mediaType == "movie" ? "movie/$tmdbId" : "tv/$tmdbId/$season/$episode"}";
    print("Path: $path");
    Response response = await dio.get(path, options: Options(headers: headers));
    if (response.statusCode != 200) {
      return videoDataList;
    }
    List<String> servers = extractUrls(response.data
        .toString()
        .split("const fixedServers = ")[1]
        .split("];")[0]);
    for (var server in servers) {
      videoDataList.add(
        VideoData(
          videoSource: "VIDSRC_${videoDataList.length + 1}",
          videoSourceUrl: server,
        ),
      );
    }
    return videoDataList;
  }
}
