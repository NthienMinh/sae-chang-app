
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/color_configs.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_bloc.dart';
import 'package:sae_chang/features/bloc/practice_bloc/practice_event.dart';
import 'package:sae_chang/features/bloc/sound_cubit.dart';
import 'package:sae_chang/features/practice/multiple_choice/image_list.dart';
import 'package:sae_chang/features/practice/multiple_choice/multiple_choice_view.dart';
import 'package:sae_chang/features/practice/record/normal_record/sounder.dart';
import 'package:sae_chang/models/base_model/question_model.dart';
import 'package:sae_chang/untils/custom_check.dart';
import 'package:sae_chang/untils/custom_padding.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/next_back_widget.dart';
import '../../../../shared_preferences.dart';
import '../../../../widgets/custom_scroll_bar.dart';
import '../paragraph_view.dart';
import '../question_custom.dart';

class InputTextView extends StatefulWidget {
  final QuestionModel questionModel;
  final PracticeBloc bloc;
  final String type;
  final double height;

  const InputTextView({
    super.key,
    required this.questionModel, required this.bloc, required this.type, required this.height,
  });

  @override
  State<InputTextView> createState() => _InputTextViewState();
}

class _InputTextViewState extends State<InputTextView> {

  double firstHeight = 0;
  @override
  void initState() {
    firstHeight = widget.height;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ListPathCubit soundsCubit = ListPathCubit(widget.questionModel.listSound);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
       SizedBox(
         width: double.infinity,
         height: firstHeight * 0.4,
         child: Card(
           elevation: 5,
           margin: CustomPadding.questionCardPadding(context),
           shape: RoundedRectangleBorder(
               borderRadius:
               BorderRadius.circular(Resizable.size(context, 20)),
               side: const BorderSide(color: Color(0xffE0E0E0), width: 1)),
           child: Center(
             child: CustomScrollBar(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   if (widget.questionModel.question != "")
                     QuestionCustom(question: widget.questionModel.question,),
                   if (widget.questionModel.image != "")
                     Padding(
                         padding: EdgeInsets.symmetric(
                             horizontal: Resizable.padding(context, 30),
                             vertical: Resizable.padding(context, 5)),
                         child: ImageList(widget.questionModel.listImage, dir: widget.bloc.dir)),
                   if (widget.questionModel.sound != "")
                     BlocBuilder<ListPathCubit, String>(
                         bloc: soundsCubit..load(),
                         builder: (_, String sound) {
                           return Padding(
                               padding: EdgeInsets.symmetric(
                                   horizontal: Resizable.padding(context, 30),
                                   vertical: Resizable.padding(context, 5)),
                               child: Column(
                                 children: [
                                   BlocProvider(
                                     key: Key(widget.questionModel.id.toString()),
                                     create: (context) => SoundCubit(),
                                     child: BlocBuilder<SoundCubit, double>(
                                       builder: (context, state) {
                                         final SoundCubit soundCubit =
                                         context.read<SoundCubit>();
                                         return Sounder1(
                                           CustomCheck.getAudioLink(sound, widget.bloc.dir),
                                           iconColor: primaryColor,
                                           size: 20,
                                           q: widget.questionModel,
                                           soundCubit: soundCubit,
                                           soundType: 'download',
                                         );
                                       },
                                     ),
                                   ),
                                   if (widget.questionModel.listSound.length > 1)
                                     NextBackWidget(() {
                                       soundsCubit.next();
                                     }, () {
                                       soundsCubit.prev();
                                     },
                                         text:
                                         '${soundsCubit.index + 1}/${soundsCubit.size}'),
                                 ],
                               ));
                         }),
                   if (widget.questionModel.paragraph != "") ...[
                     ParagraphView(questionModel: widget.questionModel)
                   ],
                 ],
               ),
             ),
           ),
         ),
       ),
       SizedBox(
           height: firstHeight * 0.6 - Resizable.height(context) * 0.05,
           child: Padding(
             padding: CustomPadding.questionCardPadding(context).copyWith(
               top: Resizable.padding(context, 20)
             ),
             child:  TextFormField(
               key: Key(widget.questionModel.id.toString()),
               onChanged: (String? text) async {
                 if (text != null && text.isNotEmpty) {
                   widget.questionModel.answered = [text];
                   widget.bloc.add(UpdateEvent());
                   BaseSharedPreferences.savePracticeData(widget.questionModel, widget.type, widget.bloc.id, widget.bloc.resultId);
                 }
                 else {
                   widget.questionModel.answered = [];
                   widget.bloc.add(UpdateEvent());
                 }
               },
               initialValue:  widget.questionModel.answered.isNotEmpty ? widget.questionModel.answered.first : '',
               expands: true,
                minLines: null,
               maxLines: null,
               textAlignVertical: TextAlignVertical.top,

               style: TextStyle(
                   color: Colors.black,
                   fontWeight: FontWeight.w600,
                   fontSize: Resizable.font(context, 16)
               ),
               keyboardType: TextInputType.multiline,
               decoration: InputDecoration(
                 hintText: "Nhập đáp án của bạn vào đây.",
                 contentPadding: const EdgeInsets.all(30),
                 hintStyle: const TextStyle(
                   color: Colors.black,
                   fontStyle: FontStyle.italic,
                   fontWeight: FontWeight.w500
                 ),
                 fillColor: Colors.white,
                 filled: true,
                 constraints: BoxConstraints(
                   minHeight: Resizable.height(context) * 0.3,
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(15.0),
                   borderSide: const BorderSide(
                     color: Color(0xffdadada),
                     width: 1,
                   ),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(15.0),
                   borderSide: const BorderSide(
                     color: primaryColor,
                     width: 1,
                   ),
                 ),
               ),
             ),
           )),


      ],
    );
  }
}
