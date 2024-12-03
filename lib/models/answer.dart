class Answer {
  final int id;
  final int orderQuestionId;
  final String answer;

  Answer({
    required this.id,
    required this.orderQuestionId,
    required this.answer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      orderQuestionId: json['order_question_id'],
      answer: json['answer'],
    );
  }
}
