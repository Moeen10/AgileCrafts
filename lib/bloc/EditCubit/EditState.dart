import 'package:task/models/product_model.dart';

abstract class EditState {}

class DoEditState extends EditState {
  final Product singleProduct;
  DoEditState(this.singleProduct);
}

class OfflineDoEditState extends EditState {
  final Product singleProduct;
  OfflineDoEditState(this.singleProduct);
}

class NoEditState extends EditState {}
class ErrorEditState extends EditState {
  final String error;
  ErrorEditState(this.error);
}
class DoneEditState extends EditState {}
class DoneOfflineEditState extends EditState {}

