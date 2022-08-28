import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/screens/video.screen.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/models/prompts_model.dart';

import '../models/prompts_model.dart';

class Constants {
  static const String Subscribe = 'Go Home Page';
  static const String Settings = 'Go Another Page';
  static const String SignOut = 'Refresh Page';

  static const List<String> choices = <String>[Subscribe, Settings, SignOut];
}

late DatabaseReference _promptsRef;
late SwiperController _swiperController;
List<Prompt> promptsList = [];
class PromptScreen extends StatefulWidget {
  // const PromptScreen({Key? key}) : super(key: key);
  const PromptScreen({super.key, required this.category});
  final String category;

  @override
  _PromptScreenState createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
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
          'How to manage ${widget.category.toUpperCase()}',
          style: TextStyle(fontSize: 22),),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        titleTextStyle: TextStyle(
          color: Colors.white
        ),
      ),
      body: Column(
        children:[
          _landscapeMode(context)
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
            child: _buildBodySection(context, widget.category),
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
            child: _buildBodySection(context, widget.category),
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
            log(promptsList[index].body ?? "");
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
              )
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
          child: Container(
                child: Text('# ${promptsList[index].step}', 
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32
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
            child: TextField(
              readOnly: true,
              style: TextStyle(
                color: Colors.black
              ),
              cursorColor: Colors.white,
              autofocus: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                fillColor: AppThemes.midCardColor,
                filled: true,
                hintText: promptsList[index].body ?? "",
                hintMaxLines: 40,
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 0.0),
                ),
                border: OutlineInputBorder(),
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontStyle: FontStyle.italic
                ),
            ),),
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
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return VideoScreen(videoUrl: promptsList[index].videoUrl!,);
                        },
                      ),
                    );
              }, 
              icon: Icon(Icons.play_arrow)
            ),
          ),
          Text("Play Video",
          style: TextStyle(
            color: Colors.white
          ),)
        ],
      );
    }
    return Container();    
  }
}

