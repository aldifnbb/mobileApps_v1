class Song {
  final String id;
  final String title;
  final String artist;
  final String lyricsWithChord;
  final String originalKey;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.lyricsWithChord,
    required this.originalKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'lyricsWithChord': lyricsWithChord,
      'originalKey': originalKey,
    };
  }

  factory Song.fromMap(Map map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      lyricsWithChord: map['lyricsWithChord'],
      originalKey: map['originalKey'],
    );
  }
}