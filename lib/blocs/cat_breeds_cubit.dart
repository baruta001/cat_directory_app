import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/cat_breed.dart';
import '../repositories/cat_repository.dart';

part 'cat_breeds_cubit.freezed.dart';

@freezed
abstract class CatBreedsState with _$CatBreedsState {
  const factory CatBreedsState({
    @Default([]) List<CatBreed> breeds,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
    @Default(1) int currentPage,
    String? errorMessage,
  }) = _CatBreedsState;
}

class CatBreedsCubit extends Cubit<CatBreedsState> {
  final CatRepository _repository;
  static const int _limit = 10;
  bool _isFetching = false;

  CatBreedsCubit(this._repository) : super(const CatBreedsState());

  Future<void> fetchBreeds() async {
    if (state.hasReachedMax || state.isLoading || state.isLoadingMore || _isFetching) return;
    
    _isFetching = true;
    
    // Usamos Future.delayed(Duration.zero) para asegurarnos de que el emit ocurra 
    // en el siguiente ciclo del event loop, evitando problemas de "Build scheduled during frame".
    await Future.delayed(Duration.zero);

    emit(state.copyWith(
      isLoading: state.breeds.isEmpty,
      isLoadingMore: state.breeds.isNotEmpty,
      errorMessage: null,
    ));

    try {
      final newBreeds = await _repository.getBreeds(state.currentPage, _limit);
      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        breeds: List.of(state.breeds)..addAll(newBreeds),
        currentPage: state.currentPage + 1,
        hasReachedMax: newBreeds.length < _limit,
        errorMessage: null,
      ));
    } catch (e) {
      String userMessage = 'Error al cargar razas. Intenta de nuevo.';
      if (e.toString().contains('SocketException') || e.toString().contains('No address associated with hostname')) {
        userMessage = 'No tienes acceso a internet.';
      }
      
      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: userMessage,
      ));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> refresh() async {
    // Para el refresco, primero nos aseguramos de no estar ya en medio de una petición.
    if (_isFetching) return;
    
    // Reseteamos el estado a su valor inicial antes de volver a pedir los datos.
    emit(const CatBreedsState());
    await fetchBreeds();
  }
}
