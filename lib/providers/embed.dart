import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/utils/is_accessible.dart';

class Embed {
  final headers = {
    "Referer": "https://embed.su",
    "Origin": "https://embed.su",
    "Host": "embed.su",
  };
  final String baseUrl = "https://embed.su";
  final Dio dio = Dio();

  Future<String> stringAtob(String input) async {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
    final str = input.replaceAll("=+\$", '');
    var output = '';
    if (str.length % 4 == 1) {
      throw FormatException(
          "'atob' failed: The string to be decoded is not correctly encoded.");
    }
    var bc = 0;
    var bs = 0;
    int? buffer;
    for (var i = 0; i < str.length; i++) {
      buffer = chars.indexOf(str[i]);
      if (buffer == -1) continue;
      bs = bc % 4 != 0 ? bs * 64 + buffer : buffer;
      if (bc++ % 4 != 0) {
        output += String.fromCharCode(255 & (bs >> (-2 * bc & 6)));
      }
    }
    return output;
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
    try {
      final url =
          "$baseUrl/embed/${mediaType == 'movie' ? 'movie' : 'tv'}/$tmdbId${mediaType == 'tv' ? '/$season/$episode' : ''}";
      Response response = await dio.get(
        url,
        options: Options(
          headers: headers,
          followRedirects: true,
        ),
      );
      final encodedMessage =
          response.data.toString().split("atob(`")[1].split("`));")[0];
      final hash = jsonDecode(
          String.fromCharCodes(base64.decode(encodedMessage)))['hash'];
      List<String> firstDecode;
      try {
        firstDecode = (await stringAtob(hash))
            .split(".")
            .map((item) => String.fromCharCodes(item.codeUnits.reversed))
            .toList();
      } catch (e) {
        return videoDataList;
      }

      List<dynamic> secondDecode;
      try {
        final joinedReversed = firstDecode.join("");
        final reversedString =
            String.fromCharCodes(joinedReversed.codeUnits.reversed);
        secondDecode = jsonDecode(await stringAtob(reversedString));
      } catch (e) {
        return videoDataList;
      }
      if (secondDecode.isEmpty) {
        return videoDataList;
      }
      for (var items in secondDecode) {
        Response response = await dio.get(
          "$baseUrl/api/e/${items['hash']}",
          options: Options(
            headers: headers,
            followRedirects: true,
          ),
        );
        final streamURL = response.data['source'];
        print("\n\n\nVideo Source: EMBED");
        if (await isAccessible(url: streamURL, headers: headers)) {
          videoDataList.add(
            VideoData(
              videoSource: "EMBED_${videoDataList.length + 1}",
              videoSourceUrl: streamURL,
              videoSourceHeaders: headers,
            ),
          );
        } else {
          continue;
        }
      }
    } catch (e) {
      print("Exception: $e");
    }
    return videoDataList;
  }
}

void main() async {
  final imdbID = "tt14513804";
  final tmdbID = "822119";
  final mediaType = "movie";
  final title = "Captain America: Brave New World";
  final year = "2025";
  final season = null;
  final episode = null;
  List<VideoData> videoDataList = [];
  videoDataList = await Embed().scrape(
    imdbId: imdbID,
    tmdbId: tmdbID,
    mediaType: mediaType,
    title: title,
    year: year,
    season: season,
    episode: episode,
  );
  for (var videoData in videoDataList) {
    print("\n\n\nVideo Source: ${videoData.videoSource}");
    print("Video Source URL: ${videoData.videoSourceUrl}");
  }
}
