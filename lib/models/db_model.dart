import 'package:sqflite/sqflite.dart'; // sqflite untuk database
import 'package:path/path.dart'; // package path
import './todo_model.dart'; // the todo model we created before

class DatabaseConnect {
  Database? _database;

  // memanggil dan membuka koneksi ke database
  Future<Database> get database async {
    // this is the location of our database in device. ex - data/data/....
    final dbpath = await getDatabasesPath();
    // nama database
    const dbname = 'todo.db';
    // this joins the dbpath and dbname and creates a full path for database.
    final path = join(dbpath, dbname);
    // membuka koneksi
    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    
    // membuat masing masing DB function
    return _database!;
  }

  // membuat db function
  // membuat tabel di database
  Future<void> _createDB(Database db, int version) async {
    // make sure the columns we create in our table match the todo_model field.
    await db.execute('''
      CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        creationDate TEXT,
        isChecked INTEGER
      )
    ''');
  }

  // function untuk menambah data ke database
  Future<void> insertTodo(Todo todo) async {
    // koneksi ke database
    final db = await database;
    // menambah todo
    await db.insert(
      'todo', // nama tabel
      todo.toMap(), // the function we created in our todo_model
      conflictAlgorithm:
          ConflictAlgorithm.replace, // this will replace the duplicate entry
    );
  }

  // function untuk menghapus data
  Future<void> deleteTodo(Todo todo) async {
    final db = await database;
    // menghapus data dari database based on its id.
    await db.delete(
      'todo',
      where: 'id == ?', // this condition will check for id in todo list
      whereArgs: [todo.id],
    );
  }

  // function to fetch all the todo data from our database
  Future<List<Todo>> getTodo() async {
    final db = await database;
    // query the database and save the todo as list of maps
    List<Map<String, dynamic>> items = await db.query(
      'todo',
      orderBy: 'id DESC',
    ); // this will order the list by id in descending order.
    // so the latest todo will be displayed on top.

    // now convert the items from list of maps to list of todo

    return List.generate(
      items.length,
      (i) => Todo(
        id: items[i]['id'],
        title: items[i]['title'],
        creationDate: DateTime.parse(items[i][
            'creationDate']), // this is in Text format right now. let's convert it to dateTime format
        isChecked: items[i]['isChecked'] == 1
            ? true
            : false, // this will convert the Integer to boolean. 1 = true, 0 = false.
      ),
    );
  }


  // function untuk update data
  Future<void> updateTodo(int id, String title) async {
    final db = await database;

    await db.update(
      'todo', // nama tabel
      {
        //
        'title': title, // data we have to update
      }, //
      where: 'id == ?', // which Row we have to update
      whereArgs: [id],
    );
  }
}
