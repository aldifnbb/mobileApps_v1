import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SongService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all songs (real-time)
  Stream<QuerySnapshot> getSongs() {
    return _firestore
        .collection('songs')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Add new song
  Future<void> addSong({
    required String title,
    required String artist,
    required String lyricsWithChord,
    required String originalKey,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await _firestore.collection('songs').add({
      'title': title,
      'artist': artist,
      'lyricsWithChord': lyricsWithChord,
      'originalKey': originalKey,
      'createdBy': user.uid,
      'createdAt': Timestamp.now(),
    });
  }

  // Delete song
  Future<void> deleteSong(String id) async {
    await _firestore.collection('songs').doc(id).delete();
  }
}