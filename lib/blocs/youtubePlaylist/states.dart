import 'package:tv/models/youtubePlaylistItemList.dart';

abstract class YoutubePlaylistState {}

class YoutubePlaylistInitState extends YoutubePlaylistState {}

class YoutubePlaylistLoading extends YoutubePlaylistState {}

class YoutubePlaylistLoaded extends YoutubePlaylistState {
  final YoutubePlaylistItemList youtubePlaylistItemList;
  YoutubePlaylistLoaded({this.youtubePlaylistItemList});
}

class YoutubePlaylistError extends YoutubePlaylistState {
  final error;
  YoutubePlaylistError({this.error});
}
