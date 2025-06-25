import 'dart:ui';
import 'package:boshqa_dunyo_ostonasi/features/shop/data/enties/book_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool _isLoading = false;
  double _downloadProgress = 0.0;

  // PDF faylini yuklab olish va progressni kuzatish
  Future<String> _downloadAndSavePdf() async {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(widget.book.pdfUrl));
    final response = await client.send(request);

    final totalBytes = response.contentLength ?? -1;
    int receivedBytes = 0;
    final bytes = <int>[];

    response.stream.listen(
      (chunk) {
        bytes.addAll(chunk);
        receivedBytes += chunk.length;
        if (totalBytes > 0 && mounted) {
          setState(() {
            _downloadProgress = receivedBytes / totalBytes;
          });
        }
      },
      onDone: () async {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/temp_book.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        if (mounted) {
          setState(() {
            _isLoading = false;
            _downloadProgress = 0.0;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => PdfViewerPage(
                    filePath: filePath,
                    title: widget.book.title,
                  ),
            ),
          );
        }
        client.close();
      },
      onError: (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _downloadProgress = 0.0;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('PDFni yuklashda xato: $e')));
        }
        client.close();
      },
      cancelOnError: true,
    );

    return '${(await getTemporaryDirectory()).path}/temp_book.pdf';
  }

  // PDF ko'rish sahifasini ochish
  void _openPdfViewer() async {
    setState(() {
      _isLoading = true; // Yuklanish boshlandi
      _downloadProgress = 0.0;
    });

    try {
      await _downloadAndSavePdf();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _downloadProgress = 0.0;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('PDFni yuklashda xato: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        forceMaterialTransparency: true,
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.book.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _isLoading
                ? Text(
                  '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: Colors.white),
                )
                : Text(''),
          ],
        ),
        backgroundColor: Colors.transparent, // Shaffof AppBar
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.book.coverUrl),
                  fit: BoxFit.cover,
                  onError:
                      (exception, stackTrace) => const AssetImage(
                        'assets/images/placeholder_book.jpg',
                      ),
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                child: Container(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(
                    0.4,
                  ), // withOpacity bu yerda ishlaydi
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ).copyWith(top: kToolbarHeight + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kitob rasmi
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 160,
                      height: 160 * (16 / 9), // 16:9 nisbat
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        image: DecorationImage(
                          image: NetworkImage(widget.book.coverUrl),
                          fit: BoxFit.cover,
                          onError:
                              (exception, stackTrace) => const AssetImage(
                                'assets/images/placeholder_book.jpg',
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Kitob nomi
                Text(
                  widget.book.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Muallif
                Text(
                  widget.book.author,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 16),
                // Tavsif
                Text(
                  widget.book.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                // O'qish tugmasi yoki yuklanish indikatori
                Center(
                  child:
                      _isLoading
                          ? Column(
                            children: [
                              LinearProgressIndicator(
                                value:
                                    _downloadProgress > 0
                                        ? _downloadProgress
                                        : null,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _downloadProgress > 0
                                    ? 'Yuklanmoqda: ${(_downloadProgress * 100).toStringAsFixed(0)}%'
                                    : 'Yuklanmoqda...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                          : ElevatedButton(
                            onPressed: _openPdfViewer,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Kitobni o'qish",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// PDF ko'rish sahifasi
class PdfViewerPage extends StatelessWidget {
  final String filePath;
  final String title;

  const PdfViewerPage({super.key, required this.filePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.blueGrey, // Shaffof AppBar
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDFni yuklashda xato: $error')),
          );
        },
      ),
    );
  }
}
