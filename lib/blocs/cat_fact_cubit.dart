import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../repositories/cat_repository.dart';

part 'cat_fact_cubit.freezed.dart';

@freezed
abstract class CatFactState with _$CatFactState {
  const factory CatFactState.initial() = _Initial;
  const factory CatFactState.loading() = _Loading;
  const factory CatFactState.loaded(String fact) = _Loaded;
  const factory CatFactState.error(String message) = _Error;
}

class CatFactCubit extends Cubit<CatFactState> {
  final CatRepository _repository;

  CatFactCubit(this._repository) : super(const CatFactState.initial());

  Future<void> fetchRandomFact() async {
    // Usamos Future.delayed(Duration.zero) en lugar de microtask para evitar el error
    // "Build scheduled during frame" al emitir estados desde el constructor del BlocProvider.
    await Future.delayed(Duration.zero);
    emit(const CatFactState.loading());
    try {
      final fact = await _repository.getRandomFact();
      emit(CatFactState.loaded(fact));
    } catch (e) {
      emit(CatFactState.error(e.toString()));
    }
  }
}
