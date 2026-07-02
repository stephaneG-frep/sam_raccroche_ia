import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/call_log_entry.dart';

class ExportService {
  Future<File> exportCallLog(List<CallLogEntry> entries) async {
    final rows = [
      [
        'Date',
        'Heure',
        'Numero',
        'Type',
        'Action',
        'Message',
        'Scenario',
        'Duree',
        'Note',
      ],
      ...entries.map((entry) {
        return [
          DateFormat('dd/MM/yyyy').format(entry.date),
          DateFormat('HH:mm').format(entry.date),
          entry.number,
          entry.type.label,
          entry.action.label,
          entry.messageUsed,
          entry.scenarioUsed,
          entry.estimatedDurationSeconds,
          entry.note,
        ];
      }),
    ];
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'sam-raccroche-journal.csv'));
    return file.writeAsString(const ListToCsvConverter().convert(rows));
  }
}
