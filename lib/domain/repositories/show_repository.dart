import '../entities/show_entity.dart';

abstract class ShowRepository {
  // Create
  Future<ShowEntity> createShow(String name);
  
  // Read
  Future<List<ShowEntity>> getAllShows();
  Future<ShowEntity> getShowById(int id);
  
  // Update
  Future<ShowEntity> updateShow(int id, String name);
  
  // Delete
  Future<void> deleteShow(int id);
}