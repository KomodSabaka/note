import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/common/const/app_colors.dart';
import 'package:note/common/enums/priority_enum.dart';
import '../../model/note.dart';
import '../bloc/note_bloc.dart';

class NoteWidget extends StatefulWidget {
  final Note note;

  const NoteWidget({
    super.key,
    required this.note,
  });

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  late final TextEditingController _controller;
  bool _isSelected = false;

  void _saveContent() {
    context.read<NoteBloc>().add(
          ChangeContentEvent(
            note: widget.note,
            content: _controller.value.text,
          ),
        );
  }

  Color _getColor() {
    switch (widget.note.priority) {
      case PriorityEnum.high:
        return AppColors.highPriorityNotes;
      case PriorityEnum.medium:
        return AppColors.mediumPriorityNotes;
      case PriorityEnum.low:
        return AppColors.lowPriorityNotes;
    }
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.note.content);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: InkWell(
        onTap: () {
          print(context.read<NoteBloc>().state.template.indexOf(widget.note));
          setState(() => _isSelected = true);
        },
        onDoubleTap: _isSelected == false
            ? null
            : () {
                _saveContent();
                setState(() => _isSelected = false);
              },
        child: AnimatedContainer(
          height: _isSelected ? size.height * 0.3 : size.height * 0.15,
          width: _isSelected ? size.width : size.width * 0.3,
          color: _getColor(),
          duration: const Duration(milliseconds: 400),
          child: _isSelected
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      autofocus: true,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.note.content,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 6),
                    overflow: TextOverflow.clip,
                  ),
                ),
        ),
      ),
    );
  }
}
