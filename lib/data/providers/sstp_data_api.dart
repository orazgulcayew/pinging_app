import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class SstpDataApi {
  Future<String> getAllHosts() async {
    var response = await http.get(Uri.parse(
        "https://friendly-sprinkles-21ed57.netlify.app/.netlify/functions/server/gate"));

    return response.body;
  }

  Future<String> getAllHosts2() async {
    var response = await http
        .get(Uri.parse("https://duralga-next-vercel.vercel.app/api/key_req_2"));

    return response.body;
  }

  Future<String> getAllHosts3({
    void Function(int, int)? onReceiveProgress,
  }) async {
    var response = await Dio().get<String>(
      "https://duralga-next-vercel.vercel.app/api/key_req_2",
      onReceiveProgress: onReceiveProgress,
    );

    return response.data ?? "";
  }
}
