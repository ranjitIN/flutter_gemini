import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:generative_ai_gemini/model/chat.dart';
import 'package:generative_ai_gemini/model/env.dart';
import 'package:generative_ai_gemini/utils/const_asset.dart';
import 'package:generative_ai_gemini/widgets/chat_view.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Chat> chats = [];
  bool loading = false;
  GenerativeModel? model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: Env.geminiApiKey,
  );

  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SendMessageEvent>(sendMessage);
    on<ReciveMessageEvent>(reciveMessage);
    on<ResponseLoadingEvent>(onResponseLoading);
  }

  FutureOr<void> onResponseLoading(
      ResponseLoadingEvent event, Emitter<ChatState> emit) {
        loading = false;
        emit(ResponseLoadingState(loading: loading));
        int index = chats.indexOf(event.chat);
        chats[index].generated = true;
        emit(MessageSendAndReciveState(chats: chats));
    // state.chats.add(Chat(promptType: PromptType.gemini, prompt: event.response));
    // print(state.loading);
    // state.loading = event.loading;
    // emit(ResponseLoadingState(loading: state.loading));
    // print(state.loading);
  }

  FutureOr<void> reciveMessage(
      ReciveMessageEvent event, Emitter<ChatState> emit) {
    // chats.add(Chat(promptType: PromptType.gemini, prompt: event.response));
    // emit(MessageReciveState(chats: state.chats));
  }

  FutureOr<void> sendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      chats.add(Chat(id:DateTime.now().microsecondsSinceEpoch.toString(),promptType: PromptType.user, prompt: event.prompt));
      chats.add(Chat(id:DateTime.now().microsecondsSinceEpoch.toString(),promptType: PromptType.loading, prompt: ""));
      emit(MessageSendAndReciveState(chats: chats));
      loading = true;
      emit(ResponseLoadingState(loading: loading));
      final content = [Content.text(event.prompt)];
      final response = await model?.generateContent(content);
      chats.removeLast();
      chats.add(Chat(id:DateTime.now().microsecondsSinceEpoch.toString(),promptType: PromptType.gemini, prompt: response?.text ?? ""));
      emit(MessageSendAndReciveState(chats: chats));
    } catch (error) {
      chats.removeLast();
      loading = false;
      chats.add(Chat(id:DateTime.now().microsecondsSinceEpoch.toString(),promptType: PromptType.error, prompt: error.toString()));
      emit(MessageSendAndReciveState(chats: chats));
      emit(ResponseLoadingState(loading: loading));
    }
  }
}
