import 'package:bloc/bloc.dart';
import 'package:cocktails/provider/cocktail_list_get.dart';
import 'package:meta/meta.dart';

import '../../models/notification_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final CocktailRepository notificationService;

  NotificationBloc(this.notificationService) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await notificationService.fetchNotifications();
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError('Failed to load notifications'));
      }
    });

    on<MarkNotificationsAsRead>((event, emit) async {
      try {
        // Отправляем POST-запрос для пометки уведомлений как прочитанных
        await notificationService.markAllAsRead();
      } catch (e) {
        emit(NotificationError('Failed to mark notifications as read'));
      }
    });
  }
}
