import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CocktailCardSlider extends StatefulWidget {
  final List<String> imageUrls;
  final String? videoUrl;

  const CocktailCardSlider({
    super.key,
    required this.imageUrls,
    this.videoUrl,
  });

  @override
  State<CocktailCardSlider> createState() => _CocktailCardSliderState();
}

class _CocktailCardSliderState extends State<CocktailCardSlider> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    // Инициализируем контроллер только если есть videoUrl
    if (widget.videoUrl != null &&
        YoutubePlayer.convertUrlToId(widget.videoUrl!) != null) {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl!);
      _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: true, // Отключаем перетаскивание
        ),
      );
    }
  }

  // Метод для перемотки назад на 5 секунд
  void rewind() {
    final currentPosition = _controller?.value.position ?? Duration.zero;
    final newPosition = currentPosition - const Duration(seconds: 5);
    _controller
        ?.seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
  }

  // Метод для перемотки вперед на 5 секунд
  void fastForward() {
    final currentPosition = _controller?.value.position ?? Duration.zero;
    final videoDuration = _controller?.metadata.duration ?? Duration.zero;
    final newPosition = currentPosition + const Duration(seconds: 5);
    _controller
        ?.seekTo(newPosition < videoDuration ? newPosition : videoDuration);
  }

  @override
  Widget build(BuildContext context) {
    // Логика для отображения изображений и видео
    final List<Widget> mediaWidgets = [];

    // Добавляем изображения в слайдер или заглушку, если изображений нет
    if (widget.imageUrls.isNotEmpty) {
      for (var url in widget.imageUrls) {
        mediaWidgets.add(
          Stack(
            children: [
              Image.network(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 340,
              ),
              Positioned(
                right: 16.0,
                bottom: 10.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    "${mediaWidgets.length + 1}/${widget.imageUrls.length + (widget.videoUrl != null ? 1 : 0)}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      // Если изображений нет, добавляем заглушку
      mediaWidgets.add(
        Container(
          width: double.infinity,
          height: 340,
          color: Colors.grey,
          child: const Icon(
            Icons.image,
            color: Colors.white,
            size: 100,
          ),
        ),
      );
    }

    // Добавляем YouTube-видео, если URL присутствует
    if (widget.videoUrl != null && _controller != null) {
      mediaWidgets.add(
        Stack(
          children: [
            YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
            ),
            GestureDetector(
              // Обработка двойного нажатия на левую часть экрана для перемотки назад
              onDoubleTapDown: (details) {
                final box = context.findRenderObject() as RenderBox?;
                final localPosition =
                    box?.globalToLocal(details.globalPosition);
                if (localPosition != null &&
                    localPosition.dx < MediaQuery.of(context).size.width / 2) {
                  rewind();
                } else {
                  fastForward();
                }
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ],
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: mediaWidgets.length,
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        height: 340.0,
        aspectRatio: 1,
        viewportFraction: 1,
        initialPage: 0,
      ),
      itemBuilder: (context, index, pageIndex) {
        return mediaWidgets[index];
      },
    );
  }

  @override
  void dispose() {
    // Проверяем, инициализирован ли контроллер, перед его удалением
    _controller?.dispose();
    super.dispose();
  }
}
