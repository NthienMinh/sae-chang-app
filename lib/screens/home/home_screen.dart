import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/home/home_appbar.dart';
import 'package:sae_chang/screens/home/user_class_screen.dart';
import 'package:sae_chang/untils/resizable_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: HomeAppbar(title: widget.title),
        toolbarHeight: Resizable.size(context, 60),
      ),
      body: BlocBuilder<ConnectCubit, bool>(
          bloc: ConnectCubit.instance,
          builder: (c, s) {
            return  widget.title == AppText.txtHanNguSaeChang.text
                ?  UserClassScreen()
                : Center(child: Text(widget.title));
          }),
    );
  }
}
