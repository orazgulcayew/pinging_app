part of 'address_manager_cubit.dart';

class AddressManagerState extends Equatable {
  final String authKey;
  final List<SstpDataModel> addresses;
  final List<SstpDataModel> history;
  final double pingingProgress;
  final AppError? error;
  final String? deviceId;
  final bool isLoading;
  final int lastRequestedTime;

  const AddressManagerState({
    required this.addresses,
    required this.history,
    this.authKey = '',
    this.pingingProgress = 0,
    this.error,
    this.deviceId,
    this.isLoading = false,
    this.lastRequestedTime = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'addresses': addresses.map((e) => e.toMap()).toList(),
      'history': history.map((e) => e.toMap()).toList(),
      'authKey': authKey,
      'deviceId': deviceId,
      'lastRequestedTime': lastRequestedTime,
    };
  }

  factory AddressManagerState.fromMap(Map<String, dynamic>? map) {
    if (map == null) return AddressManagerInitial();

    return AddressManagerState(
      addresses: List.of(map['addresses'])
          .map((e) => SstpDataModel.fromMap(e))
          .toList(),
      history:
          List.of(map['history']).map((e) => SstpDataModel.fromMap(e)).toList(),
      authKey: map['authKey'],
      deviceId: map['deviceId'],
      lastRequestedTime: map['lastRequestedTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressManagerState.fromJson(String source) =>
      AddressManagerState.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        addresses,
        pingingProgress,
        history,
        authKey,
        error,
        deviceId,
        isLoading,
        lastRequestedTime,
      ];

  AddressManagerState copyWith({
    List<SstpDataModel>? addresses,
    List<SstpDataModel>? history,
    double? pingingProgress,
    String? authKey,
    AppError? error,
    String? deviceId,
    bool? isLoading,
    int? lastRequestedTime,
  }) {
    return AddressManagerState(
      authKey: authKey ?? this.authKey,
      addresses: addresses ?? this.addresses,
      history: history ?? this.history,
      pingingProgress: pingingProgress ?? this.pingingProgress,
      error: error ?? this.error,
      deviceId: deviceId ?? this.deviceId,
      isLoading: isLoading ?? this.isLoading,
      lastRequestedTime: lastRequestedTime ?? this.lastRequestedTime,
    );
  }
}

class AddressManagerInitial extends AddressManagerState {
  AddressManagerInitial()
      : super(
          addresses: [],
          history: [],
        );
}
