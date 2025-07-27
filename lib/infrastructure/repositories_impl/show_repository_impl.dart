import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/show_entity.dart';
import '../../domain/values_object/failure.dart';
import '../../domain/repositories/show_repository.dart';
import '../data_source/show_remote_data_source.dart';
import '../core/dio_error_handler.dart';

class ShowRepositoryImpl implements ShowRepository {
  final ShowRemoteDataSource remoteDataSource;

  ShowRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ShowEntity>> createShow(String name) async {
    try {
      final showModel = await remoteDataSource.createShow(name);
      return Right(showModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, List<ShowEntity>>> getAllShows() async {
    try {
      final showModels = await remoteDataSource.getAllShows();
      final entities = showModels.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, ShowEntity>> getShowById(int id) async {
    try {
      final showModel = await remoteDataSource.getShowById(id);
      return Right(showModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, ShowEntity>> updateShow(int id, String name) async {
    try {
      final showModel = await remoteDataSource.updateShow(id, name);
      return Right(showModel.toEntity());
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteShow(int id) async {
    try {
      await remoteDataSource.deleteShow(id);
      return const Right(unit);
    } on Failure catch (e) {
      return Left(e);
    } on DioException catch (e) {
      return Left(DioErrorHandler.handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: 'Terjadi kesalahan, silakan coba lagi'));
    }
  }

}
