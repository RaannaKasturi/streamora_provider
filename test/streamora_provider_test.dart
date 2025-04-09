import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/providers/two_embed.dart';

final List providers = [
  TwoEmbed(),
];

void main() async {
  final imdbID = "tt14513804";
  final mediaType = "movie";
  final title = "Captain America: Brave New World";
  final year = "2025";
  final season = null;
  final episode = null;
  List<VideoData> videoDataList = [];

  for (var provider in providers) {
    List<VideoData> response = await provider.scrape(
      imdbId: imdbID,
      mediaType: mediaType,
      title: title,
      year: year,
      season: season,
      episode: episode,
    );
    videoDataList.addAll(response);
  }
  for (var videoData in videoDataList) {
    print("\n\n\nVideo Source: ${videoData.videoSource}");
    print("Video Source URL: ${videoData.videoSourceUrl}");
  }
}
