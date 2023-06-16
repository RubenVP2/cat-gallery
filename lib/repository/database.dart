import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/repository/Cat.dart';

class DatabaseHelper {

  static Future<void> createTables(Database database) async {
    await database.execute(
        'CREATE TABLE cats(id INTEGER PRIMARY KEY, url TEXT, date dateAdded)');
  }

  static Future<Database> db() async {
    return openDatabase(
      'cat_database',
      version: 1,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

    // Define a function that inserts dogs into the database
    Future<void> insertCat(Cat cat) async {
      // Get a reference to the database.
      final db = await DatabaseHelper.db();

      // Insert the Dog into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same dog is inserted twice.
      //
      // In this case, replace any previous data.
      await db.insert(
        'cats',
        cat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // A method that retrieves all the dogs from the dogs table.
    Future<List<Cat>> cats() async {
      // Get a reference to the database.
      final db = await DatabaseHelper.db();
      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('cats');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return Cat(
          id: maps[i]['id'],
          url: maps[i]['url'],
          dateAdded: maps[i]['dateAdded'],
        );
      });
    }

    Future<void> deleteCat(int id) async {
      // Get a reference to the database.
      final db = await DatabaseHelper.db();

      // Remove the Dog from the database.
      await db.delete(
        'cats',
        // Use a `where` clause to delete a specific dog.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }
  }
}
