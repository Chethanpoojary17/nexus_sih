import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/meteocons_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class PdfViewer extends StatefulWidget {
  final String title;
  final String url;
  PdfViewer({
    this.title,
    this.url,
 });
  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title,overflow: TextOverflow.ellipsis,),
        actions: <Widget>[
          IconButton(icon: Icon(Entypo.download),onPressed:() async {
            final status = await Permission.storage.request();
            final message='Download Completed';
            if (status.isGranted) {
              final externalDir = await getExternalStorageDirectory();

              final id = await FlutterDownloader.enqueue(
                url:widget.url,
                savedDir: externalDir.path,
                fileName: widget.title,
                showNotification: true,
                openFileFromNotification: true,
              ).then((value){
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(message,style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white)),),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              });
            } else {
              print("Permission deined");
            }
          },),
        ],
      ),
      body: Container(
        child: PDF(
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onError: (error) {
            print(error.toString());
          },
          onPageError: (page, error) {
            print('$page: ${error.toString()}');
          },
          onPageChanged: (int page, int total) {
            print('page change: $page/$total');
          },
        ).cachedFromUrl(widget.url),
      ),
    );
  }
}
