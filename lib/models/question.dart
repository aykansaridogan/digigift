import 'answer.dart';

class Question {
  final int id;
  final int order;
  final String question;
  final String type;
  final List<Answer>? answers;

  Question({
    required this.id,
    required this.order,
    required this.question,
    required this.type,
    this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    var answersList = json['answers'] as List<dynamic>?;

    return Question(
      id: json['id'],
      order: json['order'],
      question: json['question'],
      type: json['type'],
      answers: answersList?.map((answer) => Answer.fromJson(answer)).toList(),
    );
  }
}
