import 'package:flutter/material.dart';

import '../component/branch_shortcuts_dropdown.dart';
import '../model/branch_shortcut.dart';
import '../theme/shortcut_tokens.dart';

class BranchShortcutsDemo extends StatefulWidget {
  const BranchShortcutsDemo({super.key});

  @override
  State<BranchShortcutsDemo> createState() => _BranchShortcutsDemoState();
}

class _BranchShortcutsDemoState extends State<BranchShortcutsDemo> {
  static const _branches = [
    BranchShortcut(id: 'sp', name: 'São Paulo', customerCount: 152),
    BranchShortcut(id: 'rio', name: 'Rio de Janeiro', customerCount: 87),
    BranchShortcut(id: 'curitiba', name: 'Curitiba', customerCount: 43),
  ];

  final Set<String> _selectedBranchIds = {'sp'};

  void _handleBranchAction(BranchShortcut branch, BranchAction action) {
    setState(() {
      if (action == BranchAction.add) {
        _selectedBranchIds.add(branch.id);
      } else {
        _selectedBranchIds.remove(branch.id);
      }
    });
    _showFeedback(
      action == BranchAction.add
          ? '${branch.name} adicionada.'
          : '${branch.name} removida.',
    );
  }

  void _handleBulkAction(BranchAction action) {
    setState(() {
      if (action == BranchAction.add) {
        _selectedBranchIds.addAll(_branches.map((branch) => branch.id));
      } else {
        _selectedBranchIds.clear();
      }
    });
    _showFeedback(
      action == BranchAction.add
          ? 'Todas as filiais foram adicionadas.'
          : 'Todas as filiais foram removidas.',
    );
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ShortcutTokens.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atalhos de filiais'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: EdgeInsets.all(tokens.spaceLarge),
              children: [
                Text(
                  'Ações rápidas para sua rede',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(height: tokens.spaceSmall),
                Text(
                  'Adicione ou remova filiais e acompanhe a seleção em tempo real.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: tokens.spaceLarge * 1.5),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 620;
                    final cards = [
                      _buildVariantCard(BranchShortcutVariant.add),
                      _buildVariantCard(BranchShortcutVariant.remove),
                    ];

                    if (!isWide) {
                      return Column(
                        children: [
                          cards[0],
                          SizedBox(height: tokens.spaceLarge),
                          cards[1],
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: cards[0]),
                        SizedBox(width: tokens.spaceLarge),
                        Expanded(child: cards[1]),
                      ],
                    );
                  },
                ),
                SizedBox(height: tokens.spaceLarge),
                Text(
                  '${_selectedBranchIds.length} de ${_branches.length} filiais adicionadas',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: tokens.bodyText,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVariantCard(BranchShortcutVariant variant) {
    return BranchShortcutsDropdown(
      variant: variant,
      branches: _branches,
      selectedBranchIds: _selectedBranchIds,
      onBranchAction: _handleBranchAction,
      onBulkAction: _handleBulkAction,
    );
  }
}
