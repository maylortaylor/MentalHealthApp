import 'dart:developer';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/models/answer_model.dart';
import 'package:mental_health_app/models/arguments/PromptArguments.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/models/prompts_model.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';


late DatabaseReference _promptsRef;
late SwiperController _swiperController;
List<Prompt> promptsList = [];
late Prompt currentPrompt;
class PromptScreen extends StatefulWidget {
  // const PromptScreen({super.key});

  // const PromptScreen({super.key, this.category, this.step});
  const PromptScreen({super.key, this.args});
  // final String? category;
  // final int? step;
  final PromptArguments? args;

  @override
  _PromptScreenState createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  late AnswerModel _answerModel;
  String _nextButtonText = "Next";
  bool _showFrontSide = true;
  bool _flipXAxis = true;
  late int _currentIndex;
  bool nextPageIsActive = false;
  final answerAreaTextController = TextEditingController();

  Future<void> init() async {
    _swiperController = SwiperController();
    final database = FirebaseDatabase.instance;
    answerAreaTextController.addListener(_textAnswerListener);
    database.setLoggingEnabled(false);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

   @override
  void dispose() {
    answerAreaTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    
    print('Category: ${widget.args?.category}');
    print('Step: ${widget.args?.step}');
    int? step = widget.args?.step;

    // _currentIndex = (step! - 1);
        
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getAppBarColor(),
        title: Text(
          'How to manage ${widget.args?.category}',
          style: const TextStyle(
            fontFamily: AppFontFamily.poppins,
            fontSize: 22
          ),),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        titleTextStyle: const TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white
        ),
      ),
      body: Column(
        children:[
          _buildFlipAnimation(context)
          // LayoutBuilder(builder: (context, constraints) {
          //   if (constraints.maxWidth > 600) {
          //     // return _landscapeMode(context);
          //     return _buildFlipAnimation(context);
          //   } else {
          //     return _portraitMode(context);
          //   }
          // },),
        ]
      )
    );
  }

 void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  void _textAnswerListener() {
    if (answerAreaTextController.text.isNotEmpty && answerAreaTextController.text.length >= 7) {
      setState(() {
        nextPageIsActive = true;
      });
    } else {
      setState(() {
        nextPageIsActive = false;
      });
    }
  }

  Color _getAppBarColor() {
    switch (widget.args?.category) {
      case "Angry":
        return AppThemes.angryColor;
      case "Anxiety":
        return AppThemes.anxiousColor;
      case "Depression":
        return AppThemes.depressedColor;
      case "Guilt":
        return AppThemes.guiltyColor;
      default:
        return AppThemes.angryColor;
    }
  }
  
  void _previousCard() {
    _swiperController.previous(animation: true);
  }
  
  void _nextCard() {
    _swiperController.next(animation: true);

    setState(() {
      nextPageIsActive = false;
    });
  }

  _saveAnswerToDatabase() {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    _answerModel = AnswerModel(
      step: currentPrompt.step, 
      category: widget.args!.category.toLowerCase(),
      answerText: answerAreaTextController.text, 
      watchedVideo: false,
      dateCreated: DateTime.now().toIso8601String()
    );

    print("SAVING ANSWER");
    inspect(_answerModel);

    firestoreDatabase.setUserAnswerCat(_answerModel, _answerModel.category);
  }
 
  Widget _buildFront(context) {
  // return __buildLayout(
  //   key: ValueKey(true),
  //   backgroundColor: Colors.blue,
  //   faceName: "F",
  // );
  return __buildLayout(context);
}

