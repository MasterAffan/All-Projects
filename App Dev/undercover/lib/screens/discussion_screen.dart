import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/game_provider.dart';
import '../utils/theme_utils.dart';
import '../utils/dialog_utils.dart';
import '../widgets/game_timer.dart';
import 'voting_screen.dart';
import 'result_screen.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitConfirmationDialog(context),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ThemeUtils.modernAppBar('Discussion Phase'),
        body: Container(
          decoration: ThemeUtils.gradientBackground,
          child: SafeArea(
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Column(
                    children: [
                      if (gameProvider.eliminatedPlayers.isNotEmpty)
                        Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(20),
                          decoration: ThemeUtils.cardDecoration.copyWith(
                            color: AppColors.surface.withOpacity(0.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_off,
                                    color: AppColors.error,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Eliminated Players',
                                    style: ThemeUtils.titleStyle.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: gameProvider.eliminatedPlayers.map((name) {
                                  final player = gameProvider.players
                                      .firstWhere((p) => p.name == name);
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: player.isImposter
                                          ? AppColors.primary.withOpacity(0.2)
                                          : AppColors.error.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: player.isImposter
                                            ? AppColors.primary
                                            : AppColors.error,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          player.isImposter
                                              ? Icons.security
                                              : Icons.person,
                                          size: 16,
                                          color: player.isImposter
                                              ? AppColors.primary
                                              : AppColors.error,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          name,
                                          style: TextStyle(
                                            color: player.isImposter
                                                ? AppColors.primary
                                                : AppColors.error,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(20),
                        decoration: ThemeUtils.cardDecoration,
                        child: Column(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Discussion Time',
                              style: ThemeUtils.titleStyle,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Discuss your words without revealing them directly',
                              style: ThemeUtils.subtitleStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            GameTimer(
                              durationInSeconds: 180,
                              onTimerComplete: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Time\'s up! Ready to vote?'),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: AppColors.primary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const VotingScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.how_to_vote),
                          label: Text(
                            'Start Voting',
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 