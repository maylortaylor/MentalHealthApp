import 'package:flutter/material.dart';
import 'package:mental_health_app/constants/app_font_family.dart';
import 'package:mental_health_app/constants/app_colors.dart';

class ErrorScreen extends StatefulWidget {
  ErrorScreen({Key? key}) : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.angryColor,
        title: Text(
          'Uh oh...',
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
      body: Card(
              child: Padding(
                child: Text(
                  "Something is not right here...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
              ),
              color: Colors.red,
              margin: EdgeInsets.zero,
            ),);
  }
}