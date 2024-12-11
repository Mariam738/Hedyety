import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedyety/constants/constants.dart';
import 'package:hedyety/features/gift_management/screens/events_list/events_list_controller.dart';
import 'package:hedyety/features/gift_management/screens/gifts/gifts_list_controller.dart';
import 'package:hedyety/features/gift_management/screens/gifts/my_pledge_gifts.dart';
import 'package:hedyety/main_controller.dart';
import 'package:hedyety/my_theme.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class FilteContainer extends StatefulWidget {
  const FilteContainer({
    super.key,
    required this.categoryList,
    required this.isEvent,
  });
  final List categoryList;
  final bool isEvent;

  @override
  State<FilteContainer> createState() => _FilteContainerState();
}

class _FilteContainerState extends State<FilteContainer> {

  var controller;

  bool isAscending = true;
  List _selectedCategories = [];
  List _selectedStatus = [];
  int _value = 1;

  @override
  initState(){
    super.initState();
    controller = widget.isEvent == true ? EventsListController() : GiftsListController();
  }

  @override
  Widget build(BuildContext context) {
    List statusList = widget.isEvent
        ? MyConstants.eventStatusList
        : MyConstants.giftStatusList;

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sort by Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sort By Name: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                const Text('Ascending'),
                Checkbox(
                    activeColor: MyTheme.primary,
                    value: isAscending,
                    onChanged: (val) {
                      setState(() {
                        isAscending = val!;
                        print('filtering $isAscending');
                      });
                    }),
                const Text('Descending'),
                Checkbox(
                    activeColor: MyTheme.primary,
                    value: !isAscending,
                    onChanged: (val) {
                      setState(() {
                        isAscending = !val!;
                                                print('filtering $isAscending');
                      });
                    }),
                const SizedBox(height: 16),
              ],
            ),
            const SizedBox(height: 16),
      
            // Sort by Category
            Column(
              children: [
                const Text(
                  'Sort By Category: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                MultiSelectChipField(
                  selectedChipColor: MyTheme.primary,
                  selectedTextStyle: TextStyle(color: Colors.white),
                  chipShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: MyTheme.primary)),
                  scroll: false,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent)),
                  showHeader: false,
                  items: widget.categoryList
                      .map((e) => MultiSelectItem(e, e))
                      .toList(),
                  onTap: (val) {
                    _selectedCategories = val;                        
                    print('filtering $_selectedCategories');

                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Sort by Status
            const Text(
              'Sort By Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MultiSelectChipField(
                        selectedChipColor: MyTheme.primary,
                        selectedTextStyle: TextStyle(color: Colors.white),
                        chipShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: MyTheme.primary)),
                        scroll: false,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent)),
                        showHeader: false,
                        items:
                            statusList.map((e) => MultiSelectItem(e, e)).toList(),
                        onTap: (val) {
                          _selectedStatus = val;
                                              print('filtering $_selectedStatus');

                        },
                      ),
              ],
            ),
      
            // Sort Button
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.4,
              child: ElevatedButton(
                // onPressed: () {print('filter pressed');},
                  onPressed: () async{
                     controller.filter(isAscending, _selectedCategories, _selectedStatus) ;
                  }, //() {=> Navigator.pop(context)},
                  child: const Text('Sort')),
            )
          ],
        ),
      ),
    );
  }
}
