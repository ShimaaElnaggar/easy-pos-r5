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

  Future<void> registerForeignKeys() async {
    await db!.rawQuery("PRAGMA foreign_keys = ON");
    var result = await db!.rawQuery("PRAGMA foreign_keys");

    print('foreign keys result : $result');
  }

  Future<bool> createTables() async {
    try {
      await registerForeignKeys();
      var batch = db!.batch();
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

      batch.execute("""
        CREATE TABLE IF NOT EXISTS orders(
          id INTEGER PRIMARY KEY,
          label TEXT,
          totalPrice REAL,
          paidPrice REAL,
          discount REAL,
          clientId INTEGER NOT NULL,
          foreign key(clientId) references clients(id)
          on delete restrict
          ) 
          """);

      batch.execute("""
        CREATE TABLE IF NOT EXISTS orderProductItems(
         orderId INTEGER,
         productCount INTEGER,
         productId INTEGER,
         isPaid Real,
          foreign key(productId) references products(id)
          on delete restrict
          ) 
          """);

      batch.execute('''
      CREATE TABLE IF NOT EXISTS exchangeRate (
          id INTEGER PRIMARY KEY,
          currencyFrom TEXT,
          currencyTo TEXT,
          rate REAL 
      )
    ''');

      print("Tables created Successfully!");
      var result = await batch.commit();
      print("Result: $result");
      return true;
    } catch (error) {
      print("Error in creating tables: $error");
      return false;
    }
  }
}
