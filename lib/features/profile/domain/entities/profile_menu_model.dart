import 'package:flutter/material.dart';

class Menu {
  String title;
  String subtitle;
  Icon icon;
  GestureTapCallback? onTap;

  Menu(this.title, this.subtitle, this.icon, this.onTap);
}