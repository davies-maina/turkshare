
import 'dart:io';
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turkshare/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;


class Upload extends StatefulWidget {
  final User currentUser;

  Upload({this.currentUser});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File _image;
  final picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController descriptionTextEditingController=TextEditingController();
  TextEditingController locationTextEditingController=TextEditingController();
  bool uploading=false;

  String postId=Uuid().v4();



  pickImage(nContext){
    return showDialog(

        context: nContext,
        builder: (context){
          return SimpleDialog(
        title: Center(
          child: Text(
          'New post',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
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
        Navigator.pop(context);
      } else {
        print('No image selected.');
      }
    });
  }

  removeImage(){

    setState(() {
      _image=null;
    });
  }

  displayUploadFormScreen(){
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:Theme.of(context).accentColor.withOpacity(0.5) ,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon:Icon(Icons.arrow_back_ios,color: Colors.black,), onPressed: removeImage),
        title: Text(
          'New post',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),

        actions: <Widget>[
          FlatButton(onPressed: uploading ? null:()=>{
            uploadAndSave()
          }, child: Text(
            'Share',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0
            ),

          ))
        ],
      ),

      body: ListView(

        children: <Widget>[
          Container(

            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_image),
                    fit: BoxFit.cover

                  )
                ),
              ),


            ),
          ),

          Padding(
              padding: EdgeInsets.only(top: 12.0)

          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                      widget.currentUser.url
              ),
            ),

            title: Container(

              width: 250.0,
              child: TextField(
                style:TextStyle(
                  color: Colors.white,
                ),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Image caption',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: InputBorder.none
                ),
              ),
            ),
          ),

          Divider(),

          ListTile(
            leading: Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 36.0,
            ),

            title: Container(
              width: 250.0,
              child: TextField(
                style:TextStyle(
                  color: Colors.white,
                ),
                controller: locationTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Location name',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: InputBorder.none,

                ),
              ),
            ),
          ),

          Container(
            width: 220.0,
            height: 120.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(onPressed: getUserCurrentLocation, icon: Icon(Icons.add_location,color: Colors.white,), label: Text(
              'Get my current location',
              style: TextStyle(
                color: Colors.white
              ),
            ),shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),

            ),
              color: Theme.of(context).accentColor
              ,),
          )


        ],
      ),
    );
  }

  getUserCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placeMarks=await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark nPlaceMark=placeMarks[0];
    String addressInfo='${nPlaceMark.subThoroughfare} ${nPlaceMark.thoroughfare}, ${nPlaceMark.subLocality} ${nPlaceMark.locality},${nPlaceMark.subAdministrativeArea} ${nPlaceMark.administrativeArea},${nPlaceMark.postalCode} ${nPlaceMark.country},';
    String specificAddressInfo='${nPlaceMark.locality},${nPlaceMark.country}';

    locationTextEditingController.text=specificAddressInfo;
  }

  compressPhoto() async {
    final toDirectory=await getTemporaryDirectory();
    final path=toDirectory.path;
    ImD.Image imageFile=ImD.decodeImage(_image.readAsBytesSync());
    final compressedImage=File('$path/img_$postId.jpg')..writeAsBytesSync(ImD.encodeJpg(imageFile,quality: 90));

    setState(() {
      _image=compressedImage;
    });
  }

  uploadAndSave() async{
    setState(() {
      uploading=true;
    });

   await compressPhoto();
  }
  @override
  Widget build(BuildContext context) {
    return _image==null ? displayUploadScreen():displayUploadFormScreen();
  }
}
