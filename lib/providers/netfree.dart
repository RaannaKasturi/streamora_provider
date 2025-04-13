import 'package:dio/dio.dart';
import 'package:streamora_provider/data/video_data.dart';

class NetFree {
  final baseUrl = "https://netfree.cc";
  final List<VideoData> videoDataList = [];
  final Dio dio = Dio();

  Future<void> getHeaders() async {
    try {
      Response response = await dio.get("https://netmirror.8man.me/api/cookie");
      if (response.statusCode == 200) {
        final data = response.data;
        if (data["cookie"] != null) {
          final cookie = data["cookie"].toString().replaceAll("Asu", "Ani");
          dio.options.headers = {
            "cookie": cookie,
          };
        } else {
          print("Cookie not found in API response");
        }
      } else {
        print("Failed to fetch headers: ${response.statusCode}");
      }
    } catch (e) {
      print("Netfree Headers Error: $e");
    }
  }

  Future<String> getId({required String title}) async {
    String movieId = "";
    try {
      Response response = await dio.get("$baseUrl/mobile/search.php?s=$title");
      Map data = response.data;
      if (data["status"] != "y") {
        return movieId;
      }
      List<dynamic> results = data["searchResult"];
      return results[0]["id"].toString();
    } catch (e) {
      print("Netfree Search Error: $e");
    }
    return movieId;
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
    await getHeaders();
    String movieId = await getId(title: title);
    if (movieId.isEmpty) {
      print("Movie ID not found for title: $title");
      return videoDataList;
    }
    Response response =
        await dio.get("$baseUrl/mobile/playlist.php?id=$movieId");
    if (response.statusCode != 200) {
      print("Failed to fetch video data: ${response.statusCode}");
      return videoDataList;
    }
    final sources = response.data[0]['sources'];
    for (Map source in sources) {
      videoDataList.add(
        VideoData(
          videoSource:
              "NETFREE_${videoDataList.length + 1} (${source["label"]}) Multi-Lang",
          videoSourceUrl: "$baseUrl${source['file']}",
        ),
      );
    }
    return videoDataList;
  }
}

void main() async {
  final imdbID = "tt14513804";
  final tmdbID = "822119";
  final mediaType = "movie";
  final title = "Dhoom Dhaam";
  final year = "2025";
  final season = null;
  final episode = null;
  List<VideoData> videoDataList = [];
  final netFree = NetFree();

  try {
    List<VideoData> response = await netFree.scrape(
      imdbId: imdbID,
      tmdbId: tmdbID,
      mediaType: mediaType,
      title: title,
      year: year,
      season: season,
      episode: episode,
    );
    videoDataList.addAll(response);
  } catch (e) {
    print("Error: $e");
  }

  print("-----" * 25);
  for (var videoData in videoDataList) {
    print("Video Source: ${videoData.videoSource}");
    print("Video Source URL: ${videoData.videoSourceUrl}");
    print("Video Source Headers: ${videoData.videoSourceHeaders}");
  }
}
