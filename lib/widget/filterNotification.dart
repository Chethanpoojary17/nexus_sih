import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class FilterNotification extends StatefulWidget {
  final Function filterNot;
  final currentOrg;
  final DateTime _currentFromDate, _currentToDate;
  final bool filtered;
  FilterNotification(this.filterNot,this.currentOrg,this._currentFromDate,this._currentToDate,this.filtered);
  @override
  _FilterNotificationState createState() => _FilterNotificationState();
}

class _FilterNotificationState extends State<FilterNotification> {
  DateTime _selectedFromDate, _selectedToDate;
  var organization = '', subject = '', dateFrom, dateTo;

  var filterApplied=0;
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
      Navigator.of(context).pop(true);
    }
  }
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 10,
          left: MediaQuery.of(context).size.width*0.06,
          right: MediaQuery.of(context).size.width*0.06,
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
//              TextField(onChanged: (value){
//                subject=value;
//              },decoration: InputDecoration(labelText: 'Subject'),),
              DropdownButtonFormField(
                key: ValueKey('organization'),
                value: (widget.currentOrg.isNotEmpty)?widget.currentOrg:null,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                decoration: InputDecoration(
                  hintText: 'Select the Organization',
                  labelText: 'Organization',
                ),
               validator: (value){
                  if(value.toString().isEmpty)
                    return 'This cant be empty!!';
                        return null;
                 },
                onChanged: (value){
                  organization=value.toString();
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
                      child: textDisplay((_selectedFromDate == null&&widget._currentFromDate==null)
                          ? 'From: No Date Chosen!'
                          : 'From: ${DateFormat.yMd().format((_selectedFromDate==null)?widget._currentFromDate:_selectedFromDate)}', 15, FontWeight.bold),
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
                      child: textDisplay((_selectedToDate == null&&widget._currentToDate==null)
                          ? 'To: No Date Chosen!'
                          : 'To: ${DateFormat.yMd().format((_selectedToDate==null)?widget._currentToDate:_selectedToDate)}', 15, FontWeight.bold),
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
              (widget.filtered)?
              RaisedButton(
                onPressed:(){
                  widget.filterNot(subject,organization,_selectedFromDate,_selectedToDate);
                  Navigator.of(context).pop(true);
                },
                color: Theme.of(context).primaryColor,
                child: Text('Clear applied filter',style: TextStyle(color: Colors.white),),
              ):
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
