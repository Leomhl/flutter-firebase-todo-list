import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {

  String _title;
  String _description;
  String _date;
  IconData _icon;
  Color _iconColor;
  bool _done;

  Task({
    @required String title,
    @required String description,
    @required String date,
    bool done = false}) {
      this.title = title;
      this.description = description;
      this.done = done;
      this.date = date;
    }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  bool get done => _done;

  set done(bool value) {
    _done = value;

    if (_done == true) {
      this._icon = CupertinoIcons.check_mark_circled_solid;
      this._iconColor = Color(0xff00cf8d);
    } else {
      this._icon = CupertinoIcons.clock_solid;
      this._iconColor = Color(0xffff9e00);
    }
  }

  Color get iconColor => _iconColor;
  IconData get icon => _icon;

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}