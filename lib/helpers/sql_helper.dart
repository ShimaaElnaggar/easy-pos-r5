import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlHelper{
  Database? db;

  Future<void> init() async {
    try{

      if(kIsWeb){
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase('my_db.db');


      } else
      {
        db =  await openDatabase(
            'customers.db',
            version : 1,
            onCreate: ( Database db , int version ){
              print("Database created successfully");
            }
        );
      }
    } catch(error){
      print("The error in creating database : $error");
    }
  }

  Future<bool> createTables()async{
    try{
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
            iaAvailable BOOLEAN NOT NULL,
            image BLOB,
            categoryId INTEGER NOT NULL
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
      print("result: $result");

    }catch(error){
      print("Error in creating tables: $error");
    }
    return true;
  }

}