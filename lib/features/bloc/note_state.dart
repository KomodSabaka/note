part of 'note_bloc.dart';

class NoteState extends Equatable {
  final List<Note> template;
  final List<Note> inProgress;
  final List<Note> done;

  const NoteState({
    this.template = const [],
    this.inProgress = const [],
    this.done = const [],
  });

  @override
  List<Object?> get props => [
        template,
        inProgress,
        done,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'template': template.map((x) => x.toMap()).toList(),
      'inProgress': inProgress.map((x) => x.toMap()).toList(),
      'done': done.map((x) => x.toMap()).toList(),
    };
  }

  factory NoteState.fromMap(Map<String, dynamic> map) {
    return NoteState(
      template:
          List<Note>.from((map['template'] as List).map((x) => Note.fromMap(x)))
              .toList(),
      inProgress: List<Note>.from(
          (map['inProgress'] as List).map((x) => Note.fromMap(x))).toList(),
      done:
          List<Note>.from((map['done'] as List).map((x) => Note.fromMap(x)))
              .toList(),
    );
  }
}
