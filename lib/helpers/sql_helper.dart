import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlHelper {
  Database? db;

  Future<void> init() async {
    try {
      if (kIsWeb) {
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase('pos.db');
      } else {
        db = await openDatabase('pos.db', version: 1,
            onCreate: (Database db, int version) {
          print("Database created successfully");
        });
      }
    } catch (error) {
      print("The error in creating database : $error");
    }
  }

  Future<bool> createTables() async {
    try {
      var batch = db!.batch();
      batch.execute('''
        PRAGMA foreign_keys = ON
        ''');
      batch.rawQuery('''
        PRAGMA foreign_keys 
        ''');
      batch.execute('''
        CREATE TABLE IF NOT EXISTS categories (
            id INTEGER PRIMARY KEY ,
            name TEXT NOT NULL,
            description TEXT NOT NULL
        )
        ''');

      batch.execute('''
        CREATE TABLE IF NOT EXISTS products (
            id INTEGER PRIMARY KEY ,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            price DOUBlE NOT NULL,
            stock INTEGER NOT NULL,
            isAvailable BOOLEAN NOT NULL,
            image TEXT,
            categoryId INTEGER NOT NULL,
            foreign key (categoryId) references categories (id)
            on delete restrict
        )
        ''');

      batch.execute('''
        CREATE TABLE IF NOT EXISTS clients (
            id INTEGER PRIMARY KEY ,
            name TEXT NOT NULL,
            email TEXT,
            phone TEXT,
            address TEXT
        )
        ''');

      print("Tables created Successfully!");
      var result = await batch.commit();
      print("Result: $result");
      var enableForeignKeyResult = result[0]; // Result of executing 'PRAGMA foreign_keys = ON;'
      var foreignKeyPragmaResult = result[1]; // Result of executing 'PRAGMA foreign_keys;'
      print(enableForeignKeyResult); // Result of enabling foreign key support
      print(foreignKeyPragmaResult);
      return true;
    } catch (error) {
      print("Error in creating tables: $error");
      return false;
    }
  }
}
