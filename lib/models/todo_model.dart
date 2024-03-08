class Todo {
  int? id;
  final String title;
  DateTime creationDate;
  bool isChecked;

  // membuat konstruktor
  Todo({
    this.id,
    required this.title,
    required this.creationDate,
    required this.isChecked,
  });

  // ubah menjadi to a map untuk menyimpan data di database
  // membuat functionnya
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'creationDate': creationDate
          .toString(), // sqflite database tidak mendukung tipe waktu tanggal jadi menyimpannya sebagai teks
      'isChecked': isChecked
          ? 1
          : 0, // juga tidak mendukung bilangan bulat, jadi menyimpannya sebagai integer
    };
  }

  // fungsi ini hanya untuk debugging
  @override
  String toString() {
    return 'Todo(id : $id, title : $title, creationDate : $creationDate, isChecked : $isChecked)';
  }
}
