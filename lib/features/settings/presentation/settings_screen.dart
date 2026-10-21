import 'package:flutter/material.dart';

import '../../../core/storage/local_game_storage.dart';
import '../../../core/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.storage});
  final LocalGameStorage storage;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool sound;
  @override
  void initState() {
    super.initState();
    sound = widget.storage.soundEnabled;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'YOUR ARCADE',
          style: TextStyle(
            color: retroCyan,
            letterSpacing: 1.4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          tileColor: retroSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Sound effects'),
          subtitle: const Text('Preference saved locally'),
          value: sound,
          onChanged: (v) async {
            setState(() => sound = v);
            await widget.storage.setSoundEnabled(v);
          },
        ),
        const SizedBox(height: 12),
        const ListTile(
          leading: Icon(Icons.offline_bolt, color: retroYellow),
          title: Text('Offline-first'),
          subtitle: Text('All included game logic runs locally.'),
        ),
        const ListTile(
          leading: Icon(Icons.palette_outlined, color: retroCyan),
          title: Text('Retro theme'),
          subtitle: Text('Indigo, cyan, purple and warm yellow'),
        ),
      ],
    ),
  );
}
