import 'package:task/bloc/EditCubit/EditState.dart';
import 'package:task/models/post_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit() : super(NoEditState());

  void editPermission(bool ok, Product singleProduct) {
    if (ok) {
      emit(DoEditState(singleProduct));
    } else {
      emit(NoEditState());
    }
  }
}
