import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koishi/components/user_input_helper.dart';
import 'package:koishi/models/api_exception.dart';
import 'package:koishi/models/collection_model.dart';
import 'package:koishi/models/collection_model_value.dart';
import 'package:koishi/services/http_service.dart';
import 'package:koishi/services/koishi_api/collections_service.dart';

class AddRecordScreen extends StatefulWidget {
  final String collectionId;
  final String collectionTitle;

  const AddRecordScreen({
    Key? key,
    required this.collectionId,
    required this.collectionTitle,
  }) : super(key: key);

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final GlobalKey<FormState> _addRecordScreenFormKey = GlobalKey<FormState>();
  Map<String, Map<String, dynamic>> fields = <String, Map<String, dynamic>>{};
  late CollectionModel collectionModel;
  bool loading = true;
  List<dynamic> submitError = [];

  Future<void> _loadFields() async {
    if (!(await HttpService.checkInternetConnectionWithDialog(_loadFields))) {
      return;
    }
    CollectionModel model =
        await KoishiApiCollectionsService.getModel(widget.collectionId);
    for (CollectionModelValue m in model.value) {
      setState(() {
        fields[m.columnName] = {
          "controller": TextEditingController(),
          "unit": m.unit,
          "dataType": m.dataType,
        };
      });
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _handleSubmitRow() async {
    if (!(await HttpService.checkInternetConnection())) return;
    List<dynamic> payload = [];
    for (String x in fields.keys) {
      // Cast text to the original var type
      String i = fields[x]!["controller"].text;
      var val = int.tryParse(i) ?? i; // ...cast as int
      if (val.runtimeType != int) {
        val = double.tryParse(i) ?? i; // ...cast as double
      }
      if (val is String && val == "true" || val == "false") {
        val = i == "true"; // ...cast as boolean
      }
      // ...leave it as a String

      payload.add({"column": x, "data": val});
    }

    try {
      await KoishiApiCollectionsService.addRow(widget.collectionId, payload);
    } catch (ex) {
      if ((ex as ApiException).statusCode == 400) {
        // 400 - Bad request
        print(ex.body);
        setState(() {
          submitError = jsonDecode(ex.body) as List<dynamic>;
        });
        return;
      } else {
        // Some other error
        // TODO: implement generic error handling
      }
    }

    Get.back();
    Get.snackbar("Row added", "A row added to ${widget.collectionTitle}");
  }

  List<Widget> _renderForm() {
    List<Widget> render = List<Widget>.empty(growable: true);

    // Form header
    render.add(Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 15),
      child: Text(
        "New row",
        style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: 24),
      ),
    ));

    // Inputs
    render.addAll(fields.keys.map((e) {
      Widget child = Container();

      switch (fields[e]!["dataType"]) {
        case "text":
          child = InputHelper.renderTextInput(
            hint: e,
            controller: fields[e]!["controller"],
          );
          break;
        case "number":
          child = InputHelper.renderNumberInput(
            hint: e,
            controller: fields[e]!["controller"],
          );
          break;
        case "time":
          child = InputHelper.renderTimeInput(
              hint: e, controller: fields[e]!["controller"]);
          break;
        case "date":
          child = InputHelper.renderDateInput(
            hint: e,
            controller: fields[e]!["controller"],
          );
          break;
        case "bool":
          child = InputHelper.renderSwitch(
              value: (fields[e]!["controller"] as TextEditingController).text ==
                  "true",
              onChange: (v) {
                setState(() {
                  (fields[e]!["controller"] as TextEditingController).text =
                      v.toString();
                });
              },
              hint: e);
          break;
        default:
          child = InputHelper.renderTextInput(
            hint: e,
            controller: fields[e]!["controller"],
          );
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
        child: child,
      );
    }).toList());

    // Submit button
    render.add(ElevatedButton(
      onPressed: _handleSubmitRow,
      child: const Text("Submit"),
    ));

    // Submit error messages
    render.addAll(submitError.map(
      (e) => Text(
        e,
        style: const TextStyle(color: Colors.red),
      ),
    ));

    return render;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _loadFields);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.collectionTitle,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w400,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
      body: (!loading)
          ? SingleChildScrollView(
              child: Form(
                key: _addRecordScreenFormKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _renderForm(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
