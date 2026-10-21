import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../../../core/widgets/crackers_celebration.dart';

class MemoryCardItem {
  const MemoryCardItem({
    required this.id,
    required this.emoji,
    required this.name,
    required this.imageUrl,
  });

  final String id;
  final String emoji;
  final String name;
  final String imageUrl;
}

const memoryCardsPool = <MemoryCardItem>[
  MemoryCardItem(
    id: 'cherry',
    emoji: '🍒',
    name: 'Cherry',
    imageUrl: 'https://images.unsplash.com/photo-1528825871115-3581a5387919?auto=format&fit=crop&w=300&q=80',
  ),
  MemoryCardItem(
    id: 'gamepad',
    emoji: '🎮',
    name: 'Arcade',
    imageUrl: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?auto=format&fit=crop&w=300&q=80',
  ),
  MemoryCardItem(
    id: 'rocket',
    emoji: '🚀',
    name: 'Rocket',
    imageUrl: 'https://images.unsplash.com/photo-1517976487504-59a1a04d20e6?auto=format&fit=crop&w=300&q=80',
  ),
  MemoryCardItem(
    id: 'diamond',
    emoji: '💎',
    name: 'Diamond',
    imageUrl: 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=300&q=80',
  ),
  MemoryCardItem(
    id: 'star',
    emoji: '⭐',
    name: 'Star',
    imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=300&q=80',
  ),
  MemoryCardItem(
    id: 'joystick',
    emoji: '🕹️',
    name: 'Joystick',
    imageUrl: 'https://images.unsplash.com/photo-1534423861386-85a16f5d13fd?auto=format&fit=crop&w=300&q=80',
  ),
  MemoryCardItem(
    id: 'alien',
    emoji: '👾',
    name: 'Alien',
    imageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=300&q=80',
  ),
  MemoryCardItem(
    id: 'trophy',
    emoji: '🏆',
    name: 'Trophy',
    imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=300&q=80',
  ),
];

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  int level = 1;
  late List<MemoryCardItem> cards;
  final Set<int> open = {};
  final Set<int> matched = {};
  int moves = 0;
  bool _showCelebration = false;

  int get pairsForLevel {
    switch (level) {
      case 1:
        return 4; // 8 cards (4x2)
      case 2:
        return 6; // 12 cards (4x3)
      default:
        return 8; // 16 cards (4x4)
    }
  }

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    final pool = List<MemoryCardItem>.from(memoryCardsPool)..shuffle(Random());
    final selected = pool.take(pairsForLevel).toList();
    cards = [...selected, ...selected]..shuffle(Random());
    open.clear();
    matched.clear();
    moves = 0;
    _showCelebration = false;
  }

  void _nextLevel() {
    setState(() {
      level = level >= 3 ? 1 : level + 1;
      _reset();
    });
  }

  Future<void> tap(int i) async {
    if (open.contains(i) || matched.contains(i) || open.length >= 2) return;
    setState(() => open.add(i));
    if (open.length == 2) {
      moves++;
      final pair = open.toList();
      if (cards[pair[0]].id == cards[pair[1]].id) {
        await Future.delayed(const Duration(milliseconds: 280));
        if (mounted) {
          setState(() {
            matched.addAll(pair);
            if (matched.length == cards.length) {
              _showCelebration = true;
            }
          });
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 650));
      }
      if (mounted) setState(open.clear);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLevelComplete = matched.length == cards.length && cards.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        actions: [
          IconButton(
            onPressed: () => setState(_reset),
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart level',
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // Level and game stats row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: retroCyan.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: retroCyan.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          'LEVEL $level',
                          style: const TextStyle(
                            color: retroCyan,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Moves: $moves',
                        style: const TextStyle(
                          color: retroMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Pairs: ${matched.length ~/ 2} / $pairsForLevel',
                        style: const TextStyle(
                          color: retroYellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Grid of fully responsive cards
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: level == 1
                            ? 1.05
                            : (level == 2 ? 0.95 : 1.0),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cards.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 9,
                                mainAxisSpacing: 9,
                                childAspectRatio: 0.82,
                              ),
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () => tap(i),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0,
                                end: open.contains(i) || matched.contains(i)
                                    ? 1
                                    : 0,
                              ),
                              duration: const Duration(milliseconds: 220),
                              builder: (context, v, _) {
                                final isFaceUp = v > 0.5;
                                return Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, .001)
                                    ..rotateY(pi * v),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: matched.contains(i)
                                          ? retroCyan.withValues(alpha: 0.3)
                                          : open.contains(i)
                                          ? retroRaised
                                          : retroSurface,
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(
                                        color: matched.contains(i)
                                            ? retroYellow
                                            : open.contains(i)
                                            ? retroCyan
                                            : retroCyan.withValues(alpha: 0.22),
                                        width: matched.contains(i) ? 2.2 : 1.2,
                                      ),
                                      boxShadow: matched.contains(i)
                                          ? [
                                              BoxShadow(
                                                color: retroYellow.withValues(
                                                  alpha: 0.5,
                                                ),
                                                blurRadius: 10,
                                                spreadRadius: 1.5,
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.3,
                                                ),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                    ),
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(pi * v),
                                      child: isFaceUp
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  // Full-card responsive image
                                                  Image.network(
                                                    cards[i].imageUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    loadingBuilder:
                                                        (
                                                          context,
                                                          child,
                                                          progress,
                                                        ) {
                                                          if (progress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return Container(
                                                            color: retroRaised,
                                                            child: const Center(
                                                              child: SizedBox(
                                                                width: 16,
                                                                height: 16,
                                                                child: CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                  color:
                                                                      retroCyan,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Container(
                                                            color: retroRaised,
                                                            child: Center(
                                                              child: Text(
                                                                cards[i].emoji,
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          27,
                                                                    ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                  ),
                                                  // Card label at bottom
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 3,
                                                            horizontal: 2,
                                                          ),
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      child: Text(
                                                        '${cards[i].emoji} ${cards[i].name}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 8.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (matched.contains(i))
                                                    Container(
                                                      color: retroYellow
                                                          .withValues(
                                                            alpha: 0.22,
                                                          ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons
                                                              .check_circle_rounded,
                                                          color: retroYellow,
                                                          size: 26,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            )
                                          : Center(
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  7,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: retroRaised,
                                                  border: Border.all(
                                                    color: retroCyan.withValues(
                                                      alpha: 0.35,
                                                    ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  '?',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    color: retroCyan,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Level completion card & actions
                  if (isLevelComplete)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            retroSurface,
                            retroRaised.withValues(alpha: 0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: retroYellow.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: retroYellow.withValues(alpha: 0.25),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            level >= 3
                                ? '🏆 ALL LEVELS MASTERED! 🎆'
                                : '🎉 LEVEL $level COMPLETE! 🎆',
                            style: const TextStyle(
                              color: retroYellow,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Perfect match in $moves moves! Crackers celebrate your victory!',
                            style: const TextStyle(
                              color: retroText,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => setState(_reset),
                                icon: const Icon(Icons.replay, size: 16),
                                label: Text('Replay Lvl $level'),
                              ),
                              const SizedBox(width: 10),
                              FilledButton.icon(
                                onPressed: _nextLevel,
                                icon: const Icon(Icons.arrow_forward, size: 16),
                                label: Text(
                                  level >= 3 ? 'Start Over' : 'Next Level',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    FilledButton(
                      onPressed: () => setState(_reset),
                      child: const Text('Restart round'),
                    ),
                ],
              ),
            ),
            // Crackers celebration raining down from the top
            CrackersCelebration(
              play: _showCelebration,
              onFinished: () => setState(() => _showCelebration = false),
            ),
          ],
        ),
      ),
    );
  }
}
