import 'package:flutter/material.dart';

import '../../../core/storage/local_game_storage.dart';
import '../../../core/theme.dart';
import '../domain/game_info.dart';
import '../widgets/game_card.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../snake/presentation/snake_screen.dart';
import '../../tic_tac_toe/presentation/tic_tac_toe_screen.dart';
import '../../dots_boxes/presentation/dots_boxes_screen.dart';
import '../../number_merge/presentation/number_merge_screen.dart';
import '../../memory_match/presentation/memory_match_screen.dart';
import '../../minesweeper/presentation/minesweeper_screen.dart';
import '../../pong/presentation/pong_screen.dart';
import '../../whack_a_mole/presentation/whack_a_mole_screen.dart';
import '../../sliding_puzzle/presentation/sliding_puzzle_screen.dart';
import '../../hangman/presentation/hangman_screen.dart';
import '../../reaction_tap/presentation/reaction_tap_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.storage});
  final LocalGameStorage storage;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String category = 'All', search = '';
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final catalog = tab == 1
        ? gameCatalog
              .where((g) => widget.storage.favorites.contains(g.id))
              .toList()
        : gameCatalog;
    final visible = catalog
        .where(
          (g) =>
              (category == 'All' || g.category == category) &&
              '${g.title} ${g.subtitle}'.toLowerCase().contains(
                search.toLowerCase(),
              ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.sports_esports, color: retroYellow),
            SizedBox(width: 9),
            Text('RetroPlay', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SettingsScreen(storage: widget.storage),
              ),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          children: [
            const Text(
              'CLASSIC GAMES. TIMELESS FUN.',
              style: TextStyle(
                color: retroCyan,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your pocket arcade',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 5),
            const Text(
              'Pick up and play. No internet needed.',
              style: TextStyle(color: retroMuted),
            ),
            const SizedBox(height: 18),
            TextField(
              onChanged: (v) => setState(() => search = v),
              decoration: InputDecoration(
                hintText: 'Find a game...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: retroSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Arcade', 'Board', 'Puzzle', 'Word']
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: category == c,
                          onSelected: (_) => setState(() => category = c),
                          selectedColor: retroCyan,
                          backgroundColor: retroSurface,
                          side: BorderSide.none,
                          labelStyle: TextStyle(
                            color: category == c ? retroBg : retroText,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Game library',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  '${visible.length} GAMES',
                  style: const TextStyle(color: retroMuted, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (visible.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    'No games found here yet.',
                    style: TextStyle(color: retroMuted),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visible.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: .80,
                ),
                itemBuilder: (_, i) => GameCard(
                  game: visible[i],
                  favorite: widget.storage.favorites.contains(visible[i].id),
                  onFavorite: () async {
                    await widget.storage.toggleFavorite(visible[i].id);
                    setState(() {});
                  },
                  onTap: () => _open(visible[i]),
                ),
              ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [retroRaised, Color(0xFF1B3B48)],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(Icons.offline_bolt, color: retroYellow, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Offline by design · Games and preferences stay on your device.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: retroSurface,
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() {
          tab = i;
          category = 'All';
          search = '';
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Settings'),
        ],
      ),
    );
  }

  void _open(GameInfo g) {
    final pages = <String, Widget>{
      'snake': SnakeScreen(storage: widget.storage),
      'tic_tac_toe': TicTacToeScreen(),
      'dots_boxes': DotsBoxesScreen(),
      'number_merge': NumberMergeScreen(storage: widget.storage),
      'memory_match': MemoryMatchScreen(),
      'minesweeper': MinesweeperScreen(),
      'pong': PongScreen(),
      'whack_a_mole': WhackAMoleScreen(),
      'sliding_puzzle': SlidingPuzzleScreen(),
      'hangman': HangmanScreen(),
      'reaction_tap': ReactionTapScreen(),
    };
    Navigator.push(context, MaterialPageRoute(builder: (_) => pages[g.id]!));
  }
}
