import 'package:dio/dio.dart';

void main() async {
  final headers = {
    "Referer": "https://embed.su",
    "Origin": "https://embed.su",
    // "Host": "embed.su",
  };
  Response response = await Dio().get(
    "https://embed.su/api/proxy/viper/gentlebreeze85.xyz/file2/n32vQu2kTV8hhDb3JLkrdfqjSLxMQ8upG7W11jhGtDoHjriOiKMvS30YjIFIdv5aFgnJibm3d+UYL6O~04ju9xRZLIDm9QSVd~pkIqbhHClumW8FPLzc72pcb5JG+x87tUKegIZlSGG7t682Y4+NKn~GlUXKXHljKHDaD3QzoY4=/MTA4MA==/aW5kZXgubTN1OA==.m3u8",
    options: Options(
      headers: headers,
    ),
  );
  print(response);
  print(response.data.toString());
}
