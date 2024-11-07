import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../bloc/cocktale_list_bloc/cocktail_list_bloc.dart';

class CustomSearchBar extends StatefulWidget {
  final bool isFavorites;
  final TextEditingController? controller;
  final bool userRecipes;

  const CustomSearchBar({
    super.key,
    this.isFavorites = false,
    this.controller,
    this.userRecipes = false,
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _showRecordingDialog(); // Показать диалог записи

      _speech.listen(onResult: (result) {
        setState(() {
          widget.controller?.text = result.recognizedWords;
        });
        _onSearchChanged(result.recognizedWords);
      }).then((_) => _closeRecordingDialog()); // Закрыть диалог по завершении
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    _closeRecordingDialog(); // Закрыть диалог, если остановлено вручную
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      if (widget.isFavorites) {
        context.read<CocktailListBloc>().add(
              SearchFavoriteCocktails(
                query: query,
                page: 1,
                pageSize: 50,
              ),
            );
      } else if (widget.userRecipes) {
        context.read<CocktailListBloc>().add(
              FetchUserCocktails(
                query: query,
                page: 1,
                pageSize: 50,
              ),
            );
      } else {
        context.read<CocktailListBloc>().add(
              SearchCocktails(
                query: query,
                page: 1,
                pageSize: 20,
              ),
            );
      }
    } else {
      if (widget.isFavorites) {
        context.read<CocktailListBloc>().add(const FetchFavoriteCocktails());
      } else if (widget.userRecipes) {
        context.read<CocktailListBloc>().add(FetchUserCocktails());
      } else {
        context.read<CocktailListBloc>().add(FetchCocktails());
      }
    }
  }

  // Метод для показа диалога записи
  void _showRecordingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Разрешить закрытие по нажатию вне диалога
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          content: Row(
            children: [
              Icon(Icons.mic, color: Colors.red, size: 30),
              const SizedBox(width: 10),
              Text(
                tr("search.recording"),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Убедимся, что запись остановлена, если диалог закрыт вручную
      if (_isListening) _stopListening();
    });
  }

  // Метод для закрытия диалога записи
  void _closeRecordingDialog() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: tr('search.search'),
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: _onSearchChanged,
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/microphone_icon.svg',
              color: Colors.white54,
              width: 24,
              height: 24,
            ),
            onPressed: _isListening ? _stopListening : _startListening,
          ),
        ],
      ),
    );
  }
}
