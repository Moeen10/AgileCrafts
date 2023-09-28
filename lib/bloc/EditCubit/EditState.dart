import 'package:task/models/post_model.dart';

abstract class EditState {}

class DoEditState extends EditState {
  final Product singleProduct;
  DoEditState(this.singleProduct);
}

class NoEditState extends EditState {}
class ErrorEditState extends EditState {
  final String error;
  ErrorEditState(this.error);
}
class DoneEditState extends EditState {}

