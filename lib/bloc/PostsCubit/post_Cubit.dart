import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/PostsCubit/state_cubit.dart';
import 'package:task/models/post_model.dart';
import 'package:task/repository/getRepository/post_repository.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(LoadingState()) {
    fetchPosts();
  }
  PostRepository postRepository = PostRepository();

  void fetchPosts() async {
    try {
      print("*************");
      emit(LoadingState());
      List<Product> posts = await postRepository.fetchPosts();
      emit(GetDataState(posts));
    } catch (e) {
      emit(ErrorMesageState(e.toString()));
      print("---------  ERROR From post_Cubit--------fetchPosts() functions");
      throw e;
    }
  }
}
