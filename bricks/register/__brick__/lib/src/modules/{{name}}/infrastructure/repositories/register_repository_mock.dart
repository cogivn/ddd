import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';


import '../../../../core/domain/errors/api_error.dart';
import '../../../auth/infrastructure/dtos/user_dto.dart';
import '../../domain/repositories/register_repository.dart';
import '../../../../common/utils/app_environment.dart';
import '../../../../core/domain/entities/user.dart';
import '../../domain/models/register_request.dart';

@alpha
@LazySingleton(as: RegisterRepository)
class RegisterRepositoryMock implements RegisterRepository {
  @override
  Future<ResultDart<User, ApiError>> register(
    RegisterRequest request, {
    CancelToken? token,
  }) async {
    // Create a mock MemberAccountDto with the correct properties

    
    // Create a mock UserDto with correct structure
    final userDto = UserDTO();
    
    // Return the UserDto which implements the User interface
    return Success(userDto);
  }

  // @override
  // Future<ResultDart<Supportive, ApiError>> getSupportiveByKey(String key) async {
  //   // Simulate network delay
  //   await Future.delayed(const Duration(milliseconds: 300));
  //
  //   // Return mock data based on the key
  //   return Success(
  //     Supportive(
  //       id: 'MOCK_ID',
  //       key: key,
  //       name: 'Mock Supportive Content',
  //       content: 'This is mock content for key: $key',
  //       contentTc: '這是模擬內容，鍵值：$key',
  //       status: '1',
  //       statusName: 'Active',
  //     ),
  //   );
  // }
}