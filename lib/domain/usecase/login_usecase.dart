import 'package:dartz/dartz.dart';
import 'package:ecommerce_mvvm/data/network/failure.dart';
import 'package:ecommerce_mvvm/data/network/requests.dart';
import 'package:ecommerce_mvvm/domain/model/models.dart';
import 'package:ecommerce_mvvm/domain/repository/repository.dart';
import 'package:ecommerce_mvvm/domain/usecase/base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  Repository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    return await _repository.login(LoginRequest(input.email, input.password));
  }
}

class LoginUseCaseInput {
  String email;
  String password;
  LoginUseCaseInput(this.email, this.password);
}
