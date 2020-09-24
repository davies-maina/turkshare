
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File _image;
  final picker = ImagePicker();

  pickImage(nContext){
    return showDialog(

        context: nContext,
        builder: (context){
          return SimpleDialog(
        title: Text(
        'New post',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
    ),

            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Capture image with your camera',
                  style: TextStyle(
                    color: Colors.black
                  ),

                ),
                onPressed: captureImageWithCamera,
              ),

              SimpleDialogOption(
                child: Text(
                  'Select image from your gallery',
                  style: TextStyle(
                      color: Colors.black
                  ),

                ),
                onPressed: pickImageFromGallery,
              ),

              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.black
                  ),

                ),
                onPressed:()=> Navigator.pop(context)
              ),
            ],
    );
        }
    );
  }

  displayUploadScreen(){
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_a_photo,color: Colors.white,size: 200.0,
            
          ),
          
          Padding(padding: EdgeInsets.only(top: 20.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.0),

            ),
            child: Text(
              'Upload image',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0
              ),
            ),

            color: Theme.of(context).accentColor,
            onPressed:() =>pickImage(context),
          ),),

        ],
      ),
    );
  }

  Future captureImageWithCamera() async {

      Navigator.pop(context);
      /*final imageFile=await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 630,
      maxWidth: 970
    );*/

      final pickedFile = await picker.getImage(source: ImageSource.camera,maxHeight: 630,
          maxWidth: 970);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });

  }

  Future pickImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return displayUploadScreen();
  }
}
