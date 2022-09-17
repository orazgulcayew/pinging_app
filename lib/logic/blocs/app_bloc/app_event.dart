part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

@immutable
class AppEventLoad extends AppEvent {}

@immutable
class AppEventLoadFiles extends AppEvent {}

@immutable
class AppEventAuth extends AppEvent {
  final String authKey;
  AppEventAuth(this.authKey);
}

@immutable
class AppEventGhFile extends AppEvent {
  final List<SstpFileMeta> files;
  final int index;
  AppEventGhFile(this.files, this.index);

  SstpFileMeta get file => files[index];
}

@immutable
class AppEventDownloadGhFile extends AppEventGhFile {
  AppEventDownloadGhFile(super.files, super.index);
}

@immutable
class AppEventToggleGhFile extends AppEventGhFile {
  AppEventToggleGhFile(super.files, super.index);
}

@immutable
class AppEventDeleteGhFile extends AppEventGhFile {
  AppEventDeleteGhFile(super.files, super.index);
}

@immutable
class AppEventPing extends AppEvent {}
