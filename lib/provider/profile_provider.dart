import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zen_mobile/config/apis.dart';
import 'package:zen_mobile/models/user_profile_model.dart';
import 'package:zen_mobile/models/user_setting_model.dart';
import 'package:zen_mobile/repository/profile_provider_service.dart';
import 'package:zen_mobile/services/dio_service.dart';
import 'package:zen_mobile/utils/enums.dart';
import '../services/shared_preference_service.dart';
import '../utils/timezone_manager.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({required this.profileService});
  ProfileService profileService;
  String? dropDownValue;
  String selectedTimeZone = 'UTC';
  String? slug;

  List<String> dropDownItems = [
    'Founder or learship team',
    'Product manager',
    'Designer',
    'Software developer',
    'Freelancer',
    'Other'
  ];
  String theme = 'Light';
  int roleIndex = -1;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  StateEnum getProfileState = StateEnum.empty;
  StateEnum updateProfileState = StateEnum.empty;
  UserProfile userProfile = UserProfile.initialize();
  UserSettingModel userSetting = UserSettingModel.initialize();

  void changeIndex(int index) {
    roleIndex = index;
    dropDownValue = dropDownItems[index];
    notifyListeners();
  }

  void setState() {
    notifyListeners();
  }

  void changeTheme(String theme) {
    this.theme = theme;
    notifyListeners();
  }

  void clear() {
    firstName.clear();
    lastName.clear();
    dropDownValue = null;
    userProfile = UserProfile.initialize();
  }

  void setName() {
    userProfile = UserProfile.initialize(firstName: 'TESTER');
    notifyListeners();
  }

  Future<Either<UserProfile, DioException>> getProfile() async {
    getProfileState = StateEnum.loading;
    final response = await profileService.getProfile();

    return response.fold((userProfile) {
      this.userProfile = userProfile;
      SharedPrefrenceServices.setTheme(userProfile!.theme!);
      SharedPrefrenceServices.setUserID(userProfile.id!);
      firstName.text = userProfile.firstName!;
      lastName.text = userProfile.lastName!;
      getProfileState = StateEnum.success;
      selectedTimeZone = userProfile.userTimezone.toString();
      TimeZoneManager.findLabelFromTimeZonesList(selectedTimeZone) ??
          'UTC, GMT';
      notifyListeners();
      return Left(userProfile);
    }, (error) {
      log(error.toString());
      getProfileState = StateEnum.error;
      notifyListeners();
      return Right(error);
    });
  }

  Future<Either<UserSettingModel, DioException>> getProfileSetting() async {
    final response = await profileService.getProfileSetting();
    return response.fold((userSetting) {
      this.userSetting = userSetting;
      return Left(userSetting);
    }, (error) {
      log(error.toString());
      return Right(error);
    });
  }

  Future<Either<UserProfile, DioException>> updateProfile(
      {required Map data}) async {
    updateProfileState = StateEnum.loading;
    notifyListeners();
    final response = await profileService.updateProfile(data: data);
    if (response.isLeft()) {
      userProfile = response.fold((l) => l, (r) => UserProfile.initialize());
      SharedPrefrenceServices.setTheme(userProfile.theme!);
      updateProfileState = StateEnum.success;
      notifyListeners();
    } else {
      log(response.fold((l) => l.toString(), (r) => r.toString()));
      updateProfileState = StateEnum.error;
      notifyListeners();
    }
    return response;
  }

  Future updateIsOnBoarded({required bool val}) async {
    try {
      await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.isOnboarded,
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: {"is_onboarded": val});
      userProfile.isOnboarded = val;
      return val;
    } on DioException catch (e) {
      log(e.error.toString());
    }
  }

  Future deleteAvatar() async {
    updateProfileState = StateEnum.loading;
    notifyListeners();
    try {
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: "${APIs.fileUpload}${userProfile.avatar!.split('/').last}/",
        hasBody: false,
        httpMethod: HttpMethod.delete,
      );
      log(response.statusCode.toString());
      await updateProfile(data: {"avatar": ""});
      updateProfileState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      log(e.error.toString());
      updateProfileState = StateEnum.error;
      notifyListeners();
    }
  }
}
