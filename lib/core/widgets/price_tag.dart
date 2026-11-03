import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:room_aura/core/theme/app_typography.dart';

class PriceTag extends StatelessWidget {
  final double price;
  final TextStyle? style;

  const PriceTag({super.key, required this.price, this.style});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'en');
    return Text(
      'Br ${formatter.format(price.round())}',
      style: style ?? AppTypography.price,
    );
  }
}
