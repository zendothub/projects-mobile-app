import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zen_mobile/models/user_profile_model.dart';
import 'package:zen_mobile/models/user_setting_model.dart';
import 'package:zen_mobile/services/dio_service.dart';
import '../config/apis.dart';
import '../utils/enums.dart';

class ProfileService {
  ProfileService(this.dio);
  DioConfig dio;

  Future<Either<UserProfile, DioException>> getProfile() async {
    try {
      final response = await dio.dioServe(
        hasAuth: true,
        url: '${APIs.baseApi}${APIs.profile}',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left(UserProfile.fromMap(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  Future<Either<UserSettingModel, DioException>> getProfileSetting() async {
    try {
      final response = await dio.dioServe(
        hasAuth: true,
        url: '${APIs.baseApi}${APIs.profile}settings/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      return Left(UserSettingModel.fromJson(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(err);
    }
  }

  Future<Either<UserProfile, DioException>> updateProfile(
      {required Map data}) async {
    try {
      final response = await dio.dioServe(
          hasAuth: true,
          url: APIs.baseApi + APIs.profile,
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: data);
      return Left(UserProfile.fromMap(response.data));
    } on DioException catch (err) {
      log(err.response.toString());
      return Right(DioException(requestOptions: RequestOptions()));
    }
  }
}
