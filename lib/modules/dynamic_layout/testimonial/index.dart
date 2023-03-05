import 'package:flutter/material.dart';

import '../config/testimonial_config.dart';
import '../index.dart';
import 'testimonial_card.dart';
import 'testimonial_chat.dart';

class TestimonialLayout extends StatelessWidget {
  final TestimonialConfig config;
  const TestimonialLayout({required this.config, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (config.type == TestimonialType.chat) {
      return TestimonialChat(
        config: config,
      );
    }
    return TestimonialCard(
      config: config,
    );
  }
}
