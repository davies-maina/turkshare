import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn= GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isAuth=false;

  void initState(){
    super.initState();

    googleSignIn.onCurrentUserChanged.listen((account){
        controlSignIn(account);
    },onError: (error){
      print('error message :' + error);
    });

    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      controlSignIn(account);
    }).catchError((error){
      print('error message :' + error);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async{
    if(signInAccount!=null){
        setState(() {
          isAuth=true;
        });
    }
    else{
      setState(() {
        isAuth=false;
      });
    }
  }

  login(){

    googleSignIn.signIn();
  }

  logout(){
    googleSignIn.signOut();
  }
  Widget buildAuthScreen(){
    return RaisedButton.icon(onPressed: logout, icon: Icon(Icons.close), label:Text('Sign out'));
  }

  Scaffold buildUnAuthScreen(){

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).accentColor.withOpacity(0.7)
            ]
          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Turkshare',style: TextStyle(
              fontFamily:'"Signatra',
              fontSize: 90,
              color: Colors.white
            ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/google_signin_button.png",

                    ),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen():buildUnAuthScreen();
  }
}
