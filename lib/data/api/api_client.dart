import 'package:dio/dio.dart';

final baseOptions = BaseOptions(
  sendTimeout: 30 * 1000,
);

final localOptions = baseOptions.copyWith(
  baseUrl: "https://atageldi194229.github.io/pinging-server",
  // baseUrl: "https://github.com/atageldi194229/pinging-server/raw/main/data",
);

class ApiClient {
  late final Dio dio;
  ApiClient._sharedInstance() : dio = Dio(localOptions);
  static final ApiClient _shared = ApiClient._sharedInstance();
  factory ApiClient() => _shared;
}

class ApiLoader {
  final String path;
  late Future<Response> Function() loader;

  ApiLoader({
    required this.path,
    required Future<Response> Function(String path) loader,
  }) {
    this.loader = () => loader(path);
  }

  Future<dynamic> dataLoader() => loader().then((res) => res.data);
}
