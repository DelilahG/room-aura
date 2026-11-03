import 'dart:math';

import 'package:flutter/material.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/constants/app_constants.dart';
import 'package:room_aura/data/models/room.dart';

class RoomEditorCanvas extends StatefulWidget {
  final RoomDesign roomDesign;
  final String? selectedFurnitureId;
  final void Function(String id, double x, double y)? onFurnitureMoved;
  final ValueChanged<String>? onFurnitureSelected;
  final void Function(String id, double rotation)? onFurnitureRotated;
  final ValueChanged<String>? onFurnitureRemoved;

  const RoomEditorCanvas({
    super.key,
    required this.roomDesign,
    this.selectedFurnitureId,
    this.onFurnitureMoved,
    this.onFurnitureSelected,
    this.onFurnitureRotated,
    this.onFurnitureRemoved,
  });

  @override
  State<RoomEditorCanvas> createState() => _RoomEditorCanvasState();
}

class _RoomEditorCanvasState extends State<RoomEditorCanvas> {
  String? _draggingId;
  Offset? _dragStartLocal;
  Offset? _dragStartFurniture;
  final TransformationController _transformController =
      TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  double get ppm => AppConstants.pixelsPerMeter;

  Rect _furnitureRect(PlacedFurniture f) {
    return Rect.fromLTWH(f.x * ppm, f.y * ppm, f.width * ppm, f.depth * ppm);
  }

  PlacedFurniture? _hitTest(Offset localPosition) {
    for (final f in widget.roomDesign.furniture.reversed) {
      if (_furnitureRect(f).contains(localPosition)) {
        return f;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.roomDesign;
    final canvasWidth = room.width * ppm + 80;
    final canvasHeight = room.length * ppm + 80;

    return InteractiveViewer(
      transformationController: _transformController,
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.3,
      maxScale: 3.0,
      child: GestureDetector(
        onTapUp: (details) {
          final pos = details.localPosition - const Offset(40, 40);
          final hit = _hitTest(pos);
          if (hit != null) {
            widget.onFurnitureSelected?.call(hit.id);
          } else {
            widget.onFurnitureSelected?.call('');
          }
        },
        onPanStart: (details) {
          final pos = details.localPosition - const Offset(40, 40);
          final hit = _hitTest(pos);
          if (hit != null) {
            setState(() {
              _draggingId = hit.id;
              _dragStartLocal = pos;
              _dragStartFurniture = Offset(hit.x, hit.y);
            });
            widget.onFurnitureSelected?.call(hit.id);
          }
        },
        onPanUpdate: (details) {
          if (_draggingId == null ||
              _dragStartLocal == null ||
              _dragStartFurniture == null) {
            return;
          }
          final pos = details.localPosition - const Offset(40, 40);
          final delta = pos - _dragStartLocal!;
          final piece = widget.roomDesign.furniture
              .where((f) => f.id == _draggingId)
              .firstOrNull;
          if (piece == null) return;

          final newX = (_dragStartFurniture!.dx + delta.dx / ppm).clamp(
            0.0,
            room.width - piece.width,
          );
          final newY = (_dragStartFurniture!.dy + delta.dy / ppm).clamp(
            0.0,
            room.length - piece.depth,
          );

          widget.onFurnitureMoved?.call(_draggingId!, newX, newY);
        },
        onPanEnd: (_) {
          setState(() {
            _draggingId = null;
            _dragStartLocal = null;
            _dragStartFurniture = null;
          });
        },
        child: Container(
          width: canvasWidth,
          height: canvasHeight,
          color: AppColors.surfaceVariant,
          child: CustomPaint(
            size: Size(canvasWidth, canvasHeight),
            painter: _RoomPainter(
              room: room,
              ppm: ppm,
              selectedId: widget.selectedFurnitureId,
              draggingId: _draggingId,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomPainter extends CustomPainter {
  final RoomDesign room;
  final double ppm;
  final String? selectedId;
  final String? draggingId;

  _RoomPainter({
    required this.room,
    required this.ppm,
    this.selectedId,
    this.draggingId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const offset = Offset(40, 40);
    final roomW = room.width * ppm;
    final roomH = room.length * ppm;
    final roomRect = Rect.fromLTWH(offset.dx, offset.dy, roomW, roomH);

    _drawFloor(canvas, roomRect);
    _drawGrid(canvas, roomRect);
    _drawWalls(canvas, roomRect);
    _drawDimensions(canvas, roomRect);
    _drawFurniture(canvas, offset);
  }

  void _drawFloor(Canvas canvas, Rect rect) {
    final paint = Paint()..color = Color(room.floorColor);
    canvas.drawRect(rect, paint);
  }

  void _drawGrid(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..strokeWidth = 0.5;

    final step = ppm * 0.5;
    for (double x = rect.left; x <= rect.right; x += step) {
      canvas.drawLine(Offset(x, rect.top), Offset(x, rect.bottom), paint);
    }
    for (double y = rect.top; y <= rect.bottom; y += step) {
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), paint);
    }
  }

  void _drawWalls(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Color(room.wallColor).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRect(rect, paint);

    final borderPaint = Paint()
      ..color = AppColors.charcoal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(rect, borderPaint);
  }

  void _drawDimensions(Canvas canvas, Rect rect) {
    final style = TextStyle(
      color: AppColors.textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    _drawText(
      canvas,
      '${room.width.toStringAsFixed(1)}m',
      Offset(rect.center.dx, rect.top - 14),
      style,
    );
    _drawText(
      canvas,
      '${room.length.toStringAsFixed(1)}m',
      Offset(rect.left - 22, rect.center.dy),
      style,
      rotate: -pi / 2,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset position,
    TextStyle style, {
    double rotate = 0,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(position.dx, position.dy);
    if (rotate != 0) canvas.rotate(rotate);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  void _drawFurniture(Canvas canvas, Offset offset) {
    for (final f in room.furniture) {
      final rect = Rect.fromLTWH(
        offset.dx + f.x * ppm,
        offset.dy + f.y * ppm,
        f.width * ppm,
        f.depth * ppm,
      );

      canvas.save();
      if (f.rotation != 0) {
        canvas.translate(rect.center.dx, rect.center.dy);
        canvas.rotate(f.rotation * pi / 180);
        canvas.translate(-rect.center.dx, -rect.center.dy);
      }

      final isSelected = f.id == selectedId;
      final isDragging = f.id == draggingId;

      final bodyPaint = Paint()
        ..color = Color(f.color).withValues(alpha: isDragging ? 0.7 : 0.85);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      canvas.drawRRect(rrect, bodyPaint);

      final borderPaint = Paint()
        ..color = isSelected
            ? AppColors.info
            : Colors.black.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.5 : 1;
      canvas.drawRRect(rrect, borderPaint);

      if (isSelected) {
        final handlePaint = Paint()..color = AppColors.info;
        const r = 4.0;
        for (final corner in [
          rect.topLeft,
          rect.topRight,
          rect.bottomLeft,
          rect.bottomRight,
        ]) {
          canvas.drawCircle(corner, r, handlePaint);
        }
      }

      final labelStyle = TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 9,
        fontWeight: FontWeight.w500,
      );
      _drawTextCentered(
        canvas,
        f.name,
        rect.center,
        labelStyle,
        rect.width - 8,
      );

      canvas.restore();
    }
  }

  void _drawTextCentered(
    Canvas canvas,
    String text,
    Offset center,
    TextStyle style,
    double maxWidth,
  ) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    )..layout(maxWidth: maxWidth.clamp(20, double.infinity));
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _RoomPainter old) => true;
}
