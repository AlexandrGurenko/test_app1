class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String photo;

  User({this.id, this.firstName, this.lastName, this.email, this.photo});

  factory User.fromJson(Map<String, dynamic> json) {

    var name = json['name'];
    var photo = json['picture'];

    return User(
      firstName: name['first'],
      lastName: name['last'],
      email: json['email'],
      photo: photo['large']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'photo': photo
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    firstName = map['first_name'];
    lastName = map['last_name'];
    email = map['email'];
    photo = map['photo'];
  }

}