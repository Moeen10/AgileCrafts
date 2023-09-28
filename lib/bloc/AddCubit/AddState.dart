abstract class AddState{}

class AddLoadingState extends AddState{}

class DoneAddState extends AddState{}

class CancelAddState extends AddState{}

class ErrorAddState extends AddState{
  final String errorMessage;
  ErrorAddState(this.errorMessage);
}

class AddInitialStateState extends AddState{}

class OpenAddState extends AddState{}


