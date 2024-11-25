import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'change_log_row.dart';
import 'package:provider/provider.dart';
import '../../services/change_log_websocket_service.dart';

class ChangeLogPage extends StatefulWidget {
  const ChangeLogPage({super.key});
  static const routeName = '/change-log';

  @override
  State<ChangeLogPage> createState() => _ChangeLogPageState();
}

class _ChangeLogPageState extends State<ChangeLogPage> {
  @override
  Widget build(BuildContext context) {
    final webSocketService = Provider.of<ChangeLogWebSocketService>(context);
    var changeLogs = webSocketService.changeLogs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Log'),
      ),
      body: changeLogs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: changeLogs.length,
              itemBuilder: (context, index) {
                final changeLog = changeLogs[index];
                final unixTimestamp = int.parse(changeLog.timestamp);
                final parsedDate =
                    DateTime.fromMillisecondsSinceEpoch(unixTimestamp).toLocal();

                final now = DateTime.now();
                final todayStart = DateTime(now.year, now.month, now.day);
                final todayEnd = todayStart.add(const Duration(days: 1));

                final isToday = parsedDate.isAfter(todayStart) &&
                    parsedDate.isBefore(todayEnd);

                String formattedDate;
                if (isToday) {
                  formattedDate = 'Today ${DateFormat.jm().format(parsedDate)}';
                } else {
                  formattedDate = DateFormat.yMMMd().add_jm().format(parsedDate);
                }

                return ChangeLogRow(
                  formattedDate: formattedDate,
                  text: changeLog.change,
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 1,
              ),
            ),
    );
  }
}
