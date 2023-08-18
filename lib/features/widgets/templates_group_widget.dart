import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/common/enums/priority_enum.dart';
import '../bloc/note_bloc.dart';
import 'note_widget.dart';

class TemplateGroupWidget extends StatelessWidget {
  final String title;
  final PriorityEnum priority;
  final VoidCallback enableDragging;
  final VoidCallback disableDragging;

  const TemplateGroupWidget({
    super.key,
    required this.title,
    required this.priority,
    required this.enableDragging,
    required this.disableDragging,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        var notes = state.template
            .where((element) => element.priority == priority)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => BlocProvider.of<NoteBloc>(context)
                      .add(AddTemplateEvent(priority: priority)),
                  child: Text(
                    'Add',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              runSpacing: 10,
              spacing: 5,
              children: List.generate(
                notes.length,
                (index) {
                  final note = NoteWidget(
                    key: UniqueKey(),
                    note: notes[index],
                  );
                  return LongPressDraggable(
                    data: notes[index],
                    onDragStarted: enableDragging,
                    childWhenDragging: SizedBox(
                      height: size.height * 0.15,
                      width: size.width * 0.3,
                    ),
                    feedback: note,
                    child: note,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
