import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../data/events_data.dart';
import '../models/event.dart';
import '../widgets/category_nav_bar.dart';
import '../widgets/event_card.dart';
import '../widgets/profile_view.dart';
import 'event_detail_screen.dart';

// ────────────────────────────────────────────────────
// Home Screen
// ────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedCategoryIndex = 1; // Start at TRENDING
  bool _overlayOpen = false;

  late AnimationController _staggerCtrl;
  late AnimationController _overlayCtrl;

  // Per-card stagger animations (rebuilt on category change)
  List<Animation<double>> _cardFades = [];
  List<Animation<Offset>> _cardSlides = [];

  @override
  void initState() {
    super.initState();

    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _overlayCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _rebuildStagger();
    _staggerCtrl.forward();
  }

  // ── Stagger animation helpers ───────────────────────

  void _rebuildStagger() {
    final count = _currentEvents.length;
    _cardFades = List.generate(count, (i) {
      final s = (i * 0.14).clamp(0.0, 0.7);
      final e = (s + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _staggerCtrl, curve: Interval(s, e, curve: Curves.easeOut)),
      );
    });
    _cardSlides = List.generate(count, (i) {
      final s = (i * 0.14).clamp(0.0, 0.7);
      final e = (s + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.35),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
            parent: _staggerCtrl,
            curve: Interval(s, e, curve: Curves.easeOutCubic)),
      );
    });
  }

  // ── Category selection ─────────────────────────────

  List<Event> get _currentEvents =>
      appCategories[_selectedCategoryIndex].events;

  void _selectCategory(int index) {
    if (index == _selectedCategoryIndex && !_overlayOpen) return;

    HapticFeedback.selectionClick();

    // Close overlay first
    if (_overlayOpen) {
      setState(() => _overlayOpen = false);
      _overlayCtrl.reverse();
    }

    setState(() => _selectedCategoryIndex = index);

    // Restart stagger for new cards
    _staggerCtrl.reset();
    _rebuildStagger();
    _staggerCtrl.forward();
  }

  // ── FAB toggle ─────────────────────────────────────

  void _toggleOverlay() {
    HapticFeedback.mediumImpact();
    setState(() => _overlayOpen = !_overlayOpen);
    if (_overlayOpen) {
      _overlayCtrl.forward();
    } else {
      _overlayCtrl.reverse();
    }
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    _overlayCtrl.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // ── Main content column ────────────────
              Column(
                children: [
                  // Nav bar
                  CategoryNavBar(
                    categories: appCategories,
                    selectedIndex: _selectedCategoryIndex,
                    onCategorySelected: _selectCategory,
                  ),

                  // Thin divider under nav
                  Container(height: 1, color: Colors.grey.shade100),

                  // Content area
                  Expanded(
                    child: _buildContentArea(),
                  ),
                ],
              ),

              // ── Category overlay ───────────────────
              AnimatedBuilder(
                animation: _overlayCtrl,
                builder: (_, __) {
                  if (_overlayCtrl.value == 0) return const SizedBox.shrink();
                  return CategoryOverlay(
                    categories: appCategories,
                    selectedIndex: _selectedCategoryIndex,
                    controller: _overlayCtrl,
                    onCategorySelected: _selectCategory,
                    onClose: _toggleOverlay,
                  );
                },
              ),

              // ── FAB ────────────────────────────────
              Positioned(
                bottom: 24,
                right: 20,
                child: _Fab(
                  isOpen: _overlayOpen,
                  onTap: _toggleOverlay,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Content area (profile or events) ───────────────

  Widget _buildContentArea() {
    final category = appCategories[_selectedCategoryIndex];

    // YOU tab → profile view
    if (category.isProfile) {
      return const ProfileView();
    }

    // Event feed
    final events = _currentEvents;
    final widgets = _buildEventWidgets(events);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView(
        key: ValueKey(_selectedCategoryIndex),
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: widgets,
      ),
    );
  }

  // ── Build event widget list (handling pairs) ────────

  List<Widget> _buildEventWidgets(List<Event> events) {
    final result = <Widget>[];
    int i = 0;
    int animIdx = 0;

    while (i < events.length) {
      final e = events[i];

      // Check for a consecutive pair of small cards
      if (e.isSmall &&
          i + 1 < events.length &&
          events[i + 1].isSmall) {
        final left = events[i];
        final right = events[i + 1];
        final fade = animIdx < _cardFades.length
            ? _cardFades[animIdx]
            : const AlwaysStoppedAnimation(1.0);
        final slide = animIdx < _cardSlides.length
            ? _cardSlides[animIdx]
            : const AlwaysStoppedAnimation(Offset.zero);

        result.add(
          SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: fade,
              child: EventCardPair(left: left, right: right),
            ),
          ),
        );
        i += 2;
        animIdx++;
      } else {
        final fade = animIdx < _cardFades.length
            ? _cardFades[animIdx]
            : const AlwaysStoppedAnimation(1.0);
        final slide = animIdx < _cardSlides.length
            ? _cardSlides[animIdx]
            : const AlwaysStoppedAnimation(Offset.zero);

        result.add(
          SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: fade,
              child: GestureDetector(
                onTap: () => _openDetail(e),
                child: EventCard(event: e),
              ),
            ),
          ),
        );
        i++;
        animIdx++;
      }
    }

    // Bottom padding so FAB doesn't overlap last card
    result.add(const SizedBox(height: 80));
    return result;
  }

  void _openDetail(Event event) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => EventDetailScreen(event: event),
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: FadeTransition(opacity: anim, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }
}

// ────────────────────────────────────────────────────
// Animated FAB  (+ / ×)
// ────────────────────────────────────────────────────

class _Fab extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const _Fab({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isOpen ? AppColors.darkPurple : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isOpen ? 0.25 : 0.15),
              blurRadius: isOpen ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedRotation(
          turns: isOpen ? 0.125 : 0, // rotate 45° when open (+ → ×)
          duration: const Duration(milliseconds: 250),
          child: Icon(
            isOpen ? Icons.close : Icons.add,
            color: isOpen ? Colors.white : AppColors.darkPurple,
            size: 26,
          ),
        ),
      ),
    );
  }
}
