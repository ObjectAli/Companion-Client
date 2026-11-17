import 'package:flutter/material.dart';
import 'event_card.dart';

class TestEventDetailsScreen extends StatelessWidget {
  const TestEventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Временно
    const String testId = '1bf2c407-276f-4f45-97e7-98fa7abae56c'; 

    return const EventDetailsScreen(
      eventId: testId, 
    );
  }
}