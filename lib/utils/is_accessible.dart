import 'package:dio/dio.dart';

Future<bool> isAccessible({
  required String url,
}) async {
  print("Checking URL: $url");
  if (url.isEmpty) return false;
  try {
    final response =
        await Dio().get(url, options: Options(followRedirects: true)).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        print("Request timed out for URL: $url");
        return Response(
          statusCode: 408,
          requestOptions: RequestOptions(path: url),
        );
      },
    );
    if (response.statusCode == 200) {
      print("PASS\n\n\n");
      return true;
    } else {
      print("FAIL\n\n\n");
      return false;
    }
  } catch (e) {
    print("Error: $e\n\n\n");
    return false;
  }
}
