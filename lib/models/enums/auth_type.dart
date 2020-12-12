enum AuthType {
  User,
  Google,
  Facebook
}

class AuthTypeHelper {
  static AuthType getUserFromString(String userType) {
    for (var element in AuthType.values) {
      if (element.toString().split('.')[1].toLowerCase() == userType.toLowerCase()) {
        return element;
      }
    }
    return null;
  }
}
