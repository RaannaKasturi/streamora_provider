import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/providers/auto_embed_1.dart';
import 'package:streamora_provider/providers/auto_embed_2.dart';
import 'package:streamora_provider/providers/two_embed.dart';

final List providers = [
  AutoEmbed1(),
  AutoEmbed2(),
  TwoEmbed(),
];

void main() async {
  final imdbID = "tt15571732";
  final mediaType = "tv";
  final title = "Agatha All Along";
  final year = "2024";
  final season = "1";
  final episode = "1";
  List<VideoData> videoDataList = [];

  for (var provider in providers) {
    final response = await provider.scrape(
      imdbID: imdbID,
      mediaType: mediaType,
      title: title,
      year: year,
      season: season,
      episode: episode,
    );
    videoDataList.addAll(response);
  }
  for (var videoData in videoDataList) {
    print("Video Source: ${videoData.videoSource}");
    print("Video Source URL: ${videoData.videoSourceUrl}");
  }
}
