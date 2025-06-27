import 'package:flutter/cupertino.dart';

class FeatureModel {
  final String img;
  final String title;
  final String subtitle;
  final Widget route;
  final String permissionKey;

  FeatureModel({
    required this.img,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.permissionKey,
  });
}
