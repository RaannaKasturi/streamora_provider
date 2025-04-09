import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/providers/auto_embed_1.dart';
import 'package:streamora_provider/providers/auto_embed_2.dart';
import 'package:streamora_provider/providers/embed.dart';
import 'package:streamora_provider/providers/two_embed.dart';
import 'package:streamora_provider/providers/vidsrc_su.dart';

final List providers = [
  AutoEmbed1(),
  AutoEmbed2(),
  TwoEmbed(),
  Embed(),
  VidsrcSu(),
];

void main() async {
  final imdbID = "tt15571732";
  final tmdbID = "138501";
  final mediaType = "tv";
  final title = "Agatha All Along";
  final year = "2024";
  final season = 1;
  final episode = 1;
  List<VideoData> videoDataList = [];

  for (var provider in providers) {
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
    print("Video Source: ${videoData.videoSource}");
    print("Video Source URL: ${videoData.videoSourceUrl}");
  }
}
