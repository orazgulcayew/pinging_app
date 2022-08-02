// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'address_manager_cubit.dart';

class AddressManagerState extends Equatable {
  final List<SstpDataModel> addresses;
  final List<SstpDataModel> history;
  final double pingingProgress;

  const AddressManagerState({
    required this.addresses,
    required this.history,
    this.pingingProgress = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'addresses': addresses.map((e) => e.toMap()).toList(),
      'history': history.map((e) => e.toMap()).toList(),
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
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressManagerState.fromJson(String source) =>
      AddressManagerState.fromMap(json.decode(source));

  @override
  List<Object> get props => [addresses, pingingProgress];

  AddressManagerState copyWith({
    List<SstpDataModel>? addresses,
    List<SstpDataModel>? history,
    double? pingingProgress,
  }) {
    return AddressManagerState(
      addresses: addresses ?? this.addresses,
      history: history ?? this.history,
      pingingProgress: pingingProgress ?? this.pingingProgress,
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
