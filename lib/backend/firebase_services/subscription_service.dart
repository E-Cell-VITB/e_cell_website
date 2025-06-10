import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:flutter/services.dart' show rootBundle;

class SubscriptionService {
  // static const _credentials = r'''

  // ''';

  // Google Sheet ID
  static const _spreadsheetId = '1uWjjJPV4pajOObqNj2MStHFWOMJkOaNitU3MKbzUmjo';

  // final _gsheets = GSheets(_credentials);
  static late GSheets _gsheets;
  Spreadsheet? _spreadsheet;
  Worksheet? _worksheet;

  int _emailColumn = 1; // B column (1-indexed in the API)
  int _dateColumn = 2; // C column (1-indexed in the API)

  // Initialize the service
  Future<void> init() async {
    try {
      final credentials = await rootBundle.loadString('credentials.json');
      _gsheets = GSheets(jsonDecode(credentials));
      // Get spreadsheet by ID
      _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);

      // Get or create worksheet named 'Subscribers'
      _worksheet = await _getWorksheet(_spreadsheet!, 'Subscribers');

      // Check and create headers if needed
      final headerRow = await _worksheet!.values.row(1);

      // Detect which columns contain our headers
      if (headerRow.contains('Email')) {
        _emailColumn = headerRow.indexOf('Email') + 1; // Convert to 1-indexed
      }

      if (headerRow.contains('Date Subscribed')) {
        _dateColumn =
            headerRow.indexOf('Date Subscribed') + 1; // Convert to 1-indexed
      }

      if (!headerRow.contains('Email') ||
          !headerRow.contains('Date Subscribed')) {
        if (_emailColumn > 0) {
          await _worksheet!.values
              .insertValue('Email', column: _emailColumn, row: 1);
        }

        if (_dateColumn > 0) {
          await _worksheet!.values
              .insertValue('Date Subscribed', column: _dateColumn, row: 1);
        }
      }
    } catch (e) {
      throw Exception('Error initializing subscription service: $e');
    }
  }

  Future<Worksheet> _getWorksheet(Spreadsheet spreadsheet, String title) async {
    var sheet = spreadsheet.worksheetByTitle(title);

    if (sheet == null) {
      sheet = await spreadsheet.addWorksheet(title);
    } else {}

    return sheet;
  }

  Future<bool> emailExists(String email) async {
    if (_worksheet == null) await init();

    final lowerEmail = email.trim().toLowerCase();

    final emails = await _worksheet!.values.column(_emailColumn);
    if (emails.isNotEmpty) emails.removeAt(0);

    final emailSet = emails.toSet();
    return emailSet.contains(lowerEmail);
  }

  // Add new subscriber
  Future<bool> addSubscriber(String email) async {
    if (_worksheet == null) await init();

    try {
      final normalizedEmail = email.trim().toLowerCase();

      // Check if email already exists
      if (await emailExists(normalizedEmail)) {
        return false;
      }

      // Get the next available row
      final rows = await _worksheet!.values.map.allRows();
      final nextRow =
          (rows?.length ?? 1) + 2; // Add 1 because rows are 1-indexed

      // Insert the email in the correct column
      await _worksheet!.values
          .insertValue(normalizedEmail, column: _emailColumn, row: nextRow);

      // Insert the date in the correct column
      final now = DateTime.now().toString();
      await _worksheet!.values
          .insertValue(now, column: _dateColumn, row: nextRow);

      return true;
    } catch (e) {
      throw Exception('Error adding subscriber: $e');
    }
  }
}
