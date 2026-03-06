import 'dart:async';
import 'package:flutter/material.dart';
import '../services/chord_transpose_service.dart';

class DetailScreen extends StatefulWidget {
  final Map song;

  const DetailScreen({super.key, required this.song});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int transposeValue = 0;

  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;

  double scrollSpeed = 30; // pixels per second
  bool isScrolling = false;

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void startAutoScroll() {
    _scrollTimer?.cancel();

    _scrollTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            _scrollController.offset + (scrollSpeed * 0.1),
          );
        }
      },
    );

    setState(() {
      isScrolling = true;
    });
  }

  void stopAutoScroll() {
    _scrollTimer?.cancel();
    setState(() {
      isScrolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String transposedLyrics = ChordTransposeService.transposeLyrics(
      widget.song['lyricsWithChord'],
      transposeValue,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song['title'] ?? ''),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                transposeValue--;
              });
            },
          ),
          Center(
            child: Text(
              transposeValue >= 0
                  ? "+$transposeValue"
                  : "$transposeValue",
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                transposeValue++;
              });
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: buildChordText(transposedLyrics),
              ),
            ),

            const SizedBox(height: 10),

            /// SPEED SLIDER
            Row(
              children: [
                const Text(
                  "Speed",
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: Slider(
                    min: 10,
                    max: 100,
                    value: scrollSpeed,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        scrollSpeed = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            /// PLAY / STOP BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isScrolling ? Colors.red : Colors.green,
              ),
              onPressed: () {
                if (isScrolling) {
                  stopAutoScroll();
                } else {
                  startAutoScroll();
                }
              },
              icon: Icon(
                isScrolling ? Icons.stop : Icons.play_arrow,
              ),
              label: Text(
                isScrolling ? "Stop" : "Start Auto Scroll",
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =============================
  /// RENDER CHORD & LYRICS
  /// =============================
  Widget buildChordText(String lyrics) {
    final regex = RegExp(r'\[([^\]]+)\]');
    final spans = <TextSpan>[];

    int lastIndex = 0;

    for (final match in regex.allMatches(lyrics)) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: lyrics.substring(lastIndex, match.start),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(
            color: Colors.lightBlueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      lastIndex = match.end;
    }

    if (lastIndex < lyrics.length) {
      spans.add(
        TextSpan(
          text: lyrics.substring(lastIndex),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 18,
          height: 1.6,
          fontFamily: 'monospace',
        ),
        children: spans,
      ),
    );
  }
}