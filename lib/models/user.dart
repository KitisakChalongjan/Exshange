class UserModel {
  String id;
  List<Map<String, dynamic>> _addresses;
  String _email;

  UserModel(this.id, this._addresses, this._email);

  get addresses {
    return _addresses;
  }

  get email {
    return _email;
  }
}
