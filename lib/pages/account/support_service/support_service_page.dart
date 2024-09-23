import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../models/message_model.dart';
import '../../../utilities/data_formater.dart';
import '../../../widgets/account/chat_bubble.dart';
import '../../../widgets/custom_arrowback.dart';

class SupportServicePage extends StatefulWidget {
  final int userId;

  const SupportServicePage({super.key, required this.userId});

  @override
  State<SupportServicePage> createState() => SupportServicePageState();
}

class SupportServicePageState extends State<SupportServicePage> {
  final TextEditingController _messageController = TextEditingController();
  WebSocketChannel? _channel;
  bool _isConnected = false;
  List<Message> _messages = [];

  final ScrollController _scrollController =
      ScrollController(); // Контроллер для списка сообщений

  @override
  void initState() {
    super.initState();
    _connectWebSocket(); // Подключаем WebSocket при инициализации
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose(); // Освобождаем ресурсы контроллера списка
    _disconnectWebSocket(); // Закрываем соединение при удалении виджета
    super.dispose();
  }

  void _connectWebSocket() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(
            'ws://109.71.246.251:8000/ws/support/?user_id=${widget.userId}'),
      );
      _isConnected = true;
      print("Соединение установлено");

      // Слушаем поток WebSocket для получения сообщений
      _channel!.stream.listen((data) {
        print("Получены данные: $data");
        final decodedData = jsonDecode(data);

        if (decodedData['type'] == 'chat_history') {
          // Обрабатываем историю чата
          List<Message> messages = (decodedData['history'] as List)
              .map((msg) => Message.fromJson(msg))
              .toList();
          setState(() {
            _messages = messages;
          });

          // Прокручиваем вниз после загрузки истории чата
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom(); // Прокручиваем к последнему сообщению
          });
        } else if (decodedData['type'] == 'new_message') {
          // Обрабатываем новое сообщение
          Message newMessage = Message.fromJson(decodedData);
          setState(() {
            _messages.add(newMessage);
            _scrollToBottom(); // Прокручиваем вниз при новом сообщении
          });
        }
      });
    } catch (e) {
      _isConnected = false;
      print("Ошибка при подключении: $e");
    }
  }

  void _disconnectWebSocket() {
    if (_channel != null) {
      _channel!.sink.close(1000, 'Normal closure');
      _isConnected = false;
      print("Соединение закрыто");
    }
  }

  void _sendMessage() {
    if (_isConnected && _messageController.text.isNotEmpty) {
      final messageText = _messageController.text;
      final jsonMessage = jsonEncode({
        "message": messageText,
        "user_id": widget.userId,
        "timestamp": DateTime.now().toIso8601String() // Добавляем текущее время
      });

      // Добавляем сообщение локально в список сразу после отправки
      setState(() {
        _messages.add(Message(
          message: messageText,
          userId: widget.userId,
          timestamp:
              DateTime.now(), // Устанавливаем текущее время для timestamp
        ));
        _scrollToBottom(); // Прокручиваем вниз при отправке сообщения
      });

      // Отправляем сообщение через WebSocket
      _channel!.sink.add(jsonMessage);
      _messageController.clear();
      print("Сообщение отправлено: $messageText");
    } else {
      print(
          "Сообщение не может быть отправлено: Нет соединения или пустое сообщение");
    }
  }

  // Прокручиваем список вниз при новом сообщении
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 14, right: 16),
          child: Column(
            children: [
              CustomAppBar(
                text: tr('support_page.title'), // Локализация "Тех.поддержка"
                arrow: true,
                auth: false,
                onPressed: null,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // Контроллер для прокрутки
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUserMessage = message.userId == widget.userId;

                    // Определяем, является ли сообщение первым в серии
                    final isFirstInSeries = index == 0 ||
                        _messages[index - 1].userId != message.userId;

                    // Форматируем дату сообщения
                    final DateTime messageDate = message.timestamp;
                    final DateTime previousDate = index > 0
                        ? _messages[index - 1].timestamp
                        : messageDate;
                    final bool isFirstOfDay =
                        !isSameDay(messageDate, previousDate);

                    // Форматируем время сообщения
                    final String formattedTime =
                        DateFormat.Hm().format(message.timestamp);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isFirstOfDay)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              formatMessageDate(messageDate),
                              // Локализованный формат даты
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                          ),
                        ChatBubble(
                          message: message,
                          isUserMessage: isUserMessage,
                          isFirstInSeries: isFirstInSeries,
                          formattedTime:
                              formattedTime, // Передаем форматированное время
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: tr('support_page.write_message'),
                          // Локализация "Написать сообщение..."
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (query) {},
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                          'assets/images/send_messege_icon.svg'),
                      onPressed: _sendMessage, // Отправка сообщения
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 7,
              )
            ],
          ),
        ),
      ),
    );
  }
}
