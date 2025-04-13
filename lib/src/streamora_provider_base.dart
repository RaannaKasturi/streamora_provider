import 'package:streamora_provider/data/video_data.dart';
import 'package:streamora_provider/providers/auto_embed_1.dart';
import 'package:streamora_provider/providers/auto_embed_2.dart';
import 'package:streamora_provider/providers/embed.dart';
import 'package:streamora_provider/providers/netfree.dart';
import 'package:streamora_provider/providers/two_embed.dart';
import 'package:streamora_provider/providers/vidsrc_su.dart';
import 'package:streamora_provider/providers/vidzee.dart';

class StreamoraProvider {
  final List providers = [
    AutoEmbed1(),
    AutoEmbed2(),
    TwoEmbed(),
    Embed(),
    VidsrcSu(),
    Vidzee(),
    NetFree(),
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
