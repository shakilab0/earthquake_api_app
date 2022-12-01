
import 'package:earth_quake/providers/earth_quake_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/helper_functions.dart';




class HomePage extends StatefulWidget {
  static const String routeName="/";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late EarthQuakeProvider earthQuakeProvider;

  DateTime? startDate;
  DateTime? endDate;
  double magnitude = 5.0;


  @override
  void didChangeDependencies() {
    Provider.of<EarthQuakeProvider>(context, listen: false).getEarthQuakeDetails();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Data'),
      ),
      body: Consumer<EarthQuakeProvider>(
        builder:(context, provider, child) => Column(
          children: [
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    _selectDate(true);
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(startDate == null
                      ? 'Start Date'
                      : getFormattedDate(startDate!)),
                ),
                TextButton.icon(
                  onPressed: () {
                    _selectDate(false);
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                      endDate == null ? 'End Date' : getFormattedDate(endDate!)),
                ),
                DropdownButton<double>(
                  value: magnitude,
                  onChanged: (value) {
                    setState(() {
                      magnitude = value!;
                    });
                  },
                  items: magList
                      .map((e) => DropdownMenuItem<double>(
                    value: e,
                    child: Text(e.toString()),
                  ))
                      .toList(),
                ),
                TextButton(
                  onPressed: _getData,
                  child: const Text('GO'),
                )
              ],
            ),
            Expanded(
              child: provider.hasDataLoaded ? ListView.builder(
                itemCount: provider.earthQuakeResponse!.features!.length,
                itemBuilder: (context, index) {
                  final features = provider.earthQuakeResponse!.features![index];
                  final properties = features.properties;
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(properties!.mag.toString()),
                    ),
                    title: Text(properties.place.toString()),
                    subtitle: Text(getFormattedDate(DateTime.fromMillisecondsSinceEpoch(properties.time!.toInt()))),
                  );
                },
              ) : const Center(child: CircularProgressIndicator(),),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if(selectedDate != null) {
      setState(() {
        if(isStartDate) {
          startDate = selectedDate;
        } else {
          endDate = selectedDate;
        }
      });
    }
  }

  void _getData() {
    if(startDate == null) {
      return;
    }
    if(endDate == null) {
      return;
    }
    Provider.of<EarthQuakeProvider>(context, listen: false)
        .getEarthQuakeDetails(startDate: getFormattedDate(startDate!), endDate: getFormattedDate(endDate!), magnitude: magnitude);
  }
}



