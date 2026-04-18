import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class FetchStoreProfile extends ProfileEvent {
  const FetchStoreProfile();

  @override
  List<Object?> get props => [];
}

class LogoutPressed extends ProfileEvent {
  const LogoutPressed();

  @override
  List<Object?> get props => [];
}

class LaunchZedSection extends ProfileEvent {
  final String url;

  const LaunchZedSection({required this.url});

  @override
  List<Object?> get props => [url];
}

