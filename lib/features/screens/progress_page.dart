import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/common/enums/progress_enum.dart';
import 'package:reorderables/reorderables.dart';
import '../../common/const/app_colors.dart';
import '../../model/note.dart';
import '../bloc/note_bloc.dart';
import '../widgets/note_widget.dart';

class ProgressPage extends StatefulWidget {
  final PageController pageController;
  final bool isDragging;
  final VoidCallback disableDragging;
  final VoidCallback enableDragging;

  const ProgressPage({
    super.key,
    required this.pageController,
    required this.isDragging,
    required this.disableDragging,
    required this.enableDragging,
  });

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>{
  bool _isReordering = false;

  void _addNote(Note note) {
    context.read<NoteBloc>().add(
        ChangeProgressEvent(note: note, progress: ProgressEnum.inProgress));
  }

  void _setReordering() => setState(() => _isReordering = !_isReordering);

  void _reorder({
    required int oldIndex,
    required int newIndex,
  }) {
    context.read<NoteBloc>().add(ReorderEvent(
          progress: ProgressEnum.inProgress,
          oldIndex: oldIndex,
          newIndex: newIndex,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.progressPageBG,
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              alignment: Alignment.topLeft,
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
                              'In progress',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          _isReordering ? const SizedBox() :  TextButton(
                              onPressed: _setReordering,
                              child: FadeInRight(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  'Reorder',
                                  style:
                                      Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: ReorderableWrap(
                            runSpacing: 10,
                            spacing: 5,
                            children: List.generate(
                              state.inProgress.length,
                              (index) {
                                var note =
                                    NoteWidget(note: state.inProgress[index]);
                                return _isReordering
                                    ? note
                                    : LongPressDraggable(
                                  data: state.inProgress[index],
                                  onDragStarted: widget.enableDragging,
                                  childWhenDragging: SizedBox(
                                    height: size.height * 0.15,
                                    width: size.width * 0.3,
                                  ),
                                  feedback: note,
                                  child: note,
                                );
                              },
                              growable: false,
                            ),
                            onReorder: (oldIndex, newIndex) {
                              _reorder(oldIndex: oldIndex, newIndex: newIndex);
                            },
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
                Align(
                  alignment: Alignment.topRight,
                  child: DragTarget(
                    onLeave: (val) {},
                    onMove: (value){
                      widget.pageController.nextPage(
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
      floatingActionButton: _isReordering
          ? FloatingActionButton(
              onPressed: _setReordering,
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}