Widget _buildPortraitFront(context) {
  // return __buildLayout(
  //   key: ValueKey(true),
  //   backgroundColor: Colors.blue,
  //   faceName: "F",
  // );
  // return __buildLayout(context);
  return _portraitMode(context);
}

  Widget __buildLayout(context) {
// Widget __buildLayout({Key? key, String? faceName, Color? backgroundColor}) {
  return _landscapeMode(context);
  // return Container(
  //   key: key,
  //   decoration: BoxDecoration(
  //     shape: BoxShape.rectangle,
  //     borderRadius: BorderRadius.circular(20.0),
  //     color: backgroundColor,
  //   ),
  //   child: Center(
  //     child: Text(faceName!.substring(0, 1), style: TextStyle(fontSize: 80.0)),
  //   ),
  // );
}
  Widget __buildLayoutRear({Key? key, String? faceName, Color? backgroundColor}) {
  return Container(
    key: key,
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(20.0),
      color: backgroundColor,
    ),
    child: Center(
      child: Text(faceName!.substring(0, 1), style: TextStyle(
        fontFamily: AppFontFamily.poppins,
        fontSize: 80.0)),
    ),
  );
}

  Widget _buildRear(context) {
  // return __buildLayoutRear(
  //   key: ValueKey(false),
  //   backgroundColor: Colors.blue.shade700,
  //   faceName: "R",
  // );
  return _buildVimeoCard(context);
}

  Widget _buildVimeoCard(BuildContext context) {
    return Card(
      color: Theme.of(context).cardTheme.color,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
            IconButton(
              onPressed: (){
                _switchCard();
              }, 
              icon: const Icon(
                Icons.arrow_back,
              )
            ),
          ],),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    // child: VimeoPlayer(id:'70591644', autoPlay: true,),
                  child: VimeoVideoPlayer(
                      vimeoPlayerModel: VimeoPlayerModel(
                        // url: promptsList[_currentIndex].videoUrl!,
                        // url: 'https://vimeo.com/362134114/5fd352ede3',
                        url: 'https://vimeo.com/70591644',
                        deviceOrientation: DeviceOrientation.portraitUp,
                        systemUiOverlay: const [
                          SystemUiOverlay.top,
                          SystemUiOverlay.bottom,
                          ],
                      ),
                    )
                  ),
                )
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlipAnimation(context) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        // child: _showFrontSide ? _buildFront(context) : _buildRear(context),
        child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // return _landscapeMode(context);
                  return _showFrontSide ? _buildFront(context) : _buildRear(context);
                  // return _buildFlipAnimation(context);
                } else {
                  // return _portraitMode(context);
                  return _showFrontSide ? _buildPortraitFront(context) : _buildRear(context);
                }
              },),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget!.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _landscapeMode(context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){
                  _previousCard();
                }, 
                icon: Icon(
                  Icons.arrow_back,
                )
              ),
              Container(
                child: Text("Back")
              )
          ]),
        ),
        Container(
          child: _buildBodySection(context, widget.args?.category ?? "none"),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: nextPageIsActive ? (){
                  
                  _saveAnswerToDatabase();
                  answerAreaTextController.clear();

                  if (promptsList.length == (_currentIndex + 1)) {
                    // last prompt -- finish
                    Navigator.pushNamed(
                        context,
                        AppRoutes.home,
                    );
                  } else {
                    _nextCard();
                  }
                } : null, 
                icon: Icon(
                  Icons.arrow_forward,
                  color: nextPageIsActive ? null : Colors.grey
                )
              ),
              Container(
                child: Text(_nextButtonText)
              )
            ]
            ),)
      ],
    );
  }

  Widget _portraitMode(context) {
    return Flexible(
      child: Row(
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width * 0.15,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       IconButton(
          //         onPressed: (){
          //           _previousCard();
          //         }, 
          //         icon: Icon(Icons.arrow_back)
          //       ),
          //       Container(
          //         child: Text("Back")
          //       )
          //   ]),
          // ),
          Container(
            child: _buildBodySection(context, widget.args!.category),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width * 0.15,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       IconButton(
          //         onPressed: (){
          //           _nextCard();
          //         }, 
          //         icon: Icon(Icons.arrow_forward)
          //       ),
          //       Container(
          //         child: Text("Next")
          //       )
          //     ]
          //     ),)
        ],
      ),
    );
  }

  Widget _buildBodySection(BuildContext context, String category) {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder(
        stream: firestoreDatabase.promptsCategoryStream(category: category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            promptsList = snapshot.data as List<Prompt>;

            if (promptsList.isNotEmpty) {
              return buildSwiper();
            } else {
              //todosEmptyTopMsgDefaultTxt
              return Flexible(child: Container(
                color: Theme.of(context).cardTheme.color)
                );
            }
          } else if (snapshot.hasError) {
            //todosErrorTopMsgTxt
            return Flexible(child: Container(color: Colors.red,));
          }
          return Flexible(child: Center(child: CircularProgressIndicator()));
        });
  }

  Widget buildSwiper() {
    return Expanded(
      child: Swiper(itemCount: promptsList.length, itemBuilder: _buildItem,
        onIndexChanged: (index) {
          print("ON INDEX CHANGED ${index}");
          setState(() {
            _currentIndex = index;
            inspect(promptsList[index]);
            if (promptsList.length == (_currentIndex + 1)) {
              _nextButtonText = "Finish";
            } else {
              _nextButtonText = "Next";
            }
          });
        },
        controller: _swiperController,
        loop: true,
        scrollDirection: Axis.horizontal,
        axisDirection: AxisDirection.left,
        physics: NeverScrollableScrollPhysics(),
        pagination: const SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                size: 20.0, activeSize: 20.0, space: 10.0))),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    currentPrompt = Prompt(
      id: promptsList[index].id,
      title: promptsList[index].title,
      body: promptsList[index].body,
      textPrompt: promptsList[index].textPrompt,
      step: promptsList[index].step,
      dateCreated: promptsList[index].dateCreated
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).cardTheme.color,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      child: cardStepArea(index)
                    ),
                    Flexible(
                      flex: 10,
                      fit: FlexFit.loose,
                      child: cardTitleArea(index)
                    ),
                    Container(
                      width: 100,
                      child: displayPlayButton(index)
                    )
                  ]
                ),
              ),
             bodyArea(index),
             answerArea(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardStepArea(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AutoSizeText(
          'Step',
        maxLines: 1,
        minFontSize: 8,
        maxFontSize: 12, 
        style: TextStyle(
            fontFamily: AppFontFamily.poppins,
            // fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
        )
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          // padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
          child: Container(
                child: AutoSizeText(
                  '# ${promptsList[index].step}',
                maxLines: 1,
                minFontSize: 8,
                maxFontSize: 12,  
                style: const TextStyle(
                  fontFamily: AppFontFamily.poppins,
                  // fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
              )
            )
          ),
        ),
      ],
    );
  }
  
  Widget cardTitleArea(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.55,
        child: AutoSizeText(
          '${promptsList[index].title}', 
        maxLines: 1,
        minFontSize: 8,
        maxFontSize: 30,
        style: const TextStyle(
            fontFamily: AppFontFamily.poppins,
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )
        )
      ),
    );
  }
  
  Widget promptText(int index) {
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
  
  Widget bodyArea(int index) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * .50,
        constraints: BoxConstraints(maxHeight: double.infinity),
        // height: MediaQuery.of(context).size.height * .40,
        decoration: BoxDecoration(
          color: AppThemes.promptCardColor,
          border: Border.all(
            color: Colors.white
          ),
        borderRadius: BorderRadius.circular(20) // use instead of BorderRadius.all(Radius.circular(20))
        ),
        child: AutoSizeText(
          '${promptsList[index].body}', 
        maxLines: 20,
        minFontSize: 4,
        maxFontSize: 24,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
              fontFamily: AppFontFamily.poppins,
              // fontSize: 18,
              color: Colors.white,
              fontStyle: FontStyle.italic
          ),
        )
      ),
    );
  }

  Widget answerArea(int index) {
    const maxLines = 5;
    const numberOfLines = 5;
    const cursorHeight = 22.0;

    return  Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          promptText(index),
          Stack(
            children: [
              for (int i = 0; i < numberOfLines; i++)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: 4 + (i + 1) * cursorHeight,
                    left: 15,
                    right: 15,
                  ),
                  height: 1,
                  color: Colors.white,
                ),
               SizedBox(
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
                      hintText: promptsList[index].textPrompt,
                      hintStyle: TextStyle(color: Colors.white)
                      ),
                    cursorHeight: cursorHeight,
                    keyboardType: TextInputType.multiline,
                    // expands: true,
                    maxLines: maxLines,
                  ),
                ),
              ),
            ],
          ),
          // TextField(
          //   controller: answerAreaTextController,
          //   style: const TextStyle(
          //     fontSize: 14,
          //     fontFamily: AppFontFamily.poppins,
          //     color: Colors.white
          //   ),
          //   cursorColor: Colors.white,
          //   autofocus: true,
          //   keyboardType: TextInputType.multiline,
          //   minLines: maxLines,
          //   maxLines: maxLines + 2,
          //   decoration: InputDecoration(
          //     fillColor: AppThemes.midCardColor,
          //     filled: true,
          //     hintText: promptsList[index].textPrompt,
          //     hintMaxLines: 40,
          //     hintStyle: const TextStyle(
          //       color: Colors.white,
          //       fontSize: 18,
          //       fontStyle: FontStyle.italic
          //     ),
          //     // enabledBorder: const OutlineInputBorder(
          //     //   borderSide: BorderSide(color: Colors.white, width: 0.0),
          //     // ),
          //     enabledBorder: const UnderlineInputBorder( //<-- SEE HERE
          //       borderSide: BorderSide(
          //           width: 3, color: Colors.greenAccent), 
          //     ),
          //     focusedBorder: const OutlineInputBorder( //<-- SEE HERE
          //       borderSide: BorderSide(
          //           width: 3, color: Colors.blueAccent), 
          //     ),
          //     errorBorder: const OutlineInputBorder( //<-- SEE HERE
          //       borderSide: BorderSide(
          //           width: 3, color: Colors.redAccent), 
          //     ),
          //     border: const OutlineInputBorder(),
          //   ),
          // ),
        ],
      ),
    );
  }
  
  Widget displayPlayButton(int index) {
    if (promptsList[index].videoUrl!.isEmpty) {
      return Container();    
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            // Go to video url
            _switchCard();
            // Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return VideoScreen(videoUrl: promptsList[index].videoUrl!,);
            //         },
            //       ),
            //     );
          }, 
          icon: Icon(Icons.play_arrow)
        ),
        const AutoSizeText(
          "Play Video",
        maxLines: 1,
        minFontSize: 4,
        maxFontSize: 12, 
        style: TextStyle(
          fontFamily: AppFontFamily.poppins,
          color: Colors.white
        ),)
      ],
    );
  }

}

