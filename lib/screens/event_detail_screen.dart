import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../models/event.dart';

// ────────────────────────────────────────────────────
// Event Detail Screen
// – Collapsing SliverAppBar with category colour
// – White card (group info + RSVP)
// – Dark details section (time / location / price)
// – Staggered entrance animation on all content items
// ────────────────────────────────────────────────────

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen>
    with TickerProviderStateMixin {
  bool _isGoing = false;
  bool _hasResponded = false;

  late AnimationController _staggerCtrl;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Five staggered items: group, rsvp, time, location, price
    _fades = List.generate(5, (i) {
      final s = 0.05 + i * 0.13;
      final e = (s + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _staggerCtrl, curve: Interval(s, e)));
    });
    _slides = List.generate(5, (i) {
      final s = 0.05 + i * 0.13;
      final e = (s + 0.35).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.25),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: _staggerCtrl,
          curve: Interval(s, e, curve: Curves.easeOutCubic)));
    });

    _staggerCtrl.forward();
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────

  Widget _stagger(int idx, Widget child) => SlideTransition(
        position: _slides[idx],
        child: FadeTransition(opacity: _fades[idx], child: child),
      );

  // ── Build ──────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPurple,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Collapsing colour header ───────────────
          _buildSliverAppBar(),

          // ── White card (group + RSVP) ──────────────
          SliverToBoxAdapter(child: _buildWhiteCard()),

          // ── Dark details section ───────────────────
          SliverToBoxAdapter(child: _buildDarkSection()),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Collapsing SliverAppBar
  // ────────────────────────────────────────────────

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: widget.event.cardColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.ios_share_outlined,
              color: Colors.white, size: 20),
          onPressed: () {},
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding:
            const EdgeInsets.only(left: 20, bottom: 56, right: 60),
        title: Text(
          widget.event.title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Solid colour background
            Container(color: widget.event.cardColor),

            // Watermark symbol
            Positioned(
              right: 10,
              top: 30,
              child: Text(
                widget.event.backgroundSymbol,
                style: TextStyle(
                  fontSize: 90,
                  color: Colors.white.withOpacity(0.1),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
      // Rounded bottom creates the swoosh effect
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(32),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  // White card section
  // ────────────────────────────────────────────────

  Widget _buildWhiteCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group info
          _stagger(
            0,
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.event.cardColor.withOpacity(0.2),
                  ),
                  child: Icon(Icons.group_outlined,
                      color: widget.event.cardColor, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.groupName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkPurple,
                      ),
                    ),
                    Text(
                      widget.event.location,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // RSVP card
          _stagger(1, _buildRsvpCard()),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // RSVP pill card
  // ────────────────────────────────────────────────

  Widget _buildRsvpCard() {
    if (_hasResponded) {
      return Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade200),
              child: const Icon(Icons.edit_outlined,
                  size: 18, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isGoing ? 'You are going!' : 'You are not going',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkPurple,
                    ),
                  ),
                  Text('Edit',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textGrey)),
                ],
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF00B4D8)),
              child: const Icon(Icons.check, color: Colors.white, size: 22),
            ),
          ],
        ),
      );
    }

    // Pre-response state
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkPurple,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
            ),
            child: const Icon(Icons.arrow_forward,
                size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Are you going?',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                Text('56 spots left',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.white54)),
              ],
            ),
          ),
          // No button
          GestureDetector(
            onTap: () => setState(() {
              _isGoing = false;
              _hasResponded = true;
            }),
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18)),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
          // Yes button
          GestureDetector(
            onTap: () => setState(() {
              _isGoing = true;
              _hasResponded = true;
            }),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18)),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // Dark details section (time / location / price)
  // ────────────────────────────────────────────────

  Widget _buildDarkSection() {
    return Container(
      color: AppColors.darkPurple,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
      child: Column(
        children: [
          // Time
          _stagger(
            2,
            _DetailRow(
              icon: Icons.access_time_outlined,
              title: 'Today',
              subtitle: '5:30 PM – 8:00 PM',
              extra: widget.event.isRecurring
                  ? widget.event.recurrenceText
                  : null,
            ),
          ),

          _divider(),

          // Location
          _stagger(
            3,
            Column(
              children: [
                _DetailRow(
                  icon: Icons.location_on_outlined,
                  title: 'The Bay Department Store',
                  subtitle:
                      '585 Saint Catherine Street West, Montreal, QC',
                ),
                const SizedBox(height: 14),
                // Map placeholder
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white12,
                  ),
                  child: Stack(
                    children: [
                      // Grid lines to suggest a map
                      Positioned.fill(
                        child: CustomPaint(painter: _MapGridPainter()),
                      ),
                      const Center(
                        child: Icon(Icons.location_pin,
                            color: Color(0xFF8B35BF), size: 36),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _divider(),

          // Price
          _stagger(
            4,
            _DetailRow(
              icon: Icons.credit_card_outlined,
              title: widget.event.price,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Divider(color: AppColors.dividerWhite, height: 1),
      );
}

// ────────────────────────────────────────────────────
// Detail row (icon + title + optional subtitles)
// ────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? extra;

  const _DetailRow(
      {required this.icon, required this.title, this.subtitle, this.extra});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white54, size: 22),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(subtitle!,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.white60)),
                ),
              if (extra != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(extra!,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.white60)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────
// Subtle map-grid painter for the location placeholder
// ────────────────────────────────────────────────────

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // A couple of "road" lines
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 3;
    canvas.drawLine(
        Offset(size.width * 0.2, 0),
        Offset(size.width * 0.4, size.height),
        roadPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.55),
        roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
