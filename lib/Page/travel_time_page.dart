import 'package:flutter/material.dart';

class TravelTime extends StatefulWidget {
  @override
  _TravelTimeState createState() => _TravelTimeState();
}

class _TravelTimeState extends State<TravelTime> {
  DateTime pickedDate;
  TimeOfDay time;

  @override
  void initState() {
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(2.0),
            height: 50,
            width: double.infinity,
            child: Center(
              child: Text(
                "Programar un viaje",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Divider(),
          InkWell(
            child: Container(
              margin: const EdgeInsets.all(2.0),
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(
                  "${pickedDate.day}, ${pickedDate.month}, ${pickedDate.year}",
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            onTap: _pickDate,
          ),
          Divider(),
          InkWell(
            child: Container(
              margin: const EdgeInsets.all(2.0),
              height: 50,
              width: double.infinity,
              child: Center(
                child: Text(
                  "${time.format(context)} - ${time.hour}:${time.minute + 10}",
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
            onTap: _pickTime,
          ),
          Divider(),
          RaisedButton(
            onPressed: () {},
            color: Colors.black,
            highlightElevation: 0,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              child: Text(
                "FIJAR HORA DEL VIAJE",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 8)
        ],
      ),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (date != null)
      setState(() {
        pickedDate = date;
      });
    {}
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);

    if (t != null)
      setState(() {
        time = t;
      });
    {}
  }
}
