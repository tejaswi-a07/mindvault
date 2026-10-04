class MemoryNode {
  final String id;
  final String label;
  final String category;
  final double x; // normalized 0.0 to 1.0 or canvas coords
  final double y;
  final int count;
  final String iconName;

  MemoryNode({
    required this.id,
    required this.label,
    required this.category,
    required this.x,
    required this.y,
    required this.count,
    required this.iconName,
  });
}

class MemoryEdge {
  final String fromId;
  final String toId;

  MemoryEdge({
    required this.fromId,
    required this.toId,
  });
}
