class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? selectedColor;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
    this.selectedColor,
  });

  double get subtotal => price * quantity;

  CartItem copyWith({int? quantity, String? selectedColor}) => CartItem(
    productId: productId,
    productName: productName,
    price: price,
    quantity: quantity ?? this.quantity,
    selectedColor: selectedColor ?? this.selectedColor,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'price': price,
    'quantity': quantity,
    'selectedColor': selectedColor,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'] as String,
    productName: json['productName'] as String,
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'] as int? ?? 1,
    selectedColor: json['selectedColor'] as String?,
  );
}
