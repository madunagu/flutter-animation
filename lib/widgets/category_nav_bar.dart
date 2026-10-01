import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';
import '../app_colors.dart';

// ────────────────────────────────────────────────────
// Horizontal scrollable category nav bar
// ────────────────────────────────────────────────────

class CategoryNavBar extends StatelessWidget {
  final List<EventCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategoryNavBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      color: AppColors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _NavItem(
            category: categories[index],
            isSelected: index == selectedIndex,
            onTap: () => onCategorySelected(index),
            isYou: index == 0,
          );
        },
      ),
    );
  }
}

// ────────────────────────────────────────────────────
// Individual nav bar tab item
// ────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final EventCategory category;
  final bool isSelected;
  final bool isYou;
  final VoidCallback onTap;

  const _NavItem({
    required this.category,
    required this.isSelected,
    required this.isYou,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isYou ? AppColors.pink : category.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(right: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Icon / avatar ─────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: isSelected ? 52 : 44,
              height: isSelected ? 52 : 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: accentColor, width: 2.2)
                    : null,
              ),
              child: isYou
                  ? _YouAvatar(isSelected: isSelected)
                  : Icon(
                      category.icon,
                      color: isSelected ? accentColor : Colors.grey.shade400,
                      size: isSelected ? 23 : 20,
                    ),
            ),

            const SizedBox(height: 4),

            // ── Label ─────────────────────────────
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: GoogleFonts.poppins(
                fontSize: 9.5,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected
                    ? AppColors.darkPurple
                    : Colors.grey.shade400,
                letterSpacing: 0.3,
              ),
              child: Text(category.name),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────
// YOU avatar with notification badge
// ────────────────────────────────────────────────────

class _YouAvatar extends StatelessWidget {
  final bool isSelected;
  const _YouAvatar({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar circle
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Container(
              color: const Color(0xFF6B3FAB),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: isSelected ? 28 : 24,
                ),
              ),
            ),
          ),
        ),

        // Notification badge "12"
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: AppColors.pink,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '12',
                style: GoogleFonts.poppins(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────
// Expanded category overlay (shown when FAB is tapped)
// ────────────────────────────────────────────────────

class CategoryOverlay extends StatelessWidget {
  final List<EventCategory> categories;
  final int selectedIndex;
  final AnimationController controller;
  final ValueChanged<int> onCategorySelected;
  final VoidCallback onClose;

  const CategoryOverlay({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.controller,
    required this.onCategorySelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Opacity(
            opacity: controller.value.clamp(0.0, 1.0),
            child: child,
          );
        },
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(categories.length, (i) {
                  final cat = categories[i];
                  final isSelected = i == selectedIndex;
                  final accentColor =
                      i == 0 ? AppColors.pink : cat.primaryColor;

                  // Stagger interval per item
                  final start = (i * 0.12).clamp(0.0, 0.6);
                  final end = (start + 0.4).clamp(0.0, 1.0);
                  final itemAnim = CurvedAnimation(
                    parent: controller,
                    curve: Interval(start, end, curve: Curves.easeOutBack),
                  );

                  return AnimatedBuilder(
                    animation: itemAnim,
                    builder: (ctx, child) {
                      return Transform.translate(
                        offset: Offset(0, 30 * (1 - itemAnim.value)),
                        child: Opacity(
                          opacity: itemAnim.value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => onCategorySelected(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isSelected ? 62 : 50,
                              height: isSelected ? 62 : 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? accentColor
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2.4 : 1.2,
                                ),
                              ),
                              child: i == 0
                                  ? _YouAvatar(isSelected: isSelected)
                                  : Icon(
                                      cat.icon,
                                      color: isSelected
                                          ? accentColor
                                          : Colors.grey.shade400,
                                      size: isSelected ? 26 : 22,
                                    ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              cat.name,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.darkPurple
                                    : Colors.grey.shade400,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
