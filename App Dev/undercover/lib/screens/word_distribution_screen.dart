import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/game_provider.dart';
import '../utils/theme_utils.dart';
import '../utils/dialog_utils.dart';
import 'discussion_screen.dart';

class WordDistributionScreen extends StatefulWidget {
  const WordDistributionScreen({super.key});

  @override
  State<WordDistributionScreen> createState() => _WordDistributionScreenState();
}

class _WordDistributionScreenState extends State<WordDistributionScreen> with SingleTickerProviderStateMixin {
  final Set<String> _viewedWords = {};
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
    final gameProvider = context.watch<GameProvider>();
    
    return WillPopScope(
      onWillPop: () => showExitConfirmationDialog(context),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ThemeUtils.modernAppBar('View Your Words'),
        body: Container(
          decoration: ThemeUtils.gradientBackground,
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: ThemeUtils.cardDecoration,
                      child: Column(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 48,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Pass the device to each player',
                            style: ThemeUtils.titleStyle,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap your name to reveal your word',
                            style: ThemeUtils.subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: gameProvider.players.length,
                      itemBuilder: (context, index) {
                        final player = gameProvider.players[index];
                        final hasSeenWord = _viewedWords.contains(player.name);
                        
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: ThemeUtils.cardDecoration.copyWith(
                            color: hasSeenWord 
                                ? AppColors.surface.withOpacity(0.5)
                                : AppColors.surface,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (hasSeenWord) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: AppColors.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.warning,
                                            color: AppColors.primary,
                                            size: 24,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'View Word Again?',
                                            style: ThemeUtils.titleStyle,
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        'Are you sure you want to view your word again? Make sure no other player can see your screen.',
                                        style: ThemeUtils.bodyStyle,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: ThemeUtils.secondaryButton,
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: AppColors.surface,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                title: Text(
                                                  player.name,
                                                  style: ThemeUtils.titleStyle,
                                                ),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Your word is:',
                                                      style: ThemeUtils.subtitleStyle,
                                                    ),
                                                    SizedBox(height: 16),
                                                    Container(
                                                      padding: EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.primary.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        player.word ?? 'Error: No word assigned',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    style: ThemeUtils.secondaryButton,
                                                    child: Text('Close'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          style: ThemeUtils.primaryButton,
                                          child: Text('View Word'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: AppColors.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Text(
                                        player.name,
                                        style: ThemeUtils.titleStyle,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Your word is:',
                                            style: ThemeUtils.subtitleStyle,
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              player.word ?? 'Error: No word assigned',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _viewedWords.add(player.name);
                                            });
                                            Navigator.pop(context);
                                          },
                                          style: ThemeUtils.secondaryButton,
                                          child: Text('Got it'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        hasSeenWord ? Icons.check : Icons.person,
                                        color: hasSeenWord 
                                            ? AppColors.primary
                                            : AppColors.primary.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        player.name,
                                        style: ThemeUtils.bodyStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: hasSeenWord 
                                              ? AppColors.textLight.withOpacity(0.5)
                                              : AppColors.textLight,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      hasSeenWord ? Icons.visibility : Icons.arrow_forward_ios,
                                      color: hasSeenWord 
                                          ? AppColors.primary
                                          : AppColors.primary.withOpacity(0.7),
                                      size: hasSeenWord ? 24 : 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton.icon(
                      onPressed: _viewedWords.length == gameProvider.players.length
                          ? () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const DiscussionScreen(),
                                ),
                              );
                            }
                          : null,
                      icon: Icon(Icons.play_arrow),
                      label: Text(
                        'Start Discussion',
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
    );
  }
} 