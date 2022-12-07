import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_themes.dart';

class AnswerArea extends StatefulWidget {
  AnswerArea({Key? key, required this.textPrompt, required this.nextPageStatus}) : super(key: key);
  late String textPrompt;
  late Function(bool) nextPageStatus;

  @override
  State<AnswerArea> createState() => _AnswerAreaState();
}

class _AnswerAreaState extends State<AnswerArea> {
  late List<TextEditingController> answerAreaTextControllers;
  final answerAreaTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

   @override
  void dispose() {
    super.dispose();
  }

  _textAnswerListener() {
    if (answerAreaTextController.text.isNotEmpty && answerAreaTextController.text.length >= 7) {
      widget.nextPageStatus(true);
    } else {
      widget.nextPageStatus(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    answerAreaTextController.addListener(_textAnswerListener);

    const maxLines = 5;
    const numberOfLines = 5;
    const cursorHeight = 22.0;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          tapToTypeText(),
          Stack(
            children: [
               Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppThemes.lightGrey
                ),
                 child: SizedBox(
                  height: numberOfLines * (cursorHeight + 8),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15),
                     child: TextField(
                       controller: answerAreaTextController,
                       autofocus: true,
                       style: const TextStyle(
                         fontSize: 14,
                         fontFamily: AppFontFamily.poppins,
                         color: Colors.white
                       ),
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: widget.textPrompt,
                         hintStyle: TextStyle(color: Colors.white),
                         ),
                       cursorHeight: cursorHeight,
                       keyboardType: TextInputType.multiline,
                       // expands: true,
                       maxLines: maxLines,
                     ),
                   ),
                 ),
               ),
              for (int i = 0; i < numberOfLines; i++)
                answerAreaTextController.text.isEmpty ? Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: 4 + (i + 1) * cursorHeight,
                    left: 15,
                    right: 15,
                  ),
                  height: 1,
                  color: Colors.white,
                ) : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget tapToTypeText() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: const Text(
          'Tap to Type', 
        style: TextStyle(
            fontFamily: AppFontFamily.poppins,
            // fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          )
        )
      ),
    );
  }
}