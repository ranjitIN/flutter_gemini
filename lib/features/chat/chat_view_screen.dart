import 'package:animated_text_kit/animated_text_kit.dart';
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
    scrollController.addListener(_scrollListener);
    // scrollController.addListener(() {
    //   if (scrollController.offset >=
    //       scrollController.position.maxScrollExtent) {
    //     scrollController.animateTo(scrollController.position.maxScrollExtent,
    //         duration: const Duration(milliseconds: 200),
    //         curve: Curves.bounceIn);
    //   }
    // });
  }

  void _scrollListener() {
    if (scrollController.hasClients &&
        scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.bounceIn);
      // _shouldAutoscroll = true;
    } else {
      // _shouldAutoscroll = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessageSendAndReciveState) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(
              scrollController.position.maxScrollExtent,
            );
          }
        } else {}
      },
      bloc: chatBloc,
      builder: (context, state) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              context.read<ChatBloc>().chats.isEmpty
                  ? Expanded(
                      child: Center(
                        child: SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                robot_image,
                                width: screenSize.width * 0.4,
                                height: screenSize.height * 0.2,
                              ),
                              AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Welocome to my new project',
                                    textStyle: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TypewriterAnimatedText(
                                    'How can i help you',
                                    textStyle: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TypewriterAnimatedText(
                                    'send the context what you are looking for !',
                                    textStyle: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                displayFullTextOnTap: true,
                                stopPauseOnTap: true,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: context.read<ChatBloc>().chats.length,
                          itemBuilder: (context, index) {
                            if (context
                                    .read<ChatBloc>()
                                    .chats[index]
                                    .promptType ==
                                PromptType.gemini) {
                              return PromptByGemini(
                                  onAnimating: () {
                                    scrollController.animateTo(
                                        scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.bounceIn);
                                  },
                                  chat: context.read<ChatBloc>().chats[index]);
                            } else if (context
                                    .read<ChatBloc>()
                                    .chats[index]
                                    .promptType ==
                                PromptType.user) {
                              return PromptByUser(
                                prompt: context
                                        .read<ChatBloc>()
                                        .chats[index]
                                        .prompt ??
                                    "",
                                onPressed: () {
                                  chatBloc?.add(EditMessageEvent(
                                      chat: context
                                          .read<ChatBloc>()
                                          .chats[index]));
                                },
                              );
                            } else if (context
                                    .read<ChatBloc>()
                                    .chats[index]
                                    .promptType ==
                                PromptType.error) {
                              return ResponseError(
                                chat: context.read<ChatBloc>().chats[index],
                              );
                            } else if (context
                                    .read<ChatBloc>()
                                    .chats[index]
                                    .promptType ==
                                PromptType.editable) {
                              return EditablePrompt(
                                chat: context.read<ChatBloc>().chats[index],
                                textController: TextEditingController(
                                    text: context
                                        .read<ChatBloc>()
                                        .chats[index]
                                        .prompt),
                              );
                            } else {
                              return const ResponseLoading();
                            }
                          }),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                      hintText: "Enter a prompt here",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
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
            ],
          ),
        ),
      ),
    );
  }
}
