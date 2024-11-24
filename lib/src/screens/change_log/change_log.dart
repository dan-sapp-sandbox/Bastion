import 'package:flutter/material.dart';
import '../../models/change_log.dart';
import 'package:intl/intl.dart';
import '../../services/change_log_service.dart';

class ChangeLogPage extends StatefulWidget {
  const ChangeLogPage({super.key});
  static const routeName = '/change-log';
  @override
  State<ChangeLogPage> createState() => _ChangeLogPageState();
}

class _ChangeLogPageState extends State<ChangeLogPage> {
  Future<List<ChangeLogEntry>>? _changeLog;
  final ChangeLogService _changeLogService = ChangeLogService();

  @override
  void initState() {
    super.initState();
    _fetchChangeLogs();
  }

  Future<void> _fetchChangeLogs() async {
    var logs = await _changeLogService.fetchChangeLog();
    setState(() {
      _changeLog = Future.value(logs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChangeLogEntry>>(
      future: _changeLog,
      builder:
          (BuildContext context, AsyncSnapshot<List<ChangeLogEntry>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications, size: 64, color: Colors.amber),
                SizedBox(height: 16),
                Text('No new notifications'),
              ],
            ),
          );
        } else {
          List<ChangeLogEntry> changeLogs = snapshot.data!;
          return ListView.separated(
            itemCount: changeLogs.length,
            itemBuilder: (context, index) {
              final changeLog = changeLogs[index];

              final unixTimestamp = int.parse(changeLog.timestamp);
              final parsedDate =
                  DateTime.fromMillisecondsSinceEpoch(unixTimestamp).toLocal();
              final formattedDate =
                  DateFormat.yMMMd().add_jm().format(parsedDate);

              return ListTile(
                title: Row(
                  children: [
                    const Icon(Icons.history, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(changeLog.change),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 1,
            ),
          );
        }
      },
    );
  }
}
