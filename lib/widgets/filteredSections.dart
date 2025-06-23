// lib/widgets/filtered_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_021/controller/orderController.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<OrderController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // 1) Client dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String?>(
              value: ctrl.activeClientFilter,
              underline: const SizedBox(),
              icon: const SizedBox(), // we'll put our own icon next
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All Clients'),
                ),
                ...ctrl.uniqueClients.map((c) => DropdownMenuItem<String?>(
                  value: c,
                  child: Text(c),
                )),
              ],
              onChanged: ctrl.setClientFilter,
            ),
          ),

          const SizedBox(width: 8),

          // 2) Person-add icon
          InkWell(
            onTap: () {
              // TODO: open “add client” dialog
            },
            child: const Icon(Icons.person_add, size: 24, color: Colors.black54),
          ),

          const SizedBox(width: 12),

          // 3) User chip (“Lalit”)
          Chip(
            label: const Text('Lalit'),
            backgroundColor: Colors.grey.shade100,
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () {
              // TODO: remove user filter if needed
            },
          ),

          const SizedBox(width: 16),

          // 4) Search field
          Expanded(
            child: TextField(
              onChanged: ctrl.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search for a stock, future, option or index',
                prefixIcon: const Icon(Icons.search, size: 20, color: Colors.black54),
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 5) Active ticker chips
          ...ctrl.activeTickerFilters.map((t) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(t),
              backgroundColor: Colors.grey.shade100,
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => ctrl.removeTickerFilter(t),
            ),
          )),

          // push cancel button to right
          const SizedBox(width: 16),

          // 6) Cancel All button
          ElevatedButton.icon(
            onPressed: ctrl.cancelAllOrders,
            icon: const Icon(Icons.block, size: 20),
            label: const Text('Cancel all'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
