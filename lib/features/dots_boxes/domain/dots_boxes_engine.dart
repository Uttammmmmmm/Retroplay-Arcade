class DotsBoxesEngine {
  static const n = 4;
  final Set<String> edges = {};
  final Map<String, int> boxes = {};
  int player = 1;
  int score1 = 0;
  int score2 = 0;

  String h(int r, int c) => 'h$r-$c';
  String v(int r, int c) => 'v$r-$c';

  List<String> boxEdges(int r, int c) => [
    h(r, c),
    h(r + 1, c),
    v(r, c),
    v(r, c + 1),
  ];

  void tap(String key, List<List<String>> adjacent) {
    if (edges.contains(key) || boxes.length == n * n) return;
    edges.add(key);
    var scored = false;
    for (final b in adjacent) {
      final id = b.join('|');
      if (b.every(edges.contains) && !boxes.containsKey(id)) {
        boxes[id] = player;
        if (player == 1) {
          score1++;
        } else {
          score2++;
        }
        scored = true;
      }
    }
    if (!scored) {
      player = player == 1 ? 2 : 1;
    }
  }

  void reset() {
    edges.clear();
    boxes.clear();
    player = 1;
    score1 = 0;
    score2 = 0;
  }
}
