enum ToolCategory {
  convert('Convert'),
  structure('Structure'),
  edit('Edit & optimize'),
  security('Security'),
  inspect('Inspect');

  const ToolCategory(this.label);

  final String label;
}
