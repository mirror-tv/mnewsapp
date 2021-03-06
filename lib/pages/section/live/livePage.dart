import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/blocs/live/liveCubit.dart';
import 'package:tv/blocs/promotionVideo/bloc.dart';
import 'package:tv/helpers/analyticsHelper.dart';
import 'package:tv/helpers/environment.dart';
import 'package:tv/models/adUnitId.dart';
import 'package:tv/pages/section/live/liveCams.dart';
import 'package:tv/widgets/liveWidget.dart';
import 'package:tv/pages/section/live/promotionVideos.dart';
import 'package:tv/services/promotionVideosService.dart';
import 'package:tv/widgets/inlineBannerAdWidget.dart';

class LivePage extends StatelessWidget {
  final AdUnitId? adUnitId;

  LivePage({this.adUnitId});

  @override
  Widget build(BuildContext context) {
    AnalyticsHelper.sendScreenView(screenName: 'LivePage');
    return ListView(
      children: [
        Column(
          children: [
            BlocProvider(
                create: (context) => LiveCubit(),
                child: LiveWidget(
                  livePostId: Environment().config.mNewsLivePostId,
                )),

            // InlineBannerAdWidget(adUnitId: adUnitId?.at1AdUnitId,),

            BlocProvider(
              create: (context) => LiveCubit(),
              child: LiveCams(),
            ),

            // InlineBannerAdWidget(adUnitId: adUnitId?.at2AdUnitId,),

            BlocProvider(
                create: (context) => PromotionVideoBloc(
                    promotionVideosRepos: PromotionVideosServices()),
                child: PromotionVideos()),

            // InlineBannerAdWidget(adUnitId: adUnitId?.at3AdUnitId,),

            SizedBox(height: 24),
          ],
        ),
      ],
    );
  }
}
