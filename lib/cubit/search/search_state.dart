import 'package:alquran_app/data/models/surat_model.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SuratModel> results;

  const SearchLoaded({required this.results});

  @override
  List<Object> get props => [results];
}

class SearchError extends SearchState {
  final String message;
  const SearchError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
