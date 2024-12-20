import 'package:intl/intl.dart';


String compareDate(String date){
  final dateFromat = DateFormat("dd-MM-yyyy");
  DateTime parsedDate = dateFromat.parse(date);
  DateTime currentDate = DateTime.now();
  currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
  if(parsedDate.isBefore(currentDate))
    return "Past";
  else if (parsedDate.isAtSameMomentAs(currentDate))
    return "Current";
  else return "Upcoming";
}