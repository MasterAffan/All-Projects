import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/game_provider.dart';
import '../utils/theme_utils.dart';
import '../utils/dialog_utils.dart';
import '../widgets/voting_card.dart';
import 'result_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> with SingleTickerProviderStateMixin {
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

  void _handleVoteResult(BuildContext context, GameProvider gameProvider) {
    final votedPlayer = gameProvider.getMostVotedPlayer();
    if (votedPlayer == null) return;

    final imposterCaught = gameProvider.processVote(votedPlayer);
    final bool gameOver = gameProvider.shouldGameEnd();
    final bool civiliansWin = gameProvider.didCiviliansWin();

    if (gameOver) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResultScreen(civiliansWin: civiliansWin),
        ),
      );
    }
  }

  Widget _buildEliminatedPlayerChip(String name, bool wasImposter) {
    final color = wasImposter ? AppColors.primary : AppColors.primary.withOpacity(0.7);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            wasImposter ? Icons.security : Icons.person,
            size: 16,
            color: color,
          ),
          SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitConfirmationDialog(context),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ThemeUtils.modernAppBar('Vote for the Imposter'),
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
                                    color: AppColors.primary.withOpacity(0.7),
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Eliminated Players',
                                          style: ThemeUtils.titleStyle.copyWith(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '${gameProvider.remainingChances} chances left',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                  return _buildEliminatedPlayerChip(
                                    name,
                                    player.isImposter,
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
                              Icons.how_to_vote,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Time to Vote',
                              style: ThemeUtils.titleStyle,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Select who you think is the Hidden Agent',
                              style: ThemeUtils.subtitleStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: gameProvider.players.length,
                          itemBuilder: (context, index) {
                            final player = gameProvider.players[index];
                            final isEliminated = gameProvider.isPlayerEliminated(player.name);
                            final isSelected = gameProvider.selectedVote == player.name;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                decoration: ThemeUtils.cardDecoration.copyWith(
                                  color: isEliminated
                                      ? AppColors.surface.withOpacity(0.5)
                                      : isSelected
                                          ? AppColors.primary.withOpacity(0.1)
                                          : AppColors.surface,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: isEliminated
                                        ? null
                                        : () => gameProvider.vote(player.name),
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
                                              isEliminated
                                                  ? Icons.person_off
                                                  : Icons.person,
                                              color: isEliminated
                                                  ? AppColors.textLight.withOpacity(0.5)
                                                  : AppColors.primary,
                                              size: 24,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              player.name,
                                              style: ThemeUtils.bodyStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: isEliminated
                                                    ? AppColors.textLight.withOpacity(0.5)
                                                    : AppColors.textLight,
                                              ),
                                            ),
                                          ),
                                          if (gameProvider.selectedVote == player.name)
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: AppColors.onPrimary,
                                                size: 16,
                                              ),
                                            ),
                                        ],
                                      ),
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
                          onPressed: gameProvider.selectedVote != null
                              ? () => _handleVoteResult(context, gameProvider)
                              : null,
                          icon: Icon(Icons.gavel),
                          label: Text(
                            'Submit Vote',
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