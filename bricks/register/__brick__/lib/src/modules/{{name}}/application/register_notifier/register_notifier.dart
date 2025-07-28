import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../common/utils/logger.dart';
import '../../../../core/application/events/auth_event_bus.dart';
import '../../../../core/domain/value_objects/phone_number.dart';
import '../../domain/errors/register_error.dart';
import '../../domain/models/register_request.dart';
import '../../domain/repositories/register_repository.dart';
import '../../domain/validators/register_validator.dart';

part 'register_notifier.freezed.dart';

part 'register_state.dart';

@ProviderFor(RegisterNotifier)
final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  () => getIt<RegisterNotifier>(),
);

@injectable
class RegisterNotifier extends Notifier<RegisterState> {
  final RegisterRepository _repository;
  final AuthEventBus _authEventBus;
  final String _instanceId = const Uuid().v4();
  CancelToken? _cancelToken;

  RegisterNotifier(this._repository, this._authEventBus) {
    logger.d('[RegisterNotifier] Created new instance $_instanceId');
  }

  @override
  RegisterState build() {
    ref.onDispose(() {
      logger.d('[RegisterNotifier] Disposed instance $_instanceId');
      _cancelOngoingRequests();
    });
    return RegisterState();
  }

  /// Cancels any ongoing API requests
  void _cancelOngoingRequests() {
    if (_cancelToken != null) {
      logger.d('[RegisterNotifier] Cancelling requests for instance $_instanceId');
      _cancelToken?.cancel('Notifier was disposed');
      _cancelToken = null;
    }
  }

  /// Creates a new cancel token for API requests
  CancelToken _createCancelToken() {
    _cancelOngoingRequests();
    _cancelToken = CancelToken();
    logger.d('[RegisterNotifier] Created new cancel token for instance $_instanceId');
    return _cancelToken!;
  }

  Future<void> initialize() async {
    // final key = SupportiveKeys.tncSignup;
    // final result = await _repository.getSupportiveByKey(key);
    // final supportive = result.getOrNull();
    // setSupportive(supportive);
  }

  // void setSupportive(Supportive? supportive) {
  //   state = state.copyWith(supportive: supportive);
  //   logger.d('[RegisterNotifier] setSupportive $_instanceId');
  // }

  void setPhone(String phone, String verificationCode) {
    state = state.copyWith(
      input: state.input.copyWith(
        verificationCode: verificationCode,
        phone: phone,
      ),
    );
    logger.d('[RegisterNotifier] setPhone $_instanceId');
  }

  void onPasswordChanged(String password) {
    state = state.copyWith(
      input: state.input.copyWith(password: password),
    );
  }

  void onConfirmPasswordChanged(String confirmPassword) {
    state = state.copyWith(
      input: state.input.copyWith(cPassword: confirmPassword),
    );
  }

  Future<void> register() async {
    final currentState = state;
    if (!currentState.input.isValid()) {
      state = currentState.onValidationErrors(state.input.getErrorCase());
      return;
    }

    state = currentState.loading;

    try {
      final request = RegisterWithPhoneRequest(
        phoneNumber: PhoneNumber(currentState.input.phone),
        mobileToken: currentState.input.verificationCode,
        password: currentState.input.password,
      );

      final result = await _repository.register(
        request,
        token: _createCancelToken(),
      );

      state = result.fold(
        (user) {
          // Follows MCP-ddd-domain-layer: Use domain events to signal important changes
          logger.i('[RegisterNotifier] Registration successful for user: ${user.id}');
          
          // The AuthEventBus will handle the authentication notification,
          // which will be received by the AuthNotifier to update its state
          // and persist the user data and token
          _authEventBus.notifyAuthenticated(user);
          
          return currentState.onSuccess();
        },
        (error) => currentState.copyWith(
          status: RegisterStatus.error(RegisterError.api(error)),
        ),
      );
    } catch (e) {
      logger.e('[RegisterNotifier] Registration failed: ${e.toString()}');
      state = currentState.copyWith(
        status: RegisterStatus.error(RegisterError.unknown(e.toString())),
      );
    }
  }
}
