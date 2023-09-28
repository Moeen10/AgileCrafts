class Product {
  int? tenantId;
  String? name;
  String? description;
  bool? isAvailable;
  int? id;

  Product(
      {this.tenantId, this.name, this.description, this.isAvailable, this.id});

  Product.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenantId'];
    name = json['name'];
    description = json['description'];
    isAvailable = json['isAvailable'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenantId'] = this.tenantId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isAvailable'] = this.isAvailable;
    data['id'] = this.id;
    return data;
  }
}