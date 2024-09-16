import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../provider/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<UpdatePoints>(_onUpdatePoints);
  }

  // Обработка события FetchProfile
  Future<void> _onFetchProfile(
      FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await repository.fetchProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      print('Ошибка при загрузке профиля: $e');
      emit(ProfileError('Failed to fetch profile: ${e.toString()}'));
    }
  }

  void _onUpdatePoints(UpdatePoints event, Emitter<ProfileState> emit) async {
    try {
      final points = await repository.fetchPointsFromServer();
      if (state is ProfileLoaded && points != null) {
        final updatedProfile =
            Map<String, dynamic>.from((state as ProfileLoaded).profileData);
        updatedProfile['points'] = points;
        emit(ProfileLoaded(updatedProfile));
      }
    } catch (e) {
      emit(ProfileError('Failed to update points: ${e.toString()}'));
    }
  }
}
