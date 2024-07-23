import 'package:scarpetta/model/duration.dart';

class RecipeStep {
  final String description;
  final String? type;
  final Duration? duration;

  RecipeStep({required this.description, this.type, this.duration});

  factory RecipeStep.fromMap({required Map<String, dynamic> map}) {
    print("Starting conversion of RecipeStep from map named ${map['description']}");
    print("${map['description']} of type ${map['description'].runtimeType}");
    print("${map['type']} of type ${map['type'].runtimeType}");
    print("${map['duration']} of type ${map['duration'].runtimeType}");

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