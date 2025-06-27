import 'package:flutter/material.dart';

class Tile {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color txtcolor;

  const Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.txtcolor,
  });
}
