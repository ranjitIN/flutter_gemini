import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generative_ai_gemini/features/chat/bloc/chat_bloc.dart';
import 'package:generative_ai_gemini/model/chat.dart';
import 'package:generative_ai_gemini/utils/const_asset.dart';
import 'package:generative_ai_gemini/widgets/chat_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController promptController = TextEditingController();
  ChatBloc? chatBloc;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context);

    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.bounceIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessageSendAndReciveState) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceIn);
        } else {}
      },
      bloc: chatBloc,
      builder: (context, state) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: context.read<ChatBloc>().chats.length,
              itemBuilder: (context, index) {
                if (context.read<ChatBloc>().chats[index].promptType ==
                    PromptType.gemini) {
                  return PromptByGemini(
                      chat: context.read<ChatBloc>().chats[index]);
                } else if (context.read<ChatBloc>().chats[index].promptType ==
                    PromptType.user) {
                  return PromptByUser(
                    prompt: context.read<ChatBloc>().chats[index].prompt ?? "",
                    onPressed: () {},
                  );
                } else if (context.read<ChatBloc>().chats[index].promptType ==
                    PromptType.error) {
                  return ResponseError(
                    chat: context.read<ChatBloc>().chats[index],
                  );
                } else {
                  return const ResponseLoading();
                }
              }),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                prefixIcon: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.attachment)),
                suffixIcon: IconButton(
                    onPressed: () {
                      if (promptController.text.isNotEmpty) {
                        if (!context.read<ChatBloc>().loading) {
                          chatBloc?.add(SendMessageEvent(
                              prompt: promptController.text.trim()));
                        }
                        promptController.clear();
                      }
                      //  Future.delayed(const Duration(seconds: 3)).then((value){
                      //   chatBloc?.add(ReciveMessageEvent(response: sampleResponse));
                      //  });
                    },
                    icon: Icon(Icons.send,
                        color: context.read<ChatBloc>().loading
                            ? Colors.grey
                            : Colors.blue))),
            controller: promptController,
          ),
        ),
      ),
    );
  }
}
