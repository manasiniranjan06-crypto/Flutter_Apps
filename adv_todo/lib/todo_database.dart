

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabase {
  Future<Database> creatdb() async{
    Database localdb = await openDatabase(
      join(await getDatabasesPath(),"todoDb.db"),
      version: 1,
      onCreate: (db, version)   async{
       await  db.execute(
          '''
          CREATE TABLE TODOLIST(
          Id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          date TEXT,
          )
        '''
        );
      },
    );
    return localdb;
  }

  // get data
  Future<List<Map>> gettodoitems() async{
    Database localdb = await creatdb();
    List<Map> list =  await localdb.query("TODOLIST");
    return list;
  }

  //add datta insert
void inserttodoitems(Map<String, dynamic> obj) async{
    Database localdb = await creatdb();
    localdb.insert("TODOLIST", obj , conflictAlgorithm: ConflictAlgorithm.replace);

  }
  //update todo card
  Future<void> updatetodoitems(Map<String, dynamic> obj) async{
    Database localdb = await creatdb();
    await localdb.update("TODOLIST", obj, where: "Id=?", whereArgs:  [obj['Id']]);
  
  }

  //delete data
  Future<void> deletertodoitems(int index) async {
    Database localdb = await creatdb();
    localdb.delete("TODOLIST" , where: "Id=?", whereArgs: [index] );

  }
}