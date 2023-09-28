final product = Product(
  name: name,
  description: description,
  isAvailable: isAvailable,
);
// Add 'product' to Hive
Hive.box<Product>("products").add(product);
// Close the dialog
Navigator.of(context).pop();
},
onClose: () {
// Close the dialog
Navigator.of(context).pop();
},