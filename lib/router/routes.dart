class Routes {
  Routes._();
  static const String collection = '/collection';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String cardDetails = '/card_details';
  static const String login = '/login';
  static const String register = '/register';

  static const String nestedCardDetailsCollection = '/collection/card_details';
  static const String nestedCardDetailsSearch = '/search/card_details';

  static const String showDialog = '/show_dialog/:title/:message';
}
