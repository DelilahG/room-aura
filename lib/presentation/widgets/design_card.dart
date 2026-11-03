import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:room_aura/core/theme/app_colors.dart';
import 'package:room_aura/core/theme/app_typography.dart';
import 'package:room_aura/data/models/room.dart';

class DesignCard extends StatelessWidget {
  final RoomDesign design;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;

  const DesignCard({
    super.key,
    required this.design,
    this.onTap,
    this.onDelete,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _MiniRoomPreview(design: design)),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            design.name,
                            style: AppTypography.labelLarge.copyWith(
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (design.isDraft)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Draft',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.warning,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        PopupMenuButton<String>(
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onSelected: (value) {
                            if (value == 'delete') onDelete?.call();
                            if (value == 'duplicate') onDuplicate?.call();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'duplicate',
                              child: Text('Duplicate'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '${design.roomType}  ${design.width.toStringAsFixed(1)} × ${design.length.toStringAsFixed(1)} m',
                      style: AppTypography.caption,
                    ),
                    const Spacer(),
                    Text(
                      DateFormat.yMMMd().format(design.updatedAt),
                      style: AppTypography.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniRoomPreview extends StatelessWidget {
  final RoomDesign design;

  const _MiniRoomPreview({required this.design});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(design.floorColor),
      child: CustomPaint(
        painter: _MiniRoomPainter(design: design),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _MiniRoomPainter extends CustomPainter {
  final RoomDesign design;

  _MiniRoomPainter({required this.design});

  @override
  void paint(Canvas canvas, Size size) {
    final wallPaint = Paint()
      ..color = Color(design.wallColor).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final inset = 12.0;
    final roomRect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    canvas.drawRect(roomRect, wallPaint);

    if (design.furniture.isEmpty) return;

    final scaleX = roomRect.width / design.width;
    final scaleY = roomRect.height / design.length;

    for (final f in design.furniture) {
      final paint = Paint()
        ..color = Color(f.color).withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      final fx = roomRect.left + f.x * scaleX;
      final fy = roomRect.top + f.y * scaleY;
      final fw = f.width * scaleX;
      final fd = f.depth * scaleY;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            fx,
            fy,
            fw.clamp(4, roomRect.width),
            fd.clamp(4, roomRect.height),
          ),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniRoomPainter old) => true;
}
