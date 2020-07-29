import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PostFeed extends StatefulWidget {
  final String typePost;

  PostFeed({
    @required this.typePost,
  });

  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  final box=GetStorage();
  var title = '', description = '', content = '';
  var user='Chethan',proPic='url',uid='';
  final _feedPost = GlobalKey<FormState>();
  File _pickedImage;
  bool _isLoading=false;

  void _pickImage() async {
    final pickedImageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _trySubmit() async {
    final isValid = _feedPost.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      user=box.read('currentUname');
      uid=box.read('currentUid');
      proPic=box.read('currentProfile');
      _feedPost.currentState.save();
      try {
        setState(() {
          _isLoading = true;
        });
        if (widget.typePost.compareTo('Photo') == 0) {
          List list = List.generate(18, (i) => i);
          list.shuffle();
          String suffix = list[0].toString();
          final ref = FirebaseStorage.instance
              .ref()
              .child('post_image')
              .child(uid+suffix+'.jpg');

          await ref.putFile(_pickedImage).onComplete;

          final url = await ref.getDownloadURL();
          content = url;
        }
        bool type;
        (widget.typePost.compareTo('Photo') == 0) ? type = true : type = false;
        await Firestore.instance.collection('newsfeed').add({
          'name': user.trim(),
          'Title': title.trim(),
          'Description': description.trim(),
          'proPic': proPic,
          'type': type,
          'content': content.trim(),
          'Time':Timestamp.now()
        });
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(true);
      } on PlatformException catch (err) {
        var message = 'An error occurred, please check your credentials!';

        if (err.message != null) {
          message = err.message;
        }
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(true);
      } catch (err) {
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('POST FEED'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shadowColor: Theme.of(context).primaryColor,
            child: Container(
              height: (widget.typePost == 'Photo') ? height * 0.8 : height * 0.6,
              child: Form(
                key: _feedPost,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextFormField(
                      key: ValueKey('title'),
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.title),
                        hintText: 'Enter the Title',
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        title = value;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('description'),
                      decoration: const InputDecoration(
                        icon: const Icon(Icons.description),
                        hintText: 'Enter the Description',
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        description = value;
                      },
                    ),
                    if (widget.typePost.compareTo('Photo') == 0)
                      Container(
                        height: 300,
                        margin: EdgeInsets.all(4),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: _pickedImage != null
                            ? Image.file(
                                _pickedImage,
                                fit: BoxFit.contain,
                              )
                            : Icon(Icons.insert_photo),
                      ),
                    (widget.typePost.compareTo('Photo') == 0)
                        ? FlatButton.icon(
                            textColor: Theme.of(context).primaryColor,
                            onPressed: _pickImage,
                            icon: Icon(Icons.image),
                            label: Text('Add Image'),
                          )
                        : TextFormField(
                            key: ValueKey('content'),
                            maxLines: 6,
                            decoration: const InputDecoration(
                              icon: const Icon(Icons.link),
                              hintText: 'Enter the Url or Text',
                              labelText: 'URL/Text',
                            ),
                            validator: (value) {
                              if (value.isEmpty ||
                                  value.length < 4
                                  ) {
                                return 'Please enter at least 4 characters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              content = value;
                            },
                          ),
                    (_isLoading)?CircularProgressIndicator():RaisedButton(
                      onPressed: _trySubmit,
                      child: Text("Post"),
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}
