import 'package:email_validator/email_validator.dart';

class Validator {
  //validate email address
  bool validateEmail(String email) {
    final bool isValid = EmailValidator.validate(email.trim());
    return isValid;
  }
}
