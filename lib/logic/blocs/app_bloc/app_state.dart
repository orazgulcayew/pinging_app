part of 'app_bloc.dart';

@immutable
abstract class AppState {}

@immutable
class AppStateInitialPingingProgress extends AppState {
  final int chunkCount;
  AppStateInitialPingingProgress(this.chunkCount);
}

@immutable
class AppStateSstpFileChecked extends AppState {
  final dynamic key;
  final bool value;

  AppStateSstpFileChecked({
    required this.key,
    required this.value,
  });
}

@immutable
class AppStatePingingProgress extends AppState {
  final int process;
  final ProgressStatus progress;

  AppStatePingingProgress({
    required this.process,
    required this.progress,
  });
}

@immutable
class AppStateUniqueProgress extends AppState {
  final dynamic key;
  final ProgressStatus progress;

  AppStateUniqueProgress({
    required this.key,
    required this.progress,
  });
}

@immutable
class AppStateAppBarProgress extends AppState {
  final ProgressStatus progress;
  AppStateAppBarProgress(this.progress);
}

@immutable
class AppStateUnlock extends AppState {}

@immutable
class AppStateLock extends AppState {}

@immutable
class AppStateFiles extends AppState {
  final Iterable<SstpFileMeta> files;
  final Iterable<SstpFileMeta> cached;
  AppStateFiles(this.files, this.cached);
}

@immutable
class AppStateSstps extends AppState {
  final Iterable<SstpDataModel> sstps;
  AppStateSstps(this.sstps);
}

@immutable
class AppStateHistory extends AppStateSstps {
  AppStateHistory(super.sstps);
}

@immutable
class AppInitial extends AppState {}
