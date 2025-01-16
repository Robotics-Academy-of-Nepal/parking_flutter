import 'package:flutter/material.dart';

import 'package:sumi/componets/history.dart';
import 'package:sumi/componets/history_groups.dart';
import 'package:sumi/componets/history_manager.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<HistoryEntry>> historyFuture;

  @override
  void initState() {
    super.initState();
    historyFuture = HistoryManager.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: FutureBuilder<List<HistoryEntry>>(
        future: historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No history available."));
          }

          final groupedData = groupByHour(snapshot.data!);

          return ListView(
            children: groupedData.entries.map((entry) {
              final String hour = entry.key; // Grouped by hour
              final List<HistoryEntry> entries = entry.value;
              final double totalRevenue = calculateTotalRevenue(entries);

              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hour: $hour",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Vehicles: ${entries.length}"),
                      Text(
                          "Total Revenue: RS ${totalRevenue.toStringAsFixed(2)}"),
                      Divider(),
                      ...entries.map((historyEntry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "Receipt ID: ${historyEntry.receiptId} - Vehicle: ${historyEntry.vehicleNumber}",
                              style: TextStyle(fontSize: 14),
                            ),
                          )),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
