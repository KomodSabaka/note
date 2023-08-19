import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/common/const/app_colors.dart';

import '../../common/enums/progress_enum.dart';
import '../../model/note.dart';
import '../bloc/note_bloc.dart';
import '../widgets/note_widget.dart';

class DoneNotePage extends StatefulWidget {
  final PageController pageController;
  final bool isDragging;
  final VoidCallback disableDragging;
  final VoidCallback enableDragging;

  const DoneNotePage({
    super.key,
    required this.pageController,
    required this.isDragging,
    required this.disableDragging,
    required this.enableDragging,
  });

  @override
  State<DoneNotePage> createState() => _DoneNotePageState();
}

class _DoneNotePageState extends State<DoneNotePage>{

  void _addNote(Note note) {
    context
        .read<NoteBloc>()
        .add(ChangeProgressEvent(note: note, progress: ProgressEnum.done));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.donePageBG,
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      SizedBox(
                        height: size.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Done',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            runSpacing: 10,
                            spacing: 5,
                            children: List.generate(
                              state.done.length,
                              (index) {
                                final note =
                                    NoteWidget(note: state.done[index]);
                                return LongPressDraggable(
                                  data: state.done[index],
                                  onDragStarted: widget.enableDragging,
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
                        ),
                      ),
                    ],
                  ),
                ),
                DragTarget<Note>(
                  onAccept: (note) {
                    _addNote(note);
                    widget.disableDragging();
                  },
                  builder: (context, accepted, rejected) {
                    return SizedBox(
                      height: size.height,
                      width: size.width,
                    );
                  },
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: DragTarget(
                    onAccept: (value) {},
                    onMove: (value) {
                      widget.pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    builder: (context, accepted, rejected) {
                      return SizedBox(
                        height: size.height,
                        width: widget.isDragging ? 60 : 0,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
