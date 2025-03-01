import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CocktailCardSlider extends StatefulWidget {
  final List<String> imageUrls;
  final String? videoUrl;
  final bool isImageAvailable;

  const CocktailCardSlider({
    super.key,
    required this.imageUrls,
    this.videoUrl,
    this.isImageAvailable = true,
  });

  @override
  State<CocktailCardSlider> createState() => _CocktailCardSliderState();
}

class _CocktailCardSliderState extends State<CocktailCardSlider> {
  YoutubePlayerController? _controller;
  bool _showControls = false;
  Timer? _hideControlsTimer;
  double imageHeight = 340;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrls.isNotEmpty) {
      imageHeight = widget.isImageAvailable ? 340 : 200;
    } else {
      imageHeight = 200;
    }

    // Инициализируем контроллер YouTube, если есть видео
    if (widget.videoUrl != null &&
        YoutubePlayer.convertUrlToId(widget.videoUrl!) != null) {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl!);
      _controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: true,
        ),
      );
    }
  }

  // Переключение воспроизведения (пауза/играет)
  void _togglePlayPause() {
    if (_controller == null) return;

    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    setState(() {}); // Обновляем UI
  }

  // Показываем кнопку паузы и скрываем через 3 секунды
  void _showPauseButton() {
    setState(() {
      _showControls = true;
    });

    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> mediaWidgets = [];

    // Добавляем изображения
    if (widget.imageUrls.isNotEmpty) {
      for (var url in widget.imageUrls) {
        mediaWidgets.add(
          Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 340,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 340,
                color: Colors.grey,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white,
                  size: 50,
                ),
              );
            },
          ),
        );
      }
    } else {
      mediaWidgets.add(
        Container(
          width: double.infinity,
          height: 340,
          color: Colors.grey,
          child: const Icon(
            Icons.image,
            color: Colors.white,
            size: 50,
          ),
        ),
      );
    }

    // Добавляем YouTube-видео
    if (widget.videoUrl != null && _controller != null) {
      mediaWidgets.add(
        GestureDetector(
          onTap: _showPauseButton,
          child: Stack(
            alignment: Alignment.center,
            children: [
              YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
              ),
              if (_showControls)
                Positioned(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 30,
                      child: Icon(
                        _controller!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: mediaWidgets.length,
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        height: imageHeight,
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
    _controller?.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }
}
