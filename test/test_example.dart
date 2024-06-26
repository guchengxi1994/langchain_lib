import 'package:langchain/langchain.dart';
import 'package:langchain_lib/client/load_env.dart';
import 'package:langchain_lib/models/llm_models.dart';
import 'package:langchain_openai/langchain_openai.dart';

void main() async {
  LlmModels? envs = loadEnv(r"D:\github_repo\all_in_one\env.json");
  if (envs == null) {
    return;
  }
  final first = envs.find(tag: "text-model");
  final llm = ChatOpenAI(
      apiKey: first!.llmSk,
      baseUrl: first.llmBase,
      defaultOptions: ChatOpenAIOptions(model: first.llmModelName));

// This is an LLMChain to write a synopsis given a title of a play
  const synopsisTemplate = '''
You are a playwright. Given the title of play, it is your job to write a synopsis for that title.

Title: {title}
Playwright: This is a synopsis for the above play:''';
  final synopsisPromptTemplate = PromptTemplate.fromTemplate(synopsisTemplate);
  final synopsisChain =
      LLMChain(llm: llm, prompt: synopsisPromptTemplate, outputKey: "synopsis");

// This is an LLMChain to write a review of a play given a synopsis
  const reviewTemplate = '''
You are a play critic from the New York Times. Given the synopsis of play, it is your job to write a review for that play.

Play Synopsis:
{synopsis}
Review from a New York Times play critic of the above play:''';
  final reviewPromptTemplate = PromptTemplate.fromTemplate(reviewTemplate);
  final reviewChain =
      LLMChain(llm: llm, prompt: reviewPromptTemplate, outputKey: "review");

// This is the overall chain where we run these two chains in sequence
  final overallChain = SimpleSequentialChain(
      chains: [synopsisChain, reviewChain], inputKey: "title");
  final review =
      await overallChain.invoke({"title": 'Tragedy at sunset on the beach'});
  print(review);
}
