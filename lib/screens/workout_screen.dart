// screens/workout_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'widgets/glass_card.dart';
import 'widgets/gradient_button.dart';

class WorkoutScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final String level;

  const WorkoutScreen({
    super.key,
    this.title = 'Full Body Blast',
    this.subtitle = '32 min • 320 kcal',
    this.gradient = const [AppColors.primary, AppColors.accent],
    this.level = 'Intermediate',
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with SingleTickerProviderStateMixin {
  bool _liked = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _exercises = [
    {'name': 'Jumping Jacks', 'reps': '3 sets • 20 reps', 'done': true},
    {'name': 'Push Ups', 'reps': '3 sets • 15 reps', 'done': true},
    {'name': 'Squats', 'reps': '4 sets • 20 reps', 'done': false},
    {'name': 'Plank Hold', 'reps': '3 sets • 45 sec', 'done': false},
    {'name': 'Mountain Climbers', 'reps': '3 sets • 30 sec', 'done': false},
  ];

  int get _completedCount => _exercises.where((e) => e['done'] == true).length;
  double get _progress => _completedCount / _exercises.length;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExercise(int index) {
    setState(() {
      _exercises[index]['done'] = !(_exercises[index]['done'] as bool);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildPremiumHeader(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProgressCard(),
                          const SizedBox(height: 26),
                          _buildSectionHeader(),
                          const SizedBox(height: 14),
                          ...List.generate(_exercises.length, (i) {
                            final e = _exercises[i];
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 400 + (i * 100)),
                              curve: Curves.easeOutCubic,
                              builder: (_, value, __) {
                                return Transform.translate(
                                  offset: Offset(20 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _buildExerciseTile(
                                        index: i,
                                        name: e['name'] as String,
                                        reps: e['reps'] as String,
                                        done: e['done'] as bool,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStartButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.gradient,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.gradient[0].withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Animated decorative blobs
          ...List.generate(2, (index) {
            return Positioned(
              right: [-20.0, 100.0][index],
              top: [-40.0, 50.0][index],
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 3),
                builder: (_, value, __) {
                  return Transform.rotate(
                    angle: value * 0.3,
                    child: Container(
                      width: [180.0, 120.0][index],
                      height: [180.0, 120.0][index],
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08 * (0.5 + 0.5 * value)),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => setState(() => _liked = !_liked),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            _liked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(_liked),
                            color: _liked ? Colors.red : Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                style: GoogleFonts.fredoka(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildHeaderPill(
                    Icons.timer_outlined,
                    widget.subtitle.split(' • ').first,
                  ),
                  if (widget.subtitle.contains('•'))
                    _buildHeaderPill(
                      Icons.local_fire_department_rounded,
                      widget.subtitle.split(' • ').last,
                    ),
                  _buildHeaderPill(
                    Icons.speed_rounded,
                    widget.level,
                  ),
                  _buildHeaderPill(
                    Icons.star_rounded,
                    '4.8 ★',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: body(12, color: Colors.white, weight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: GlassCard.getDecoration(
        blur: 20,
        opacity: 0.08,
        borderRadius: 26,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _progress),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, __) {
                    return SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        backgroundColor: AppColors.background,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.secondary,
                        ),
                      ),
                    );
                  },
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _progress * 100),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, __) {
                    return Text(
                      '${value.round()}%',
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _progress == 1.0
                      ? 'Workout Complete! 🎉'
                      : 'Keep Going, Maaz!',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _progress == 1.0
                      ? 'Amazing work today 💪'
                      : "You're doing great today 💪",
                  style: body(14, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercises',
              style: GoogleFonts.fredoka(
                fontSize: 20,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$_completedCount of ${_exercises.length} completed',
              style: body(13, color: AppColors.textMuted),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            '${(_progress * 100).round()}%',
            style: body(12, color: Colors.white, weight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseTile({
    required int index,
    required String name,
    required String reps,
    required bool done,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _toggleExercise(index),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: done
                ? AppColors.secondary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: done
                  ? AppColors.secondary.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.06),
              width: 1.5,
            ),
            boxShadow: done
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: done ? AppColors.secondary : AppColors.background,
                  shape: BoxShape.circle,
                  border: done
                      ? null
                      : Border.all(
                          color: AppColors.textMuted.withValues(alpha: 0.3),
                          width: 2,
                        ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: done
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                          key: ValueKey('done'),
                        )
                      : const SizedBox(key: ValueKey('not-done')),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        color: done ? AppColors.textMuted : AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        decoration: done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      reps,
                      style: body(12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: done
                      ? null
                      : const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                  color: done ? AppColors.secondary.withValues(alpha: 0.2) : null,
                  shape: BoxShape.circle,
                  boxShadow: done
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Icon(
                  done
                      ? Icons.check_circle_rounded
                      : Icons.play_circle_fill_rounded,
                  color: done ? AppColors.secondary : Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0),
            AppColors.background,
          ],
        ),
      ),
      child: GradientButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout started — let\'s go! 💪'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.textDark,
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Workout',
              style: GoogleFonts.fredoka(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}