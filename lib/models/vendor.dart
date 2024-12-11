import 'dart:convert';

class Vendor {
  final String id;
  final String fullName;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String role;
  final String password;

  Vendor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.role,
    required this.password
  });

  //sử dụng khi cần tuần tự hóa đối tượng User hoặc truyền nó qua các API
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      'fullName': fullName,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'role': role,
      'password': password
    };
  }

  //Convert object User to json
  //Từ user -> Map,dùng encode để chuyển thằng map thành json
  String toJson() => jsonEncode(toMap());


  // Mỗi thuộc tính của User được lấy từ cặp khóa-giá trị tương ứng trong Map.
  // Nếu bất kỳ khóa nào không tồn tại trong Map, nó sẽ được mặc định là chuỗi rỗng ("").
  factory Vendor.fromMap(Map<String,dynamic> map) {
    return Vendor (
      id: map['_id'] as String? ?? "",
      fullName: map['fullName'] as String? ?? "",
      email: map['email'] as String? ?? "",
      state: map['state'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      role: map['role'] as String? ?? "",
      password: map['password'] as String? ?? ""
    );
  }


  //nhận dữ liệu JSON từ một API
  //chuyển đổi nó thành đối tượng User trong ứng dụng.
  factory Vendor.fromJson(String source) =>
      Vendor.fromMap(json.decode(source) as Map<String, dynamic>);
}