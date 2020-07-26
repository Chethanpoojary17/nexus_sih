import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class FilterNotification extends StatefulWidget {
  final Function filterNot;
  FilterNotification(this.filterNot);
  @override
  _FilterNotificationState createState() => _FilterNotificationState();
}

class _FilterNotificationState extends State<FilterNotification> {
  DateTime _selectedFromDate, _selectedToDate;
  var organization = '', subject = '', dateFrom, dateTo;
  List<String> spinnerItems = [
    'Punjab National Bank',
    'Union Bank of India	',
    'Bank of Baroda',
    'Punjab & Sind Bank',
    'Reserve Bank of India',
    'Canara Bank',
    'Department of financial services'
  ];

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedFromDate = pickedDate;
      });
    });
    print('...');
  }

  void _presentDatePicker2() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: _selectedFromDate,
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedToDate = pickedDate;
      });
    });
    print('...');
  }
  Widget textDisplay(String text, double size, FontWeight fweight) {
    return AutoSizeText(
      text,
      style: GoogleFonts.lato(
        textStyle:
        TextStyle(fontSize: size, letterSpacing: .5, fontWeight: fweight),
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      minFontSize: size,
      overflow: TextOverflow.ellipsis,
    );
  }
  final _filterKey = GlobalKey<FormState>();
  void _trySubmit() async {
    final isValid = _filterKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _filterKey.currentState.save();
      widget.filterNot(
        subject,organization,_selectedFromDate,_selectedToDate
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft:  Radius.circular(30),topRight:  Radius.circular(30)
          ),
        ),
        child: Form(
          key: _filterKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              textDisplay('Filters', 20, FontWeight.bold),
              TextFormField(
                key: ValueKey(subject),
                decoration: InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Enter the subject to search',
                ),
//                validator: (value){
//                  if(value.isEmpty)
//                    return 'Subject cant be empty';
//                  return null;
//                },
                onChanged: (value){
                  subject=value;
                },
              ),
              DropdownButtonFormField(
                key: ValueKey('organization'),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  hintText: 'Select the Organization',
                  labelText: 'Organization',
                ),
                validator: (String data){
                  if(data.isEmpty)
                    return 'Please select one Organization';
                  return null;
                },
                onChanged: (String data) {
                  setState(() {
                    organization = data;
                  });
                },
                items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: textDisplay(_selectedFromDate == null
                          ? 'From: No Date Chosen!'
                          : 'From: ${DateFormat.yMd().format(_selectedFromDate)}', 15, FontWeight.bold),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: textDisplay(_selectedToDate == null
                          ? 'To: No Date Chosen!'
                          : 'To: ${DateFormat.yMd().format(_selectedToDate)}', 15, FontWeight.bold),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _presentDatePicker2,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                onPressed:_trySubmit,
                color: Theme.of(context).primaryColor,
                child: Text('Submit',style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
