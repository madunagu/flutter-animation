import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/event.dart';

// ────────────────────────────────────────────────────
// A single full-width event card
// ────────────────────────────────────────────────────

class EventCard extends StatelessWidget {
  final Event event;
  final bool small; // half-width variant for 2-column grid

  const EventCard({
    super.key,
    required this.event,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: small ? 165 : 165,
      color: event.cardColor,
      padding: EdgeInsets.all(small ? 14 : 20),
      child: Stack(
        children: [
          // ── Background watermark ──────────────────
          Positioned(
            right: small ? -8 : -12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                event.backgroundSymbol,
                style: TextStyle(
                  fontSize: small ? 54 : 72,
                  color: Colors.white.withValues(alpha: 0.12),
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),

          // ── Foreground content ────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Day + time label
              Text(
                '${event.dayLabel}  ${event.time}',
                style: GoogleFonts.poppins(
                  fontSize: small ? 9 : 11,
                  color: Colors.white.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),

              // Event title
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    event.title,
                    style: GoogleFonts.poppins(
                      fontSize: small ? 14 : 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    maxLines: small ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              // Participants row
              Row(
                children: [
                  _ParticipantAvatars(small: small),
                  SizedBox(width: small ? 6 : 8),
                  Expanded(
                    child: Text(
                      event.participantText,
                      style: GoogleFonts.poppins(
                        fontSize: small ? 9.5 : 11,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────
// Overlapping avatar circles
// ────────────────────────────────────────────────────

class _ParticipantAvatars extends StatelessWidget {
  final bool small;
  const _ParticipantAvatars({this.small = false});

  static const List<Color> _colors = [
    Color(0xFFFFB347),
    Color(0xFF87CEEB),
  ];

  @override
  Widget build(BuildContext context) {
    final size = small ? 20.0 : 24.0;
    final overlap = small ? 12.0 : 16.0;
    return SizedBox(
      width: overlap + size,
      height: size,
      child: Stack(
        children: List.generate(2, (i) {
          return Positioned(
            left: i * overlap.toDouble(),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _colors[i],
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ────────────────────────────────────────────────────
// A row of two small (half-width) cards
// ────────────────────────────────────────────────────

class EventCardPair extends StatelessWidget {
  final Event left;
  final Event right;

  const EventCardPair({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: EventCard(event: left, small: true)),
        Expanded(child: EventCard(event: right, small: true)),
      ],
    );
  }
}
