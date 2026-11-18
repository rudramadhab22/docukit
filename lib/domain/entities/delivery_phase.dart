/// Maps features to the agreed 7-phase delivery plan.
enum DeliveryPhase {
  foundation(1, 'Foundation'),
  coreUtilities(2, 'Core PDF utilities'),
  conversions(3, 'Conversions'),
  structure(4, 'PDF structure tools'),
  editOptimize(5, 'Edit & optimize'),
  security(6, 'Security'),
  polish(7, 'Polish & ship');

  const DeliveryPhase(this.number, this.label);

  final int number;
  final String label;
}
