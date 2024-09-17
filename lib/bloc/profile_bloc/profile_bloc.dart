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
  }

  Future<void> _onFetchProfile(
      FetchProfile event, Emitter<ProfileState> emit) async {
    try {
      // Загружаем профиль из кэша
      final cachedProfile = await repository.getProfileFromCache();

      if (cachedProfile != null) {
        emit(ProfileLoaded(
            cachedProfile)); // Сначала отображаем кэшированные данные
      }

      // Загружаем данные с сервера и обновляем кэш
      final profileData =
          await repository.fetchProfileDataFromServer(forceRefresh: true);
      emit(ProfileLoaded(profileData)); // Обновляем данные после запроса
    } catch (e) {
      print('Ошибка при загрузке профиля: $e');
      emit(ProfileError('Failed to fetch profile: ${e.toString()}'));
    }
  }
}
