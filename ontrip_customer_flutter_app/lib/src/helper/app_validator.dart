import '../../app_export.dart';

class AppValidator {
  AppValidator._();

  factory AppValidator() => AppValidator._();

  static String? mobileNumberValidator(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return "Please enter phone number";
    } else {
      if (phone.trim().startsWith('0')) {
        return 'Mobile number can\'t  start with 0';
      } else if (phone.trim().length != 10) {
        return "Invalid number";
      } else {
        return null;
      }
    }
  }

  static String? emailValidator(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Please enter email address';
    } else {
      Pattern pattern = r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
      RegExp regexp = RegExp(pattern.toString());
      if (regexp.hasMatch(email.trim())) {
        return null;
      } else {
        return "Please enter valid email";
      }
    }
  }

  static String? notEmptyValidator(String? value, String error) {
    if (value != null && value.trim().isNotEmpty) return null;
    return error;
  }

  static String? mobileNumberNotRequiredValidator(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return null;
    } else {
      if (phone.trim().startsWith('0')) {
        return 'Mobile number can\'t  start with 0';
      } else if (phone.trim().length != 10) {
        return "Invalid number";
      } else {
        return null;
      }
    }
  }

  static String? emailNotRequiredValidator(String? email) {
    if (email == null || email.trim().isEmpty) {
      return null;
    } else {
      Pattern pattern = r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
      RegExp regexp = RegExp(pattern.toString());
      if (regexp.hasMatch(email.trim())) {
        return null;
      } else {
        return "Please enter valid email";
      }
    }
  }

  String? newRequiredMobileValidator(PhoneNumber? phoneNumber) {
    if (phoneNumber != null && phoneNumber.number.trim().isNotEmpty) {
      return null;
    } else {
      return "Please provide number";
    }
  }

  String? newNotRequiredMobileValidator(PhoneNumber? phoneNumber) => null;

  static final mobileInputFormatters = <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9]'))];
  static final realPositiveFormatters = <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))];
}
