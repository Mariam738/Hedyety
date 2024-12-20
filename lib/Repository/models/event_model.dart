import 'package:hedyety/Repository/local_database.dart';

class EventModel {
  int? id;
  String? eid;
  String? name;
  String? date; 
  String? location; 
  String? description; 
  String? category;
  int? userId; 

  static LocalDatabse mydb = LocalDatabse();

  EventModel({this.id, this.name, this.date, this.location, this.description, this.category, this.userId, this.eid});

  static addEvent(String name, String date, String location, String description, String category, int userId) async {
    try {
      int res = await mydb.insertData(
        '''INSERT INTO 'EVENTS' ('NAME','DATE', 'LOCATION', 'DESCRIPTION', 'CATEGORY' , 'USERID')
        VALUES ("$name","$date",
        "$location", "$description", "$category", "$userId")''');
      return res;
    } catch(e) {
      print('error in add Event $e');
      return null;
    }
  }

  static editEvent(String name, String date, String location, String description, String category, int id) async {
    try {
      int res = await mydb.updateData(
        '''UPDATE 'EVENTS' SET 'NAME' = "$name",'DATE' = "$date",'LOCATION' = "$location", 
          'DESCRIPTION' = "$description", 'CATEGORY' = "$category" WHERE ID= "$id"''');
      return res;
    } catch(e) {
      print('error in editEvent $e');
      return null;
    }
  }

  static editEid(String eid, int id) async {
    try {
      int res = await mydb.updateData(
        '''UPDATE 'EVENTS' SET 'EID' = "$eid" WHERE ID= "$id"''');
      return res;
    } catch(e) {
      print('error in editEid $e');
      return null;
    }
  }

  static getEvents(currentUid) async{
    try{
    List<Map> res=  await mydb.readData('''SELECT * FROM 'EVENTS' WHERE USERID="$currentUid"''');
    print('getEvents $res, id $currentUid');
    return res;
    } catch(e){
      print('error in getEvents $e');
    }
  }
  static getEid(id) async{
    try{
    List<Map> res=  await mydb.readData('''SELECT EID FROM 'EVENTS' WHERE ID="$id"''');
    print('getEventEid $res, id $id');
    return res;
    } catch(e){
      print('error in getEid $e');
    }
  }

  static deleteEvent(int id) async {
    try {
      var res = await mydb.deleteData("DELETE FROM EVENTS WHERE ID=$id");
      return res;
    } catch (e) {
      print('error in deleteEvent $e');
      return null;
    }
  }

  toJson() {
    return {
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'category': category,
    };
  }
}
  