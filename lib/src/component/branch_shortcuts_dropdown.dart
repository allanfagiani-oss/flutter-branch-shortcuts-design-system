import 'package:flutter/material.dart';

import '../model/branch_shortcut.dart';
import '../theme/shortcut_tokens.dart';

class BranchShortcutsDropdown extends StatelessWidget {
  const BranchShortcutsDropdown({
    required this.variant,
    required this.branches,
    required this.onBranchAction,
    required this.onBulkAction,
    this.selectedBranchIds = const {},
    this.enabled = true,
    super.key,
  });

  final BranchShortcutVariant variant;
  final List<BranchShortcut> branches;
  final Set<String> selectedBranchIds;
  final BranchActionCallback onBranchAction;
  final ValueChanged<BranchAction> onBulkAction;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = ShortcutTokens.of(context);
    final textTheme = Theme.of(context).textTheme;
    final allBranchesSelected = branches.isNotEmpty &&
        branches.every((branch) => selectedBranchIds.contains(branch.id));
    final hasSelectedBranches =
        branches.any((branch) => selectedBranchIds.contains(branch.id));
    final canPerformBulkAction = enabled &&
        branches.isNotEmpty &&
        switch (variant.action) {
          BranchAction.add => !allBranchesSelected,
          BranchAction.remove => hasSelectedBranches,
        };

    return Semantics(
      explicitChildNodes: true,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: tokens.surface,
          border: Border.all(color: tokens.border),
          borderRadius: BorderRadius.circular(tokens.cornerRadius),
          boxShadow: ShortcutTokens.cardShadows,
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.spaceLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spaceLarge),
                child: Text(
                  variant.title,
                  style: textTheme.titleSmall?.copyWith(
                    color: tokens.bodyText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: tokens.spaceLarge),
              Divider(height: 1, color: tokens.border),
              if (branches.isEmpty)
                Padding(
                  padding: EdgeInsets.all(tokens.spaceLarge),
                  child: Text(
                    'Nenhuma filial disponível.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: tokens.bodyText,
                    ),
                  ),
                )
              else
                ...branches.map(
                  (branch) => _BranchShortcutRow(
                    branch: branch,
                    selected: selectedBranchIds.contains(branch.id),
                    variant: variant,
                    canPerformAction: enabled &&
                        switch (variant.action) {
                          BranchAction.add =>
                            !selectedBranchIds.contains(branch.id),
                          BranchAction.remove =>
                            selectedBranchIds.contains(branch.id),
                        },
                    onPressed: () => onBranchAction(branch, variant.action),
                  ),
                ),
              Divider(height: 1, color: tokens.border),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  tokens.spaceLarge,
                  tokens.spaceMedium,
                  tokens.spaceLarge,
                  0,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    key: const ValueKey('bulk-action'),
                    onPressed: canPerformBulkAction
                        ? () => onBulkAction(variant.action)
                        : null,
                    child: Text(variant.bulkActionLabel),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchShortcutRow extends StatelessWidget {
  const _BranchShortcutRow({
    required this.branch,
    required this.selected,
    required this.variant,
    required this.canPerformAction,
    required this.onPressed,
  });

  final BranchShortcut branch;
  final bool selected;
  final BranchShortcutVariant variant;
  final bool canPerformAction;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = ShortcutTokens.of(context);
    final textTheme = Theme.of(context).textTheme;
    final branchDescription =
        '${branch.name}, ${branch.customerCount} clientes';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spaceLarge,
        vertical: tokens.spaceMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: branchDescription,
              selected: selected,
              child: ExcludeSemantics(
                child: Text(
                  branchDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: tokens.bodyText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: tokens.spaceMedium),
          FilledButton(
            key: ValueKey('branch-action-${branch.id}'),
            onPressed: canPerformAction ? onPressed : null,
            child: Text(
              variant.actionLabel,
              semanticsLabel: '${variant.actionLabel} filial ${branch.name}',
            ),
          ),
        ],
      ),
    );
  }
}
