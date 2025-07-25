import '../../../domain/entities/event_ticket_entity.dart';

enum TicketActionType {
  edit,
  delete,
  statusChange,
}

class TicketAction {
  final TicketActionType type;
  final EventTicketEntity ticket;
  final TicketStatus? newStatus;

  const TicketAction({
    required this.type,
    required this.ticket,
    this.newStatus,
  });

  TicketAction.edit(EventTicketEntity ticket)
      : this(type: TicketActionType.edit, ticket: ticket);

  TicketAction.delete(EventTicketEntity ticket)
      : this(type: TicketActionType.delete, ticket: ticket);

  TicketAction.statusChange(EventTicketEntity ticket, TicketStatus newStatus)
      : this(type: TicketActionType.statusChange, ticket: ticket, newStatus: newStatus);
}