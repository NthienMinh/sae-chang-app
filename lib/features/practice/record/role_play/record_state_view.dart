import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';


class RecordStateView extends StatelessWidget {
  const RecordStateView({super.key, required this.recordingStateCubit});
  final RolePlayStateCubit recordingStateCubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RolePlayStateCubit, int>(
        bloc: recordingStateCubit,
        builder: (ct, rolePlayState) {
          if (rolePlayState == 1) {
            return AvatarGlow(
                glowColor: primaryColor.shade300,
                endRadius: Resizable.size(context, 70),
                child: Card(
                    margin: EdgeInsets.symmetric(
                        vertical: Resizable.size(context, 10)),
                    shadowColor: primaryColor,
                    elevation: Resizable.size(context, 2),
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            Resizable.size(context, 50))),
                    child: AvatarGlow(
                      endRadius: Resizable.size(context, 45),
                      child: Container(
                          margin: EdgeInsets.all(
                              Resizable.size(context, 10)),
                          padding: EdgeInsets.all(
                              Resizable.size(context, 10)),
                          child: Icon(Icons.mic,
                              size: Resizable.size(context, 50),
                              color: Colors.white)),
                    )));
          }
          if (rolePlayState == 2) {
            return Card(
                margin: EdgeInsets.symmetric(
                    vertical: Resizable.size(context, 10)),
                shadowColor: primaryColor,
                elevation: Resizable.size(context, 2),
                color: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        Resizable.size(context, 50))),
                child: Container(
                    margin:
                    EdgeInsets.all(Resizable.size(context, 10)),
                    padding:
                    EdgeInsets.all(Resizable.size(context, 10)),
                    child: Icon(Icons.stop,
                        size: Resizable.size(context, 50),
                        color: Colors.white)));
          }
          return const SizedBox();
        });
  }
}
