import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/song_service.dart';
import 'detail_screen.dart';
import 'profile_screen.dart';
import 'add_song_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final SongService songService = SongService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chord App"),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),
        ],
      ),

      body: StreamBuilder(
        stream: songService.getSongs(),
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // jika error
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          }

          // jika tidak ada data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada lagu"));
          }

          final songs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];

              // convert data
              final data = song.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['title'] ?? ""),
                subtitle: Text(data['artist'] ?? ""),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailScreen(song: data)),
                  );
                },

                trailing: user == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await songService.deleteSong(song.id);
                        },
                      ),
              );
            },
          );
        },
      ),

      floatingActionButton: user == null
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                "Tambah Lagu",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddSongScreen(),
                  ),
                );
              },
            ),
    );
  }
}
