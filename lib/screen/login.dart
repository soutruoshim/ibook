import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';

import 'package:ibook/model/user.dart';
import 'package:ibook/providers/auth_provider.dart';
import 'package:ibook/providers/user_provider.dart';
import 'package:ibook/screen/SettingScreen.dart';
import 'package:ibook/screen/register.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/validator.dart';
import 'package:ibook/utils/widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();

  String _userName = "", _password = "";


  @override
  Widget build(BuildContext context) {

    AuthProvider auth = Provider.of<AuthProvider>(context);

    var doLogin = (){

      final form = formKey.currentState;

      if(form!.validate()){

        form.save();

        final Future<Map<String,dynamic>> respose =  auth.login(_userName,_password);

        respose.then((response) {
          print("respone $response");
          if (response['status']) {

            User user = response['user'];
            print("user response ${user.email}");

            Provider.of<UserProvider>(context, listen: false).setUser(user);

            //Navigator.pushReplacementNamed(context, '/dashboard');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SettingScreen(onTap: (){})));
          } else {
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              titleText: Text(
                "Failed Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: "ShadowsIntoLightTwo"),
              ),
              messageText: Text(
                response['message']['message'].toString(),
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: "ShadowsIntoLightTwo"),
              ),
            )..show(context);
          }
        });


      }else{
        Flushbar(
          title: 'Invalid form',
          message: 'Please complete the form properly',
          duration: Duration(seconds: 10),
        ).show(context);
      }

    };


    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/reset-password');
          },
        ),
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: ()
            //Navigator.pushReplacementNamed(context, '/register');
            async {
              //Register().launch(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Register()));
          },
        ),
      ],
    );

    return Scaffold(
        appBar: AppBar(title: Text('Login'),),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(26.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
                  Text("Email"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    //validator: (value)=> validateEmail(value!),
                    onSaved: (value)=> _userName = value??"",
                    decoration: buildInputDecoration('Enter Email',Icons.email),
                  ),
                  SizedBox(height: 20.0,),
                  Text("Password"),
                  SizedBox(height: 5.0,),
                  TextFormField(
                    autofocus: false,
                    obscureText: true,
                    validator: (value)=> value!.isEmpty?"Please enter password":null,
                    onSaved: (value)=> _password = value??"",
                    decoration: buildInputDecoration('Enter Password',Icons.lock),
                  ),
                  SizedBox(height: 20.0,),
                  auth.loggedInStatus == Status.Authenticating
                      ?loading
                      : longButtons('Login',doLogin),
                  SizedBox(height: 8.0,),
                  forgotLabel

                ],
              ),
            ),
          ),
        ),
      );

  }
}