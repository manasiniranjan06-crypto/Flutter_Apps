class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isTailor;
  final bool isTyping;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isTailor = false,
    this.isTyping = false,
  });
}

class QuickQuestion {
  final String question;
  final String category;
  final String detailedResponse;

  QuickQuestion({
    required this.question,
    required this.category,
    required this.detailedResponse,
  });
}