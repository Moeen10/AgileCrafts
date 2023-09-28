import 'package:task/models/product_model.dart';

abstract class PostState {}

class LoadingState extends PostState {}

class GetDataState extends PostState {
  final List<Product> posts;
  GetDataState(this.posts);
}

class ErrorMesageState extends PostState {
  final String error;
  ErrorMesageState(this.error);
}

