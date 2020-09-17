import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:turkshare/pages/Notifications.dart';
import 'package:turkshare/pages/profile.dart';
import 'package:turkshare/pages/search.dart';
import 'package:turkshare/pages/timeline.dart';
import 'package:turkshare/pages/upload.dart';

final GoogleSignIn googleSignIn= GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isAuth=false;
  PageController pageController;
  int getPageIndex=0;

  void initState(){
    super.initState();
    pageController=PageController();

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

  void dispose(){
    pageController.dispose();
    super.dispose();

  }

  login(){

    googleSignIn.signIn();
  }

  logout(){
    googleSignIn.signOut();
  }

  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex=pageIndex;
    });
  }
  changePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(microseconds: 400), curve: Curves.bounceInOut);
  }
  Scaffold buildAuthScreen(){
    //return RaisedButton.icon(onPressed: logout, icon: Icon(Icons.close), label:Text('Sign out'));
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          Search(),
          Upload(),
          Notifications(),
          Profile(),


        ],

        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
    ),
    bottomNavigationBar: CupertinoTabBar(
      backgroundColor: Theme.of(context).accentColor,
    currentIndex: getPageIndex,
    onTap: changePage,
      activeColor: Colors.white,
      inactiveColor: Colors.blueGrey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home)),
        BottomNavigationBarItem(icon: Icon(Icons.search)),
        BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size: 37.0,)),
        BottomNavigationBarItem(icon: Icon(Icons.favorite)),
        BottomNavigationBarItem(icon: Icon(Icons.person)),
      ],
    ),
    );
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
