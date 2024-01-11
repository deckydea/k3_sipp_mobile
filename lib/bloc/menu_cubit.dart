import 'package:flutter_bloc/flutter_bloc.dart';

class MenuCubit extends Cubit<int> {
  MenuCubit() : super(0);

  // Define methods to update the state
  void navigateTo(int index) => emit(index);
}