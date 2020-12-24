import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:taxiapp/app/locator.dart';
import 'package:taxiapp/services/auth_social_network_service.dart';

class ProfileViewModel extends BaseViewModel {
  final AuthSocialNetwork _authSocialNetwork = locator<AuthSocialNetwork>();
  BuildContext _context;

  ProfileViewModel(BuildContext context) : _context = context;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Getters
  GlobalKey<FormState> get formKey => _formKey;

  // * Functions
}
