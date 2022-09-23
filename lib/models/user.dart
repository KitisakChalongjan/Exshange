import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserModel {
  String _id;
  List<Map<String, dynamic>> _addresses;
  String _email;
  String _profileImgUrl;

  UserModel(this._id, this._addresses, this._email, this._profileImgUrl);

  List<Map<String, dynamic>> get addresses {
    return _addresses;
  }

  String get email {
    return _email;
  }

  String get profileImgUrl{
    return _profileImgUrl;
  }

  @override
  String toString() {
    // TODO: implement toString
    return '${_id}, ${_addresses}, ${_email}, ${_profileImgUrl}';
  }
}
