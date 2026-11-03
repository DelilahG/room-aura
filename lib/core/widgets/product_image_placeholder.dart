import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:room_aura/core/theme/app_colors.dart';

class ProductImagePlaceholder extends StatelessWidget {
  final String category;
  final int colorValue;
  final double? width;
  final double? height;
  final String? imageUrl;

  const ProductImagePlaceholder({
    super.key,
    required this.category,
    required this.colorValue,
    this.width,
    this.height,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              width: width,
              height: height,
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: (context, url) => Container(
                color: AppColors.surfaceVariant,
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.beige,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => _buildFallback(),
            )
          : _buildFallback(),
    );
  }

  Widget _buildFallback() {
    return ClipRect(
      child: CustomPaint(
        painter: _FurnitureIllustrationPainter(
          baseColor: Color(colorValue),
          category: category.toLowerCase(),
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _FurnitureIllustrationPainter extends CustomPainter {
  final Color baseColor;
  final String category;

  _FurnitureIllustrationPainter({
    required this.baseColor,
    required this.category,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);

    switch (category) {
      case 'sofas':
        _drawSofa(canvas, size);
      case 'beds':
        _drawBed(canvas, size);
      case 'chairs':
        _drawChair(canvas, size);
      case 'tables':
        _drawTable(canvas, size);
      case 'storage':
        _drawStorage(canvas, size);
      case 'lighting':
        _drawLighting(canvas, size);
      case 'rugs':
        _drawRug(canvas, size);
      case 'decor':
        _drawDecor(canvas, size);
      case 'cabinets':
        _drawCabinet(canvas, size);
      case 'outdoor' || 'outdoor furniture':
        _drawOutdoor(canvas, size);
      default:
        _drawGeneric(canvas, size);
    }
  }

  HSLColor get _hsl => HSLColor.fromColor(baseColor);

  Color get _lighter =>
      _hsl.withLightness((_hsl.lightness + 0.18).clamp(0.0, 0.95)).toColor();
  Color get _darker =>
      _hsl.withLightness((_hsl.lightness - 0.15).clamp(0.05, 1.0)).toColor();
  Color get _shadow => _hsl
      .withLightness((_hsl.lightness - 0.25).clamp(0.05, 1.0))
      .toColor()
      .withValues(alpha: 0.3);
  Color get _highlight => Colors.white.withValues(alpha: 0.25);

  void _drawBackground(Canvas canvas, Size size) {
    final bgLight = _hsl
        .withSaturation((_hsl.saturation * 0.15).clamp(0.0, 1.0))
        .withLightness(0.94)
        .toColor();
    final bgMid = _hsl
        .withSaturation((_hsl.saturation * 0.1).clamp(0.0, 1.0))
        .withLightness(0.91)
        .toColor();

    final bgGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [bgLight, bgMid],
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = bgGradient.createShader(Offset.zero & size),
    );

    final floorY = size.height * 0.78;
    final floorPaint = Paint()
      ..color = _hsl
          .withSaturation((_hsl.saturation * 0.08).clamp(0.0, 1.0))
          .withLightness(0.87)
          .toColor();
    canvas.drawRect(
      Rect.fromLTRB(0, floorY, size.width, size.height),
      floorPaint,
    );

    final floorLine = Paint()
      ..color = Colors.black.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, floorY), Offset(size.width, floorY), floorLine);
  }

  void _drawDropShadow(Canvas canvas, Rect bounds) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bounds.center.dx, bounds.bottom + 4),
        width: bounds.width * 0.85,
        height: 10,
      ),
      shadowPaint,
    );
  }

  RRect _rrect(double l, double t, double w, double h, [double r = 3]) =>
      RRect.fromRectAndRadius(Rect.fromLTWH(l, t, w, h), Radius.circular(r));

  void _drawSofa(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final baseY = s.height * 0.75;
    final w = s.width * 0.72;
    final h = s.height * 0.32;
    final left = cx - w / 2;

    _drawDropShadow(canvas, Rect.fromLTWH(left, baseY - h, w, h));

    // legs
    final legPaint = Paint()..color = _darker;
    for (final lx in [left + w * 0.08, left + w * 0.92 - 5]) {
      canvas.drawRRect(_rrect(lx, baseY - 4, 5, 12, 2), legPaint);
    }

    // seat base
    final seatRect = Rect.fromLTWH(left, baseY - h * 0.55, w, h * 0.55);
    final seatPaint = Paint()..color = baseColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(seatRect, const Radius.circular(6)),
      seatPaint,
    );

    // back
    final backRect = Rect.fromLTWH(
      left + w * 0.03,
      baseY - h,
      w * 0.94,
      h * 0.55,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(backRect, const Radius.circular(8)),
      Paint()..color = _darker,
    );

    // back highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          backRect.left + 4,
          backRect.top + 3,
          backRect.width - 8,
          8,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = _highlight,
    );

    // armrests
    for (final ax in [left, left + w - w * 0.1]) {
      canvas.drawRRect(
        _rrect(ax, baseY - h * 0.75, w * 0.1, h * 0.75, 6),
        Paint()
          ..color = _hsl
              .withLightness((_hsl.lightness - 0.05).clamp(0.05, 1.0))
              .toColor(),
      );
    }

    // cushion lines
    final cushionLine = Paint()
      ..color = _darker.withValues(alpha: 0.3)
      ..strokeWidth = 1.2;
    final cushW = (w * 0.94 - w * 0.1 * 2) / 3;
    for (var i = 1; i < 3; i++) {
      final lx = left + w * 0.1 + cushW * i;
      canvas.drawLine(
        Offset(lx, seatRect.top + 4),
        Offset(lx, seatRect.bottom - 4),
        cushionLine,
      );
    }

    // seat highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          seatRect.left + w * 0.12,
          seatRect.top + 3,
          seatRect.width - w * 0.24,
          5,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = _highlight,
    );
  }

  void _drawBed(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final baseY = s.height * 0.76;
    final w = s.width * 0.74;
    final left = cx - w / 2;
    final bedH = s.height * 0.22;
    final headH = s.height * 0.36;

    _drawDropShadow(canvas, Rect.fromLTWH(left, baseY - headH, w, headH));

    // legs
    final legPaint = Paint()..color = _darker;
    for (final lx in [left + 4, left + w - 8]) {
      canvas.drawRect(Rect.fromLTWH(lx, baseY - 3, 4, 10), legPaint);
    }

    // mattress
    canvas.drawRRect(
      _rrect(left, baseY - bedH, w, bedH, 5),
      Paint()..color = const Color(0xFFF5F0EB),
    );
    canvas.drawRRect(
      _rrect(left, baseY - bedH, w, bedH, 5),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // blanket/duvet
    final blanketRect = Rect.fromLTWH(
      left + 2,
      baseY - bedH + 6,
      w - 4,
      bedH * 0.65,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(blanketRect, const Radius.circular(4)),
      Paint()..color = baseColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          blanketRect.left + 6,
          blanketRect.top + 2,
          blanketRect.width - 12,
          5,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = _highlight,
    );

    // headboard
    canvas.drawRRect(
      _rrect(left + w * 0.02, baseY - headH, w * 0.96, headH - bedH + 4, 8),
      Paint()..color = _darker,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + w * 0.05, baseY - headH + 3, w * 0.9, 6),
        const Radius.circular(3),
      ),
      Paint()..color = _highlight,
    );

    // pillows
    final pillowColor = _lighter;
    final pw = w * 0.28;
    final ph = bedH * 0.4;
    for (final px in [left + w * 0.12, left + w * 0.6]) {
      canvas.drawRRect(
        _rrect(px, baseY - bedH - ph * 0.3, pw, ph, 8),
        Paint()..color = pillowColor,
      );
      canvas.drawRRect(
        _rrect(px + 4, baseY - bedH - ph * 0.3 + 3, pw - 8, 4, 2),
        Paint()..color = Colors.white.withValues(alpha: 0.3),
      );
    }
  }

  void _drawChair(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final baseY = s.height * 0.76;
    final w = s.width * 0.42;
    final left = cx - w / 2;
    final seatH = s.height * 0.08;
    final backH = s.height * 0.28;
    final legH = s.height * 0.18;

    _drawDropShadow(
      canvas,
      Rect.fromLTWH(left, baseY - seatH - backH, w, seatH + backH),
    );

    // back legs
    final legPaint = Paint()
      ..color = _darker
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(left + w * 0.15, baseY - seatH),
      Offset(left + w * 0.08, baseY + legH * 0.3),
      legPaint,
    );
    canvas.drawLine(
      Offset(left + w * 0.85, baseY - seatH),
      Offset(left + w * 0.92, baseY + legH * 0.3),
      legPaint,
    );

    // front legs
    canvas.drawLine(
      Offset(left + w * 0.2, baseY - seatH + seatH),
      Offset(left + w * 0.12, baseY + legH * 0.3),
      legPaint,
    );
    canvas.drawLine(
      Offset(left + w * 0.8, baseY - seatH + seatH),
      Offset(left + w * 0.88, baseY + legH * 0.3),
      legPaint,
    );

    // seat
    canvas.drawRRect(
      _rrect(left, baseY - seatH, w, seatH, 5),
      Paint()..color = baseColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + 4, baseY - seatH + 2, w - 8, 4),
        const Radius.circular(2),
      ),
      Paint()..color = _highlight,
    );

    // backrest
    final backPath = Path();
    backPath.moveTo(left + w * 0.08, baseY - seatH);
    backPath.quadraticBezierTo(
      left + w * 0.05,
      baseY - seatH - backH * 0.5,
      left + w * 0.12,
      baseY - seatH - backH,
    );
    backPath.lineTo(left + w * 0.88, baseY - seatH - backH);
    backPath.quadraticBezierTo(
      left + w * 0.95,
      baseY - seatH - backH * 0.5,
      left + w * 0.92,
      baseY - seatH,
    );
    backPath.close();
    canvas.drawPath(backPath, Paint()..color = _darker);

    // backrest highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + w * 0.15, baseY - seatH - backH + 5, w * 0.7, 5),
        const Radius.circular(3),
      ),
      Paint()..color = _highlight,
    );
  }

  void _drawTable(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final baseY = s.height * 0.74;
    final w = s.width * 0.62;
    final left = cx - w / 2;
    final topH = s.height * 0.045;
    final legH = s.height * 0.25;
    final topY = baseY - legH - topH;

    _drawDropShadow(canvas, Rect.fromLTWH(left, topY, w, topH + legH));

    // legs
    final legPaint = Paint()..color = _darker;
    final legW = 5.0;
    for (final lx in [left + w * 0.1, left + w * 0.9 - legW]) {
      canvas.drawRRect(_rrect(lx, topY + topH, legW, legH, 2), legPaint);
    }

    // cross-brace
    canvas.drawLine(
      Offset(left + w * 0.1 + legW / 2, topY + topH + legH * 0.6),
      Offset(left + w * 0.9 - legW / 2, topY + topH + legH * 0.6),
      Paint()
        ..color = _darker.withValues(alpha: 0.5)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // tabletop
    canvas.drawRRect(
      _rrect(left, topY, w, topH, 4),
      Paint()..color = baseColor,
    );

    // tabletop highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + 6, topY + 2, w - 12, 4),
        const Radius.circular(2),
      ),
      Paint()..color = _highlight,
    );

    // tabletop edge shadow
    canvas.drawLine(
      Offset(left + 4, topY + topH),
      Offset(left + w - 4, topY + topH),
      Paint()
        ..color = _shadow
        ..strokeWidth = 1,
    );

    // decorative item on table (a small vase)
    final vaseX = cx - 6;
    final vaseBottom = topY;
    canvas.drawRRect(
      _rrect(vaseX, vaseBottom - 18, 12, 18, 4),
      Paint()..color = _lighter.withValues(alpha: 0.7),
    );
    // tiny plant
    canvas.drawCircle(
      Offset(vaseX + 6, vaseBottom - 22),
      7,
      Paint()..color = const Color(0xFFA8B5A0).withValues(alpha: 0.6),
    );
  }

  void _drawStorage(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final baseY = s.height * 0.76;
    final w = s.width * 0.52;
    final h = s.height * 0.48;
    final left = cx - w / 2;
    final top = baseY - h;

    _drawDropShadow(canvas, Rect.fromLTWH(left, top, w, h));

    // main body
    canvas.drawRRect(_rrect(left, top, w, h, 4), Paint()..color = baseColor);

    // shelves
    final shelfCount = 4;
    final shelfH = h / shelfCount;
    final shelfPaint = Paint()
      ..color = _darker.withValues(alpha: 0.35)
      ..strokeWidth = 1.5;
    for (var i = 1; i < shelfCount; i++) {
      final sy = top + shelfH * i;
      canvas.drawLine(
        Offset(left + 3, sy),
        Offset(left + w - 3, sy),
        shelfPaint,
      );
    }

    // side panels (darker edges)
    final sidePaint = Paint()
      ..color = _darker
      ..strokeWidth = 2.5;
    canvas.drawLine(Offset(left, top + 2), Offset(left, baseY - 2), sidePaint);
    canvas.drawLine(
      Offset(left + w, top + 2),
      Offset(left + w, baseY - 2),
      sidePaint,
    );

    // books on shelves
    final bookColors = [
      _lighter,
      _darker.withValues(alpha: 0.6),
      const Color(0xFFD4C5B2),
      baseColor.withValues(alpha: 0.7),
    ];
    final rng = Random(baseColor.toARGB32());
    for (var shelf = 0; shelf < shelfCount; shelf++) {
      final sy = top + shelfH * shelf + 4;
      final bookH = shelfH - 8;
      var bx = left + 6.0;
      final bookCount = 2 + rng.nextInt(3);
      for (var b = 0; b < bookCount && bx < left + w - 12; b++) {
        final bw = 5.0 + rng.nextDouble() * 7;
        canvas.drawRRect(
          _rrect(
            bx,
            sy + (bookH - bookH * (0.7 + rng.nextDouble() * 0.3)),
            bw,
            bookH * (0.7 + rng.nextDouble() * 0.3),
            1.5,
          ),
          Paint()..color = bookColors[rng.nextInt(bookColors.length)],
        );
        bx += bw + 2;
      }
    }

    // top highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + 3, top + 1, w - 6, 3),
        const Radius.circular(2),
      ),
      Paint()..color = _highlight,
    );
  }

  void _drawLighting(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final topY = s.height * 0.06;

    // cord
    canvas.drawLine(
      Offset(cx, 0),
      Offset(cx, topY + s.height * 0.12),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..strokeWidth = 1.5,
    );

    // shade
    final shadeTop = topY + s.height * 0.12;
    final shadeBottom = shadeTop + s.height * 0.32;
    final shadeTopW = s.width * 0.15;
    final shadeBotW = s.width * 0.45;

    // glow effect
    final glowPaint = Paint()
      ..color = baseColor.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
    canvas.drawCircle(
      Offset(cx, shadeBottom + s.height * 0.12),
      s.width * 0.35,
      glowPaint,
    );

    // shade shape
    final shadePath = Path();
    shadePath.moveTo(cx - shadeTopW / 2, shadeTop);
    shadePath.lineTo(cx - shadeBotW / 2, shadeBottom);
    shadePath.quadraticBezierTo(
      cx,
      shadeBottom + 8,
      cx + shadeBotW / 2,
      shadeBottom,
    );
    shadePath.lineTo(cx + shadeTopW / 2, shadeTop);
    shadePath.close();

    canvas.drawPath(shadePath, Paint()..color = baseColor);

    // shade highlight
    final hlPath = Path();
    hlPath.moveTo(cx - shadeTopW / 2 + 3, shadeTop + 2);
    hlPath.lineTo(cx - shadeBotW / 2 + 10, shadeBottom - 4);
    hlPath.lineTo(cx - shadeBotW * 0.15, shadeBottom - 4);
    hlPath.lineTo(cx - shadeTopW * 0.1, shadeTop + 2);
    hlPath.close();
    canvas.drawPath(hlPath, Paint()..color = _highlight);

    // rim
    canvas.drawLine(
      Offset(cx - shadeBotW / 2, shadeBottom),
      Offset(cx + shadeBotW / 2, shadeBottom),
      Paint()
        ..color = _darker
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // light cone
    final conePaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFFF8E7).withValues(alpha: 0.2),
              const Color(0xFFFFF8E7).withValues(alpha: 0.02),
            ],
          ).createShader(
            Rect.fromLTWH(
              cx - shadeBotW,
              shadeBottom,
              shadeBotW * 2,
              s.height * 0.4,
            ),
          );
    final conePath = Path();
    conePath.moveTo(cx - shadeBotW / 2 + 5, shadeBottom + 2);
    conePath.lineTo(cx - shadeBotW * 0.7, s.height * 0.78);
    conePath.lineTo(cx + shadeBotW * 0.7, s.height * 0.78);
    conePath.lineTo(cx + shadeBotW / 2 - 5, shadeBottom + 2);
    conePath.close();
    canvas.drawPath(conePath, conePaint);

    // canopy at top
    canvas.drawRRect(_rrect(cx - 10, topY, 20, 8, 4), Paint()..color = _darker);
  }

  void _drawRug(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height * 0.52;
    final w = s.width * 0.72;
    final h = s.height * 0.42;

    // rug shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 4), width: w, height: h),
        const Radius.circular(6),
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.06)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // main rug
    final rugRect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: w,
      height: h,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rugRect, const Radius.circular(4)),
      Paint()..color = baseColor,
    );

    // border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w - 14, height: h - 14),
        const Radius.circular(3),
      ),
      Paint()
        ..color = _darker
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // inner border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w - 24, height: h - 24),
        const Radius.circular(2),
      ),
      Paint()
        ..color = _lighter.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // center pattern — diamond
    final dSize = min(w, h) * 0.22;
    final diamond = Path();
    diamond.moveTo(cx, cy - dSize);
    diamond.lineTo(cx + dSize, cy);
    diamond.lineTo(cx, cy + dSize);
    diamond.lineTo(cx - dSize, cy);
    diamond.close();
    canvas.drawPath(diamond, Paint()..color = _darker.withValues(alpha: 0.4));

    final innerDiamond = Path();
    final id = dSize * 0.55;
    innerDiamond.moveTo(cx, cy - id);
    innerDiamond.lineTo(cx + id, cy);
    innerDiamond.lineTo(cx, cy + id);
    innerDiamond.lineTo(cx - id, cy);
    innerDiamond.close();
    canvas.drawPath(
      innerDiamond,
      Paint()..color = _lighter.withValues(alpha: 0.5),
    );

    // corner accents
    final cornerSize = 8.0;
    for (final offset in [
      Offset(rugRect.left + 18, rugRect.top + 18),
      Offset(rugRect.right - 18, rugRect.top + 18),
      Offset(rugRect.left + 18, rugRect.bottom - 18),
      Offset(rugRect.right - 18, rugRect.bottom - 18),
    ]) {
      canvas.drawCircle(
        offset,
        cornerSize,
        Paint()..color = _darker.withValues(alpha: 0.25),
      );
    }

    // texture lines
    final texPaint = Paint()
      ..color = _darker.withValues(alpha: 0.08)
      ..strokeWidth = 0.8;
    for (var i = 0; i < 6; i++) {
      final y = rugRect.top + 16 + (h - 32) / 6 * i;
      canvas.drawLine(
        Offset(rugRect.left + 14, y),
        Offset(rugRect.right - 14, y),
        texPaint,
      );
    }

    // fringe at top and bottom
    final fringePaint = Paint()
      ..color = _lighter.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    for (var x = rugRect.left + 8; x < rugRect.right - 6; x += 5) {
      canvas.drawLine(
        Offset(x, rugRect.top),
        Offset(x, rugRect.top - 6),
        fringePaint,
      );
      canvas.drawLine(
        Offset(x, rugRect.bottom),
        Offset(x, rugRect.bottom + 6),
        fringePaint,
      );
    }
  }

  void _drawDecor(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final baseY = s.height * 0.76;

    _drawDropShadow(
      canvas,
      Rect.fromLTWH(cx - 20, baseY - s.height * 0.35, 40, s.height * 0.35),
    );

    // vase body
    final vaseW = s.width * 0.22;
    final vaseH = s.height * 0.34;
    final vaseTop = baseY - vaseH;

    final vasePath = Path();
    vasePath.moveTo(cx - vaseW * 0.3, vaseTop);
    vasePath.cubicTo(
      cx - vaseW * 0.55,
      vaseTop + vaseH * 0.3,
      cx - vaseW * 0.5,
      vaseTop + vaseH * 0.7,
      cx - vaseW * 0.45,
      baseY,
    );
    vasePath.lineTo(cx + vaseW * 0.45, baseY);
    vasePath.cubicTo(
      cx + vaseW * 0.5,
      vaseTop + vaseH * 0.7,
      cx + vaseW * 0.55,
      vaseTop + vaseH * 0.3,
      cx + vaseW * 0.3,
      vaseTop,
    );
    vasePath.close();

    canvas.drawPath(vasePath, Paint()..color = baseColor);

    // vase highlight
    final hlPath = Path();
    hlPath.moveTo(cx - vaseW * 0.2, vaseTop + 4);
    hlPath.cubicTo(
      cx - vaseW * 0.35,
      vaseTop + vaseH * 0.3,
      cx - vaseW * 0.32,
      vaseTop + vaseH * 0.6,
      cx - vaseW * 0.3,
      baseY - 4,
    );
    hlPath.lineTo(cx - vaseW * 0.15, baseY - 4);
    hlPath.cubicTo(
      cx - vaseW * 0.2,
      vaseTop + vaseH * 0.6,
      cx - vaseW * 0.22,
      vaseTop + vaseH * 0.3,
      cx - vaseW * 0.1,
      vaseTop + 4,
    );
    hlPath.close();
    canvas.drawPath(hlPath, Paint()..color = _highlight);

    // rim
    canvas.drawRRect(
      _rrect(cx - vaseW * 0.32, vaseTop - 3, vaseW * 0.64, 6, 3),
      Paint()..color = _darker,
    );

    // branches/leaves
    final leafColor = const Color(0xFF6B7F62);
    final stemPaint = Paint()
      ..color = leafColor.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // center stem
    canvas.drawLine(
      Offset(cx, vaseTop - 3),
      Offset(cx, vaseTop - vaseH * 0.55),
      stemPaint,
    );
    // left branch
    canvas.drawLine(
      Offset(cx - 2, vaseTop - vaseH * 0.3),
      Offset(cx - vaseW * 0.45, vaseTop - vaseH * 0.6),
      stemPaint,
    );
    // right branch
    canvas.drawLine(
      Offset(cx + 2, vaseTop - vaseH * 0.25),
      Offset(cx + vaseW * 0.4, vaseTop - vaseH * 0.55),
      stemPaint,
    );

    // leaves
    final leafPaint = Paint()..color = leafColor.withValues(alpha: 0.55);
    for (final pos in [
      Offset(cx, vaseTop - vaseH * 0.55),
      Offset(cx - vaseW * 0.45, vaseTop - vaseH * 0.6),
      Offset(cx + vaseW * 0.4, vaseTop - vaseH * 0.55),
      Offset(cx - vaseW * 0.2, vaseTop - vaseH * 0.42),
      Offset(cx + vaseW * 0.18, vaseTop - vaseH * 0.38),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: pos, width: 14, height: 9),
        leafPaint,
      );
    }
  }

  void _drawCabinet(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final baseY = s.height * 0.76;
    final w = s.width * 0.65;
    final h = s.height * 0.36;
    final left = cx - w / 2;
    final top = baseY - h;

    _drawDropShadow(canvas, Rect.fromLTWH(left, top, w, h));

    // legs
    final legPaint = Paint()..color = _darker;
    for (final lx in [left + 8, left + w - 12]) {
      canvas.drawRRect(_rrect(lx, baseY - 2, 4, 10, 2), legPaint);
    }

    // main body
    canvas.drawRRect(_rrect(left, top, w, h, 5), Paint()..color = baseColor);

    // divider line (two doors)
    canvas.drawLine(
      Offset(cx, top + 6),
      Offset(cx, baseY - 6),
      Paint()
        ..color = _darker.withValues(alpha: 0.3)
        ..strokeWidth = 1.5,
    );

    // door handles
    final handlePaint = Paint()
      ..color = _darker
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final handleY = top + h / 2;
    canvas.drawLine(
      Offset(cx - 12, handleY - 8),
      Offset(cx - 12, handleY + 8),
      handlePaint,
    );
    canvas.drawLine(
      Offset(cx + 12, handleY - 8),
      Offset(cx + 12, handleY + 8),
      handlePaint,
    );

    // top highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + 4, top + 2, w - 8, 4),
        const Radius.circular(2),
      ),
      Paint()..color = _highlight,
    );

    // side shadow
    canvas.drawRect(
      Rect.fromLTWH(left + w - 4, top + 4, 4, h - 8),
      Paint()..color = _shadow.withValues(alpha: 0.15),
    );

    // tabletop surface
    canvas.drawRRect(
      _rrect(left - 3, top - 4, w + 6, 6, 3),
      Paint()..color = _darker,
    );
  }

  void _drawOutdoor(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final baseY = s.height * 0.76;
    final w = s.width * 0.6;
    final left = cx - w / 2;
    final seatH = s.height * 0.06;
    final backH = s.height * 0.2;
    final legH = s.height * 0.16;

    _drawDropShadow(
      canvas,
      Rect.fromLTWH(left, baseY - seatH - backH, w, seatH + backH + legH),
    );

    // bench legs (slatted style)
    final legPaint = Paint()
      ..color = _darker
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(left + w * 0.1, baseY - seatH),
      Offset(left + w * 0.08, baseY + legH * 0.4),
      legPaint,
    );
    canvas.drawLine(
      Offset(left + w * 0.9, baseY - seatH),
      Offset(left + w * 0.92, baseY + legH * 0.4),
      legPaint,
    );
    // front legs
    canvas.drawLine(
      Offset(left + w * 0.18, baseY),
      Offset(left + w * 0.15, baseY + legH * 0.4),
      legPaint,
    );
    canvas.drawLine(
      Offset(left + w * 0.82, baseY),
      Offset(left + w * 0.85, baseY + legH * 0.4),
      legPaint,
    );

    // armrests
    canvas.drawRRect(
      _rrect(
        left,
        baseY - seatH - backH * 0.4,
        w * 0.08,
        backH * 0.4 + seatH,
        3,
      ),
      Paint()..color = _darker,
    );
    canvas.drawRRect(
      _rrect(
        left + w - w * 0.08,
        baseY - seatH - backH * 0.4,
        w * 0.08,
        backH * 0.4 + seatH,
        3,
      ),
      Paint()..color = _darker,
    );

    // seat slats
    final slatCount = 5;
    final slatW = (w - w * 0.16 - (slatCount - 1) * 2) / slatCount;
    for (var i = 0; i < slatCount; i++) {
      final sx = left + w * 0.08 + (slatW + 2) * i;
      canvas.drawRRect(
        _rrect(sx, baseY - seatH, slatW, seatH, 1.5),
        Paint()..color = baseColor,
      );
    }

    // backrest slats
    final backSlatCount = 5;
    final backSlatW = (w * 0.84 - (backSlatCount - 1) * 3) / backSlatCount;
    for (var i = 0; i < backSlatCount; i++) {
      final bx = left + w * 0.08 + (backSlatW + 3) * i;
      canvas.drawRRect(
        _rrect(bx, baseY - seatH - backH, backSlatW, backH, 2),
        Paint()..color = i % 2 == 0 ? baseColor : _lighter,
      );
    }

    // top rail
    canvas.drawRRect(
      _rrect(left + w * 0.06, baseY - seatH - backH - 4, w * 0.88, 6, 3),
      Paint()..color = _darker,
    );

    // highlight on seat
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left + w * 0.1, baseY - seatH + 1, w * 0.8, 3),
        const Radius.circular(2),
      ),
      Paint()..color = _highlight,
    );
  }

  void _drawGeneric(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height * 0.5;
    final r = s.width * 0.2;

    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = baseColor);
    canvas.drawCircle(
      Offset(cx - r * 0.25, cy - r * 0.25),
      r * 0.35,
      Paint()..color = _highlight,
    );
  }

  @override
  bool shouldRepaint(covariant _FurnitureIllustrationPainter old) =>
      old.baseColor != baseColor || old.category != category;
}
