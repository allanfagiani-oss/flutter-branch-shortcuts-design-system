import 'package:flutter/material.dart';

import 'src/demo/branch_shortcuts_demo.dart';
import 'src/theme/design_system_theme.dart';

void main() {
  runApp(const BranchShortcutsApp());
}

class BranchShortcutsApp extends StatelessWidget {
  const BranchShortcutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atalhos de filiais',
      debugShowCheckedModeBanner: false,
      theme: DesignSystemTheme.light(),
      home: const BranchShortcutsDemo(),
    );
  }
}
