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
  
  static final List giftStatusList = ["Pledged", "Unpledged"];

  static String? Function(String?) emailValidator = (value) {

    if(value == null || value.isEmpty ||
        (!value.endsWith("@gmail.com") &&
            !value.endsWith("@hotmail.com")))
      return "Field must end with @gmail.com or @hotmail.com";
    return null;
  };

}
