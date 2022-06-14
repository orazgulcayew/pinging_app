import 'package:http/http.dart' as http;

class SstpDataApi {
  Future<String> getAllHosts() async {
    var response = await http.get(Uri.parse(
        "https://friendly-sprinkles-21ed57.netlify.app/.netlify/functions/server/gate"));

    return response.body;
  }
}
