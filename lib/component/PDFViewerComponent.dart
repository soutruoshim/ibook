import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibook/utils/Extensions/Commons.dart';
import 'package:ibook/utils/Extensions/string_extensions.dart';
import 'package:ibook/utils/colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utils/appWidget.dart';
import '../utils/constant.dart';

class PDFViewerComponent extends StatefulWidget {
  static String tag = '/PDFViewerComponent';
  final String url;
  final bool isAdsLoad;

  PDFViewerComponent({required this.url, this.isAdsLoad = false});

  @override
  PDFViewerComponentState createState() => PDFViewerComponentState();
}

class PDFViewerComponentState extends State<PDFViewerComponent> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController? _pdfViewerController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    print("PDF Path=>" + widget.url);
    _pdfViewerController = PdfViewerController();
  }

  void _showContextMenu(BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState? _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
            child: Text('Copy', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: details.selectedText));
              _pdfViewerController!.clearSelection();
            }),
      ),
    );
    _overlayState!.insert(_overlayEntry!);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", color: primaryColor, textColor: Colors.white, showBack: true),
      bottomNavigationBar: mWebBannerAds == '1' ? showBannerAds() : SizedBox(),
      body: SfPdfViewer.network(
        widget.url.validate(),
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        otherSearchTextHighlightColor: primaryColor,
        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          if (details.selectedText == null && _overlayEntry != null) {
            _overlayEntry!.remove();
            _overlayEntry = null;
          } else if (details.selectedText != null && _overlayEntry == null) {
            _showContextMenu(context, details);
          }
        },
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          toast(details.description);
        },
        scrollDirection: PdfScrollDirection.vertical,
        canShowPaginationDialog: true,
        canShowScrollStatus: true,
        enableTextSelection: true,
        currentSearchTextHighlightColor: primaryColor,
        pageLayoutMode: PdfPageLayoutMode.continuous,
      ),
    );
  }
}
