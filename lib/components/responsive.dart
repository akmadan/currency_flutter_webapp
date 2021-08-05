import 'package:flutter/material.dart';

class ResponsiveWidget {
  static bool isLargeScreen(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return MediaQuery.of(context).size.width > 800;
  }
}
