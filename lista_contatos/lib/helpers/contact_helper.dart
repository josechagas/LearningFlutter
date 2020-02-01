import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

part 'contact_helper.g.dart';

const String contactTable = "Contact";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper._internal();

  factory ContactHelper() => _instance;

  ContactHelper._internal();

  Database _db;

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String path =
        join(databasesPath, "contactsnew.db"); // databasesPath + "/contacts.db"

    final result = await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {

          await db.execute("CREATE TABLE $contactTable("
              "id INTEGER PRIMARY KEY,"
              "name TEXT,"
              "email TEXT,"
              "phone TEXT,"
              "img TEXT)");

        });
    return result;
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    if(dbContact == null)
      return null;

    int id = await dbContact.insert(contactTable, contact.toJson());
    contact.id = id;
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    if(dbContact == null)
      return null;

    List<Map> mapResults =
        await dbContact.query(contactTable, where: "id = ?", whereArgs: [id]);
    List<Contact> results = mapResults.map((item) => Contact.fromJson(item));
    return results.first;
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    if(dbContact == null)
      return null;

    return await dbContact
        .delete(contactTable, where: "id = ?", whereArgs: [id]);
  }
  //Returns the number of changes
  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    if(dbContact == null)
      return null;

    return await dbContact.update(contactTable, contact.toJson(),
        where: "id = ?", whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAllContacts() async {
    Database dbContact = await db;
    if(dbContact == null)
      return null;

    List<Map> mapResults = await dbContact.rawQuery("SELECT * FROM $contactTable");
    return mapResults.map((item) => Contact.fromJson(item)).toList();
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    if(dbContact == null)
      return null;

    final queryResult = await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable");
    return Sqflite.firstIntValue(queryResult);
  }

  Future close() async {
    Database dbContact = await db;
    if(dbContact == null)
      return null;

    return dbContact.close();
  }

}

@JsonSerializable()
class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact(
      {this.id,
      @required this.name,
      @required this.phone,
      this.email,
      this.img});

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
