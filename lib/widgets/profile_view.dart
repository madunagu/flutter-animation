import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';

// ────────────────────────────────────────────────────
// Profile view shown when YOU tab is selected
// ────────────────────────────────────────────────────

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  bool _aboutExpanded = true;
  bool _timelineExpanded = true;
  late AnimationController _enterController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim =
        Tween<double>(begin: 0, end: 1).animate(_enterController);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _enterController, curve: Curves.easeOut));
    _enterController.forward();
  }

  @override
  void dispose() {
    _enterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Cover photo + name ────────────────
              _buildCoverSection(),

              // ── Stats row ─────────────────────────
              _buildStatsRow(),

              // ── About Me ──────────────────────────
              _buildExpandableSection(
                title: 'About Me',
                expanded: _aboutExpanded,
                onToggle: () =>
                    setState(() => _aboutExpanded = !_aboutExpanded),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'When I was 5 years old, my mother always told me that '
                    'happiness was the key to life. When I went to school, '
                    'they asked me what I wanted to be I grew up.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.75),
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              // ── Timeline ──────────────────────────
              _buildExpandableSection(
                title: 'Timeline',
                expanded: _timelineExpanded,
                onToggle: () =>
                    setState(() => _timelineExpanded = !_timelineExpanded),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    'We may need to create an account to use some of our '
                    'Services. You are responsible for safeguarding your '
                    'account, so use a strong password and limit its use to '
                    'this account.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.75),
                      height: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // ── Cover photo + name ──────────────────────────────

  Widget _buildCoverSection() {
    return Stack(
      children: [
        // Cover image (gradient placeholder)
        Container(
          height: 260,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3D1A6E),
                Color(0xFF8B3FAB),
                Color(0xFF3D2060),
              ],
            ),
          ),
          child: Opacity(
            opacity: 0.35,
            child: Icon(
              Icons.person,
              size: 160,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),

        // Meetups badge
        Positioned(
          top: 18,
          left: 18,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '5 meetups',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Name overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 40, 18, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC1A1040)],
              ),
            ),
            child: Text(
              'Fabiena Rhodes',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Messages + Notifications ────────────────────────

  Widget _buildStatsRow() {
    return Container(
      color: AppColors.darkPurple,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
              child: _StatItem(
                  icon: Icons.mail_outline, label: 'Messages', count: '07')),
          Container(width: 1, height: 50, color: Colors.white12),
          Expanded(
              child: _StatItem(
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                  count: '05')),
        ],
      ),
    );
  }

  // ── Expandable section ──────────────────────────────

  Widget _buildExpandableSection({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      color: AppColors.darkPurple,
      margin: const EdgeInsets.only(top: 2),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0 : -0.25,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.white60),
                  ),
                ],
              ),
            ),
          ),

          // Collapsible body
          AnimatedCrossFade(
            firstChild: child,
            secondChild: const SizedBox.shrink(),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────
// Stat item (messages / notifications)
// ────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: Colors.white70, size: 28),
            Positioned(
              top: -4,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
