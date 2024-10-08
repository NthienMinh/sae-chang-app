import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sae_chang/configs/text_configs.dart';
import 'package:sae_chang/features/bloc/connect_cubit.dart';
import 'package:sae_chang/features/detail_class/tests/tests_cubit.dart';
import 'package:sae_chang/models/base_model/user_class.dart';
import 'package:sae_chang/providers/cache_data/cache_data_provider.dart';
import 'package:sae_chang/untils/resizable_utils.dart';
import 'package:sae_chang/widgets/item_shimmer.dart';
import 'package:shimmer/shimmer.dart';

import 'item_test.dart';

class TestsView extends StatelessWidget {
  TestsView({super.key, required this.userClass})
      : testsCubit = TestsCubit(userClass);
  final UserClassModel userClass;
  final TestsCubit testsCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestsCubit, int>(
        bloc: testsCubit..load(),
        builder: (c, state) {
          return RefreshIndicator(
              onRefresh: () async {
                if (ConnectCubit.instance.state) {
                  await CacheDataProvider.clearAllKey();
                  testsCubit.load();
                }
              },
              child: SingleChildScrollView(
                physics:const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    //SizedBox(height: Resizable.padding(context, 30)),
                    Builder(builder: (context) {
                      final shimmerList = List.generate(10, (index) => index);
                      return testsCubit.testResults == null
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: Resizable.padding(context, 30)),
                                    ...shimmerList
                                        .map((e) => const ItemShimmer())
                                  ],
                                ),
                              ),
                            )
                          : testsCubit.testResults!.isEmpty
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Text(
                                      AppText.txtTestEmpty.text,
                                      style: TextStyle(
                                          fontSize:
                                              Resizable.font(context, 20)),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                        height: Resizable.padding(context, 15)),
                                    ...testsCubit.testResults!.map((e) {
                                      return ItemTest(
                                        index:
                                            testsCubit.testResults!.indexOf(e) +
                                                1,
                                        test: testsCubit.getTest(e.testId),
                                        testResult: e,
                                        result: testsCubit.getResult(e.id),
                                        userId: userClass.userId,
                                        classId: userClass.classId,
                                      );
                                    }),
                                    SizedBox(
                                        height: Resizable.padding(context, 30)),
                                  ],
                                );
                    })
                  ],
                ),
              ));
        });
  }
}
