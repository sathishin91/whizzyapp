import '../models/dropdown_model.dart';

class AppContext {
  AppContext._privateConstructor();

  static final AppContext _instance = AppContext._privateConstructor();

  factory AppContext() => _instance;

  String baseUrl = "";

  List<ListDropdown> listDropdown = [];
}
