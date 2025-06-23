
// --- ORDERS SCREEN WIDGET ---
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trade_021/controller/orderController.dart';
import 'package:trade_021/models/order.dart';
import 'package:trade_021/widgets/filteredSections.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopNavBar(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSection(),
                  const SizedBox(height: 20),
                  const FilterSection(),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: const OpenOrdersTable(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopNavBar extends StatelessWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.bar_chart_rounded, color: Colors.orange, size: 32),
          const SizedBox(width: 24),
          _navItem('SIGNORIA', '0.00', Colors.black),
          _navItem('NIFTY BANK', '52,323.30', Colors.green),
          _navItem('NIFTY FIN SERVICE', '25,255.75', Colors.green),
          _navItem('RELCHEMQ', '162.73', Colors.green),
          const Spacer(),
          _textButton('MARKETWATCH'),
          _textButton('EXCHANGE FILES'),
          _textButton('PORTFOLIO'),
          _textButton('FUNDS'),
          const SizedBox(width: 20),
          const CircleAvatar(
            backgroundColor: Color(0xFFE0E0E0),
            child: Text('LK', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _navItem(String title, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }

  Widget _textButton(String text) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Colors.black54)),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Open Orders', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Spacer(),
        OutlinedButton.icon(
          icon: const Icon(Icons.download_outlined, color: Colors.black54),
          label: const Text('Download', style: TextStyle(color: Colors.black54)),
          onPressed: () => context.read<OrderController>().downloadOrders(),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 16),
        
      ],
    );
  }
}


class OpenOrdersTable extends StatelessWidget {
  const OpenOrdersTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OrderController>();
    final orders = controller.ordersForCurrentPage;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Horizontal scroll container for the table
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 32, // Account for padding
                ),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
                  sortColumnIndex: controller.sortColumnIndex,
                  sortAscending: controller.sortAscending,
                  columnSpacing: 24,
                  horizontalMargin: 12,
                  columns: _buildDataColumns(controller),
                  rows: orders.map((order) => _buildDataRow(order, controller)).toList(),
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 40,
                  headingRowHeight: 40,
                  dividerThickness: 1,
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.grey.shade300),
                    verticalInside: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),
          ),
          // Pagination controls
          _buildPaginationControls(controller),
        ],
      ),
    );
  }

  List<DataColumn> _buildDataColumns(OrderController controller) {
    return [
      DataColumn(
        label: const SizedBox(
          width: 100, // Fixed width for Time column
          child: Row(
            children: [
              Text('Time'),
              SizedBox(width: 4),
              Icon(Icons.double_arrow_rounded, size: 16),
            ],
          ),
        ),
        onSort: (index, _) => controller.sort(index),
      ),
      DataColumn(
        label: const SizedBox(
          width: 100,
          child: Row(
            children: [
              Text('Client'),
              SizedBox(width: 4),
              Icon(Icons.double_arrow_rounded, size: 16),
            ],
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 120, 
          child: Text('Ticker'),
        ),
      ),
      DataColumn(
        label: const SizedBox(
          width: 80, 
          child: Row(
            children: [
              Text('Side'),
              SizedBox(width: 4),
              Icon(Icons.filter_alt, size: 16),
            ],
          ),
        ),
      ),
      DataColumn(
        label: const SizedBox(
          width: 100, 
          child: Row(
            children: [
              Text('Product'),
              SizedBox(width: 4),
              Icon(Icons.double_arrow_outlined, size: 16),
                            Icon(Icons.filter_alt_off_outlined, size: 16),

            ],
          ),
        ),
        onSort: (index, _) => controller.sort(index),
      ),
      const DataColumn(
        label: SizedBox(
          width: 120, 
          child: Text('Qty (Executed/Total)'),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 80,
          child: Text('Price'),
          
        ),

        numeric: true,
      ),
      const DataColumn(
        label: SizedBox(
          width: 80,
          child: Text('Actions'),
        ),
      ),
    ];
  }

  DataRow _buildDataRow(Order order, OrderController controller) {
    return DataRow(
      cells: [
        DataCell(SizedBox(
          width: 100,
          child: Text(DateFormat('HH:mm:ss').format(order.time)),
        )),
        DataCell(SizedBox(
          width: 100,
          child: Text(order.client),
        )),
        DataCell(SizedBox(
          width: 120,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  order.ticker,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (order.ticker.contains('RELIANCE') || order.ticker.contains('ASIANPAINT'))
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.copyright, size: 12),
                ),
            ],
          ),
        )),
        DataCell(SizedBox(
          width: 80,
          child: Text(
            order.sideString,
            style: TextStyle(
              color: order.side == OrderSide.buy ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        )),
        DataCell(SizedBox(
          width: 100,
          child: Text(order.productString),
        )),
        DataCell(SizedBox(
          width: 120,
          child: Text('${order.quantityExecuted}/${order.quantityTotal}'),
        )),
        DataCell(SizedBox(
          width: 80,
          child: Text(order.price.toStringAsFixed(2)),
        )),
        DataCell(SizedBox(
          width: 80,
          child: const Icon(Icons.more_vert, size: 16),
        )),
      ],
    );
  }

  Widget _buildPaginationControls(OrderController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: controller.currentPage == 0 ? null : () => controller.previousPage(),
            child: const Text('Previous'),
          ),
          const SizedBox(width: 12),
          Text('Page ${controller.currentPage + 1}'),
          const SizedBox(width: 12),
          TextButton(
            onPressed: (controller.currentPage + 1) >= controller.totalPages
                ? null
                : () => controller.nextPage(),
            child: const Text('Next'),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}