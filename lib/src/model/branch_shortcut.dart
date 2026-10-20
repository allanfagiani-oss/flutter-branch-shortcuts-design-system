enum BranchShortcutVariant {
  add,
  remove;

  BranchAction get action {
    return switch (this) {
      BranchShortcutVariant.add => BranchAction.add,
      BranchShortcutVariant.remove => BranchAction.remove,
    };
  }

  String get title {
    return switch (this) {
      BranchShortcutVariant.add => 'Adicionar filiais',
      BranchShortcutVariant.remove => 'Remover filiais',
    };
  }

  String get actionLabel {
    return switch (this) {
      BranchShortcutVariant.add => 'Adicionar',
      BranchShortcutVariant.remove => 'Remover',
    };
  }

  String get bulkActionLabel {
    return switch (this) {
      BranchShortcutVariant.add => 'Adicionar todas as filiais',
      BranchShortcutVariant.remove => 'Remover todas as filiais',
    };
  }
}

enum BranchAction { add, remove }

class BranchShortcut {
  const BranchShortcut({
    required this.id,
    required this.name,
    required this.customerCount,
  });

  final String id;
  final String name;
  final int customerCount;
}

typedef BranchActionCallback = void Function(
  BranchShortcut branch,
  BranchAction action,
);
