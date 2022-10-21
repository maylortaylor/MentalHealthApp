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
import 'package:mental_health_app/widgets/responsive.dart';
import 'package:mental_health_app/widgets/video.dart';
import 'package:provider/provider.dart';
import 'package:mental_health_app/models/prompts_model.dart';


late DatabaseReference _promptsRef;
late SwiperController _swiperController;
List<Prompt> promptsList = [];
List<AnswerModel> answerList = [];
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
  late int _currentIndex = 0;
  bool nextPageIsActive = true;
  bool prevPageIsActive = false;
  bool hasWatchedVideo = false;
  String? _argCategory;
  int? _argStep;
  final answerAreaTextController = TextEditingController();
  late List<TextEditingController> answerAreaTextControllers;

  Future<void> init() async {
    _swiperController = SwiperController();
    final database = FirebaseDatabase.instance;
    // answerAreaTextController.addListener(_textAnswerListener);
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
    _argCategory = widget.args?.category;
    _argStep = widget.args?.step;
    
    print('Category: ${_argCategory}');
    print('Step: ${_argStep}');
    int? step = widget.args?.step;

    // _currentIndex = (step! - 1);
        
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: _getAppBarColor(),
        title: Text(
          'How to manage ${_argCategory}',
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
          _buildFlipAnimation(context),
          ResponsiveWidget.isSmallScreen(context) ?
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: prevPageIsActive ? _previousCard : () {},
                        icon: Icon(
                          Icons.arrow_back,
                          color: prevPageIsActive ? null : Colors.grey,
                        )
                      ),
                      const Text("Back")
                  ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: nextPageIsActive ? _nextPageAction : () { }, 
                        icon: Icon(
                          Icons.arrow_forward,
                          color: nextPageIsActive ? null : Colors.grey
                        )
                      ),
                      Text(_nextButtonText)
                    ]
                  ),
                ],
              ),
            )
           : Container()
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
    nextPageIsActive = true;
    // if (answerAreaTextControllers[0].text.isNotEmpty && answerAreaTextControllers[0].text.length >= 7) {
    //   setState(() {
    //     nextPageIsActive = true;
    //   });
    // } else {
    //   setState(() {
    //     nextPageIsActive = false;
    //   });
    // }



    // if (answerAreaTextController.text.isNotEmpty && answerAreaTextController.text.length >= 7) {
    //   setState(() {
    //     nextPageIsActive = true;
    //   });
    // } else {
    //   setState(() {
    //     nextPageIsActive = false;
    //   });
    // }
  }

  Color _getAppBarColor() {
    switch (_argCategory) {
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
    if (!answerList.asMap().containsKey(_currentIndex - 2)) {
      prevPageIsActive = false;
    }
  }
  
  void _nextCard() {
    _swiperController.next(animation: true);

    setState(() {
      // nextPageIsActive = false;
      prevPageIsActive = true;
    });
  }

  void _saveAnswerToDatabase() {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    List<String> answers = []; 

    for (var ans in promptsList[_currentIndex].textPrompts) {
      answers.add(ans!);
    }

    _answerModel = AnswerModel(
      step: currentPrompt.step, 
      category: _argCategory!.toLowerCase(),
      answerText: answers, 
      watchedVideo: hasWatchedVideo,
      dateCreated: DateTime.now().toIso8601String()
    );


    print("SAVING ANSWER");
    inspect(_answerModel);
    answerList.add(_answerModel);

    // firestoreDatabase.setUserAnswerCat(_answerModel, _answerModel.category);
  }
 
  Widget _buildVimeoCard(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
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
                      child: VideoPlayerWidget(
                        filename: 'videos/${_argCategory!.toLowerCase()}/${currentPrompt.videoName!}.mp4',
                      )
                    ),
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipAnimation(context) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child:  _showFrontSide ? _mainPromptArea(context) : _buildVimeoCard(context),
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

  Widget _mainPromptArea(context) {
    return Row(
      children: [
        (ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context)) ? Container(
          width: MediaQuery.of(context).size.width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: prevPageIsActive ? _previousCard : () {},
                icon: Icon(
                  Icons.arrow_back,
                  color: prevPageIsActive ? null : Colors.grey,
                )
              ),
              const Text("Back")
          ]),
        ) : Container(),
        Container(
          child: _buildBodySection(context, _argCategory!),
        ),
        (ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context)) ? Container(
          width: MediaQuery.of(context).size.width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: nextPageIsActive ? _nextPageAction : () {
                  
                }, 
                icon: Icon(
                  Icons.arrow_forward,
                  color: nextPageIsActive ? null : Colors.grey
                )
              ),
              Text(_nextButtonText)
            ]
            ),) : Container()
      ],
    );
  }

  _nextPageAction() {
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
        loop: false,
        scrollDirection: Axis.horizontal,
        axisDirection: AxisDirection.left,
        physics: NeverScrollableScrollPhysics(),
        pagination: const SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                size: 10.0, activeSize: 20.0, space: 10.0))),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    currentPrompt = Prompt(
      id: promptsList[index].id,
      title: promptsList[index].title,
      body: promptsList[index].body,
      textPrompt: promptsList[index].textPrompt,
      textPrompts: promptsList[index].textPrompts,
      step: promptsList[index].step,
      dateCreated: promptsList[index].dateCreated,
      videoName: promptsList[index].videoName,
      videoUrl: promptsList[index].videoUrl
    );

    answerAreaTextControllers =
      List.generate(currentPrompt.textPrompts.length, (i) => TextEditingController());

    for (var e in answerAreaTextControllers) {
      e.addListener(_textAnswerListener);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).cardTheme.color,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              (ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context)) ? 
                largeScreenTopRow(index) : smallScreenTopRow(index),
              ResponsiveWidget.isSmallScreen(context) ? cardTitleArea(index) : Container(),
             bodyArea(index),
             for (int i = 0; i < currentPrompt.textPrompts.length; i++)
              answerArea(index, i),
            ],
          ),
        ),
      ),
    );
  }

  Widget largeScreenTopRow(index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: cardStepArea(index)
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.loose,
            child: cardTitleArea(index)
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: displayPlayButton(index)
          )
        ]
      ),
    );
  }

  Widget smallScreenTopRow(index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: cardStepArea(index)
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: displayPlayButton(index)
          )
        ]
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
      child: AutoSizeText(
        '${promptsList[index].title}', 
      maxLines: 1,
      minFontSize: 20,
      maxFontSize: 36,
      style: const TextStyle(
          fontFamily: AppFontFamily.poppins,
          // fontSize: 36,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )
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
  
  Widget bodyArea(int index) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
      child: Container(
        width: ResponsiveWidget.isSmallScreen(context) 
          ? MediaQuery.of(context).size.width * .85 :  MediaQuery.of(context).size.width * .60,
        height: MediaQuery.of(context).size.height * .25,
        decoration: BoxDecoration(
          color: AppThemes.promptCardColor,
          border: Border.all(
            color: Colors.white
          ),
        borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
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
            ),
          ),
        )
      ),
    );
  }

  Widget answerArea(int index, int promptIndex) {
    const maxLines = 5;
    const numberOfLines = 5;
    const cursorHeight = 22.0;

    return  Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          tapToTypeText(),
          Stack(
            children: [
               Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppThemes.midCardColor
                ),
                 child: SizedBox(
                  height: numberOfLines * (cursorHeight + 8),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15),
                     child: TextField(
                       controller: answerAreaTextControllers[promptIndex],
                       autofocus: false,
                       style: const TextStyle(
                         fontSize: 14,
                         fontFamily: AppFontFamily.poppins,
                         color: Colors.white
                       ),
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         hintText: promptsList[index].textPrompts[promptIndex],
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
  
  Widget displayPlayButton(int index) {
    if (promptsList[index].videoUrl!.isEmpty) {
      return Container();    
    }
    Widget circle = Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: AppThemes.mediumGreen,
        shape: BoxShape.circle,
      ),
    );
    
    return Column(
      children: [
        Stack(
          children: [
            circle,
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    // Go to video url
                    _switchCard();
                
                    setState(() {
                      hasWatchedVideo = true;
                    });
                  }, 
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    )
                ),
              ),
            ),
          ],
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
