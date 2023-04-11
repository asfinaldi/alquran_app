// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alquran_app/cubit/search/search_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/api_service.dart';

class SearchCubit extends Cubit<SearchState> {
  final ApiService apiService;

  SearchCubit(
    this.apiService,
  ) : super(SearchInitial());

  void search(String query) async {
    emit(SearchLoading());
    final result = await apiService.searchSurat(query);

    result.fold(
      (l) => emit(SearchError(message: l)),
      (r) => emit(SearchLoaded(results: r)),
    );
  }
}
