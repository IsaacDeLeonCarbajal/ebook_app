import 'package:ebook_app/app/components/form_padding.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Helper {
  /// Validate that all of the [attributes] has a value if the attribute name is defined in the [requiredAttrs]
  static bool validateRequired({
    required Map<String, dynamic> attributes,
    List<String> requiredAttrs = const [],
  }) {
    bool error = false; // Initialize flag

    // If there are no required attributes specification, all of them are required
    requiredAttrs = requiredAttrs.isEmpty ? attributes.keys.toList() : requiredAttrs;

    attributes.forEach((key, value) {
      // Check that all values are defined if they are required
      if (requiredAttrs.contains(key) && !Helper.validateValue(value)) {
        error = true; // There is an error
      }
    });

    if (error) {
      Fluttertoast.showToast(msg: 'There is missing required information', backgroundColor: Colors.red);
    }

    return !error;
  }

  /// Validate that [value] is not empty, null, false or 0
  static bool validateValue(dynamic value) {
    return !["", null, false, 0].contains(value);
  }

  /// Get a value from a map, or a default value if not present or null
  static T getMapValue<T>(Map? data, String name, {T? defaultValue}) {
    if (data == null || !data.containsKey(name) || (data[name] == null && null is! T)) {
      if (defaultValue is T) {
        return defaultValue;
      }

      switch (T) {
        case int:
        case double:
          return 0 as T;
        case String:
          return '' as T;
        case bool:
          return false as T;
        case List:
          return [] as T;
        case Map:
          return {} as T;
        case DateTime:
          return DateTime(1900) as T;
        default:
          return data?[name] as T;
      }
    }

    if (T == String || T == Helper.identityType<String?>()) {
      return (data[name] != null ? data[name].toString() : data[name]) as T;
    } else if (T == int) {
      return int.parse(data[name].toString()) as T;
    } else if (T == Helper.identityType<int?>()) {
      return int.tryParse(data[name].toString()) as T;
    } else if (T == double) {
      return double.parse(data[name].toString()) as T;
    } else if (T == Helper.identityType<double?>()) {
      return double.tryParse(data[name].toString()) as T;
    } else if (T == DateTime && data[name] is String) {
      return DateTime.parse(data[name]) as T;
    } else if (T == Helper.identityType<DateTime?>() && data[name] is String) {
      return DateTime.tryParse(data[name]) as T;
    } else {
      return data[name];
    }
  }

  /// Returns the runtime type of the provided generic type parameter
  static Type identityType<T>() => T;

  /// Convert a [date] into a valid database value formatted string
  static String convertDateToField(DateTime? date) {
    return date != null ? DateFormat('yyyy-MM-dd', 'es').format(date) : '';
  }

  /// Convert a [date] into a readable value formatted string
  static String convertDateToText(DateTime? date) {
    return date != null ? DateFormat('yyyy MMM dd', 'es').format(date) : '';
  }

  /// Convert a string [value] into a DateTime object
  static DateTime? convertStringToDate(String value) {
    return DateTime.tryParse(value);
  }

  /// Show an alert dialog with two buttons, confirm and cancel
  /// Return true on confirm, false on cancel
  static Future<bool?> confirmationDialog(BuildContext context, String title, String message) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// Show an alert dialog with one button, accept
  /// Return true on accept
  static Future<bool?> acceptDialog(BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  /// Show a date picker to select a date
  /// Send the selected DateTime to the [onPicked] function
  static void selectDate(
    BuildContext context, {
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required Function(DateTime? picked) onPicked,
  }) async {
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ).then(onPicked);
  }

  /// Get the total width of the available screen space
  /// This width is without the horizontal padding of a form
  static double getTotalWidth(BuildContext context) {
    return MediaQuery.of(context).size.width - (FormPadding.horizontalPadding * 2);
  }

  /// Limit the length of a string
  static String limitString(String text, {int limit = 10, String end = '...'}) {
    return text.length > limit ? '${text.substring(0, limit)}$end' : text;
  }
}
