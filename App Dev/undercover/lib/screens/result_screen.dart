import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/game_provider.dart';
import '../utils/theme_utils.dart';
import '../utils/dialog_utils.dart';
import 'home_screen.dart';
import 'word_distribution_screen.dart';

class ResultScreen extends StatefulWidget {
  final bool civiliansWin;

  const ResultScreen({super.key, required this.civiliansWin});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildPlayerCard(String name, String role, String word) {
    final bool isImposter = role == 'Hidden Agent';
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: ThemeUtils.cardDecoration.copyWith(
        color: isImposter
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.surface,
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isImposter
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.surface.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isImposter ? Icons.security : Icons.person,
                    color: isImposter
                        ? AppColors.primary
                        : AppColors.textLight,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: ThemeUtils.titleStyle.copyWith(
                          fontSize: 18,
                          color: isImposter
                              ? AppColors.primary
                              : AppColors.textLight,
                        ),
                      ),
                      Text(
                        role,
                        style: ThemeUtils.subtitleStyle.copyWith(
                          color: isImposter
                              ? AppColors.primary.withOpacity(0.8)
                              : AppColors.textLight.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.label,
                    size: 20,
                    color: AppColors.textLight.withOpacity(0.8),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      word,
                      style: ThemeUtils.bodyStyle.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitConfirmationDialog(context),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ThemeUtils.modernAppBar('Game Results'),
        body: Container(
          decoration: ThemeUtils.gradientBackground,
          child: SafeArea(
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                final wordPair = gameProvider.currentWordPair;
                return FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: ThemeUtils.cardDecoration.copyWith(
                              color: widget.civiliansWin
                                  ? Colors.green.withOpacity(0.1)
                                  : AppColors.primary.withOpacity(0.1),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  widget.civiliansWin
                                      ? Icons.verified_user
                                      : Icons.security,
                                  size: 64,
                                  color: widget.civiliansWin
                                      ? Colors.green
                                      : AppColors.primary,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  widget.civiliansWin
                                      ? 'Civilians Win!'
                                      : 'Hidden Agent Wins!',
                                  style: ThemeUtils.titleStyle.copyWith(
                                    fontSize: 28,
                                    color: widget.civiliansWin
                                        ? Colors.green
                                        : AppColors.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.civiliansWin
                                      ? 'The Hidden Agent has been caught!'
                                      : 'The Hidden Agent remained undetected!',
                                  style: ThemeUtils.subtitleStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: ThemeUtils.cardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Game Summary',
                                    style: ThemeUtils.titleStyle.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: AppColors.textLight,
                                            size: 24,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Civilian Word',
                                            style: ThemeUtils.subtitleStyle,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            wordPair?.civilianWord ?? '',
                                            style: ThemeUtils.titleStyle.copyWith(
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 80,
                                      color: AppColors.textLight.withOpacity(0.1),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.security,
                                            color: AppColors.primary,
                                            size: 24,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Agent Word',
                                            style: ThemeUtils.subtitleStyle,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            wordPair?.imposterWord ?? '',
                                            style: ThemeUtils.titleStyle.copyWith(
                                              fontSize: 18,
                                              color: AppColors.primary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              ...gameProvider.players.map((player) {
                                return _buildPlayerCard(
                                  player.name,
                                  player.isImposter ? 'Hidden Agent' : 'Civilian',
                                  player.word ?? 'Unknown',
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Start a new game with same players
                                  final gameProvider = context.read<GameProvider>();
                                  final playerNames = gameProvider.players
                                      .map((player) => player.name)
                                      .toList();
                                  final imposterCount = gameProvider.players
                                      .where((player) => player.isImposter)
                                      .length;
                                  
                                  gameProvider.startGame(playerNames, imposterCount);
                                  
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const WordDistributionScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.replay),
                                label: Text(
                                  'Play Again',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ThemeUtils.primaryButton,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                icon: Icon(Icons.add),
                                label: Text(
                                  'New Game',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ThemeUtils.secondaryButton,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
