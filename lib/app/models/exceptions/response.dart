import 'package:mobile_app_cognitive_rehabilitation/app/models/core/base_exception.dart';

class FailToParseResponseError extends BaseException {
  int? code;
  String? error;
  String? message = "Response model has failed while doing parsing execution.";
  String? type = "$FailToParseResponseError";

  FailToParseResponseError({this.error}) : super(true);
}
