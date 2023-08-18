import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:note/common/enums/priority_enum.dart';
import 'package:note/common/enums/progress_enum.dart';

import '../../../model/note.dart';

part 'note_event.dart';

part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> with HydratedMixin {
  NoteBloc() : super(const NoteState()) {
    on<AddTemplateEvent>(_addTemplateEvent);
    on<CreateTemplatesEvent>(_createTemplatesEvent);
    on<ChangeContentEvent>(_changeContentEvent);
    on<ChangeProgressEvent>(_changeProgressEvent);
    on<ReorderEvent>(_reorderEvent);
  }

  void _addTemplateEvent(
    AddTemplateEvent event,
    Emitter<NoteState> emitter,
  ) {
    var countTemplate = state.template
        .where((element) => element.priority == event.priority)
        .length;

    if (countTemplate >= 6) return;

    emitter(NoteState(
      template: List.from(state.template)
        ..add(Note(
            content: '',
            priority: event.priority,
            progress: ProgressEnum.notStarted)),
      inProgress: List.from(state.inProgress),
      done: List.from(state.done),
    ));
  }

  void _createTemplatesEvent(
    CreateTemplatesEvent event,
    Emitter<NoteState> emitter,
  ) {
    List<Note> template = [];
    List<Note> highPriorityTemplates = List.generate(
      6,
      (index) => const Note(
        content: '',
        priority: PriorityEnum.high,
        progress: ProgressEnum.notStarted,
      ),
    );

    List<Note> mediumPriorityTemplates = List.generate(
      6,
      (index) => const Note(
        content: '',
        priority: PriorityEnum.medium,
        progress: ProgressEnum.notStarted,
      ),
    );

    List<Note> lowPriorityTemplates = List.generate(
      6,
      (index) => const Note(
        content: '',
        priority: PriorityEnum.low,
        progress: ProgressEnum.notStarted,
      ),
    );

    template
      ..addAll(highPriorityTemplates)
      ..addAll(mediumPriorityTemplates)
      ..addAll(lowPriorityTemplates);

    emitter(NoteState(
      template: template,
      inProgress: List.from(state.inProgress),
      done: List.from(state.done),
    ));
  }

  void _changeContentEvent(
      ChangeContentEvent event, Emitter<NoteState> emitter) {
    final note = event.note;
    final content = event.content;

    List<Note> template = List.from(state.template);
    List<Note> inProgress = List.from(state.inProgress);
    List<Note> done = List.from(state.done);

    switch (note.progress) {
      case ProgressEnum.notStarted:
        final index = template.indexOf(note);
        template
          ..remove(note)
          ..insert(index, note.copyWith(content: content));
        break;
      case ProgressEnum.inProgress:
        final index = inProgress.indexOf(note);
        inProgress
          ..remove(note)
          ..insert(index, note.copyWith(content: content));
        break;
      case ProgressEnum.done:
        final index = done.indexOf(note);
        done
          ..remove(note)
          ..insert(index, note.copyWith(content: content));
        break;
    }

    emitter(
      NoteState(
        template: template,
        inProgress: inProgress,
        done: done,
      ),
    );
  }

  void _changeProgressEvent(
      ChangeProgressEvent event, Emitter<NoteState> emitter) {
    final note = event.note;
    final progress = event.progress;

    List<Note> template = List.from(state.template);
    List<Note> inProgress = List.from(state.inProgress);
    List<Note> done = List.from(state.done);

    switch (note.progress) {
      case ProgressEnum.notStarted:
        template.remove(note);
        break;
      case ProgressEnum.inProgress:
        inProgress.remove(note);
        break;
      case ProgressEnum.done:
        done.remove(note);
        break;
    }

    switch (progress) {
      case ProgressEnum.notStarted:
        template.add(note.copyWith(progress: ProgressEnum.notStarted));
        break;
      case ProgressEnum.inProgress:
        inProgress.add(note.copyWith(progress: ProgressEnum.inProgress));
        break;
      case ProgressEnum.done:
        done.add(note.copyWith(progress: ProgressEnum.done));
        break;
    }

    emitter(
      NoteState(
        template: template,
        inProgress: inProgress,
        done: done,
      ),
    );
  }

  void _reorderEvent(
    ReorderEvent event,
    Emitter<NoteState> emitter,
  ) {
    final progress = event.progress;
    final oldIndex = event.oldIndex;
    final newIndex = event.newIndex;

    List<Note> template = List.from(state.template);
    List<Note> inProgress = List.from(state.inProgress);
    List<Note> done = List.from(state.done);

    switch (progress) {
      case ProgressEnum.notStarted:
        final note = template.elementAt(oldIndex);
        template.removeAt(oldIndex);
        template.insert(newIndex, note);
        break;
      case ProgressEnum.inProgress:
        final note = inProgress.elementAt(oldIndex);
        inProgress.removeAt(oldIndex);
        inProgress.insert(newIndex, note);
        break;
      case ProgressEnum.done:
        final note = done.elementAt(oldIndex);
        done.removeAt(oldIndex);
        done.insert(newIndex, note);
        break;
    }

    emitter(NoteState(
      template: template,
      inProgress: inProgress,
      done: done,
    ));
  }

  @override
  NoteState? fromJson(Map<String, dynamic> json) {
    return NoteState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(NoteState state) {
    return state.toMap();
  }
}
