// Enum for the side of the order (Buy/Sell)
enum OrderSide { buy, sell }

// Enum for the product type
enum ProductType { cnc, nrml, intraday }

// A class to represent a single order.
class Order {
  final String id;
  final DateTime time;
  final String client;
  final String ticker;
  final OrderSide side;
  final ProductType product;
  final int quantityExecuted;
  final int quantityTotal;
  final double price;

  Order({
    required this.id,
    required this.time,
    required this.client,
    required this.ticker,
    required this.side,
    required this.product,
    required this.quantityExecuted,
    required this.quantityTotal,
    required this.price,
  });

  // Helper method to get the string representation of OrderSide
  String get sideString =>
      side == OrderSide.buy ? 'Buy' : 'Sell';

  // Helper method to get the string representation of ProductType
  String get productString {
    switch (product) {
      case ProductType.cnc:
        return 'CNC';
      case ProductType.nrml:
        return 'NRML';
      case ProductType.intraday:
        return 'INTRADAY';
    }
  }
}
