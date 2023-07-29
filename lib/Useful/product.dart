class Product {
  String name, price, image;

  Product({required this.name, required this.price, required this.image});

  Product.fromMap(Map<String, dynamic> map)
      : this.name = map["name"],
        this.price = map["price"],
        this.image = map["image"];

  Map toMap() {
    return {"name": this.name, "price": this.price, "image": this.image};
  }
}
