import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generative_ai_gemini/features/chat/bloc/chat_bloc.dart';
import 'package:generative_ai_gemini/features/chat/chat_view.dart';
import 'package:generative_ai_gemini/utils/const_asset.dart';
import 'package:generative_ai_gemini/widgets/type_writer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatBloc>(create: (context) => ChatBloc())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ChatView(),
      ),
    );
  }
}

// class MarkDownView extends StatelessWidget {
//   const MarkDownView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedTextKit(
//         isRepeatingAnimation: false,
//         repeatForever: false,
//         animatedTexts: [
//         CustomMarkDownTypewriterAnimatedText(markdownResponse)
//       ]),
//     );
//   }
// }
