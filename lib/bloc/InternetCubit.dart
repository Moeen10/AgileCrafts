import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum InternetState{ initialState, connect,disconnect}

class InternetCubit extends Cubit<InternetState>{
  StreamSubscription? connectCheck ;
  Connectivity _connectConnectivity = Connectivity();
  InternetCubit() : super(InternetState.initialState){
    connectCheck = _connectConnectivity.onConnectivityChanged.listen((result) {
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        emit(InternetState.connect);
      }
      else{
        emit(InternetState.disconnect);
      }

    });

  }
  @override
  Future<void> close() {
    connectCheck?.cancel();
    // TODO: implement close
    return super.close();
  }

}