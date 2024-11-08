// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_project/shared/domain/models/product/product_model.dart';

enum ProfileConcreteState {
  initial,
  loading,
  loaded,
  failure,
  fetchingMore,
  fetchedAllProducts
}

class ProfileState extends Equatable {
  final List<Product> productList;
  final int total;
  final int page;
  final bool hasData;
  final ProfileConcreteState state;
  final String message;
  final bool isLoading;
  const ProfileState({
    this.productList = const [],
    this.isLoading = false,
    this.hasData = false,
    this.state = ProfileConcreteState.initial,
    this.message = '',
    this.page = 0,
    this.total = 0,
  });

  const ProfileState.initial({
    this.productList = const [],
    this.total = 0,
    this.page = 0,
    this.isLoading = false,
    this.hasData = false,
    this.state = ProfileConcreteState.initial,
    this.message = '',
  });

  ProfileState copyWith({
    List<Product>? productList,
    int? total,
    int? page,
    bool? hasData,
    ProfileConcreteState? state,
    String? message,
    bool? isLoading,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      productList: productList ?? this.productList,
      total: total ?? this.total,
      page: page ?? this.page,
      hasData: hasData ?? this.hasData,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'ProfileState(isLoading:$isLoading, productLength: ${productList.length},total:$total page: $page, hasData: $hasData, state: $state, message: $message)';
  }

  @override
  List<Object?> get props => [productList, page, hasData, state, message];
}
