part of 'liveCubit.dart';

@immutable
abstract class LiveState {}

class LiveInitial extends LiveState {}

class LiveIdLoaded extends LiveState {
  final String liveId;
  LiveIdLoaded({required this.liveId});
}

class LiveIdListLoaded extends LiveState {
  final List<String> liveIdList;
  LiveIdListLoaded({required this.liveIdList});
}

class LiveError extends LiveState {
  final error;
  LiveError({this.error});
}
