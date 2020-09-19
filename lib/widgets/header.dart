import 'package:flutter/material.dart';

AppBar header(context,{bool isAppTitle=false,String currentPageTitle,hideBackButton=false}) {
  return AppBar(
  iconTheme:IconThemeData(
    color: Colors.white,

  ),
    automaticallyImplyLeading: hideBackButton ? false:true,
    title: Text(
        isAppTitle ?'Turkshare':currentPageTitle,
        style: TextStyle(
            color: Colors.white,
            fontFamily: isAppTitle ? 'Signatra' : '',
            fontSize: isAppTitle ? 45.0 : 22.0
      ),

      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
