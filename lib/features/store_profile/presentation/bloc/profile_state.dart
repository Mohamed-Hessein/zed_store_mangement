import 'package:equatable/equatable.dart';
import 'package:zed_store_mangent/features/store_profile/domain/entity/store_profile_entity.dart';

enum ProfileStatus { initial, loading, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final StoreProfileEntity? storeProfile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.storeProfile,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    StoreProfileEntity? storeProfile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      storeProfile: storeProfile ?? this.storeProfile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, storeProfile, errorMessage];
}

