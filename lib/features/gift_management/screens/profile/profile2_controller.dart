import 'package:hedyety/Repository/shred_pref.dart';
import 'package:hedyety/features/gift_management/models/event_model.dart';
import 'package:hedyety/features/gift_management/models/gift_model.dart';

class Profile2Controller {
  List events = [];
  List gifts = [];

  Future readEvents() async {
    events.clear();
    List<Map> res =
        await EventModel.getEvents(await SharedPref().getCurrentUid());
    events.addAll(res);
    print('readEvents $events');
    gifts.clear();
    for (int i = 0; i < events.length; i++) {
      await readGifts(events[i]['ID']);
    }
    return events;
  }

  Future readGifts(id) async {
    List<Map> res = await GiftModel.getGifts(id);
    gifts.add(res);
    print('readGifts $gifts');
    return gifts;
  }
}
