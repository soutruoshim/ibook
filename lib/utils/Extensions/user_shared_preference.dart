import 'package:ibook/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('userId',user.userId);
    prefs.setString('firstname',user.firstname);
    prefs.setString('lastname',user.lastname);
    prefs.setString('email',user.email);
    prefs.setString('password',user.password);
    prefs.setString('token',user.token);

    return prefs.commit();

  }

  Future<User> getUser ()  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString("userId")??"";
    String firstname = prefs.getString("firstname")??"";
    String lastname = prefs.getString("lastname")??"";
    String email = prefs.getString("email")??"";
    String password = prefs.getString("password")??"";
    String token = prefs.getString("token")??"";

    return User(
        userId: userId,
        firstname: firstname,
        lastname: lastname,
        email: email,
        password: password,
        token: token);
  }

  void removeUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('userId');
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('phone');
    prefs.remove('type');
    prefs.remove('token');

  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token")??"";
    return token;
  }

}