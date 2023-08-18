import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/common/const/app_colors.dart';
import 'package:note/features/screens/done_page.dart';
import 'package:note/features/screens/templates_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/note_bloc.dart';
import 'progress_page.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late final PageController _pageController;
  bool _isDragging = false;

  void _enableDragging() {
    setState(() => _isDragging = true);
  }

  void _disableDragging() {
    setState(() => _isDragging = false);
  }

  void _checkFirstLaunch() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = preferences.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      context.read<NoteBloc>().add(CreateTemplatesEvent());
      preferences.setBool('isFirstLaunch', false);
    }
  }

  @override
  void initState() {
    _checkFirstLaunch();
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.templatesPageBG,
      body: PageView(
        controller: _pageController,
        children: [
          TemplateNotePage(
            pageController: _pageController,
            isDragging: _isDragging,
            disableDragging: _disableDragging,
            enableDragging: _enableDragging,
          ),
          ProgressPage(
            pageController: _pageController,
            isDragging: _isDragging,
            disableDragging: _disableDragging,
            enableDragging: _enableDragging,
          ),
          DoneNotePage(
            pageController: _pageController,
            isDragging: _isDragging,
            disableDragging: _disableDragging,
            enableDragging: _enableDragging,
          ),
        ],
      ),
    );
  }
}
