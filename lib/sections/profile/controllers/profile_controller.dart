import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();
  RxBool isTransactionUpdatesEnabled = true.obs;
  RxBool isTripUpdatesEnabled = true.obs;
  RxBool isOffersNotificationEnabled = true.obs;
  RxBool isInterCity = true.obs;
  RxBool isIntraCity = true.obs;
  @override
  void onInit() {
    isTransactionUpdatesEnabled.value =
        _profileService.isTransactionUpdatesEnabled;
    isTripUpdatesEnabled.value = _profileService.isTripUpdatesEnabled;
    isOffersNotificationEnabled.value =
        _profileService.isOffersNotificationEnabled;
    isInterCity.value=_profileService.isInterCity;
    isIntraCity.value=_profileService.isIntraCity;
    super.onInit();
  }

  setTransUpd(bool value) {
    _profileService.isTransactionUpdatesEnabled = value;
    isTransactionUpdatesEnabled.value = value; // Ensure that RxBool is updated
  }

  setTripUpd(bool value) {
    _profileService.isTripUpdatesEnabled = value;
    isTripUpdatesEnabled.value = value; // Ensure that RxBool is updated
  }

  setOfferUpd(bool value) {
    _profileService.isOffersNotificationEnabled = value;
    isOffersNotificationEnabled.value = value; // Ensure that RxBool is updated
  }

  setInterUpd(bool value) {
    _profileService.isInterCity = value;
    isInterCity.value = value;
    update();// Ensure that RxBool is updated
  }

  setIntraUpd(bool value) {

    _profileService.isIntraCity = value;
    isIntraCity.value = value; // Ensure that RxBool is updated
    update();
  }
}

class ProfileService {
  final Box _box = Hive.box('profileBox');

  set isInterCity(bool value) => _box.put('isInterCity', value);
  bool get isInterCity => _box.get('isInterCity', defaultValue: true);
  set isIntraCity(bool value) => _box.put('isIntraCity', value);
  bool get isIntraCity => _box.get('isIntraCity', defaultValue: true);
  bool get isTransactionUpdatesEnabled =>
      _box.get('isTransactionUpdatesEnabled', defaultValue: true);

  set isTransactionUpdatesEnabled(bool value) =>
      _box.put('isTransactionUpdatesEnabled', value);

  bool get isTripUpdatesEnabled =>
      _box.get('isTripUpdatesEnabled', defaultValue: true);

  set isTripUpdatesEnabled(bool value) =>
      _box.put('isTripUpdatesEnabled', value);

  bool get isOffersNotificationEnabled =>
      _box.get('isOffersNotificationEnabled', defaultValue: true);

  set isOffersNotificationEnabled(bool value) =>
      _box.put('isOffersNotificationEnabled', value);
}
