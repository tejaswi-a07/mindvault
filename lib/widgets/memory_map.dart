import 'package:flutter/material.dart';
import '../models/connection.dart';
import '../theme/app_theme.dart';

class MemoryMapPainter extends CustomPainter {
  final List<MemoryNode> nodes;
  final List<MemoryEdge> edges;
  final MemoryNode? selectedNode;
  final bool isDark;

  MemoryMapPainter({
    required this.nodes,
    required this.edges,
    required this.selectedNode,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final defaultLinePaint = Paint()
      ..color = isDark ? const Color(0xFF2E3148) : const Color(0xFFD6DBEA)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final activeLinePaint = Paint()
      ..color = AppTheme.primaryViolet.withOpacity(0.8)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final nodeMap = {for (var n in nodes) n.id: n};

    for (final edge in edges) {
      final from = nodeMap[edge.fromId];
      final to = nodeMap[edge.toId];

      if (from == null || to == null) continue;

      final p1 = Offset(from.x * size.width, from.y * size.height);
      final p2 = Offset(to.x * size.width, to.y * size.height);

      final isEdgeActive = selectedNode != null &&
          (selectedNode!.id == from.id || selectedNode!.id == to.id);

      // Draw smooth subtle curved line
      final path = Path();
      path.moveTo(p1.dx, p1.dy);

      final midX = (p1.dx + p2.dx) / 2;
      final midY = (p1.dy + p2.dy) / 2;
      final controlPoint = Offset(midX, midY - 15);

      path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p2.dx, p2.dy);

      canvas.drawPath(path, isEdgeActive ? activeLinePaint : defaultLinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MemoryMapPainter oldDelegate) {
    return oldDelegate.selectedNode != selectedNode ||
        oldDelegate.isDark != isDark ||
        oldDelegate.nodes != nodes ||
        oldDelegate.edges != edges;
  }
}

class MemoryMapWidget extends StatelessWidget {
  final List<MemoryNode> nodes;
  final List<MemoryEdge> edges;
  final MemoryNode? selectedNode;
  final ValueChanged<MemoryNode> onNodeSelected;

  const MemoryMapWidget({
    super.key,
    required this.nodes,
    required this.edges,
    required this.selectedNode,
    required this.onNodeSelected,
  });

  IconData _getIconForNode(String iconName) {
    switch (iconName) {
      case 'flutter':
        return Icons.flutter_dash_rounded;
      case 'palette':
        return Icons.palette_outlined;
      case 'database':
        return Icons.cloud_outlined;
      case 'motion':
        return Icons.animation_rounded;
      case 'lock':
        return Icons.security_rounded;
      case 'folder':
        return Icons.folder_open_rounded;
      case 'sparkles':
        return Icons.auto_awesome_rounded;
      case 'briefcase':
        return Icons.business_center_outlined;
      case 'server':
        return Icons.storage_rounded;
      case 'map':
        return Icons.explore_outlined;
      default:
        return Icons.bubble_chart_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            // Background Graph Lines
            CustomPaint(
              size: Size(w, h),
              painter: MemoryMapPainter(
                nodes: nodes,
                edges: edges,
                selectedNode: selectedNode,
                isDark: isDark,
              ),
            ),
            // Tappable Node Badges
            ...nodes.map((node) {
              final isSelected = selectedNode?.id == node.id;
              final catColor = AppTheme.getCategoryColor(node.category);
              final left = (node.x * w) - 45;
              final top = (node.y * h) - 26;

              return Positioned(
                left: left.clamp(8.0, w - 100),
                top: top.clamp(8.0, h - 60),
                child: GestureDetector(
                  onTap: () => onNodeSelected(node),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    transform: isSelected
                        ? Matrix4.diagonal3Values(1.12, 1.12, 1.0)
                        : Matrix4.identity(),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryViolet
                          : (isDark ? const Color(0xFF1E202E) : Colors.white),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white
                            : catColor.withOpacity(0.5),
                        width: isSelected ? 2 : 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppTheme.primaryViolet.withOpacity(0.4)
                              : Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                          blurRadius: isSelected ? 16 : 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconForNode(node.iconName),
                          size: 16,
                          color: isSelected ? Colors.white : catColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          node.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white : const Color(0xFF1E293B)),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.25)
                                : (isDark ? Colors.black38 : const Color(0xFFF1F3F9)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${node.count}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : const Color(0xFF64748B)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
