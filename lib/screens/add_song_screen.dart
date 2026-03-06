import 'package:flutter/material.dart';
import '../services/song_service.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {  

  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _lyricsController = TextEditingController();
  final _keyController = TextEditingController();

  final SongService _songService = SongService();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Tambah Lagu"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Judul Lagu",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _artistController,
              decoration: const InputDecoration(
                labelText: "Artist / Penyanyi",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: "Key Asli (C, D, G, dll)",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _lyricsController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: "Lirik + Chord",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loading ? null : () async {

                setState(() => _loading = true);

                await _songService.addSong(
                  title: _titleController.text,
                  artist: _artistController.text,
                  lyricsWithChord: _lyricsController.text,
                  originalKey: _keyController.text,
                );

                setState(() => _loading = false);

                Navigator.pop(context);

              },

              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("Simpan Lagu"),
            )
          ],
        ),
      ),
    );
  }
}