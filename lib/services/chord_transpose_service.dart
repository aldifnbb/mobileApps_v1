class ChordTransposeService {
  static final List<String> sharpScale = [
    "C", "C#", "D", "D#", "E",
    "F", "F#", "G", "G#", "A",
    "A#", "B"
  ];

  static final List<String> flatScale = [
    "C", "Db", "D", "Eb", "E",
    "F", "Gb", "G", "Ab", "A",
    "Bb", "B"
  ];

  /// =============================== 
  /// 1️⃣ PARSE CHORD (Root + Modifier)
  /// ===============================
  static Map<String, String> parseChord(String chord) {
    final regex = RegExp(r'^([A-G](#|b)?)(.*)$');
    final match = regex.firstMatch(chord);

    if (match != null) {
      return {
        "root": match.group(1) ?? "",
        "modifier": match.group(3) ?? ""
      };
    }

    return {
      "root": chord,
      "modifier": ""
    };
  }

  /// ===============================
  /// 2️⃣ TRANSPOSE ROOT NOTE
  /// ===============================
  static String transposeRoot(String root, int step) {
    List<String> scale;

    if (root.contains("b")) {
      scale = flatScale;
    } else {
      scale = sharpScale;
    }

    int index = scale.indexOf(root);

    if (index == -1) return root;

    int newIndex = (index + step) % scale.length;

    if (newIndex < 0) {
      newIndex += scale.length;
    }

    return scale[newIndex];
  }

  /// ===============================
  /// 3️⃣ TRANSPOSE FULL CHORD
  /// ===============================
  static String transposeChord(String chord, int step) {
    final parsed = parseChord(chord);

    final root = parsed["root"]!;
    final modifier = parsed["modifier"]!;

    final transposedRoot = transposeRoot(root, step);

    return "$transposedRoot$modifier";
  }

  /// ===============================
  /// 4️⃣ TRANSPOSE WHOLE LYRICS
  /// ===============================
  static String transposeLyrics(String lyrics, int step) {
    final regex = RegExp(r'\[([^\]]+)\]');

    return lyrics.replaceAllMapped(regex, (match) {
      final chord = match.group(1)!;
      final transposedChord = transposeChord(chord, step);
      return "[$transposedChord]";
    });
  }
}