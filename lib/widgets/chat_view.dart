import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:generative_ai_gemini/features/chat/bloc/chat_bloc.dart';
import 'package:generative_ai_gemini/model/chat.dart';
import 'package:generative_ai_gemini/utils/const_asset.dart';
import 'package:generative_ai_gemini/widgets/type_writer.dart';

class PromptByGemini extends StatelessWidget {
  final Chat chat;
  const PromptByGemini({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                robot_image,
                width: 16,
                height: 16,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: chat.generated
                            ? Markdown(
                                shrinkWrap: true,
                                data: chat.prompt ?? "",
                                builders: {
                                  'code': CodeElementBuilder(context: context),
                                },
                              )
                            : AnimatedTextKit(
                                onFinished: () {
                                  BlocProvider.of<ChatBloc>(context).add(
                                      ResponseLoadingEvent(
                                          chat: chat, loading: false));
                                },
                                isRepeatingAnimation: false,
                                animatedTexts: [
                                  CustomMarkDownTypewriterAnimatedText(
                                      chat.prompt ?? "")
                                ],
                              )),
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: chat.prompt ?? ""));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Copied! Text copied to clipboard.')));
                        },
                        icon: const Icon(Icons.copy),
                        iconSize: 14,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                        iconSize: 14,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromptByUser extends StatelessWidget {
  final String prompt;
  final Function() onPressed;
  const PromptByUser(
      {super.key, required this.prompt, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(prompt),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 6.0,
          ),
          IconButton(
            hoverColor: Colors.grey,
            onPressed: () {},
            icon: const Icon(Icons.edit),
            iconSize: 16,
          )
        ],
      ),
    );
  }
}

class ResponseError extends StatelessWidget {
  final Chat chat;
  const ResponseError({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                robot_image,
                width: 16,
                height: 16,
              ),
            ),
          ),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(chat.prompt ?? ""),
          )),
          CircleAvatar(
            backgroundColor: Colors.red,
            radius: 10,
            child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.error_outline_outlined,
                  color: Colors.white,
                  size: 10,
                )),
          ),
        ],
      ),
    );
  }
}

class ResponseLoading extends StatelessWidget {
  const ResponseLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              robot_image,
              width: 16,
              height: 16,
            ),
          ),
        ),
        const Card(
            child: SpinKitThreeBounce(
          size: 20,
          color: Colors.grey,
        ))
      ],
    );
  }
}
