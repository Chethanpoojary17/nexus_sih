import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class FilterCircular extends StatefulWidget {
  final Function filterString;
  final String filters;
  FilterCircular(
      this.filterString,
      this.filters
      );
  @override
  _FilterCircularState createState() => _FilterCircularState();
}

class _FilterCircularState extends State<FilterCircular> {
  var currentCategory='';
  @override
  Widget build(BuildContext context) {
    currentCategory=widget.filters;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
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
        child:Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height3*0.02,),
            Text("Select Level",style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,)),
            SizedBox(height: height3*0.01,),
            SizedBox(height: height3*0.01,),
            _getCheckList("Banking", width),
            Container(width: width*0.9,height: 2,color: Colors.blue,),
            _getCheckList("Insurance",width),
            Container(width:width*0.9,height: 2,color: Colors.blue,),
            _getCheckList("Pension Reforms", width),
            SizedBox(height:height3*0.02,),
            if(currentCategory.isNotEmpty)RaisedButton(
              onPressed: (){
                setState(() {
                  currentCategory='';
                });
                widget.filterString(['all','Banking','Insurance','Pension Reforms']);
              },
              child: Text('Clear Filters',style: GoogleFonts.lato(textStyle: TextStyle(
                color: Colors.white,
              )),),
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
  _getCheckList(String title, double width){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            setState(() {
              currentCategory=title;
              var l=['all'];
              l.add(currentCategory);
              widget.filterString(l);
              Navigator.pop(context);
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.08),
            child: Row(
              children: [
                Icon(
                  currentCategory == title ? Icons.check_box: Icons.check_box_outline_blank,
                  color: currentCategory == title ? Colors.deepOrange:Colors.black,
                ),
                SizedBox(width: width*0.02,),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
