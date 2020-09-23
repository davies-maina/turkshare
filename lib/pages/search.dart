
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:turkshare/models/user.dart';
import 'package:turkshare/pages/home.dart';
import 'package:turkshare/widgets/custom_image.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:turkshare/widgets/progress.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin<Search> {
TextEditingController searchTextEditingController=TextEditingController();
Future<QuerySnapshot> futureSearchResults;

emptyTextField(){
  searchTextEditingController.clear();

  setState(() {
    futureSearchResults=null;
  });

}

searchControl(String str){
  Future<QuerySnapshot> allUsers=userReference.where("profileName",isGreaterThanOrEqualTo: str).get();
  setState(() {
    futureSearchResults=allUsers;
  });
}
  AppBar searchHeader(){

    return AppBar(
      backgroundColor: Theme.of(context).accentColor,

      title: TextFormField(
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white
        ),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: 'Search users',
          hintStyle: TextStyle(
            color: Colors.grey,

          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey
            )
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey
            )
          ),

          filled: true,
          prefixIcon: Icon(
            Icons.person_pin,
            color: Colors.white,
            size: 30.0,
          ),
          suffixIcon: IconButton(icon:Icon(Icons.clear,
          color: Colors.white,), onPressed: emptyTextField)


        ),

        onChanged: searchControl,
      ),
    );
  }

  Column displayNoSearchResultsScreen(){
    final Orientation orientation=MediaQuery.of(context).orientation;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(

            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Icon(Icons.group,color: Theme.of(context).accentColor,size: 150.0,),
                Text(
                  'search users',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 65.0
                  )
                )
              ],
            ),
        ),
      ],
    );
  }

displayUsersFoundScreen(){
  return FutureBuilder(
    future: futureSearchResults,
    builder: (context,dataSnapshot){
      if(!dataSnapshot.hasData){
        return circularProgress();
      }

      List<UserResult> searchUserResult=[];
      dataSnapshot.data.documents.forEach((document){
          User eachUser=User.fromDocument(document);
          UserResult userResult=UserResult(eachUser);

          searchUserResult.add(userResult);
      });

      return ListView(children: searchUserResult,);
    },
  );
}

  bool get wantKeepAlive=>true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: searchHeader(),
      body: futureSearchResults==null ? displayNoSearchResultsScreen() : displayUsersFoundScreen(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: ()=>print('tapped'),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),

                ),
                title: Text(
                  eachUser.profileName,style: TextStyle(
                  color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold
                ),
                ),
                subtitle: Text(
                  eachUser.username,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
