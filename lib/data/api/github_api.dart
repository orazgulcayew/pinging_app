import 'package:dio/dio.dart';
import 'package:pinging/data/api/api_client.dart';

class GithubApi {
  ApiLoader getFile(
    String file, {
    ProgressCallback? onReceiveProgress,
  }) =>
      ApiLoader(
        path: "/$file",
        loader: (path) => ApiClient().dio.get(
              path,
              onReceiveProgress: onReceiveProgress,
            ),
      );

  ApiLoader auth({
    required String authKey,
    required String deviceId,
  }) =>
      ApiLoader(
        path: "https://duralga-next-vercel.vercel.app/api/auth",
        loader: (path) => Dio(baseOptions).get(path, queryParameters: {
          "key": authKey,
          "deviceId": "qwerty",
          // "deviceId": deviceId,
        }),
      );
}
