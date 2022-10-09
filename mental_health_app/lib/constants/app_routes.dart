class AppRoutes {
  static const String root = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String settings = '/settings';
  static const String answers = '/answers';
  static const String payment = '/pay';
  static const String prompt = '/prompt';
  static const String anger = '/anger';
  static const String anxiety= '/anxiety';
  static const String depression = '/depression';
  static const String guilt = '/guilt';
  
  static render(String url, {Map<String, dynamic>? params}) {
    return Uri(path: url, queryParameters: params ?? {}).toString();
  }
}