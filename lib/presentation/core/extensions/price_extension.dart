extension PriceExtension on double {
  /// Formats a price with thousand separators
  /// Example: 125000.0 -> "125,000"
  String toFormattedPrice() {
    final priceInt = toInt();
    final priceString = priceInt.toString();
    final result = StringBuffer();
    
    for (int i = 0; i < priceString.length; i++) {
      if ((priceString.length - i) % 3 == 0 && i != 0) {
        result.write(',');
      }
      result.write(priceString[i]);
    }
    
    return result.toString();
  }
  
  /// Formats a price with currency prefix and thousand separators
  /// Example: 125000.0 -> "Rp 125,000"
  String toFormattedPriceWithCurrency() {
    return 'Rp ${toFormattedPrice()}';
  }
}