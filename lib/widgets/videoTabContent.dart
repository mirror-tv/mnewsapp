import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/blocs/editorChoice/bloc.dart';
import 'package:tv/blocs/editorChoice/events.dart';
import 'package:tv/blocs/tabStoryList/bloc.dart';
import 'package:tv/services/editorChoiceService.dart';
import 'package:tv/services/tabStoryListService.dart';
import 'package:tv/widgets/editorChoiceStoryList.dart';
import 'package:tv/widgets/videoTabStoryList.dart';

class VideoTabContent extends StatefulWidget {
  final String categorySlug;
  final bool isFeaturedSlug;
  VideoTabContent({
    @required this.categorySlug,
    this.isFeaturedSlug = false,
  });

  @override
  _VideoTabContentState createState() => _VideoTabContentState();
}

class _VideoTabContentState extends State<VideoTabContent> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if(widget.isFeaturedSlug)
          BlocProvider(
            create: (context) => EditorChoiceBloc(editorChoiceRepos: EditorChoiceServices()),
            child: BuildEditorChoiceStoryList(editorChoiceEvent: EditorChoiceEvents.fetchVideoEditorChoiceList),
          ),
        
        if(!widget.isFeaturedSlug)
          BlocProvider(
            create: (context) => TabStoryListBloc(tabStoryListRepos: TabStoryListServices(postStyle: 'videoNews')),
            child: BuildVideoTabStoryList(
              categorySlug: widget.categorySlug,
            ),
          ),
      ],
    );
  }
}