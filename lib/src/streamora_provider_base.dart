import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/providers/embed.dart';
import 'package:streamora_provider/providers/two_embed.dart';
import 'package:streamora_provider/providers/vidzee.dart';

class StreamoraProvider {
  final List providers = [
    TwoEmbed(),
    Embed(),
    Vidzee(),
  ];

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
    for (var provider in providers) {
      List<VideoData> response = await provider.scrape(
        imdbId: imdbId,
        tmdbId: tmdbId,
        mediaType: mediaType,
        title: title,
        year: year,
        season: season,
        episode: episode,
      );
      videoDataList.addAll(response);
    }
    return videoDataList;
  }
}
