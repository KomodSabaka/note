import 'package:flutter/material.dart';
import 'package:note/common/enums/priority_enum.dart';
import 'package:note/features/widgets/templates_group_widget.dart';
import '../../model/note.dart';

class TemplateNotePage extends StatefulWidget {
  final PageController pageController;
  final bool isDragging;
  final VoidCallback disableDragging;
  final VoidCallback enableDragging;

  const TemplateNotePage({
    super.key,
    required this.pageController,
    required this.isDragging,
    required this.disableDragging,
    required this.enableDragging,
  });

  @override
  State<TemplateNotePage> createState() => _TemplateNotePageState();
}

class _TemplateNotePageState extends State<TemplateNotePage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  'Note',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TemplateGroupWidget(
                          title: 'High priority',
                          priority: PriorityEnum.high,
                          enableDragging: widget.enableDragging,
                          disableDragging: widget.disableDragging,
                        ),
                        const SizedBox(height: 12),
                        TemplateGroupWidget(
                          title: 'Medium priority',
                          priority: PriorityEnum.medium,
                          enableDragging: widget.enableDragging,
                          disableDragging: widget.disableDragging,
                        ),
                        const SizedBox(height: 12),
                        TemplateGroupWidget(
                          title: 'Low priority',
                          priority: PriorityEnum.low,
                          enableDragging: widget.enableDragging,
                          disableDragging: widget.disableDragging,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: DragTarget<Note>(
              onMove: (value) {
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
  }
}
