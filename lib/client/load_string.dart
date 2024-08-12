import 'dart:convert';

import 'package:langchain_lib/models/llm_models.dart';

LlmModels? loadString(String s) {
  return LlmModels.fromJson(jsonDecode(s));
}
