import '../common/enums/priority_enum.dart';
import '../common/enums/progress_enum.dart';

class Note{
  final String content;
  final PriorityEnum priority;
  final ProgressEnum progress;

  const Note({
    required this.content,
    required this.priority,
    required this.progress,
  });

  Note copyWith({
    String? content,
    PriorityEnum? priority,
    ProgressEnum? progress,
  }) {
    return Note(
      content: content ?? this.content,
      priority: priority ?? this.priority,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'priority': priority.type,
      'progress': progress.progress,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      content: map['content'] ?? '',
      priority: (map['priority'] as String).toPriorityEnum(),
      progress: (map['progress'] as String).toProgressEnum(),
    );
  }
}
