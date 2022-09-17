import 'package:dio/dio.dart';
import 'package:pinging/data/api/github_api.dart';
import 'package:pinging/data/models/file_meta.dart';
import 'package:pinging/data/models/sstp_data.dart';

class GithubRepository {
  Future<Iterable<SstpFileMeta>> getListOfFiles() async {
    final apiLoader = GithubApi().getFile("files.json");

    final data = await apiLoader.dataLoader();

    return (data as Iterable).map<SstpFileMeta>((e) => SstpFileMeta.fromMap(e));
  }

  Future<Iterable<SstpDataModel>> getSstpsByFileName(
    String file, {
    ProgressCallback? onReceiveProgress,
  }) async {
    final apiLoader = GithubApi().getFile(
      file,
      onReceiveProgress: onReceiveProgress,
    );

    final data = await apiLoader.dataLoader();

    return (data as Iterable)
        // .whereType<Map<String, dynamic>>()
        .map<SstpDataModel>((e) => SstpDataModel.fromMap(e));
  }
}
