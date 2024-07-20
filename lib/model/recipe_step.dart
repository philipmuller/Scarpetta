import 'package:scarpetta/model/duration.dart';

class RecipeStep {
  final String description;
  final String? type;
  final Duration? duration;

  RecipeStep({required this.description, this.type, this.duration});

  factory RecipeStep.fromMap({required Map<String, dynamic> map}) {
    return RecipeStep(
      description: map['description'],
      type: map['type'],
      duration: map['duration'] != null ? Duration.fromMap(map['duration']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'description': description,
    };

    if (type != null) {
      map['type'] = type!;
    }

    if (duration != null) {
      map['duration'] = duration!.toMap();
    }

    return map;
  }
}