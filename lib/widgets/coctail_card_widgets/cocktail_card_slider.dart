import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CocktailCardSlider extends StatefulWidget {
  final List<String> imageUrls;
  final String? videoAvsKey;
  final String? videoUrl;
  final bool isImageAvailable;

  const CocktailCardSlider({
    super.key,
    required this.imageUrls,
    this.videoAvsKey,
    this.videoUrl,
    this.isImageAvailable = true,
  });

  @override
  State<CocktailCardSlider> createState() => _CocktailCardSliderState();
}

class _CocktailCardSliderState extends State<CocktailCardSlider> {
  static const _s3BaseUrl =
      'https://cocktails-video-bucket.s3.us-east-2.amazonaws.com/';

  VideoPlayerController? _videoController;
  YoutubePlayerController? _ytController;
  double imageHeight = 340;
  int _currentIndex = 0;
  bool _hasShownVpnHint = false;

  @override
  void initState() {
    super.initState();

    // Высота слайдера
    imageHeight = widget.imageUrls.isNotEmpty
        ? (widget.isImageAvailable ? 340 : 200)
        : 200;

    // 1) Если есть ключ S3 — инициализируем video_player
    if (widget.videoAvsKey != null) {
      final uri = Uri.parse('$_s3BaseUrl${widget.videoAvsKey}');
      _videoController = VideoPlayerController.networkUrl(uri)
        ..initialize().then((_) => setState(() {}));
    }
    // 2) Иначе, если есть youtube URL — инициализируем youtube_player
    else if (widget.videoUrl != null &&
        YoutubePlayer.convertUrlToId(widget.videoUrl!) != null) {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl!)!;
      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: true,
        ),
      );
    }
  }

  void _maybeShowVpnHint() {
    if (_hasShownVpnHint || (_videoController == null && _ytController == null))
      return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Для корректного воспроизведения видео рекомендуется включить VPN',
          ),
          duration: Duration(seconds: 5),
        ),
      );
      _hasShownVpnHint = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidgets = <Widget>[];
    debugPrint(widget.videoAvsKey);
    // — картинки
    if (widget.imageUrls.isNotEmpty) {
      for (final url in widget.imageUrls) {
        mediaWidgets.add(
          Image.network(
            url,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 340,
            errorBuilder: (_, __, ___) => Container(
              width: double.infinity,
              height: 340,
              color: Colors.grey,
              child: const Icon(Icons.image_not_supported,
                  color: Colors.white, size: 50),
            ),
          ),
        );
      }
    } else {
      mediaWidgets.add(Container(
        width: double.infinity,
        height: 340,
        color: Colors.grey,
        child: const Icon(Icons.image, color: Colors.white, size: 50),
      ));
    }

    // — видео S3
    if (_videoController != null) {
      mediaWidgets.add(GestureDetector(
        onTap: () {
          if (!_videoController!.value.isInitialized) return;
          _videoController!.value.isPlaying
              ? _videoController!.pause()
              : _videoController!.play();
          setState(() {});
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_videoController!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            else
              Container(
                height: 340,
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator()),
              ),
            if (_videoController!.value.isInitialized)
              CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 30,
                child: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
              ),
          ],
        ),
      ));
    }
    // — или видео YouTube
    else if (_ytController != null) {
      mediaWidgets.add(GestureDetector(
        onTap: _maybeShowVpnHint,
        child: YoutubePlayer(
          controller: _ytController!,
          showVideoProgressIndicator: true,
        ),
      ));
    }

    // индикатор всего
    debugPrint('⚡️ mediaWidgets.length = ${mediaWidgets.length}');

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: mediaWidgets.length,
          itemBuilder: (ctx, idx, real) => mediaWidgets[idx],
          options: CarouselOptions(
            height: imageHeight,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            onPageChanged: (i, _) {
              setState(() => _currentIndex = i);
              // показываем hint, если перелистан на последний слайд с видео
              if (i == mediaWidgets.length - 1) _maybeShowVpnHint();
            },
          ),
        ),
        // точки
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              mediaWidgets.length,
              (i) => Container(
                    width: 8,
                    height: 8,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _currentIndex ? Colors.white : Colors.grey,
                    ),
                  )),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _ytController?.dispose();
    super.dispose();
  }
}
