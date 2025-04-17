import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/providers/two_embed.dart';
import 'package:streamora_provider/providers/vidsrc_su.dart';
import 'package:streamora_provider/providers/vidzee.dart';

final List providers = [
  TwoEmbed(),
  VidsrcSu(),
  Vidzee(),
];

void main() async {
  final imdbID = "tt7235466";
  final tmdbID = "75219";
  final mediaType = "tv";
  final title = "911";
  final year = "2018";
  final season = 8;
  final episode = 11;
  List<VideoData> videoDataList = [];

  for (var provider in providers) {
    print("Provider: ${provider.runtimeType}");
    try {
      List<VideoData> response = await provider.scrape(
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
  }
  for (var videoData in videoDataList) {
    print("\n\n\nVideo Source: ${videoData.videoSource}");
    print("Video Source URL: ${videoData.videoSourceUrl}");
  }
}
