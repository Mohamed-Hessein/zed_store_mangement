import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:zed_store_mangent/features/product/data/model/product_model.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/resources/app_styles.dart';
import '../bloc/ai_bloc.dart';
import '../bloc/ai_events.dart';
import '../bloc/ai_states.dart';

class AiChatWidget extends StatefulWidget {
  final List<Results> products;
  const AiChatWidget({super.key, required this.products});

  @override
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget> {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupTts();
  }


  void _setupTts() async {


    await _flutterTts.setLanguage("ar-SA");
    await _flutterTts.setPitch(0.9);


    await _flutterTts.setSpeechRate(0.4);

    await _flutterTts.setVolume(1.0);


    var voices = await _flutterTts.getVoices;
    for (var voice in voices) {
      if (voice["name"].toString().contains("ar-sa")) {
        await _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
        break;
      }
    }

    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }
  void _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop(); 
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AiAssistantBloc, AiAssistantState>(
      listener: (context, state) {
        if (state is AiSuccess) {
          _speak(state.response); 
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [

            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20.h),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.sparkles, color: AppColors.primaryPurple, size: 24.sp),
                    SizedBox(width: 10.w),
                    Text("AI Store Assistant", style: AppStyles.text16PurpleBold),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
                  onPressed: () => _flutterTts.stop(),
                  tooltip: "إيقاف الصوت",
                )
              ],
            ),
            const Divider(),


            Expanded(
              child: BlocBuilder<AiAssistantBloc, AiAssistantState>(
                builder: (context, state) {
                  if (state is AiLoading) return const Text('جاري العمل .....',style: TextStyle(color: Colors.black),);

                  if (state is AiSuccess) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: SelectionArea(
                        child: Text(
                          state.response,
                          style: TextStyle(fontSize: 15.sp, height: 1.5, color: Colors.black87),
                        ),
                      ),
                    );
                  }

                  if (state is AiError) {
                    return Center(
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return const Center(
                    child: Text("كيف يمكنني مساعدتك في مخزنك اليوم؟"),
                  );
                },
              ),
            ),

            SizedBox(height: 10.h),


            _buildInputSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "اسأل عن منتجاتك...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<AiAssistantBloc>().add(
                    AskAiEvent(value, widget.products),
                  );
                  _textController.clear();
                }
              },
            ),
          ),
          SizedBox(width: 10.w),

          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primaryPurple),
            onPressed: () {
              if (_textController.text.trim().isNotEmpty) {
                context.read<AiAssistantBloc>().add(
                  AskAiEvent(_textController.text, widget.products),
                );
                _textController.clear();
              }
            },
          ),

          _VoiceInputField(products: widget.products),
        ],
      ),
    );
  }
}


class _VoiceInputField extends StatefulWidget {
  final List<Results> products;
  const _VoiceInputField({required this.products});

  @override
  _VoiceInputFieldState createState() => _VoiceInputFieldState();
}

class _VoiceInputFieldState extends State<_VoiceInputField> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            setState(() => _isListening = false);
            context.read<AiAssistantBloc>().add(
              AskAiEvent(result.recognizedWords, widget.products),
            );
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("عذراً، المايك غير متاح حالياً")),
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _startListening,
      onLongPressUp: _stopListening,
      child: FloatingActionButton(
        heroTag: "micBtn", 
        mini: true,
        backgroundColor: _isListening ? Colors.red : AppColors.primaryPurple,
        onPressed: () {
          if (!_isListening) _startListening();
          else _stopListening();
        },
        child: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white),
      ),
    );
  }
}
