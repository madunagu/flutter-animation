import 'package:flutter/material.dart';
import '../models/event.dart';
import '../app_colors.dart';

// ────────────────────────────────────────────────────
// Sample event data mirroring the UI demo
// ────────────────────────────────────────────────────

const List<Event> _trendingEvents = [
  Event(
    id: 't1',
    dayLabel: 'TODAY',
    time: '5:30 PM',
    title: 'Yoga and Meditation for Beginners',
    groupName: 'Easy And Gentle Yoga',
    location: 'Montreal, QC Private group',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.trendingLight,
    backgroundSymbol: 'V',
    price: '\$21.00',
    isRecurring: true,
    recurrenceText: 'Every week on Monday',
  ),
  Event(
    id: 't2',
    dayLabel: 'TUESDAY',
    time: '5:30 PM',
    title: 'Practice French, English And Chinese',
    groupName: 'Language Learners Montreal',
    location: 'Montreal, QC',
    participantText: 'Join Ryan, Bob & 12 others',
    cardColor: AppColors.trendingMid,
    backgroundSymbol: '⊕',
    price: '\$0.00',
  ),
  Event(
    id: 't3',
    dayLabel: 'FRIDAY',
    time: '6:00 PM',
    title: 'Adobe XD Live Event in Europe',
    groupName: 'Adobe Design Community',
    location: 'Online',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.trendingDark,
    backgroundSymbol: 'Xd',
    price: '\$0.00',
  ),
];

const List<Event> _healthEvents = [
  Event(
    id: 'h1',
    dayLabel: 'TODAY',
    time: '5:30 PM',
    title: 'Vegetarians Recipes Meetup',
    groupName: 'Veg Community Montreal',
    location: 'Montreal, QC',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.healthLight,
    backgroundSymbol: '❋',
    price: '\$0.00',
  ),
  Event(
    id: 'h2',
    dayLabel: 'TUESDAY',
    time: '5:30 PM',
    title: 'Learn How To do Your Own Juice',
    groupName: 'Juice Lovers',
    location: 'Montreal, QC',
    participantText: 'Join Peter & 8 others',
    cardColor: AppColors.healthMid,
    backgroundSymbol: '⚗',
    price: '\$15.00',
    isSmall: true,
  ),
  Event(
    id: 'h3',
    dayLabel: 'TUESDAY',
    time: '5:30 PM',
    title: 'Top Natural Remedies',
    groupName: 'Natural Health Group',
    location: 'Montreal, QC',
    participantText: 'Join Steve & 3 others',
    cardColor: Color(0xFF2D6A00),
    backgroundSymbol: '+',
    price: '\$0.00',
    isSmall: true,
  ),
  Event(
    id: 'h4',
    dayLabel: 'FRIDAY',
    time: '6:00 PM',
    title: 'Sports Lover Training Session',
    groupName: 'Sports Lovers Montreal',
    location: 'Montreal, QC',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.healthDark,
    backgroundSymbol: '↑',
    price: '\$0.00',
  ),
];

const List<Event> _musicEvents = [
  Event(
    id: 'm1',
    dayLabel: 'TODAY',
    time: '5:30 PM',
    title: 'NYC Electronic Music Meetup',
    groupName: 'Electronic Music NYC',
    location: 'New York, NY',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.musicLight,
    backgroundSymbol: '♪',
    price: '\$0.00',
  ),
  Event(
    id: 'm2',
    dayLabel: 'TUESDAY',
    time: '5:30 PM',
    title: 'Read Inspiring Quotes Out Loud',
    groupName: 'Book & Music Lovers',
    location: 'Montreal, QC',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.musicMid,
    backgroundSymbol: '♬',
    price: '\$0.00',
  ),
  Event(
    id: 'm3',
    dayLabel: 'FRIDAY',
    time: '6:00 PM',
    title: 'Crazy Effects Music on Your Brain',
    groupName: 'Brain Music Society',
    location: 'Montreal, QC',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.musicDark,
    backgroundSymbol: '∿',
    price: '\$0.00',
  ),
];

const List<Event> _sportEvents = [
  Event(
    id: 's1',
    dayLabel: 'TODAY',
    time: '6:00 AM',
    title: 'Morning Run in Central Park',
    groupName: 'NYC Runners Club',
    location: 'New York, NY',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.sportLight,
    backgroundSymbol: '⟳',
    price: '\$0.00',
  ),
  Event(
    id: 's2',
    dayLabel: 'TUESDAY',
    time: '7:00 PM',
    title: 'Basketball Open Court Game',
    groupName: 'Street Ball Montreal',
    location: 'Montreal, QC',
    participantText: 'Join Ryan, Bob & 12 others',
    cardColor: AppColors.sportMid,
    backgroundSymbol: '○',
    price: '\$5.00',
  ),
  Event(
    id: 's3',
    dayLabel: 'FRIDAY',
    time: '9:00 AM',
    title: 'Weekend Cycling Adventure',
    groupName: 'MTL Cyclists',
    location: 'Montreal, QC',
    participantText: 'Join Marie, John & 10 others',
    cardColor: AppColors.sportDark,
    backgroundSymbol: '↻',
    price: '\$0.00',
  ),
];

// ────────────────────────────────────────────────────
// Category list – index 0 is always YOU (profile tab)
// ────────────────────────────────────────────────────

final List<EventCategory> appCategories = [
  const EventCategory(
    id: 'you',
    name: 'YOU',
    icon: Icons.person,
    primaryColor: AppColors.pink,
    events: [], // profile tab; events unused
    isProfile: true,
  ),
  const EventCategory(
    id: 'trending',
    name: 'TRENDING',
    icon: Icons.show_chart,
    primaryColor: AppColors.pink,
    events: _trendingEvents,
  ),
  const EventCategory(
    id: 'health',
    name: 'HEALTH',
    icon: Icons.favorite_border,
    primaryColor: AppColors.healthLight,
    events: _healthEvents,
  ),
  const EventCategory(
    id: 'music',
    name: 'MUSIC',
    icon: Icons.headset_outlined,
    primaryColor: AppColors.musicLight,
    events: _musicEvents,
  ),
  const EventCategory(
    id: 'sport',
    name: 'SPORT',
    icon: Icons.sports,
    primaryColor: AppColors.sportLight,
    events: _sportEvents,
  ),
];
