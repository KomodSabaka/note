part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();
}

class CreateTemplatesEvent extends NoteEvent {
  @override
  List<Object?> get props => [];
}

class AddTemplateEvent extends NoteEvent {
  final PriorityEnum priority;

  const AddTemplateEvent({
    required this.priority,
  });

  @override
  List<Object?> get props => [priority];
}

class ChangeContentEvent extends NoteEvent {
  final Note note;
  final String content;

  const ChangeContentEvent({
    required this.note,
    required this.content,
  });

  @override
  List<Object?> get props => [
        note,
        content,
      ];
}

class ChangeProgressEvent extends NoteEvent {
  final Note note;
  final ProgressEnum progress;

  const ChangeProgressEvent({
    required this.note,
    required this.progress,
  });

  @override
  List<Object?> get props => [
        note,
        progress,
      ];
}

class ReorderEvent extends NoteEvent {
  final ProgressEnum progress;
  final int oldIndex;
  final int newIndex;

  const ReorderEvent({
    required this.progress,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [
        progress,
        oldIndex,
        newIndex,
      ];
}
