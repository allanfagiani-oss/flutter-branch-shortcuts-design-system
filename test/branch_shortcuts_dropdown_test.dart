import 'dart:ui' show Tristate;

import 'package:branch_shortcuts_design_system/branch_shortcuts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _branches = [
  BranchShortcut(id: 'sp', name: 'São Paulo', customerCount: 152),
  BranchShortcut(id: 'rio', name: 'Rio de Janeiro', customerCount: 87),
];

Widget _testApp({
  required BranchShortcutVariant variant,
  required BranchActionCallback onBranchAction,
  required ValueChanged<BranchAction> onBulkAction,
  Set<String> selectedBranchIds = const {},
  bool enabled = true,
  double textScaleFactor = 1,
}) {
  return MaterialApp(
    theme: DesignSystemTheme.light(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScaleFactor),
      ),
      child: child!,
    ),
    home: Scaffold(
      body: BranchShortcutsDropdown(
        variant: variant,
        branches: _branches,
        selectedBranchIds: selectedBranchIds,
        onBranchAction: onBranchAction,
        onBulkAction: onBulkAction,
        enabled: enabled,
      ),
    ),
  );
}

void main() {
  group('BranchShortcutsDropdown', () {
    testWidgets('renders branch names and customer counts', (tester) async {
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
        ),
      );

      expect(find.text('São Paulo, 152 clientes'), findsOneWidget);
      expect(find.text('Rio de Janeiro, 87 clientes'), findsOneWidget);
    });

    testWidgets('calls the individual callback with branch and variant action',
        (tester) async {
      BranchShortcut? actedBranch;
      BranchAction? actedAction;
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          onBranchAction: (branch, action) {
            actedBranch = branch;
            actedAction = action;
          },
          onBulkAction: (_) {},
        ),
      );

      await tester.tap(find.byKey(const ValueKey('branch-action-sp')));

      expect(actedBranch?.id, 'sp');
      expect(actedAction, BranchAction.add);
    });

    testWidgets('exposes the remove variant and calls its bulk callback',
        (tester) async {
      BranchAction? actedAction;
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.remove,
          onBranchAction: (_, __) {},
          onBulkAction: (action) => actedAction = action,
          selectedBranchIds: {'sp', 'rio'},
        ),
      );

      expect(find.text('Remover filiais'), findsOneWidget);
      expect(find.text('Remover'), findsNWidgets(2));
      await tester.tap(find.byKey(const ValueKey('bulk-action')));

      expect(actedAction, BranchAction.remove);
    });

    testWidgets('calls the add action for the collective button',
        (tester) async {
      BranchAction? actedAction;
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          onBranchAction: (_, __) {},
          onBulkAction: (action) => actedAction = action,
        ),
      );

      await tester.tap(find.byKey(const ValueKey('bulk-action')));

      expect(actedAction, BranchAction.add);
    });

    testWidgets('updates its labels when the variant changes', (tester) async {
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
        ),
      );
      expect(find.text('Adicionar filiais'), findsOneWidget);

      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.remove,
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
        ),
      );

      expect(find.text('Remover filiais'), findsOneWidget);
      expect(find.text('Remover'), findsNWidgets(2));
    });

    testWidgets('keeps long branch names within a narrow viewport',
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystemTheme.light(),
          home: Scaffold(
            body: BranchShortcutsDropdown(
              variant: BranchShortcutVariant.remove,
              branches: const [
                BranchShortcut(
                  id: 'long',
                  name: 'Uma filial com um nome bastante longo',
                  customerCount: 22,
                ),
              ],
              onBranchAction: (_, __) {},
              onBulkAction: (_) {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('disables individual and bulk actions when disabled',
        (tester) async {
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
          enabled: false,
        ),
      );

      final individualButton = tester.widget<FilledButton>(
        find.byKey(const ValueKey('branch-action-sp')),
      );
      final bulkButton = tester.widget<FilledButton>(
        find.byKey(const ValueKey('bulk-action')),
      );

      expect(individualButton.onPressed, isNull);
      expect(bulkButton.onPressed, isNull);
    });

    testWidgets('does not allow adding an already selected branch',
        (tester) async {
      var callbackCalled = false;
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          selectedBranchIds: {'sp'},
          onBranchAction: (_, __) => callbackCalled = true,
          onBulkAction: (_) {},
        ),
      );

      final button = tester.widget<FilledButton>(
        find.byKey(const ValueKey('branch-action-sp')),
      );
      expect(button.onPressed, isNull);
      await tester.tap(find.byKey(const ValueKey('branch-action-sp')));
      expect(callbackCalled, isFalse);
    });

    testWidgets('does not allow removing a branch that is not selected',
        (tester) async {
      var callbackCalled = false;
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.remove,
          onBranchAction: (_, __) => callbackCalled = true,
          onBulkAction: (_) {},
        ),
      );

      final button = tester.widget<FilledButton>(
        find.byKey(const ValueKey('branch-action-rio')),
      );
      expect(button.onPressed, isNull);
      await tester.tap(find.byKey(const ValueKey('branch-action-rio')));
      expect(callbackCalled, isFalse);
    });

    testWidgets('disables bulk actions when no branches can change',
        (tester) async {
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          selectedBranchIds: {'sp', 'rio'},
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
        ),
      );
      expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('bulk-action')))
            .onPressed,
        isNull,
      );

      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.remove,
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
        ),
      );
      expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('bulk-action')))
            .onPressed,
        isNull,
      );
    });

    testWidgets('preserves enabled and empty-list behavior for bulk actions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystemTheme.light(),
          home: Scaffold(
            body: BranchShortcutsDropdown(
              variant: BranchShortcutVariant.add,
              branches: const [],
              onBranchAction: (_, __) {},
              onBulkAction: (_) {},
            ),
          ),
        ),
      );
      expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('bulk-action')))
            .onPressed,
        isNull,
      );
      expect(find.text('Nenhuma filial disponível.'), findsOneWidget);
    });

    testWidgets('exposes selection and contextual accessible action labels',
        (tester) async {
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.remove,
          selectedBranchIds: {'sp'},
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
        ),
      );

      expect(find.bySemanticsLabel('Remover filial São Paulo'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Remover filial Rio de Janeiro'),
        findsOneWidget,
      );
      final selectedBranch = tester
          .getSemantics(find.bySemanticsLabel('São Paulo, 152 clientes'))
          .getSemanticsData();
      expect(
        selectedBranch.flagsCollection.isSelected,
        Tristate.isTrue,
      );

      final removeButton = tester
          .getSemantics(find.bySemanticsLabel('Remover filial São Paulo'))
          .getSemanticsData();
      expect(removeButton.flagsCollection.isButton, isTrue);
      expect(removeButton.flagsCollection.isEnabled, Tristate.isTrue);
      expect(removeButton.label, 'Remover filial São Paulo');
    });

    testWidgets('supports enlarged text without layout exceptions',
        (tester) async {
      tester.view.physicalSize = const Size(360, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
          textScaleFactor: 2,
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Adicionar filial São Paulo'), findsNothing);
      expect(
          find.bySemanticsLabel('Adicionar filial São Paulo'), findsOneWidget);
    });

    testWidgets('shows a visible focus outline for keyboard focus',
        (tester) async {
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          onBranchAction: (_, __) {},
          onBulkAction: (_) {},
        ),
      );

      final style = FilledButtonTheme.of(
        tester.element(find.byKey(const ValueKey('branch-action-sp'))),
      ).style!;
      final focusOutline = style.side!.resolve({WidgetState.focused})!;
      expect(focusOutline.width, 2);
      expect(focusOutline.color, ShortcutTokens.reference.accent);
    });

    testWidgets('supports keyboard traversal and button activation',
        (tester) async {
      BranchShortcut? actedBranch;
      await tester.pumpWidget(
        _testApp(
          variant: BranchShortcutVariant.add,
          onBranchAction: (branch, _) => actedBranch = branch,
          onBulkAction: (_) {},
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(actedBranch?.id, 'sp');
    });
  });
}
