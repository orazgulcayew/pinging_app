import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppError {
  final String title;
  final String description;

  const AppError({
    required this.title,
    required this.description,
  });
}

@immutable
class LoadError extends AppError {
  const LoadError()
      : super(
          title: "Load error",
          description: "Maybe internet connection error",
        );
}

@immutable
class DioLoadError extends AppError {
  const DioLoadError(String description)
      : super(
          title: "Load error",
          description: description,
        );
}

@immutable
class DeviceIdAccessError extends AppError {
  const DeviceIdAccessError()
      : super(
          title: "Access error",
          description: "Could not get device id",
        );
}
