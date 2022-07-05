
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:ibook/model/user.dart';
import 'package:ibook/providers/auth_provider.dart';
import 'package:ibook/providers/user_provider.dart';
import 'package:ibook/screen/login.dart';
import 'package:ibook/utils/Extensions/Widget_extensions.dart';
import 'package:ibook/utils/validator.dart';
import 'package:ibook/utils/widgets.dart';

import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  final formKey = GlobalKey<FormState>();


  String _firstname="", _lastname="", _username="" , _password="", _confirmPassword="";

  @override
  Widget build(BuildContext context) {

    AuthProvider auth = Provider.of<AuthProvider>(context);

    var loading  = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    var doRegister = (){
      print('on doRegister');

      final form = formKey.currentState;
      if(form!.validate()){

        form.save();

        auth.loggedInStatus = Status.Authenticating;
        auth.notify();

        Future.delayed(loginTime).then((_) async {
          //Navigator.pushReplacementNamed(context, '/login');

          //Login().launch(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));

          auth.loggedInStatus = Status.LoggedIn;
          auth.notify();
        });

        // now check confirm password
        if(_password.endsWith(_confirmPassword)){

          auth.register(_firstname, _lastname, _username, _password).then((response) {
          //   if(response['status']){
          //     User user = response['data'];
          //     Provider.of<UserProvider>(context,listen: false).setUser(user);
          //     //Navigator.pushReplacementNamed(context, '/login');
          //     Login().launch(context);
          //   }else{
          //     Flushbar(
          //       title: 'Registration fail',
          //       message: response.toString(),
          //       duration: Duration(seconds: 10),
          //     ).show(context);
          //   }
          // });
            if(response!=null){
                 print("user_registered $response");
                 //User user = response['data'];
                 //Provider.of<UserProvider>(context,listen: false).setUser(user);
                 //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
            }
          });

        }else{
          Flushbar(
            title: 'Mismatch password',
            message: 'Please enter valid confirm password',
            duration: Duration(seconds: 10),
          ).show(context);
        }

      }else{
        Flushbar(
          title: 'Invalid form',
          message: 'Please complete the form properly',
          duration: Duration(seconds: 10),
        ).show(context);
      }

    };

    return Scaffold(
      appBar: AppBar(title: Text('Registration'),),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(26.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.0,),
                Text('First Name'),
                TextFormField(
                  autofocus: false,
                  validator: (value)=>value!.isEmpty?'Please enter first name':null,
                  onSaved: (value) => _firstname = value!,
                  decoration: buildInputDecoration("Enter First Name", Icons.person),
                ),
                SizedBox(height: 20.0,),
                Text('Last Name'),
                SizedBox(height: 5.0,),
                TextFormField(
                  autofocus: false,
                  validator: (value)=>value!.isEmpty?'Please enter last name':null,
                  onSaved: (value) => _lastname = value!,
                  decoration: buildInputDecoration("Enter Last Name", Icons.person),
                ),
                SizedBox(height: 20.0,),
                Text('Email'),
                SizedBox(height: 5.0,),
                TextFormField(
                  autofocus: false,
                  //validator: (value)=>validateEmail(value!),
                  validator: (value)=>value!.isEmpty?'Please enter email':null,
                  onSaved: (value) => _username = value!,
                  decoration: buildInputDecoration("Enter Email", Icons.email),
                ),
                SizedBox(height: 20.0,),
                Text('Password'),
                SizedBox(height: 5.0,),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  validator: (value)=>value!.isEmpty?'Please enter password':null,
                  onSaved: (value) => _password = value!,
                  decoration: buildInputDecoration("Enter Password", Icons.lock),
                ),
                SizedBox(height: 20.0,),
                Text('Confirm Password'),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  validator: (value)=>value!.isEmpty?'Your password is required':null,
                  onSaved: (value) => _confirmPassword = value??"",
                  decoration: buildInputDecoration("Enter Confirm Password", Icons.lock),
                ),
                SizedBox(height: 20.0,),
                auth.loggedInStatus == Status.Authenticating
                    ?loading
                    : longButtons('Register',doRegister)
              ],
            ),
          ),
        ),
      ),
    );
  }
}