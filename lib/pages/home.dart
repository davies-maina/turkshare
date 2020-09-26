import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:turkshare/models/user.dart';
import 'package:turkshare/pages/Notifications.dart';
import 'package:turkshare/pages/create_account.dart';
import 'package:turkshare/pages/profile.dart';
import 'package:turkshare/pages/search.dart';
import 'package:turkshare/pages/timeline.dart';
import 'package:turkshare/pages/upload.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


final GoogleSignIn googleSignIn= GoogleSignIn();
final userReference=FirebaseFirestore.instance.collection('users');
final StorageReference storageReference=FirebaseStorage.instance.ref().child("ppics");
final postReference=FirebaseFirestore.instance.collection('posts');

final DateTime timestamp=DateTime.now();
User currentUser;

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
      await storeUserInfoToFirestore();
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

  storeUserInfoToFirestore() async{
    final GoogleSignInAccount getCurrentUser=googleSignIn.currentUser;
    DocumentSnapshot documentSnapshot=await userReference.doc(getCurrentUser.id).get();

    if(!documentSnapshot.exists){
      final username=await Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAccount()));

      userReference.doc(getCurrentUser.id).set({
        "id":getCurrentUser.id,
        "profileName":getCurrentUser.displayName,
        "username":username,
        "url":getCurrentUser.photoUrl,
        "email":getCurrentUser.email,
        "bio":"",
        "timestamp":timestamp
      });

      documentSnapshot=await userReference.doc(getCurrentUser.id).get();
    }
    currentUser=User.fromDocument(documentSnapshot);
  }

  void dispose(){
    pageController.dispose();
    super.dispose();

  }

  login() async{
  auth.FirebaseAuth.instance.signInWithEmailAndPassword(email: "admin@test.com", password: "admin123");

    googleSignIn.signIn();
  }

  logout(){
    googleSignIn.signOut();
    auth.FirebaseAuth.instance.signOut();
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
          //Timeline(),
      RaisedButton.icon(onPressed: logout, icon: Icon(Icons.close), label:Text('Sign out')),
          Search(),
          Upload(currentUser: currentUser,),
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
                fontFamily:'Signatra',
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
