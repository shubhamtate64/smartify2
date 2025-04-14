class RegistrationModel {
  String firstName;
  String lastName;
  String email;
  String password;
  String mobileNo;
  String gender;
  late String passcode;

  RegistrationModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.mobileNo,
    required this.gender,
    required this.passcode,
  });

  // Convert RegistrationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'mobile_no': mobileNo,
      'gender': gender,
       'passcode': passcode,
    };
  }

  // Convert JSON to RegistrationModel
  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password'],
      mobileNo: json['mobile_no'],
      gender: json['gender'],
      passcode: json['passcode'],
    );
  }
}
