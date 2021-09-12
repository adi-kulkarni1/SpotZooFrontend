import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeForm extends StatefulWidget {
  int docid;

  DateTimeForm({Key key, this.docid}) : super(key: key);

  @override
  _DateTimeFormState createState() => _DateTimeFormState();
}

class _DateTimeFormState extends State<DateTimeForm> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();
  TextEditingController _controller1;
  TextEditingController _controller2;
  TextEditingController _controller3;
  TextEditingController _controller4;
  //String _initialValue;
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';
  String _valueChanged3 = '';
  String _valueToValidate3 = '';
  String _valueSaved3 = '';
  String _valueChanged4 = '';
  String _valueToValidate4 = '';
  String _valueSaved4 = '';

  @override
  void initState() {
    super.initState();
    getdocid();
    //Intl.defaultLocale = 'pt_BR';
    //_initialValue = DateTime.now().toString();
    _controller1 = TextEditingController(text: DateTime.now().toString());
    _controller2 = TextEditingController(text: DateTime.now().toString());
    _controller3 = TextEditingController(text: DateTime.now().toString());

    String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
    String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');
    _controller4 = TextEditingController(text: '$lsHour:$lsMinute');

    //_getValue(); commented out for now, future method is not useful
  }

  // This implementation is just to simulate a load data behavior
  // from a data base sqlite or from a API
  Future<void> _getValue() async {
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        //_initialValue = '2000-10-22 14:30';
        //_controller1.text = '2021-09-20 14:30';
        //_controller2.text = '2021-10-21 15:31';
        //_controller3.text = '2020-11-22';
        //_controller4.text = '17:01';
      });
    });
  }

  void getdocid() {
    FirebaseFirestore.instance
        .collection("Doc_ID_Data")
        .doc("Doc_ID_ID")
        .get()
        .then((value) {
      widget.docid = value.get("doc_id_counter");
      //print(widget.docid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _oFormKey,
      child: Column(
        children: <Widget>[
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            controller: null, // controller: _controller1,
            //initialValue: _initialValue,
            firstDate: DateTime(2021),
            lastDate: DateTime.now(),
            icon: Icon(Icons.event),
            dateLabelText: 'Date',
            timeLabelText: "Hour",
            use24HourFormat: false,
            //locale: Locale('pt', 'BR'),
            //selectableDayPredicate: (date) {
            //  if (date.weekday == 6 || date.weekday == 7) {
            //    return false;
            //  }
            //  return true;
            //},
            onChanged: (val) {
              setState(() {
                _valueChanged1 = val;
                getdocid();
                FirebaseFirestore.instance
                    .collection("Formdata")
                    .doc("Response_" + widget.docid.toString())
                    //  .doc("Test")
                    .set({'date': val, 'timestamp': Timestamp.now()}, SetOptions(merge: true));
              });
            },
            validator: (val) {
              setState(() => _valueToValidate1 = val);
              return null;
            },
            onSaved: (val) {
              setState(() {
                _valueSaved1 = val;
              });
            },
          )
        ],
      ),
    );
  }
}
