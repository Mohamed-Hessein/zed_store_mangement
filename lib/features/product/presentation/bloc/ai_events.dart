import 'package:zed_store_mangent/features/home/data/model/order_model.dart';

import '../../data/model/product_model.dart' show Results;

abstract class AiAssistantEvent {}
class AskAiEvent extends AiAssistantEvent {
  final String userPrompt;
  final List<Results> products;
  final List<OrderModel> orders; 
  final Map<String, dynamic>? analytics; 

  AskAiEvent(this.userPrompt, this.products, {this.orders = const [], this.analytics});
}
