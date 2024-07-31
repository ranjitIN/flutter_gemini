part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String prompt;
  SendMessageEvent({required this.prompt});
}

class ReciveMessageEvent extends ChatEvent {
  final String response;
  ReciveMessageEvent({required this.response});
}

class EditMessageEvent extends ChatEvent {
  final Chat chat;
  EditMessageEvent({required this.chat});
}

class EditCancelEvnet extends ChatEvent {
  final Chat chat;
  EditCancelEvnet({required this.chat});
}

class EditSubmitEvent extends ChatEvent {
  final Chat chat;
  EditSubmitEvent({required this.chat});
}

class ResponseLoadingEvent extends ChatEvent {
  final bool loading;
  final Chat chat;
  ResponseLoadingEvent({required this.chat, required this.loading});
}
