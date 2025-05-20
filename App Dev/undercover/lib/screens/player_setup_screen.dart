import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/game_provider.dart';
import '../widgets/number_selector.dart';
import '../utils/theme_utils.dart';
import '../utils/dialog_utils.dart';
import 'word_distribution_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  final List<TextEditingController> playerNameControllers = List.generate(
    4,
    (index) => TextEditingController(text: 'Player ${index + 1}'),
  );

  int imposterCount = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in playerNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    final playerNames = playerNameControllers
        .map((controller) => controller.text.trim())
        .toList();
    
    context.read<GameProvider>().startGame(playerNames, imposterCount);
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const WordDistributionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitConfirmationDialog(context),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ThemeUtils.modernAppBar('Game Setup'),
        body: Container(
          decoration: ThemeUtils.gradientBackground,
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: ThemeUtils.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Number of Hidden Agents',
                            style: ThemeUtils.titleStyle,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Choose how many agents will infiltrate the group',
                            style: ThemeUtils.subtitleStyle,
                          ),
                          SizedBox(height: 20),
                          NumberSelector(
                            label: 'Number of Hidden Agents',
                            value: imposterCount,
                            min: 1,
                            max: (playerNameControllers.length / 2).floor(),
                            onChanged: (value) => setState(() => imposterCount = value),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: ThemeUtils.cardDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Player Names',
                            style: ThemeUtils.titleStyle,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Enter unique names for each player',
                            style: ThemeUtils.subtitleStyle,
                          ),
                          SizedBox(height: 20),
                          ...List.generate(
                            playerNameControllers.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TextFormField(
                                controller: playerNameControllers[index],
                                style: ThemeUtils.bodyStyle,
                                decoration: InputDecoration(
                                  labelText: 'Player ${index + 1}',
                                  labelStyle: TextStyle(
                                    color: AppColors.textLight.withOpacity(0.7),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppColors.primary.withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.surface,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: playerNameControllers.length > 4
                                    ? () => setState(() {
                                          playerNameControllers.removeLast();
                                        })
                                    : null,
                                icon: Icon(Icons.remove),
                                label: Text('Remove'),
                                style: ThemeUtils.secondaryButton,
                              ),
                              TextButton.icon(
                                onPressed: playerNameControllers.length < 10
                                    ? () => setState(() {
                                          playerNameControllers.add(
                                            TextEditingController(
                                              text: 'Player ${playerNameControllers.length + 1}',
                                            ),
                                          );
                                        })
                                    : null,
                                icon: Icon(Icons.add),
                                label: Text('Add'),
                                style: ThemeUtils.secondaryButton,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _startGame,
                        icon: Icon(Icons.play_arrow),
                        label: Text(
                          'Start Game',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ThemeUtils.primaryButton,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 