import 'package:flutter/Material.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/practice/video/video.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class VideoView extends StatelessWidget {
  final String url, dir;
  const VideoView({
    super.key,
    required this.url,
    required this.dir,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: Resizable.size(context, 5), color: primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(Resizable.size(context, 30))),
              color: primaryColor),
          child: ClipRRect(
              borderRadius: BorderRadius.all(
                  Radius.circular(Resizable.size(context, 28))),
              child: Video.blocProvider(
                "$dir$url",
                aspectRatio: 1.77,
                autoPlay: true,
              )),
        ),
      ],
    );
  }
}
