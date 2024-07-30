class Chat {
  String id;
  PromptType? promptType;
  String? prompt;
  bool generated;
  Chat(
      {required this.id,
      required this.promptType,
      required this.prompt,
      this.generated = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Chat && runtimeType == other.runtimeType && id == other.id;
  
  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}

enum PromptType { gemini, user, loading , error, image}
