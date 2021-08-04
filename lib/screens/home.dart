import 'package:exhange_rates_flutter/functions/fetchrates.dart';
import 'package:exhange_rates_flutter/models/jsonmodel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<RatesModel> result;
  @override
  void initState() {
    super.initState();
    setState(() {
      result = fetchrates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Open Exchange Flutter')),
        body: FutureBuilder<RatesModel>(
          future: result,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/currency.jpeg'),
                      fit: BoxFit.cover)),
              child: Text(snapshot.data!.base),
            );
          },
        ));
  }
}
