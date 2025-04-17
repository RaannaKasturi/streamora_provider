import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/utils/is_accessible.dart';

class TwoEmbed {
  final Dio dio = Dio();
  final List<VideoData> videoDataList = [];
  final String baseUrl = "https://uqloads.xyz/e/";
  final headers = {
    'Origin': 'uqloads.xyz',
    'Referer': 'https://streamsrcs.2embed.cc/',
  };

  Future<String?> getStreamId(
      String imdbId, String mediaType, String title, String year,
      {int? season, int? episode}) async {
    String url = "https://www.2embed.cc/embed/";
    if (mediaType == "tv" && season != null && episode != null) {
      url += "$imdbId/season-$season-episode-$episode";
    } else {
      url += imdbId;
    }

    final response = await dio.get(url, options: Options(headers: headers));
    if (response.statusCode == 200) {
      final soup = BeautifulSoup(response.data);
      final iframe = soup.find('iframe');
      print("Iframe: $iframe");
      final dataSrc = iframe?.attributes['data-src'];
      if (dataSrc != null) {
        print("Data Source: $dataSrc");
        final streamId = dataSrc.split("?id=")[1].split("&")[0];
        print("Stream ID: $streamId");
        return streamId;
      }
    } else {
      return null;
    }
    return null;
  }

  String intToBase(int x, int base) {
    const digits = '0123456789abcdefghijklmnopqrstuvwxyz';
    if (x < 0) return '-${intToBase(-x, base)}';
    if (x < base) return digits[x];
    return intToBase(x ~/ base, base) + digits[x % base];
  }

  String jsObfuscationReplacer(String p, int a, int c, List<String> k) {
    for (int i = c - 1; i >= 0; i--) {
      if (k[i].isNotEmpty) {
        String baseA = intToBase(i, a);
        p = p.replaceAll(RegExp('\\b$baseA\\b'), k[i]);
      }
    }
    return p;
  }

  Map<String, dynamic> getPack(String packed) {
    final p = "${packed.split("}',")[0]}'}";
    final k = "|${packed.split(",'|")[1].split("'.split")[0]}";
    final ac = packed.split("}',")[1].split(",'|")[0];
    final a = int.parse(ac.split(",")[0]);
    final c = int.parse(ac.split(",")[1]);
    final keyList = k.split("|");
    return {"p": p, "a": a, "c": c, "k": keyList};
  }

  String? extractVideoSource(String htmlContent) {
    final soup = BeautifulSoup(htmlContent);
    final scriptTags = soup.findAll('script');

    for (var script in scriptTags) {
      final scriptText = script.string;
      if (scriptText.isNotEmpty &&
          scriptText.trim().startsWith("eval(function(p,a,c,k,e,d)")) {
        final pack = getPack(scriptText);
        final p = pack['p'];
        final a = pack['a'];
        final c = pack['c'];
        final k = List<String>.from(pack['k']);
        final deobfuscated = jsObfuscationReplacer(p, a, c, k);
        final streamUrl = jsonDecode(deobfuscated
            .split("var links=")[1]
            .split(";jwplayer")[0]
            .trim()
            .toString());
        for (var entry in streamUrl.entries) {
          final value = entry.value;
          if (value is List) {
            for (var item in value) {
              if (item.toString().startsWith("http")) {
                final videoUrl = item.toString();
                if (videoUrl.isNotEmpty) {
                  return videoUrl;
                }
              }
            }
          } else if (value.toString().startsWith("http")) {
            final videoUrl = value.toString();
            if (videoUrl.isNotEmpty) {
              return videoUrl;
            }
          }
        }
      }
    }
    return null;
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
    try {
      final streamId = await getStreamId(tmdbId, mediaType, title, year,
          season: season, episode: episode);
      if (streamId != null) {
        final url = "$baseUrl$streamId";
        final response = await dio.get(
          url,
          options: Options(
            headers: headers,
          ),
        );

        final source = extractVideoSource(response.data);
        print("\n\n\nVideo Source: 2EMBED");
        if (source != null &&
            await isAccessible(url: source) &&
            !videoDataList.any((element) => element.videoSourceUrl == source)) {
          videoDataList.add(
            VideoData(
              videoSource: "2EMBED_${videoDataList.length + 1}",
              videoSourceUrl: source,
            ),
          );
        } else {
          return videoDataList;
        }
      }
    } catch (e) {
      print("Error: $e");
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

  TwoEmbed twoEmbed = TwoEmbed();
  final data = twoEmbed.scrape(
    imdbId: imdbID,
    tmdbId: tmdbID,
    mediaType: mediaType,
    title: title,
    year: year,
    season: season,
    episode: episode,
  );
  print("Stream ID: $data");
}
