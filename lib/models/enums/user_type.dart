enum UserType {
  Client,
  Driver,
  Admin
}

class UserTypeHelper {
  static UserType getUserFromString(String userType) {
    for (var element in UserType.values) {
      if (element.toString().split('.')[1].toLowerCase() == userType.toLowerCase()) {
        return element;
      }
    }
    return null;
  }
}
