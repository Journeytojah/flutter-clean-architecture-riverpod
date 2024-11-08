import 'package:flutter_project/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:flutter_project/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_project/shared/domain/models/either.dart';
import 'package:flutter_project/shared/domain/models/paginated_response.dart';
import 'package:flutter_project/shared/exceptions/http_exception.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDatasource profileDatasource;
  ProfileRepositoryImpl(this.profileDatasource);

  @override
  Future<Either<AppException, PaginatedResponse>> fetchProducts(
      {required int skip}) {
    return profileDatasource.fetchPaginatedProducts(skip: skip);
  }

  @override
  Future<Either<AppException, PaginatedResponse>> searchProducts(
      {required int skip, required String query}) {
    return profileDatasource.searchPaginatedProducts(skip: skip, query: query);
  }
}
