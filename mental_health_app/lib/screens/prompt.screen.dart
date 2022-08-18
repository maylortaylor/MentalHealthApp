import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
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
  Future<void> init() async {
    _currentIndex = 0;
    _swiperController = new SwiperController();
    final database = FirebaseDatabase.instance;
    database.setLoggingEnabled(false);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);
        
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: Text(widget.category),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        titleTextStyle: TextStyle(
          color: Colors.white
        ),
      ),
      body: Column(
        children:[
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'How to manage ${widget.category.toUpperCase()}', 
                  style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          Flexible(
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
                        icon: Icon(Icons.arrow_back)
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
                        onPressed: (){
                          _nextCard();
                        }, 
                        icon: Icon(Icons.arrow_forward)
                      ),
                      Container(
                        child: Text("Next")
                      )
                    ]
                    ),)
              ],
            ),
          )
        ]
      )
    );
  }
  
  void _previousCard() {
    _swiperController.previous(animation: true);
  }
  void _nextCard() {
    _swiperController.next(animation: true);
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
              return Container(color: Colors.grey,);
            }
          } else if (snapshot.hasError) {
            //todosErrorTopMsgTxt
            return Container(color: Colors.red);
          }
          return Center(child: CircularProgressIndicator());
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
                      child: Column(
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
                                    fontSize: 32
                                )
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Padding(
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
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: displayPlayButton(index)
                    )
                  ]
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Container(
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          autofocus: false,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
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
                              color: Colors.white
                            ),
                        ),),
                      )
                    )
                  ],
                ),
              ),
            )
          ],
        ),
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

