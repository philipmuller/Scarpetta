import 'package:scarpetta/model/duration.dart';

class RecipeStep {
  final String description;
  final String? type;
  final Duration? duration;

  RecipeStep({required this.description, this.type, this.duration});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      description: json['description'],
      type: json['type'],
      duration: json['duration'] != null ? Duration.fromJson(json['duration']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'description': description,
    };

    if (type != null) {
      json['type'] = type!;
    }

    if (duration != null) {
      json['duration'] = duration!.toJson();
    }

    return json;
  }
}