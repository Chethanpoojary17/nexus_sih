import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Widget textDisplay(
      String text, double size, FontWeight fweight, TextAlign align) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: AutoSizeText(
        text,
        style: GoogleFonts.lato(
          textStyle:
              TextStyle(fontSize: size, letterSpacing: .5, fontWeight: fweight),
        ),
        textAlign: align,
        maxLines: 1,
        minFontSize: size,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    return Scaffold(
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              shadowColor: Theme.of(context).primaryColor,
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: Container(
                height: height3 * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      elevation: 3,
                      child: Container(
                        height: height3 * 0.1,
                        width: width * 1,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(4),
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                            backgroundColor: Colors.transparent,
                          ),
                          title: textDisplay(
                              'Chethan', 20, FontWeight.bold, TextAlign.start),
                        ),
                      ),
                    ),
                    Container(
                      height: height3 * 0.4,
                      width: width * 1,
                      child: Image.network(
                        'http://3.bp.blogspot.com/_Nm2MDAHcssQ/TBCDn4I9oXI/AAAAAAAAAL0/vsLEqaQBDzM/s1600/India_flag_emblem.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    textDisplay('Description: This is the body of the post and it can stretch as much as it wants', 15, FontWeight.normal, TextAlign.center),
                    textDisplay('  3 Hours ago..', 12, FontWeight.normal, TextAlign.center)
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
