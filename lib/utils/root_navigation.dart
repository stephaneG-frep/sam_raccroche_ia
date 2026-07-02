import 'package:flutter/material.dart';

final rootScaffoldKey = GlobalKey<ScaffoldState>();

void openRootDrawer() {
  rootScaffoldKey.currentState?.openDrawer();
}
