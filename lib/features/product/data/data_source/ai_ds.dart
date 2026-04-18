import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class AIChatRemoteDataSource {
  final GenerativeModel _model;

  AIChatRemoteDataSource()
      : _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: 'AIzaSyDDiHwmAlc5-XIXLqtQSZv-yhOCpJs6zJ4');

  Future<String> getChatResponse(String prompt) async {
    print("Sending Prompt: $prompt"); 
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? "عذراً، لم أستطع تحليل البيانات.";
  }
}
