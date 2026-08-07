// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'workout_screen.dart';
import 'widgets/glass_card.dart';
import 'widgets/animated_counter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _workouts = const [
    {
      'color': AppColors.primary,
      'gradient': [Color(0xFFFF6B4A), Color(0xFFFF8A65)],
      'icon': Icons.directions_run_rounded,
      'title': 'Morning Cardio',
      'subtitle': '20 min • 180 kcal',
      'iconColor': Colors.white,
      'level': 'Beginner',
    },
    {
      'color': AppColors.secondary,
      'gradient': [Color(0xFF2D9596), Color(0xFF4ECDC4)],
      'icon': Icons.self_improvement_rounded,
      'title': 'Full Body Stretch',
      'subtitle': '12 min • 60 kcal',
      'iconColor': Colors.white,
      'level': 'Easy',
    },
    {
      'color': AppColors.accent,
      'gradient': [Color(0xFFFFC93C), Color(0xFFFFD93D)],
      'icon': Icons.fitness_center_rounded,
      'title': 'Strength Training',
      'subtitle': '35 min • 260 kcal',
      'iconColor': AppColors.textDark,
      'level': 'Advanced',
    },
  ];

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

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
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

  void _openWorkout(Map<String, dynamic> workout) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => WorkoutScreen(
          title: workout['title'] as String,
          subtitle: workout['subtitle'] as String,
          gradient: workout['gradient'] as List<Color>,
          level: workout['level'] as String,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: IndexedStack(
                key: ValueKey(_navIndex),
                index: _navIndex,
                children: [
                  _buildHomeTab(),
                  _buildPlaceholderTab('Statistics', Icons.bar_chart_rounded),
                  _buildPlaceholderTab(
                      'Workouts', Icons.fitness_center_rounded),
                  _buildPlaceholderTab('Profile', Icons.person_rounded),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildPremiumBottomNav(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumTopBar(),
              const SizedBox(height: 30),
              _buildHeroCard(),
              const SizedBox(height: 25),
              _buildPremiumStatRow(),
              const SizedBox(height: 30),
              _buildSectionHeader("Today's Workout"),
              const SizedBox(height: 14),
              ..._workouts.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPremiumWorkoutCard(
                        entry.value,
                        entry.key,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String label, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            '$label — Coming Soon',
            style: GoogleFonts.fredoka(
              fontSize: 20,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re working on something amazing! 🚀',
            style: body(14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning 👋',
              style:
                  body(14, color: AppColors.textMuted, weight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              'Maaz Khan',
              style: GoogleFonts.fredoka(
                fontSize: 26,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.accent],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No new notifications right now 🎉'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.textDark,
                  ),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.notifications_rounded,
                      color: AppColors.textDark,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 2),
                        builder: (_, value, __) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.4 * (0.5 + 0.5 * value),
                                  ),
                                  blurRadius: 20 * (0.5 + 0.5 * value),
                                  spreadRadius: 5 * (0.5 + 0.5 * value),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1F2937),
            Color(0xFF2D3748),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated background blobs
          ...List.generate(3, (index) {
            return Positioned(
              left: [-20.0, 200.0, 100.0][index],
              top: [-30.0, -50.0, 100.0][index],
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 3),
                builder: (_, value, __) {
                  return Transform.rotate(
                    angle: value * 0.5,
                    child: Container(
                      width: [180.0, 150.0, 120.0][index],
                      height: [180.0, 150.0, 120.0][index],
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            [
                              AppColors.primary,
                              AppColors.secondary,
                              AppColors.accent,
                            ][index]
                                .withValues(alpha: 0.15 * (0.5 + 0.5 * value)),
                            [
                              AppColors.primary,
                              AppColors.secondary,
                              AppColors.accent,
                            ][index]
                                .withValues(alpha: 0.05),
                          ],
                          radius: 1.0,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Steps',
                        style: body(14,
                            color: Colors.white70, weight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      const AnimatedCounter(
                        targetValue: 7842,
                        duration: Duration(seconds: 2),
                      ),
                      Text(
                        'of 10,000 goal',
                        style: body(13, color: Colors.white54),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.accent, AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          '🔥 3 day streak',
                          style: body(
                            12,
                            color: AppColors.textDark,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 0.78),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (_, value, __) {
                          return SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: value,
                              strokeWidth: 8,
                              strokeCap: StrokeCap.round,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.accent,
                              ),
                            ),
                          );
                        },
                      ),
                      const Icon(
                        Icons.directions_walk_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumStatRow() {
    final stats = [
      {
        'icon': Icons.local_fire_department_rounded,
        'label': 'Calories',
        'value': '420 kcal',
        'gradient': const [AppColors.primary, Color(0xFFFF8A65)],
      },
      {
        'icon': Icons.water_drop_rounded,
        'label': 'Water',
        'value': '1.2 L',
        'gradient': const [AppColors.secondary, Color(0xFF4ECDC4)],
      },
      {
        'icon': Icons.bedtime_rounded,
        'label': 'Sleep',
        'value': '7h 20m',
        'gradient': const [AppColors.accent, Color(0xFFFFD93D)],
      },
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final s = stats[i];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (i * 100)),
            curve: Curves.easeOutCubic,
            builder: (_, value, __) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    width: 130,
                    padding: const EdgeInsets.all(16),
                    decoration: GlassCard.getDecoration(
                      blur: 20,
                      opacity: 0.1,
                      borderRadius: 22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: s['gradient'] as List<Color>,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (s['gradient'] as List<Color>)[0]
                                    .withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            s['icon'] as IconData,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          s['value'] as String,
                          style: GoogleFonts.fredoka(
                            fontSize: 17,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          s['label'] as String,
                          style: body(12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _navIndex = 2),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'See all',
              style: body(12, color: Colors.white, weight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumWorkoutCard(Map<String, dynamic> w, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (_, value, __) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: () => _openWorkout(w),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: GlassCard.getDecoration(
                    blur: 20,
                    opacity: 0.08,
                    borderRadius: 22,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: w['gradient'] as List<Color>,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: (w['gradient'] as List<Color>)[0]
                                  .withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          w['icon'] as IconData,
                          color: w['iconColor'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              w['title'] as String,
                              style: GoogleFonts.fredoka(
                                fontSize: 16,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (w['gradient'] as List<Color>)[0]
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    w['level'] as String,
                                    style: body(
                                      10,
                                      color: (w['gradient'] as List<Color>)[0],
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  w['subtitle'] as String,
                                  style: body(12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.textDark,
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
    );
  }

  Widget _buildPremiumBottomNav() {
    final items = [
      Icons.home_rounded,
      Icons.bar_chart_rounded,
      Icons.fitness_center_rounded,
      Icons.person_rounded,
    ];

    final labels = ['Home', 'Stats', 'Workouts', 'Profile'];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1F2937),
            Color(0xFF2D3748),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == _navIndex;
          return GestureDetector(
            onTap: () {
              setState(() => _navIndex = i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? 20 : 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                gradient: isActive
                    ? const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i],
                    color: isActive ? Colors.white : Colors.white38,
                    size: isActive ? 24 : 22,
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    Text(
                      labels[i],
                      style: body(12,
                          color: Colors.white, weight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
