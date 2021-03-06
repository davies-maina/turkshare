import 'dart:async';


import 'package:flutter/material.dart';
import 'package:turkshare/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String username;

  final _scaffoldKey=GlobalKey<ScaffoldState>();
  final _formKey=GlobalKey<FormState>();

  submitUsername(){
    final form=_formKey.currentState;
    if(form.validate()){
      form.save();
      SnackBar snackBar=SnackBar(content: Text('Hey! welcome' + username));
      _scaffoldKey.currentState.showSnackBar(snackBar);

      Timer(Duration(
          seconds: 4
      ),(){
        Navigator.pop(context,username);
      });
    }
  }
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,currentPageTitle: 'Settings',hideBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 26.0),
                  child: Center(
                    child: Text(
                      'Set up username',
                      style: TextStyle(
                          fontSize: 26.0
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        style: TextStyle(
                            color: Theme.of(context).accentColor
                        ),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey
                                )
                            ),

                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white
                                )
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                                fontSize: 16.0
                            ),
                            hintText: 'At least 5 characters',
                            hintStyle: TextStyle(
                                color: Theme.of(context).accentColor
                            )

                        ),
                        validator: (val){
                          if(val.trim().length<5){
                            return 'Username is short';
                          }

                          else if(val.isEmpty){
                            return 'Username cannot be empty';
                          }

                          else if(val.trim().length>15){
                            return 'Username is very long';
                          }

                          else{
                            return null;
                          }
                        },

                        onSaved: (val)=>username=val,
                      ),

                    ),
                  ),
                ),

                GestureDetector(
                  onTap: submitUsername,
                  child: Container(
                    height: 55.0,
                    width: 360.0,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
