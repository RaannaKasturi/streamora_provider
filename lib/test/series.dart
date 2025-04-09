import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/providers/embed.dart';
import 'package:streamora_provider/providers/two_embed.dart';

final List providers = [
  TwoEmbed(),
  Embed(),
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
    print("\n\n\nVideo Source: ${videoData.videoSource}");
    print("Video Source URL: ${videoData.videoSourceUrl}");
  }
}
