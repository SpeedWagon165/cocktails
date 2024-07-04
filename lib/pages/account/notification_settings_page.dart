import 'package:cocktails/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/notification_settings_bloc/notification_settings_bloc.dart';
import '../../widgets/account/custom_switch.dart';
import '../../widgets/custom_arrowback.dart';

class NotificationSetupPage extends StatefulWidget {
  const NotificationSetupPage({super.key});

  @override
  State<NotificationSetupPage> createState() => NotificationSetupPageState();
}

class NotificationSetupPageState extends State<NotificationSetupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(children: [
            const CustomArrowBack(
              text: 'Уведомления',
              arrow: true,
              auth: false,
              onPressed: null,
            ),
            const SizedBox(
              height: 42,
            ),
            BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
              builder: (context, state) {
                return Column(
                  children: [
                    _buildCustomSwitch(
                      context,
                      'Разрешить текстовые сообщения на телефоне',
                      state.smsNotificationsEnabled,
                      (value) {
                        context
                            .read<NotificationSettingsBloc>()
                            .add(ToggleSmsNotificationEvent());
                      },
                      activeColor: Color(0xFFFFBA08),
                    ),
                    _buildCustomSwitch(
                      context,
                      'Пуш уведомления',
                      state.pushNotificationsEnabled,
                      (value) {
                        context
                            .read<NotificationSettingsBloc>()
                            .add(TogglePushNotificationEvent());
                      },
                      activeColor: Color(0xFF6C6C6C),
                    ),
                  ],
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}

Widget _buildCustomSwitch(
  BuildContext context,
  String text,
  bool value,
  ValueChanged<bool> onChanged, {
  required Color activeColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            style: context.text.bodyText16White.copyWith(fontSize: 15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 80.0),
          child: CustomSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ),
      ],
    ),
  );
}
