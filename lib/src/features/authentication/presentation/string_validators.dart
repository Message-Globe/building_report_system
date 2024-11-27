import 'package:flutter/services.dart';

/// This file contains some helper functions used for string validation.

abstract class StringValidators {
  bool isValid(String value);
}

class RegexValidator implements StringValidators {
  final String regexSource;

  RegexValidator({required this.regexSource});

  @override
  bool isValid(String value) {
    try {
      // https://regex101.com/
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (final match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  final StringValidators editingValidator;

  ValidatorInputFormatter({required this.editingValidator});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final bool oldValueValid = editingValidator.isValid(oldValue.text);
    final bool newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class EmailEditingRegexValidator extends RegexValidator {
  EmailEditingRegexValidator() : super(regexSource: '^(|\\S)+\$');
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator() : super(regexSource: '^\\S+@\\S+\\.\\S+\$');
}

class PasswordSubmitRegexValidator extends RegexValidator {
  PasswordSubmitRegexValidator()
      : super(
          regexSource:
              r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$',
        );
}

class NonEmptyStringValidator extends StringValidators {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class MinLengthStringValidator extends StringValidators {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength;
  }
}
