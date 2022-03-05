import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class InputHelper {
  static TextFormField renderTextInput({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
      ),
      cursorColor: Colors.black,
    );
  }

  static TextFormField renderNumberInput({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
      ),
      cursorColor: Colors.black,
    );
  }

  static DateTimePicker renderTimeInput({
    required String hint,
    required TextEditingController controller,
  }) {
    return DateTimePicker(
      type: DateTimePickerType.time,
      timeHintText: hint,
      controller: controller,
    );
  }

  static DateTimePicker renderDateInput({
    required String hint,
    required TextEditingController controller,
  }) {
    Color c = const Color(0xFF1138f7);
    return DateTimePicker(
      cursorColor: c,
      type: DateTimePickerType.date,
      dateHintText: hint,
      initialDate: DateTime.now(),
      firstDate: DateTime(0),
      lastDate: DateTime(3000),
      controller: controller,
    );
  }

  static Widget renderSwitch({
    required bool value,
    required Function onChange,
    required String hint,
  }) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(hint),
        ),
        CupertinoSwitch(
          value: value,
          onChanged: (v) => onChange(v),
          activeColor: const Color(0xFF1138f7),
        ),
      ],
    );
  }
}
