part of 'chat_bloc.dart';

@immutable
sealed class ChatState {
}

final class ChatInitial extends ChatState {

}

final class MessageSendAndReciveState extends ChatState {
  final List<Chat> chats;
  MessageSendAndReciveState({required this.chats});
}

// final class MessageReciveState extends ChatState {
//   final List<Chat> chats;
//   MessageReciveState({required this.chats});
// }

final class ResponseLoadingState extends ChatState{
  final bool loading;
  ResponseLoadingState({required this.loading});
}
