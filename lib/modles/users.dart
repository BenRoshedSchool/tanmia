class Users {
  final int pass;
  final String userName;


  Users({
    required this.pass,
    required this.userName,
  });

  // Factory method to create a UserInfo instance from a JSON map
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      pass: json['pass'],
      userName: json['user_name'],

    );
  }

  // Method to convert UserInfo instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'pass': pass,
      'user_name': userName,

    };
  }
}
