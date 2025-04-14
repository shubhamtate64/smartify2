import 'package:get/get.dart';


class UserModel {
  var passcode = "".obs;
  var firstName = "".obs;
  var lastName = "".obs;
  var name = "".obs;
  var address = "".obs;
  var email = "".obs;
  var gender = "".obs;
  var mobileNo = "".obs;
  var userType = "".obs;
  var token = "".obs;
  var id = "".obs;
  var role = "".obs;
  var devices = "".obs;
  var activeFlag = "".obs;
  var parentId = "".obs;
  var requestStatus = "".obs;
  var imgpath = "".obs;

  UserModel({
    required String passcode,
    required String firstName,
    required String lastName,
    required String name,
    required String address,
    required String email,
    required String gender,
    required String mobileNo,
    required String userType,
    required String token,
    required String id,
    required String role,
    required String devices,
    required String activeFlag,
    required String parentId,
    required String requestStatus,
    required String imgpath,
  }) {
    this.passcode.value = passcode;
    this.firstName.value = firstName;
    this.lastName.value = lastName;
    this.name.value = name;
    this.address.value = address;
    this.email.value = email;
    this.gender.value = gender;
    this.mobileNo.value = mobileNo;
    this.userType.value = userType;
    this.token.value = token;
    this.id.value = id;
    this.role.value = role;
    this.devices.value = devices;
    this.activeFlag.value = activeFlag;
    this.parentId.value = parentId;
    this.requestStatus.value = requestStatus;
    this.imgpath.value = imgpath;
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      passcode: data["passcode"].toString(),
      firstName: data["firstName"] ?? "",
      lastName: data["lastName"] ?? "",
      name: data["name"] ?? "",
      address: data["address"] ?? "",
      email: data["email"] ?? "",
      gender: data["gender"] ?? "Other",
      mobileNo: data["contact"] ?? "",
      userType: data["userType"] ?? "User",
      token: data["token"] ?? "",
      id: data["id"].toString(),
      role: data["role"] ?? "",
      devices: data["devices"] ?? "0",
      activeFlag: data["activeFlag"] ?? "N",
      parentId: data["parentId"].toString(),
      requestStatus: data["requestStatus"] ?? "",
      imgpath: data["imgpath"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "passcode": passcode.value,
      "firstName": firstName.value,
      "lastName": lastName.value,
      "name": name.value,
      "address": address.value,
      "email": email.value,
      "gender": gender.value,
      "mobileNo": mobileNo.value,
      "userType": userType.value,
      "token": token.value,
      "id": id.value,
      "role": role.value,
      "devices": devices.value,
      "activeFlag": activeFlag.value,
      "parentId": parentId.value,
      "requestStatus": requestStatus.value,
      "imgpath": imgpath.value,
    };
  }
}
