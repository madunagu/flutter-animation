import 'package:flutter/material.dart';

// ────────────────────────────────────────────────────
// Data models
// ────────────────────────────────────────────────────

class Event {
  final String id;
  final String dayLabel; // "TODAY", "TUESDAY", "FRIDAY"
  final String time; // "5:30 PM"
  final String title;
  final String groupName;
  final String location;
  final String participantText;
  final Color cardColor;
  final String backgroundSymbol; // watermark text / emoji
  final String price;
  final bool isRecurring;
  final String recurrenceText;
  final bool isSmall; // for 2-column grid layout

  const Event({
    required this.id,
    required this.dayLabel,
    required this.time,
    required this.title,
    required this.groupName,
    required this.location,
    required this.participantText,
    required this.cardColor,
    required this.backgroundSymbol,
    this.price = '\$0.00',
    this.isRecurring = false,
    this.recurrenceText = '',
    this.isSmall = false,
  });
}

class EventCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color primaryColor; // nav accent
  final List<Event> events;
  final bool isProfile; // true = YOU tab shows profile

  const EventCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.primaryColor,
    required this.events,
    this.isProfile = false,
  });
}
