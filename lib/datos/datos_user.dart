import 'package:shared_preferences/shared_preferences.dart';

class DataUser {
  static final DataUser _instance = DataUser._internal();

  int? userId;
  int? userRole;
  String? userPassword;

  factory DataUser() {
    return _instance;
  }

  DataUser._internal();

  // Cargar datos de SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('userId');
    userRole = prefs.getInt('userRole');
    userPassword = prefs.getString('userPassword');
  }

  // Guardar datos en SharedPreferences y en memoria
  Future<void> saveUserData(int userId, int userRole, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setInt('userRole', userRole);
    await prefs.setString('userPassword', password);

    this.userId = userId;
    this.userRole = userRole;
    userPassword = password;
  }

  // Borrar datos de usuario de SharedPreferences y de memoria
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userRole');
    await prefs.remove('userPassword');

    userId = null;
    userRole = null;
    userPassword = null;
  }
}
