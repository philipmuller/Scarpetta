import 'package:uuid/uuid.dart';

class Category {
  final String id;
  final String name;
  final String? imageUrl;

  Category({
    String? id,
    required this.name,
    this.imageUrl,
  }) :
    id = id ?? const Uuid().v4();

  factory Category.fromMap({required Map<String, dynamic> map, String? id}) {

    return Category(
      id: id ?? map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap({bool includeId = false}) {
    Map<String, dynamic> map = {
      'name': name,
    };

    if (imageUrl != null) {
      map['imageUrl'] = imageUrl!;
    }

    if (includeId) {
      map['id'] = id;
    }

    return map;
  }
}