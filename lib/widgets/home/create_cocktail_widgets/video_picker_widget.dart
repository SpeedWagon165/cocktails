import 'dart:io';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:cocktails/widgets/home/create_cocktail_widgets/solid_add_photo_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../../bloc/create_cocktail_bloc/create_cocktail_bloc.dart';

class VideoPickerWidget extends StatelessWidget {
  const VideoPickerWidget({super.key});

  Future<void> _pickAndUploadVideo(BuildContext context) async {
    final picker = ImagePicker();

    // 1) Выбираем видео из галереи
    final XFile? pickedVideo =
        await picker.pickVideo(source: ImageSource.gallery);

    if (pickedVideo == null) return;

    final File videoFile =
        File(pickedVideo.path); // ⬅️ именно `videoFile`, как и дальше

    final controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    final Duration duration = controller.value.duration;
    await controller.dispose();

    if (duration > const Duration(minutes: 1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Видео должно быть не длиннее 1 минуты')),
      );
      return;
    }

    final String key = const Uuid().v4().substring(0, 12);

    context
        .read<CocktailCreationBloc>()
        .add(UpdateRecipeVideoFileEvent(videoFile));

    // 2) Генерируем миниатюру
    final XFile thumbFile = await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 128,
      quality: 75,
    );
    final File thumb = File(thumbFile.path);
    context.read<CocktailCreationBloc>().add(UpdateVideoThumbnailEvent(thumb));

    try {
      print('> Начинаю загрузку видео, ключ = $key, путь = ${videoFile.path}');
      final String? uploadedUrl = await AwsS3.uploadFile(
        accessKey: 'AKIA4XIHKZCO7KWHNPYN',
        secretKey: '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',
        region: 'us-east-2',
        bucket: 'cocktails-video-bucket',
        destDir: '',
        filename: key,
        file: videoFile,
      );
      print('> Ответ от AwsS3.uploadFile: $uploadedUrl');

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        print('Всё ок видео загружено');
        context
            .read<CocktailCreationBloc>()
            .add(UpdateRecipeVideoAwsKeyEvent(key));
      } else {
        print('Ошибка загрузки видео');
      }
    } catch (e) {
      print('Ошибка при загрузке: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CocktailCreationBloc, CocktailCreationState>(
      builder: (context, state) {
        // Если есть миниатюра — показываем её
        if (state.videoThumbnailFile != null) {
          return GestureDetector(
            onTap: () => _pickAndUploadVideo(context),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(state.videoThumbnailFile!),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Icon(Icons.play_circle_fill, color: Colors.white70),
            ),
          );
        }

        // Иначе — кнопка «добавить видео»
        return SolidAddPhotoButton(
          onTap: () => _pickAndUploadVideo(context),
        );
      },
    );
  }
}
