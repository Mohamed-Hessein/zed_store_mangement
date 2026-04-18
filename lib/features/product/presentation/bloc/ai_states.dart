abstract class AiAssistantState {}
class AiInitial extends AiAssistantState {}
class AiLoading extends AiAssistantState {}
class AiSuccess extends AiAssistantState { final String response; AiSuccess(this.response); }
class AiError extends AiAssistantState { final String message; AiError(this.message); }
