import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/cocktail_auth_repository.dart';

part 'app_start_event.dart';
part 'app_start_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository authRepository;

  AppBloc(this.authRepository) : super(AppInitial()) {
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    final isAuthenticated = await _checkAuthStatus();
    if (isAuthenticated) {
      emit(AppAuthenticated());
    } else {
      emit(AppUnauthenticated());
    }
  }

  Future<bool> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }
}
