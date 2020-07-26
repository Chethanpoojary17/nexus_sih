import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:intl/intl.dart';
class AddCircular extends StatefulWidget {
  @override
  _AddCircularState createState() => _AddCircularState();
}

class _AddCircularState extends State<AddCircular> {
  String dropdownValue = '';
  List <String> spinnerItems = [
    'AC',
    'Establishment',
    'IR',
  ] ;

  var subject='',section='',category='',pdfurl='',circularNo='',date;
  List <String> spinnerItems2 = [
    'Banking',
    'Insurance',
    'Pension Reforms',
    'All'
  ] ;
  File _pickedPdf;
  String pdfPath='';
  void _pickImage() async {
    final pickedPdfFile =
      await FilePicker.getFile(type: FileType.custom,allowedExtensions: ['pdf'],);
     pdfPath=pickedPdfFile.path;
     print(pdfPath);
    setState(() {
      _pickedPdf = pickedPdfFile;
    });
  }
  bool _isLoading=false;
  final _circularPost = GlobalKey<FormState>();
  void _trySubmit() async {
    final isValid = _circularPost.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _circularPost.currentState.save();
      try {
        setState(() {
          _isLoading = true;
        });
          List list1 = List.generate(18, (i) => i);
          list1.shuffle();
          String suffix = list1[0].toString();
          String circno=category.substring(0,3)+'-'+DateFormat('yyyyMMdd').format(DateTime.now())+list1[0].toString();
          final ref = FirebaseStorage.instance
              .ref()
              .child('circular_pdf')
              .child('subject'+suffix+'.pdf');

          await ref.putFile(_pickedPdf).onComplete;

          final url = await ref.getDownloadURL();

        await Firestore.instance.collection('circular').add({
          'subject': subject,
          'section': dropdownValue,
          'category': category,
          'pdfUrl': url,
          'date': Timestamp.now(),
          'circularNo': circno,
        });
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop(true);
      } on PlatformException catch (err) {
        var message = 'An error occurred, pelase check your credentials!';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Circular'),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 5,
          shadowColor: Theme.of(context).primaryColor,
          child: Container(
            child: Form(
              key: _circularPost,
//              Key:_circularPost,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    maxLines: 3,
                    key: ValueKey('Subject'),
                    decoration: InputDecoration(
                      labelText: '  Subject',
                      hintText: 'Enter the subject of Circular',
                      icon: Icon(Icons.subject),
                    ),
                    validator: (value){
                      if(value.isEmpty)
                        return 'Subject cant be empty';
                     return null;
                    },
                    onSaved: (value){
                      subject=value;
                    },
                  ),
                  DropdownButtonFormField(
                    key: ValueKey('section'),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        hintText: 'Select the section',
                      labelText: 'Section',
                      icon: Icon(Icons.assignment),
                    ),
                    validator: (String data){
                      if(data.isEmpty)
                        return 'Please select one Section';
                      return null;
                    },
                    onChanged: (String data) {
                      setState(() {
                        dropdownValue = data;
                      });
                    },
                    items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    key: ValueKey('Category'),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      filled: false,
                      hintText: 'Select the Category',
                      labelText: 'Category',
                      icon: Icon(Icons.assignment),
                    ),
                     validator: (String data){
                      if(data.isEmpty)
                        return 'Please select one Category';
                            return null;
                     },
                    onChanged: (String data) {
                      setState(() {
                        category = data;
                      });
                    },
                    items: spinnerItems2.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Container(
                    height: 300,
                    margin: EdgeInsets.only(top: height3*0.01),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,color: Theme.of(context).primaryColor
                      )
                    ),
                    child: (_pickedPdf!=null)?PDF(
                    ).fromPath(pdfPath):FlatButton.icon(onPressed:null,label:Text('Pdf Preview'),icon:Icon(FontAwesome5.file_pdf))
                  ),
                  if(_pickedPdf!=null)Text('File name :'+pdfPath.split('/').last),
                  FlatButton.icon(onPressed: _pickImage, icon: Icon(LineariconsFree.select), label: Text('Choose Pdf file')),
                  SizedBox(height: 20,),
                  (_isLoading)?CircularProgressIndicator():RaisedButton(
                    onPressed: _trySubmit,
                    child: Text('POST'),
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
