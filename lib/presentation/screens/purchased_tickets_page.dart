import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/show_entity.dart';
import '../../domain/entities/purchased_ticket_entity.dart';
import '../../application/purchased_ticket/purchased_ticket_provider.dart';
import '../../application/core/async_state.dart';
import '../widgets/purchased_tickets/purchased_ticket_card.dart';

class PurchasedTicketsPage extends ConsumerStatefulWidget {
  final ShowEntity show;

  const PurchasedTicketsPage({super.key, required this.show});

  @override
  ConsumerState<PurchasedTicketsPage> createState() =>
      _PurchasedTicketsPageState();
}

class _PurchasedTicketsPageState extends ConsumerState<PurchasedTicketsPage> {
  PaymentStatus? _selectedPaymentStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(purchasedTicketByShowNotifierProvider.notifier)
          .loadPurchasedTicketsByShow(widget.show.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ticketState = ref.watch(purchasedTicketByShowNotifierProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Purchased Tickets',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.secondary.withValues(alpha: 0.05),
              colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            // Show Info Section with Statistics
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildStatistics(ticketState),
            ),

            // Filter Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Filter:',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<PaymentStatus?>(
                      value: _selectedPaymentStatus,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem<PaymentStatus?>(
                          value: null,
                          child: Text('All Status'),
                        ),
                        ...PaymentStatus.values.map((status) =>
                          DropdownMenuItem<PaymentStatus?>(
                            value: status,
                            child: Text(status.value.toUpperCase()),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentStatus = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tickets List
            Expanded(child: _buildTicketsList(ticketState)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(AsyncState<List<PurchasedTicketEntity>> ticketState) {
    return ticketState.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const SizedBox.shrink(),
      data: (tickets) {
        // Filter out cancelled, expired, and failed tickets
        final validTickets = tickets.where((ticket) => 
          ticket.paymentStatus != PaymentStatus.cancelled &&
          ticket.paymentStatus != PaymentStatus.expired &&
          ticket.paymentStatus != PaymentStatus.failed
        ).toList();
        
        final totalPurchases = validTickets.length;
        final totalTickets = validTickets.fold<int>(0, (sum, ticket) => sum + ticket.quantity);
        final paidTickets = validTickets.where((ticket) => ticket.isPaid).length;
        final pendingTickets = validTickets.where((ticket) => ticket.isPending).length;
        final usedTickets = validTickets.fold<int>(0, (sum, ticket) => sum + ticket.usedTicketsCount);

        return Row(
          children: [
            Expanded(
              child: _StatItem(
                label: 'Purchases',
                value: totalPurchases.toString(),
                icon: Icons.shopping_cart,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: 'Tickets',
                value: totalTickets.toString(),
                icon: Icons.confirmation_number,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: 'Paid',
                value: paidTickets.toString(),
                icon: Icons.payment,
                color: Colors.green,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: 'Pending',
                value: pendingTickets.toString(),
                icon: Icons.pending,
                color: Colors.orange,
              ),
            ),
            Expanded(
              child: _StatItem(
                label: 'Used',
                value: usedTickets.toString(),
                icon: Icons.check_circle,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
      error: (failure) => const SizedBox.shrink(),
    );
  }

  Widget _buildTicketsList(
    AsyncState<List<PurchasedTicketEntity>> ticketState,
  ) {
    return ticketState.when(
      initial: () => const Center(child: Text('Loading purchased tickets...')),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (tickets) {
        // First filter out expired, failed, and cancelled tickets
        final validTickets = tickets.where((ticket) => 
          ticket.paymentStatus != PaymentStatus.cancelled &&
          ticket.paymentStatus != PaymentStatus.expired &&
          ticket.paymentStatus != PaymentStatus.failed
        ).toList();
        
        // Then apply user's filter selection
        final filteredTickets = _selectedPaymentStatus == null
            ? validTickets
            : validTickets.where((ticket) => ticket.paymentStatus == _selectedPaymentStatus).toList();

        if (filteredTickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  _selectedPaymentStatus == null
                      ? 'No purchased tickets found for this show'
                      : 'No ${_selectedPaymentStatus!.value} tickets found',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                if (_selectedPaymentStatus != null) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedPaymentStatus = null;
                      });
                    },
                    child: const Text('Clear Filter'),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredTickets.length,
          itemBuilder: (context, index) {
            final ticket = filteredTickets[index];
            return PurchasedTicketCard(ticket: ticket);
          },
        );
      },
      error: (failure) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error: ${failure.message}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(purchasedTicketByShowNotifierProvider.notifier)
                  .refresh(widget.show.id),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final itemColor = color ?? colorScheme.primary;

    return Column(
      children: [
        Icon(icon, color: itemColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: itemColor,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

