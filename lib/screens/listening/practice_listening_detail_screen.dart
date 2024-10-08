import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/listening_effect_cubit/listening_effect_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/listening/appbar_detail_player.dart';
import 'package:sae_chang/features/detail_class/lessons/listening/conversation_list_view.dart';
import 'package:sae_chang/features/detail_class/lessons/listening/listening_cubit.dart';
import 'package:sae_chang/features/detail_class/lessons/listening/listening_detail_cubit.dart';
import 'package:sae_chang/models/skill_models/lesson.dart';
import 'package:sae_chang/services/media_service.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/loading_progress.dart';

class PracticeListeningDetailScreen extends StatefulWidget {
  const PracticeListeningDetailScreen(
      {super.key,
      required this.positionNow,
      required this.lesson,
      this.cubit,
      required this.audioRecorder});
  final Duration positionNow;
  final Lesson lesson;
  final AudioRecorder audioRecorder;
  final ListeningCubit? cubit;

  @override
  State<PracticeListeningDetailScreen> createState() =>
      _PracticeListeningDetailScreenState();
}

class _PracticeListeningDetailScreenState
    extends State<PracticeListeningDetailScreen> {
  @override
  void dispose() {
    MediaService.instance.dispose();
    widget.audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isTablet = Resizable.isTablet(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ListeningDetailCubit(widget.cubit)
            ..load(widget.positionNow, widget.lesson),
        ),
      ],
      child: BlocBuilder<ListeningDetailCubit, int>(
        builder: (c, __) {
          final cubit = c.read<ListeningDetailCubit>();
          return BlocProvider(
            create: (context) => ListeningEffectCubit()..load(),
            child: BlocBuilder<ListeningEffectCubit, ListeningEffectState>(
              builder: (context, state) {
                if (state is ListeningEffectLoaded) {
                  return Scaffold(
                    backgroundColor: Colors.white.withOpacity(0.99),
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      toolbarHeight: isTablet ? 100 : 60,
                      iconTheme: IconThemeData(
                          color: primaryColor, size: isTablet ? 35 : null),
                      centerTitle: true,
                      leadingWidth: isTablet ? 100 : null,
                      title: Text(
                        cubit.lesson!.mean,
                        style: TextStyle(
                            fontSize: Resizable.font(context, 19),
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      bottom:  PreferredSize(
                        preferredSize: Size.fromHeight(Resizable.size(context, 150)),
                        child:const AppbarDetailPlayer(),
                      ),
                    ),
                    body: Stack(
                      children: [
                        ConversationListView(
                            listSentences: cubit.lesson!.sentences),
                      ],
                    ),
                  );
                }
                return const Scaffold(body: LoadingProgress());
              },
            ),
          );
        },
      ),
    );
  }
}
