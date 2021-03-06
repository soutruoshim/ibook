import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ibook/utils/Extensions/user_shared_preference.dart';
import 'package:ibook/utils/constant.dart';
import 'package:http/http.dart';
import 'package:ibook/model/user.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }

  Future<FutureOr> register(String firstname, String lastname, String email, String password) async {
    final Map<String, dynamic> apiBodyData = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password
    };

    return await post(
        Uri.parse(register_url),
        body: json.encode(apiBodyData),
        headers: <String, String>{'Content-Type':'application/json'}
    ).then(onValue)
        .catchError(onError);
  }

  notify(){
    notifyListeners();
  }

  static Future<FutureOr> onValue (Response response) async {
    var result ;

    final Map<String, dynamic> responseData = json.decode(response.body);

    print(responseData);

    if(response.statusCode == 200){

      var userData = responseData['data'];

      // now we will create a user model
      User authUser = User.fromJson(responseData);

      // now we will create shared preferences and save data
      UserPreferences().saveUser(authUser);

      result = {
        'status':true,
        'message':'Successfully registered',
        'data':authUser
      };

    }else{
      result = {
        'status':false,
        'message':'Successfully registered',
        'data':responseData
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {

    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(login_url),
      body: json.encode(loginData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ZGlzYXBpdXNlcjpkaXMjMTIz',
        'X-ApiKey' : 'ZGlzIzEyMw=='
      },
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = json.decode(response.body);

      print(responseData);

      var userData = responseData['user'];

      print("userData ${userData}");

      User authUser = User.fromJson(userData);

      print("user email ${authUser.email}");

      UserPreferences().saveUser(authUser);



      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
      print('Resulet $result');

    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }

    return result;

  }


  static onError(error){
    print('the error is ${error.detail}');
    return {
      'status':false,
      'message':'Unsuccessful Request',
      'data':error
    };
  }


}