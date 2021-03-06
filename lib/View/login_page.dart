import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController = TextEditingController();
  // assume our fields are valid by default
  bool _emailFieldValid = true;
  bool _passwordFieldValid = true;

  Widget appIcon(){
    return
    // return an image we get from a local directory
      Image.asset("Icons/apple.png", width: 700, height: 700);
  }

  Widget emailField(){
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          // provide the user with a keyboard specifically for email addresses
          keyboardType: TextInputType.emailAddress,
          controller: this._emailFieldController,
          decoration: InputDecoration(
              hintText: 'Email',
              // if the input provided to this field is invalid, display our error message
              errorText: !this._emailFieldValid ? "Please Enter an Email Address" : null,
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 5.0)
              )
          ),
        )
    );
  }

  Widget passwordField(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        // provide the user with a keyboard specifically for inputting passwords
          keyboardType: TextInputType.visiblePassword,
          // hide the characters the user types
          obscureText: true,
          controller: this._passwordFieldController,
          decoration: InputDecoration(
              hintText: 'Password',
              errorText: !this._passwordFieldValid ? "Please Enter a Password" : null,
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 5.0)
              )
          )
      ),
    );
  }

  Widget loginButton(){
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
            height: 50,
            child:
            ElevatedButton(
              onPressed: (){
                Config.log.i("user has pressed login button");
                // get the values from each of our input fields
                String inputEmail = this._emailFieldController.value.text;
                // TODO: do something about password here, should we refer to this in plaintext
                String inputPassword = this._emailFieldController.value.text;
                Config.log.i("user attempting to sign in with input email: " + inputEmail);
                // obviously do not log user's password
                // check if each of our fields is valid, do so within a setState
                // call so any changes to these fields is reflected in our other widgets
                setState((){
                  this._emailFieldValid = inputEmail!=null && inputEmail.isNotEmpty;
                  this._passwordFieldValid = inputPassword!=null && inputPassword.isNotEmpty;
                });

                if(this._emailFieldValid && this._passwordFieldValid){
                  // both input fields are valid, login using these fields
                  // TODO: define authentication in separate class, pass these fields to some authentication function
                  // take the user to the select institutions page after successful login
                  // clear our text fields before leaving the page
                  this._emailFieldController.clear();
                  this._passwordFieldController.clear();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return ChooseInstitute();
                      }));
                }
              },
              child: const Text("Login"),
            )
        )
    );
  }

  Widget forgotPasswordButton(){
    // display a button which is only clickable text, no border etc
    return TextButton(
      onPressed: (){
        Config.log.i("pressed forgot password button");
      },
      // specify a slightly smaller font size than regular for this button
      // as we want this button to be more out of the way
      child: const Text("Forgot Password?", style: TextStyle(fontSize: 20.0)),
    );
  }

  Widget signUpButton(){
    // display a button which is only clickable text, no border etc
    return TextButton(
      onPressed: (){
        Config.log.i("pressed sign up button");
      },
      // specify a slightly smaller font size than regular for this button
      // as we want this button to be more out of the way
      child: const Text("Sign Up", style: TextStyle(fontSize: 20.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plate Waste Tracker')),
      body: Center(
        child: ListView(
          children: <Widget>[
            appIcon(),
            emailField(),
            passwordField(),
            loginButton(),
            signUpButton(),
            forgotPasswordButton()
          ]
        )
      )
    );
  }

  @override
  void dispose(){
    this._emailFieldController.clear();
    this._passwordFieldController.clear();
    super.dispose();
  }
}

