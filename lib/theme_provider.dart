import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  Color _backgroundColor = Colors.white;
  Color _noteColor = Colors.yellow;
  Color _textColor = Colors.black;

  Color get backgroundColor => _backgroundColor;
  Color get noteColor => _noteColor;
  Color get textColor => _textColor;

  ThemeProvider() {
    _loadTheme();
  }

  void updateTheme({Color? background, Color? note, Color? text}) {
    if (background != null) _backgroundColor = background;
    if (note != null) _noteColor = note;
    if (text != null) _textColor = text;

    _saveTheme();
    notifyListeners();
  }

  void _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('backgroundColor', _backgroundColor.value);
    prefs.setInt('noteColor', _noteColor.value);
    prefs.setInt('textColor', _textColor.value);
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _backgroundColor = Color(prefs.getInt('backgroundColor') ?? Colors.white.value);
    _noteColor = Color(prefs.getInt('noteColor') ?? Colors.yellow.value);
    _textColor = Color(prefs.getInt('textColor') ?? Colors.black.value);
    notifyListeners();
  }
}
