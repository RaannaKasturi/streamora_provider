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
  final imdbID = "tt14513804";
  final tmdbID = "822119";
  final mediaType = "movie";
  final title = "Captain America: Brave New World";
  final year = "2025";
  final season = null;
  final episode = null;
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
  print("-----" * 25);
  for (var videoData in videoDataList) {
    print("Video Source: ${videoData.videoSource}");
    print("Video Source URL: ${videoData.videoSourceUrl}");
    print("Video Source Headers: ${videoData.videoSourceHeaders}");
  }
}
