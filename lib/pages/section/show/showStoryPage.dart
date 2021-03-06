import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/blocs/youtubePlaylist/bloc.dart';
import 'package:tv/helpers/analyticsHelper.dart';
import 'package:tv/helpers/dataConstants.dart';
import 'package:tv/helpers/dateTimeFormat.dart';
import 'package:tv/models/adUnitId.dart';
import 'package:tv/models/youtubePlaylistInfo.dart';
import 'package:tv/models/youtubePlaylistItem.dart';
import 'package:tv/pages/section/show/showPlaylistTabContent.dart';
import 'package:tv/services/youtubePlaylistService.dart';
import 'package:tv/widgets/inlineBannerAdWidget.dart';
import 'package:tv/widgets/story/youtubePlayer.dart';

class ShowStoryPage extends StatefulWidget {
  final String youtubePlayListId;
  final YoutubePlaylistItem youtubePlaylistItem;
  final AdUnitId adUnitId;
  ShowStoryPage({
    required this.youtubePlayListId,
    required this.youtubePlaylistItem,
    required this.adUnitId,
  });

  @override
  _ShowStoryPageState createState() => _ShowStoryPageState();
}

class _ShowStoryPageState extends State<ShowStoryPage> {
  ScrollController _listviewController = ScrollController();
  DateTimeFormat _dateTimeFormat = DateTimeFormat();

  @override
  void dispose() {
    _listviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsHelper.sendScreenView(
        screenName: 'ShowStoryPage title=${widget.youtubePlaylistItem.name}');
    return Scaffold(
      appBar: _buildBar(context),
      body: ListView(
        controller: _listviewController,
        children: [
          YoutubePlayer(widget.youtubePlaylistItem.youtubeVideoId),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _buildTitleAndPublishedDate(),
          ),
          // InlineBannerAdWidget(adUnitId: widget.adUnitId.at2AdUnitId,),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '??????????????????',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _buildMoreShowContent(
                title: '??????????????????', youtubePlayListId: widget.youtubePlayListId),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: appBarColor,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          tooltip: 'Share',
          onPressed: () {
            String url = youtubeLink + 'watch?v=' + widget.youtubePlayListId;
            Share.share(url);
          },
        ),
      ],
    );
  }

  Widget _buildTitleAndPublishedDate() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.youtubePlaylistItem.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 22.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      if (widget.youtubePlaylistItem.publishedAt != null) ...[
        SizedBox(height: 12),
        Text(
          _dateTimeFormat.changeStringToDisplayString(
              widget.youtubePlaylistItem.publishedAt!,
              'yyyy-MM-ddTHH:mm:ssZ',
              'yyyy???MM???dd???'),
          style: TextStyle(
            color: Color(0xff757575),
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ]
    ]);
  }

  Widget _buildMoreShowContent(
      {required String title, required String youtubePlayListId}) {
    return BlocProvider(
      create: (context) =>
          YoutubePlaylistBloc(youtubePlaylistRepos: YoutubePlaylistServices()),
      child: ShowPlaylistTabContent(
        youtubePlaylistInfo: YoutubePlaylistInfo(
          name: title,
          youtubePlayListId: youtubePlayListId,
        ),
        listviewController: _listviewController,
        adUnitId: widget.adUnitId,
        isMoreShow: true,
      ),
    );
  }
}
