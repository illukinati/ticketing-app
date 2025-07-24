import 'package:fpdart/fpdart.dart';
import '../entities/show_entity.dart';
import '../failures/failure.dart';

abstract class ShowRepository {
  // Create
  Future<Either<Failure, ShowEntity>> createShow(String name);
  
  // Read
  Future<Either<Failure, List<ShowEntity>>> getAllShows();
  Future<Either<Failure, ShowEntity>> getShowById(int id);
  
  // Update
  Future<Either<Failure, ShowEntity>> updateShow(int id, String name);
  
  // Delete
  Future<Either<Failure, Unit>> deleteShow(int id);
}