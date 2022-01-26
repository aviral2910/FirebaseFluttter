class Product {
  final String productname, description, prodImage, price;
  Product(
      {required this.productname,
      required this.description,
      required this.prodImage,
      required this.price});

  Product.fromJson(Map<String, Object?> json)
      : this(
            productname: json["productname"]! as String,
            description: json['description']! as String,
            prodImage: json['prodImage'] as String,
            price: json['price']! as String);

  Map<String, Object?> toJson() => {
        'productname': productname,
        'description': description,
        'prodImage': prodImage,
        'price': price
      };
}
