import 'dart:io';

import 'package:langchain/langchain.dart';
import 'package:langchain_lib/client/openai_client.dart';
import 'package:langchain_lib/client/load_env.dart';
import 'package:langchain_lib/models/llm_models.dart';

void main() async {
  LlmModels? envs = loadEnv(r"D:\github_repo\all_in_one\env.json");
  if (envs == null) {
    return;
  }

  final first = envs.find(tag: "text-model");

  final client = OpenaiClient(
      baseUrl: first!.llmBase,
      apiKey: first.llmSk,
      modelName: first.llmModelName);

  await client.invoke([
    ChatMessage.system(
        'You are a helpful assistant that translates English to French.'),
    ChatMessage.humanText('I love programming.'),
  ]).then((value) {
    print(value.outputAsString);
  });

  print(
      "=====================================================================");

  await Future.delayed(const Duration(seconds: 3));

  final stream =
      client.stream([ChatMessage.humanText("给我将一个爱因斯坦和椅子的故事，200字以内。")]);

  stream.listen(
    (event) {
      stdout.write(event.outputAsString);
    },
    onDone: () {
      stdout.write("\nThe end.\n");
    },
  );
}
