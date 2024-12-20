import 'package:hedyety/date.dart';

class MyConstants {
  MyConstants._();

  static final List categoryList = [
    "Books📚",
    "Electronics📱",
    "Watches⌚",
    "Jewleries💎",
    "Tickets🎟️",
    "Other"
  ];

  static final List eventsList = [
    "New Year☃️",
    "New House🏡",
    "Christmas🎄",
    "Graduation🎓",
    "Halloween👻",
    "Birthday🎂",
    "Other"
  ];

  static final List eventStatusList = ["Upcoming", "Current", "Past"];

  static final List giftStatusList = ["Purchased", "Pledged", "Unpledged"];

  static String? Function(String?) dateValidator = (value) {
    bool isValidDate(String date) {
      final RegExp regex =
          RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-(\d{4})$');
      if (!regex.hasMatch(date)) {
        return false;
      }
      List<String> parts = date.split('-');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      if (month == 2) {
        // February
        bool isLeapYear =
            (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
        if (day > (isLeapYear ? 29 : 28)) return false;
      } else if (month == 4 || month == 6 || month == 9 || month == 11) {
        // April, June, September, November
        if (day > 30) return false;
      } else {
        // January, March, May, July, August, October, December
        if (day > 31) return false;
      }
      return true;
    }

    if (value == null || value.isEmpty) return "Date must not be empty";
    if (!isValidDate(value))
      return "Date must be dd-MM-yyyy format and a valid date.\nFor example 12-20-2024";
    if (compareDate(value) == "Past")
      return "Date must be today or after.\nYou cannot add an event that passed.";
    return null;
  };

  static String? Function(String?) password2Validator = (val) {
    if (val == null || val.length < 8) {
      return "Password must be at least 8 characters";
    }
    bool containsSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(val);
    if (containsSpecialChar == false)
      return "Password must at least a contain special character";
    bool containsNumber = RegExp(r'\d').hasMatch(val);
    if (containsNumber == false) return "Password must at least a number";
    bool containsCapitalLetter = RegExp(r'[A-Z]').hasMatch(val);
    if (containsCapitalLetter == false)
      return "Password must at least a capital letter";

    return null;
  };

  static String? Function(String?) phoneValidator = (value) {
    bool isValidPhone(String val) => RegExp(r'^\d{11}$').hasMatch(val);
    if (value == null || value.isEmpty)
      return "Phone cannot be empty";
    else if (isValidPhone(value) == false) {
      return "Phone must  contain exaclty than 11 digits.";
    }

    return null;
  };

  static String? Function(String?) usernamaeValidator = (value) {
    if (value == null || value.length < 3)
      return "Username must be at least 3 character long";
    return null;
  };

  static String? Function(String?) emailValidator = (value) {
    if (value == null ||
        value.isEmpty ||
        (!value.endsWith("@gmail.com") && !value.endsWith("@hotmail.com")))
      return "Field must end with @gmail.com or @hotmail.com";
    return null;
  };
  static String? Function(String?) urlValidator = (value) {
    if (value == null || value.isEmpty || !value.startsWith("https://"))
      return "Url must start with https://";
    return null;
  };

  static String? Function(String?) priceValidator = (value) {
    bool isValidPrice(String price) {
      final RegExp regex = RegExp(r'^\d+(\.\d{1,2})?$');

      return regex.hasMatch(price);
    }

    if (value == null || value.isEmpty || !isValidPrice(value))
      return "Price must be a number with no decimal places or one or two";
    return null;
  };
}
