import 'package:flutter_project/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_project/features/profile/presentation/providers/state/profile_state.dart';
import 'package:flutter_project/shared/domain/models/either.dart';
import 'package:flutter_project/shared/domain/models/paginated_response.dart';
import 'package:flutter_project/shared/domain/models/product/product_model.dart';
import 'package:flutter_project/shared/exceptions/http_exception.dart';
import 'package:flutter_project/shared/globals.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileNotifier(
    this.profileRepository,
  ) : super(const ProfileState.initial());

  bool get isFetching =>
      state.state != ProfileConcreteState.loading &&
      state.state != ProfileConcreteState.fetchingMore;

  Future<void> fetchProducts() async {
    if (isFetching && state.state != ProfileConcreteState.fetchedAllProducts) {
      state = state.copyWith(
        state: state.page > 0
            ? ProfileConcreteState.fetchingMore
            : ProfileConcreteState.loading,
        isLoading: true,
      );

      final response = await profileRepository.fetchProducts(
          skip: state.page * PRODUCTS_PER_PAGE);

      updateStateFromResponse(response);
    } else {
      state = state.copyWith(
        state: ProfileConcreteState.fetchedAllProducts,
        message: 'No more products available',
        isLoading: false,
      );
    }
  }

  Future<void> searchProducts(String query) async {
    if (isFetching && state.state != ProfileConcreteState.fetchedAllProducts) {
      state = state.copyWith(
        state: state.page > 0
            ? ProfileConcreteState.fetchingMore
            : ProfileConcreteState.loading,
        isLoading: true,
      );

      final response = await profileRepository.searchProducts(
        skip: state.page * PRODUCTS_PER_PAGE,
        query: query,
      );

      updateStateFromResponse(response);
    } else {
      state = state.copyWith(
        state: ProfileConcreteState.fetchedAllProducts,
        message: 'No more products available',
        isLoading: false,
      );
    }
  }

  void updateStateFromResponse(
      Either<AppException, PaginatedResponse<dynamic>> response) {
    response.fold((failure) {
      state = state.copyWith(
        state: ProfileConcreteState.failure,
        message: failure.message,
        isLoading: false,
      );
    }, (data) {
      final productList = data.data.map((e) => Product.fromJson(e)).toList();

      final totalProducts = [...state.productList, ...productList];

      state = state.copyWith(
        productList: totalProducts,
        state: totalProducts.length == data.total
            ? ProfileConcreteState.fetchedAllProducts
            : ProfileConcreteState.loaded,
        hasData: true,
        message: totalProducts.isEmpty ? 'No products found' : '',
        page: totalProducts.length ~/ PRODUCTS_PER_PAGE,
        total: data.total,
        isLoading: false,
      );
    });
  }

  void resetState() {
    state = const ProfileState.initial();
  }
}
