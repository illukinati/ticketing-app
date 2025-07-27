import 'package:yono_bakrie_app/domain/values_object/date.dart';

import '../../domain/entities/event_ticket_entity.dart';
import 'show_model.dart';
import 'phase_model.dart';
import 'category_model.dart';

class EventTicketModel {
  final int id;
  final String createdAt;
  final String updatedAt;
  final int qty;
  final double price;
  final int showId;
  final int phaseId;
  final int categoryId;
  final String status;
  final int originalQty;
  final int movedQty;
  final ShowModel show;
  final PhaseModel phase;
  final CategoryModel category;

  const EventTicketModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.qty,
    required this.price,
    required this.showId,
    required this.phaseId,
    required this.categoryId,
    required this.status,
    required this.originalQty,
    required this.movedQty,
    required this.show,
    required this.phase,
    required this.category,
  });

  factory EventTicketModel.fromJson(Map<String, dynamic> json) {
    return EventTicketModel(
      id: json['id'] as int,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      qty: json['qty'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      showId: json['show_id'] as int,
      phaseId: json['phase_id'] as int,
      categoryId: json['category_id'] as int,
      status: json['status'] as String? ?? 'available',
      originalQty: json['original_qty'] as int? ?? 0,
      movedQty: json['moved_qty'] as int? ?? 0,
      show: ShowModel.fromJson(json['show'] as Map<String, dynamic>),
      phase: PhaseModel.fromJson(json['phase'] as Map<String, dynamic>),
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'qty': qty,
      'price': price,
      'show_id': showId,
      'phase_id': phaseId,
      'category_id': categoryId,
      'status': status,
      'original_qty': originalQty,
      'moved_qty': movedQty,
      'show': show.toJson(),
      'phase': phase.toJson(),
      'category': category.toJson(),
    };
  }

  EventTicketEntity toEntity() {
    return EventTicketEntity(
      id: id,
      createdAt: Date.fromString(createdAt),
      updatedAt: Date.fromString(updatedAt),
      qty: qty,
      price: price,
      showId: showId,
      phaseId: phaseId,
      categoryId: categoryId,
      status: TicketStatus.fromString(status),
      originalQty: originalQty,
      movedQty: movedQty,
      show: show.toEntity(),
      phase: phase.toEntity(),
      category: category.toEntity(),
    );
  }

  static EventTicketModel fromEntity(EventTicketEntity entity) {
    return EventTicketModel(
      id: entity.id,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      qty: entity.qty,
      price: entity.price,
      showId: entity.showId,
      phaseId: entity.phaseId,
      categoryId: entity.categoryId,
      status: entity.status.value,
      originalQty: entity.originalQty,
      movedQty: entity.movedQty,
      show: ShowModel.fromEntity(entity.show),
      phase: PhaseModel.fromEntity(entity.phase),
      category: CategoryModel.fromEntity(entity.category),
    );
  }
}
