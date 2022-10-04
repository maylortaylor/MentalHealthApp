/*
This class defines all the possible read/write locations from the FirebaseFirestore database.
In future, any new path can be added here.
This class work together with FirestoreService and FirestoreDatabase.
 */

class FirestorePath {
  // static String todo(String uid, String todoId) => 'users/$uid/todos/$todoId';
  // static String todos(String uid) => 'users/$uid/todos';
  static String prompt(String uid) => 'prompts/$uid';
  static String user(String uid) => 'users/$uid';
  static String prompts() => 'prompts';
  static String users() => 'users';
  static String answers(String uid) => 'answers/$uid';
  // static String answersCat(String uid, String cat) => 'answers/$uid/$cat';
}