import 'dart:convert' as convert;
import 'package:mobile_app_cognitive_rehabilitation/app/models/core/result.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/models/exceptions/response.dart';

class Effect {
  final String? title;
  final String? description;

  Effect({required this.title, required this.description});

  static Result<Effect> fromJson({required Map<String, dynamic> data}) {
    try {
      final effect =
          Effect(title: data["title"], description: data["description"]);

      return Result.ok(effect);
    } catch (e) {
      print("[Stat] fromJson error: " + "${e.toString()}");
      return Result.fail(FailToParseResponseError(error: e.toString()));
    }
  }

  static Map<String, dynamic> toMap(Effect effect) => {
        'title': effect.title,
        'description': effect.description,
      };

  static String encode(List<Result<Effect>>? effects) => convert.json.encode(
        effects!
            .map<Map<String, dynamic>>((effect) => Effect.toMap(effect.data!))
            .toList(),
      );

  static List<Result<Effect>>? decode(String effects) =>
      (convert.json.decode(effects) as List<dynamic>)
          .map<Result<Effect>>((item) => Effect.fromJson(data: item))
          .toList();
}
