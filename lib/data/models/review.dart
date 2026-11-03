class ProductReview {
  final String id;
  final String productId;
  final String authorName;
  final double rating;
  final String comment;
  final DateTime date;
  final bool isSeeded;

  const ProductReview({
    required this.id,
    required this.productId,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.date,
    this.isSeeded = true,
  });
}
