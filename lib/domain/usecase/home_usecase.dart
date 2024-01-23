import 'package:dartz/dartz.dart';
import 'package:ecommerce_mvvm/data/network/failure.dart';
import 'package:ecommerce_mvvm/data/network/requests.dart';
import 'package:ecommerce_mvvm/domain/model/models.dart';
import 'package:ecommerce_mvvm/domain/repository/repository.dart';
import 'package:ecommerce_mvvm/domain/usecase/base_usecase.dart';

class HomeUseCase implements BaseUseCase<void, HomeObject> {
  Repository _repository;
  HomeUseCase(this._repository);

  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHomeData();
  }
}
