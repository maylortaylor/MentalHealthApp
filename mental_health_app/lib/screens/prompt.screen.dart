import 'dart:developer';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/screens/video.screen.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/models/prompts_model.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

import '../models/prompts_model.dart';

late DatabaseReference _promptsRef;
late SwiperController _swiperController;
List<Prompt> promptsList = [];
class PromptScreen extends StatefulWidget {
  // const PromptScreen({Key? key}) : super(key: key);
  const PromptScreen({super.key, required this.category, this.step = 1});
  final String category;
  final int? step;

  @override
  _PromptScreenState createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  bool _showFrontSide = true;
  bool _flipXAxis = true;
  late int _currentIndex;
  bool nextPageIsActive = false;
  final answerAreaTextController = TextEditingController();

  Future<void> init() async {
    _currentIndex = 0;
    _swiperController = new SwiperController();
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
    // Clean up the controller when the widget is removed from the
    // widget tree.
    answerAreaTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);
        
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getAppBarColor(),
        title: Text(
          'How to manage ${widget.category}',
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
          // _landscapeMode(context)
          // LayoutBuilder(builder: (context, constraints) {
          //   if (constraints.maxWidth > 600) {
          //     return _landscapeMode(context);
          //   } else {
          //     return _portraitMode();
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
    switch (widget.category) {
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
      answerAreaTextController.clear();
    });
  }


  Widget _buildFront(context) {
  // return __buildLayout(
  //   key: ValueKey(true),
  //   backgroundColor: Colors.blue,
  //   faceName: "F",
  // );
  return __buildLayout(context);
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
          Row(children: [
            IconButton(
              onPressed: (){
                _switchCard();
              }, 
              icon: const Icon(
                Icons.arrow_back,
              )
            ),
          ],),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                    child: VimeoVideoPlayer(
                        vimeoPlayerModel: VimeoPlayerModel(
                          url: promptsList[_currentIndex].videoUrl!,
                          // url: 'https://vimeo.com/253989945',
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
          ),
        ],
      ),
    );
  }

  Widget _buildFlipAnimation(context) {
    return Flexible(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        child: _showFrontSide ? _buildFront(context) : _buildRear(context),
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
    return Flexible(
      child: Row(
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
            child: _buildBodySection(context, widget.category.toString()),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: nextPageIsActive ? (){
                    _nextCard();
                  } : null, 
                  icon: Icon(
                    Icons.arrow_forward,
                    color: nextPageIsActive ? null : Colors.grey
                  )
                ),
                Container(
                  child: Text("Next")
                )
              ]
              ),)
        ],
      ),
    );
  }

  Widget _portraitMode() {
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
            child: _buildBodySection(context, widget.category.toString()),
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
          setState(() {
            _currentIndex = index;
            inspect(promptsList[index]);
            // log(promptsList[index].body ?? "");
          });
        },
        controller: _swiperController,
        // control: const SwiperControl(
        //   size: 60,
        //   padding: EdgeInsets.all(8)
        // ),
        index: _currentIndex,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).cardTheme.color,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: cardStepArea(index)
                    ),
                    Flexible(
                      flex: 6,
                      child: cardTitleArea(index)
                    ),
                    Flexible(
                      flex: 1,
                      child: displayPlayButton(index)
                    )
                  ]
                ),
              ),
            ),
           textBoxArea(index),
           Spacer(),
           answerArea(index),
           Spacer(),
          ],
        ),
      ),
    );
  }

  Widget cardStepArea(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
          child: Container(
              child: const Text('Step', 
              style: TextStyle(
                  fontFamily: AppFontFamily.poppins,
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
              )
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
          child: Container(
                child: Text('# ${promptsList[index].step}', 
                style: const TextStyle(
                  fontFamily: AppFontFamily.poppins,
                  fontSize: 28,
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
        maxLines: 2,
        minFontSize: 22,
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
  Widget textBoxArea(int index) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: AppThemes.promptCardColor,
              child: AutoSizeText(
                // answerAreaTextController.text,
                '${promptsList[index].body} ${promptsList[index].body} ${promptsList[index].body} ${promptsList[index].body} ${promptsList[index].body}', 
              maxLines: 7,
              // presetFontSizes: [10, 30],
              minFontSize: 18,
              maxFontSize: 30,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                    fontFamily: AppFontFamily.poppins,
                    fontSize: 22,
                    color: Colors.white,
                    fontStyle: FontStyle.italic
                ),
              )
              // child: TextField(
              //   controller: TextEditingController(text: '${promptsList[index].body} ${promptsList[index].body}'),
              //   readOnly: true,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontFamily: AppFontFamily.poppins,
              //       fontSize: 16,
              //       color: Colors.white,
              //       fontStyle: FontStyle.italic
              //   ),
              //   cursorColor: Colors.white,
              //   autofocus: false,
              //   keyboardType: TextInputType.multiline,
              //   maxLines: null,
              //   decoration: InputDecoration(
              //     fillColor: AppThemes.promptCardColor,
              //     filled: true,
              //     // hintText: '${promptsList[index].body} ${promptsList[index].body}' ?? '',
              //     // hintMaxLines: 40,
              //     enabledBorder: const OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white, width: 0.0),
              //     ),
              //     focusedBorder: const OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white, width: 0.0),
              //     ),
              //     border: OutlineInputBorder(),
              //     // hintStyle: TextStyle(
              //     //   fontFamily: AppFontFamily.poppins,
              //     //   fontSize: 12,
              //     //   color: Colors.white,
              //     //   fontStyle: FontStyle.italic
              //     // ),
              // ),
              // ),
            ),
          )
        ],
      ),
    );
  }

  Widget answerArea(int index) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        children: [
          Container(
            child: Expanded(
              child: TextField(
                controller: answerAreaTextController,
                readOnly: false,
                style: TextStyle(
                  fontFamily: AppFontFamily.poppins,
                  color: Colors.white
                ),
                cursorColor: Colors.white,
                autofocus: false,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  fillColor: AppThemes.midCardColor,
                  filled: true,
                  // hintText: "",
                  hintMaxLines: 40,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 0.0),
                  ),
                  border: OutlineInputBorder(),
                  // hintStyle: TextStyle(
                  //   color: Colors.white,
                  //   fontSize: 18,
                  //   fontStyle: FontStyle.italic
                  // ),
                  // hintText: ""
              ),),
            )
          )
        ],
      ),
    );
  }
  Widget displayPlayButton(int index) {
    if (promptsList[index].videoUrl!.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            child: IconButton(
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
          ),
          Text("Play Video",
          style: TextStyle(
            fontFamily: AppFontFamily.poppins,
            color: Colors.white
          ),)
        ],
      );
    }
    return Container();    
  }
}

