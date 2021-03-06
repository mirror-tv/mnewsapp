import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tv/blocs/youtubePlaylist/events.dart';
import 'package:tv/blocs/youtubePlaylist/states.dart';
import 'package:tv/helpers/exceptions.dart';
import 'package:tv/models/youtubePlaylistItemList.dart';
import 'package:tv/services/youtubePlaylistService.dart';

class YoutubePlaylistBloc
    extends Bloc<YoutubePlaylistEvents, YoutubePlaylistState> {
  final YoutubePlaylistRepos youtubePlaylistRepos;
  YoutubePlaylistItemList youtubePlaylistItemList = YoutubePlaylistItemList();

  YoutubePlaylistBloc({required this.youtubePlaylistRepos})
      : super(YoutubePlaylistInitState());

  @override
  Stream<YoutubePlaylistState> mapEventToState(
      YoutubePlaylistEvents event) async* {
    print(event.toString());
    try {
      yield YoutubePlaylistLoading();
      if (event is FetchSnippetByPlaylistId) {
        youtubePlaylistItemList = await youtubePlaylistRepos
            .fetchSnippetByPlaylistId(event.playlistId,
                maxResults: event.maxResults);
        yield YoutubePlaylistLoaded(
            youtubePlaylistItemList: youtubePlaylistItemList);
      } else if (event is FetchSnippetByPlaylistIdAndPageToken) {
        yield YoutubePlaylistLoadingMore(
            youtubePlaylistItemList: youtubePlaylistItemList);
        YoutubePlaylistItemList newYoutubePlaylistItemList =
            await youtubePlaylistRepos.fetchSnippetByPlaylistIdAndPageToken(
                event.playlistId, event.pageToken,
                maxResults: event.maxResults);
        youtubePlaylistItemList.nextPageToken =
            newYoutubePlaylistItemList.nextPageToken;
        youtubePlaylistItemList.addAll(newYoutubePlaylistItemList);

        yield YoutubePlaylistLoaded(
            youtubePlaylistItemList: youtubePlaylistItemList);
      }
    } on SocketException {
      yield YoutubePlaylistError(
        error: NoInternetException('No Internet'),
      );
    } on HttpException {
      yield YoutubePlaylistError(
        error: NoServiceFoundException('No Service Found'),
      );
    } on FormatException {
      yield YoutubePlaylistError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      if (event is FetchSnippetByPlaylistIdAndPageToken) {
        Fluttertoast.showToast(
            msg: "????????????",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(Duration(seconds: 5));
        yield YoutubePlaylistLoadingMoreFail(
            youtubePlaylistItemList: youtubePlaylistItemList);
      } else {
        yield YoutubePlaylistError(
          error: UnknownException(e.toString()),
        );
      }
    }
  }
}
