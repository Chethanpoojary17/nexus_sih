import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:fluttericon/meteocons_icons.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,overflow: TextOverflow.ellipsis,),
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
        ).cachedFromUrl('http://africau.edu/images/default/sample.pdf'),
      ),
    );
  }
}
