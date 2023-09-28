import 'package:hive/hive.dart';
part 'product_model.g.dart';


@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  int? tenantId;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  bool? isAvailable;
  @HiveField(4)
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