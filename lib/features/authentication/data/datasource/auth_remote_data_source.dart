import 'package:flutter_project/shared/data/remote/remote.dart';
import 'package:flutter_project/shared/domain/models/either.dart';
import 'package:flutter_project/shared/domain/models/models.dart';
import 'package:flutter_project/shared/exceptions/http_exception.dart';

abstract class AuthRemoteDataSource {
  Future<Either<AppException, User>> loginUser({required User user});
  Future<Either<AppException, User>> registerUser({required User user});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkService networkService;

  AuthRemoteDataSourceImpl(this.networkService);

  @override
  Future<Either<AppException, User>> loginUser({required User user}) async {
    try {
      final data = {
        "formFields": [
          {
            "id": "email",
            "value": user.username,
          },
          {
            "id": "password",
            "value": user.password,
          }
        ]
      };

      final eitherType = await networkService.post(
        'http://localhost:50000/auth/signin',
        data: data,
      );
      return eitherType.fold(
        (exception) {
          return Left(exception);
        },
        (response) {
          final user = User.fromJson(response.data);
          // update the token for requests
          networkService.updateHeader(
            {'Authorization': user.token},
          );

          return Right(user);
        },
      );
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred',
          statusCode: 1,
          identifier: '${e.toString()}\nLoginUserRemoteDataSource.loginUser',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, User>> registerUser({required User user}) async {
    try {
      final data = {
        "formFields": [
          {
            "id": "email",
            "value": user.username,
          },
          {
            "id": "password",
            "value": user.password,
          }
        ]
      };

      final eitherType = await networkService.post(
        'http://localhost:50000/auth/signup',
        data: data,
      );

      return eitherType.fold((exception) => Left(exception),
          (response) => Right(User.fromJson(response.data)));
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occurred',
          statusCode: 1,
          identifier: '${e.toString()}\nLoginUserRemoteDataSource.registerUser',
        ),
      );
    }
  }
}
