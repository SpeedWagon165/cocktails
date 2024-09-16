part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdatePoints extends ProfileEvent {}

class FetchProfile extends ProfileEvent {}
