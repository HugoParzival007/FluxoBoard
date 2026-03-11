/// Entidade de categoria conforme documentação (seção 16.3)
class Category {
  final String id;
  final String userId;
  final String name;
  final String type; // 'income' | 'expense'
  final String? icon;
  final String? color;
  final String? parentCategoryId;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.icon,
    this.color,
    this.parentCategoryId,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });
}
