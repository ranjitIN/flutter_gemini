import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CustomMarkDownTypewriterAnimatedText extends AnimatedText {
  // The text length is padded to cause extra cursor blinking after typing.
  static const extraLengthForBlinks = 8;

  /// The [Duration] of the delay between the apparition of each characters
  ///
  /// By default it is set to 30 milliseconds.
  final Duration speed;

  /// The [Curve] of the rate of change of animation over time.
  ///
  /// By default it is set to Curves.linear.
  final Curve curve;

  /// Cursor text. Defaults to underscore.
  final String cursor;

  CustomMarkDownTypewriterAnimatedText(
    String text, {
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    this.speed = const Duration(milliseconds: 30),
    this.curve = Curves.linear,
    this.cursor = '_',
  }) : super(
          text: text,
          textAlign: textAlign,
          textStyle: textStyle,
          duration: speed * (text.characters.length + extraLengthForBlinks),
        );

  late Animation<double> _typewriterText;

  @override
  Duration get remaining =>
      speed *
      (textCharacters.length + extraLengthForBlinks - _typewriterText.value);

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = CurveTween(
      curve: curve,
    ).animate(controller);
  }

  // @override
  // Widget completeText(BuildContext context) => RichText(
  //       text: TextSpan(
  //         children: [
  //           TextSpan(text: text),
  //           TextSpan(
  //             text: cursor,
  //             style: const TextStyle(color: Colors.transparent),
  //           )
  //         ],
  //         style: DefaultTextStyle.of(context).style.merge(textStyle),
  //       ),
  //       textAlign: textAlign,
  //     );

  @override
  Widget completeText(BuildContext context) => Markdown(
    padding: EdgeInsets.zero,
        selectable: true,
        shrinkWrap: true,
        data: text,
        physics: const ScrollPhysics(),
        builders: {
          'code': CodeElementBuilder(context: context),
        },
        styleSheet: MarkdownStyleSheet(
            // code: const TextStyle(backgroundColor: Colors.transparent),
            // codeblockDecoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10),
            //   color: Colors.blueAccent.withOpacity(0.1),
            // ),
            ),
      );

  /// Widget showing partial text
  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    /// Output of CurveTween is in the range [0, 1] for majority of the curves.
    /// It is converted to [0, textCharacters.length + extraLengthForBlinks].
    final textLen = textCharacters.length;
    final typewriterValue = (_typewriterText.value.clamp(0, 1) *
            (textCharacters.length + extraLengthForBlinks))
        .round();

    var showCursor = true;
    var visibleString = text;
    if (typewriterValue == 0) {
      visibleString = '';
      showCursor = false;
    } else if (typewriterValue > textLen) {
      showCursor = (typewriterValue - textLen) % 2 == 0;
    } else {
      visibleString = textCharacters.take(typewriterValue).toString();
    }

    // return RichText(
    //   text: TextSpan(
    //     children: [
    //       TextSpan(text: visibleString),
    //       TextSpan(
    //         text: cursor,
    //         style:
    //             showCursor ? null : const TextStyle(color: Colors.transparent),
    //       )
    //     ],
    //     style: DefaultTextStyle.of(context).style.merge(textStyle),
    //   ),
    //   textAlign: textAlign,
    // );

    return Markdown(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      selectable: true,
      physics: const ScrollPhysics(),
      data: visibleString,
      builders: {
        'code': CodeElementBuilder(context: context),
      },
      styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
      styleSheet: MarkdownStyleSheet(
          // code: const TextStyle(backgroundColor: Colors.transparent),
          // codeblockDecoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10),
          //   color: Colors.blueAccent.withOpacity(0.1),
          // ),
          ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  BuildContext context;
  CodeElementBuilder({required this.context});
  @override
  Widget visitElementAfter(element, TextStyle? preferredStyle) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(
            element.textContent,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12.0,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // FlutterClipboard.copy(element.textContent!).then(
              //   (value) => ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text('Copied to clipboard!'),
              //     ),
              //   ),
              // );
              Clipboard.setData(ClipboardData(text: element.textContent));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Copied! Text copied to clipboard.')));
            },
            iconSize: 16,
          ),
        ),
      ],
    );
  }
}
