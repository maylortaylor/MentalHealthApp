import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/app_routes.dart';
import 'package:mental_health_app/constants/app_themes.dart';
import 'package:mental_health_app/models/answer_model.dart';
import 'package:mental_health_app/models/user_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/screens/prompt.screen.dart';
import 'package:mental_health_app/services/firestore_database.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AnswersScreen extends StatefulWidget {
  @override
  State<AnswersScreen> createState() => _AnswersScreenState();
}

class _AnswersScreenState extends State<AnswersScreen> {
  late List<AnswerModel> _userAnswers;

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  void initState() {
    super.initState();
    _userAnswers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Answers"),
        actions: [
            IconButton(
            tooltip: 'Settings',
            icon: Icon(Icons.settings), 
            color: AppThemes.whiteColor,
            onPressed: () {
              Navigator.pushNamed(
                  context,
                  AppRoutes.settings,
                  // arguments: PromptArguments(
                  //   'anxiety',
                  //   1,
                  // ),
                );
            },)
        ],
      ),
      body: _buildLayoutSection(context),
    );
  } 

  Widget _buildLayoutSection(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder(
      stream: firestoreDatabase.userAnswersStream(),
      builder: (context, snapshot)  {
        if (snapshot.hasData) {
          _userAnswers = snapshot.data as List<AnswerModel>;
    
          if (_userAnswers.isNotEmpty) {
            return ListView.builder(
              itemCount: _userAnswers.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: const Icon(Icons.question_answer),
                    trailing: Text(
                      "Step #${_userAnswers[index].step}",
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    subtitle: Text("${_userAnswers[index].category}"),
                    title: Text("${_userAnswers[index].answerText}"));
              });
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

  buildAnswerCards(snapshot) {
    return ListView.builder(
    itemCount: _userAnswers.length,
    itemBuilder: (BuildContext context, int index) {
      final answer = snapshot.data[index];

      return ListTile(
          leading: const Icon(Icons.list),
          trailing: Text(
            answer.answerText,
            style: TextStyle(color: Colors.green, fontSize: 15),
          ),
          title: Text("List item $index"));
    });
  }

}