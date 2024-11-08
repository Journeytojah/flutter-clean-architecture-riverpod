import 'package:flutter_project/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:flutter_project/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_project/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_project/shared/data/remote/network_service.dart';
import 'package:flutter_project/shared/domain/providers/dio_network_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileDatasourceProvider =
    Provider.family<ProfileDatasource, NetworkService>(
  (_, networkService) => ProfileRemoteDatasource(networkService),
);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  final datasource = ref.watch(profileDatasourceProvider(networkService));
  final repository = ProfileRepositoryImpl(datasource);

  return repository;
});
