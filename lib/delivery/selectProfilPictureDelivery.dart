import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bringme/services/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class SelectProfilPictureDelivery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectProfilPictureDeliveryState();
  }
}

class _SelectProfilPictureDeliveryState extends State<SelectProfilPictureDelivery> {
  bool _isLoading = false;
  File newProfilPic;
  CrudMethods crudObj = new CrudMethods();

  updateProfilPicture(picUrl) {
    Map<String, dynamic> userMap = {'picture': picUrl};
    crudObj.createOrUpdateDeliveryManData(userMap);
  }

  Future getImageFromGallery() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      newProfilPic = tempImage;
    });
  }

  Future getImageFromCamera() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      newProfilPic = tempImage;
    });
  }

  uploadImage() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('deliveryPicture/${user.uid}.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(newProfilPic);
    if (task.isInProgress) {
      setState(() {
        _isLoading = true;
      });
    }
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    var url = downloadUrl.toString();
    updateProfilPicture(url);
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  Widget enableUpload() {
    return Container(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            // photo de profil
            backgroundImage: FileImage(newProfilPic),
            minRadius: 30,
            maxRadius: 93,
          ),
//          Image.file(
//            newProfilPic,
//            height: 200,
//            width: 200,
//          ),
          _isLoading == false
              ? Container(
            margin: EdgeInsets.only(top: 10.0),
            child: RaisedButton(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Icon(
                Icons.done,
                color: Color(0xFF0fbc00),
              ),
              color: Color(0xFFe0fcdf),
              textColor: Colors.black87,
              onPressed: uploadImage,
            ),
          )
              : Container(margin: EdgeInsets.only(top: 18.0),child:CircularProgressIndicator()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: newProfilPic == null
                      ? Text('sélectionnez une image')
                      : enableUpload(),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Icon(
                  Icons.folder,
                  color: Colors.white,
                ),
                color: Colors.black,
                textColor: Colors.black87,
                onPressed: getImageFromGallery,
              ),
              SizedBox(
                width: 25,
              ),
              RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
                color: Colors.black,
                textColor: Colors.black87,
                onPressed: getImageFromCamera,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
