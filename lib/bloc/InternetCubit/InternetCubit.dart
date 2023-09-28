import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/InternetCubit/InternetState.dart';



class InternetCubit extends Cubit<InternetState>{
  StreamSubscription? connectCheck ;
  Connectivity _connectConnectivity = Connectivity();
  InternetCubit() : super(DisconnectedState()){
    connectCheck = _connectConnectivity.onConnectivityChanged.listen((result) {
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        emit(ConnectedState());
      }
      else{
        emit(DisconnectedState());
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