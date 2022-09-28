import 'package:mental_health_app/constants/string_extensions.dart';

class PromptArguments {
  String category;
  int step;
 
  PromptArguments(this.category, {this.step = 1}) {
    category = category.capitalize();
    step = step;
  }
}