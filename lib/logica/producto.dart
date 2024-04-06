class Product {
  final String id;
  final String product;
  final int quantity;
  final String description;
  final double price;
  final String category;
  final String user;
  final String productImage; // Add profuctImage attribute

  Product({
    required this.id,
    required this.product,
    required this.quantity,
    required this.description,
    required this.price,
    required this.category,
    required this.user,
    required this.productImage, // Include profuctImage in the constructor
  });

  Product.defaultConstructor()
      : id = 'ecosecha',
        product = 'none',
        quantity = 0,
        description = 'none',
        price = 0.0,
        category = 'none',
        user = 'none',
        productImage = 'https://firebasestorage.googleapis.com/v0/b/ecosecha-b539c.appspot.com/o/loading.gif?alt=media&token=46c14757-6666-4ddf-a886-b95e183ac967'; // Set a default value for profuctImage

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      product: json['product'],
      quantity: json['quantity'],
      description: json['description'],
      price: json['price'],
      category: json['category'],
      user: json['user'],
      productImage: json['productImage'], // Retrieve profuctImage from the JSON
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product,
        'quantity': quantity,
        'description': description,
        'price': price,
        'category': category,
        'user': user,
        'productImage': productImage, // Include profuctImage in the JSON
      };
}
