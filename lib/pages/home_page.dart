import 'package:earth_quake/model/earth_quake_response.dart';
import 'package:earth_quake/providers/earth_quake_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../utils/helper_functions.dart';
import '../utils/text_style.dart';



class HomePage extends StatefulWidget {
  static const String routeName="/";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late EarthQuakeProvider earthQuakeProvider;

  // DateTime? startDate;
  // String endDate=getFormattedDate(DateTime.now(),pattern: 'yyyy-MM-dd');
  // double magnitude = 5.0;

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


//
//
//
//   @override
//   void didChangeDependencies() {
//     if(isCallOnce){
//       earthQuakeProvider=Provider.of<EarthQuakeProvider>(context);
//       _getData();
//     }
//     isCallOnce=false;
//     super.didChangeDependencies();
//   }
//
//   void _getData(){
//       earthQuakeProvider.getData();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text('Earth Quake '),
//
//       ),
//
//       body: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Selectdate"),
//                         IconButton(onPressed: (){
//                          // _selectDate();
//                         },
//                           icon: const Icon(Icons.calendar_month),
//                         ),
//                         Text(lastDate)
//                         //Text(startDate==null? "no date chosen": getFormattedDate(purchaseDate!)),
//                       ],
//                     ),
//                   ),
//               ),
//
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text("Selectdate"),
//                       IconButton(onPressed: (){
//                         //_selectDate();
//                       },
//                         icon: const Icon(Icons.calendar_month),
//
//                       ),
//                       Text(lastDate)
//                       //Text(lastDate==null? "no date chosen": getFormattedDate(purchaseDate!)),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     const Text("QuakeVolt"),
//                     Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: DropdownButtonFormField<String>(
//                           decoration:InputDecoration(
//                               border:OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(6),
//                                 borderSide:const BorderSide(
//                                   color: Colors.blue,
//                                   width: 2,
//                                 ),
//                               )
//                           ),
//                           items: quakeVoltList.map((e) => DropdownMenuItem(value:e,child:Text(e))).toList(),
//                           value: quakeVolt,
//                           onChanged: (value){
//                             setState(() {
//                               quakeVolt=value!;
//                             });
//                           }
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             ],
//           ),
//         ],
//       ),
//
//       // body:earthQuakeProvider.hasDataLoaded ? ListView(
//       //   children: [
//       //     _quakeDetails(),
//       //   ],
//       // )
//       //     : const Center(
//       //   child: Text('Please wait'),
//       // ),
//
//     );
//   }
//
//
//   Widget _quakeDetails() {
//     final quakeList = earthQuakeProvider.earthQuakeResponse!.features!;
//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: quakeList
//                 .map((item) => Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 4.0, vertical: 8.0),
//               child: Row(
//                 children: [
//                   // Expanded(
//                   //   child: Text(
//                   //     getFormattedDate(item.dt!, pattern: 'EEE, HH:mm'),
//                   //     style: txtDate16,
//                   //   ),
//                   // ),
//                   Expanded(
//                     child: Text('${item.id!}',
//                       style: txtDate16,
//                     ),
//                   ),
//                   Expanded(
//                     child: Text("${item.geometry!}",
//                       style: txtDate16,
//                     ),
//                   ),
//                 ],
//               ),
//             ))
//                 .toList(),
//           ),
//         );
//   }
//
//   void _selectDate()async {
//     final date=await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(DateTime.now().year-1),
//       lastDate: DateTime.now(),
//     );
//     if(date!=null){
//       setState(() {
//         //purchaseDate=date;
//       });
//     }
//   }
//
//
//
// }
//
//