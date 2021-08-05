import 'package:exhange_rates_flutter/functions/fetchrates.dart';
import 'package:exhange_rates_flutter/models/ratesmodel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Initial Variables
  String dropdownValue = 'AUD';
  String answer = 'Converted Currency will be shown here :)';
  late Future<Map> allcurrencies;
  late Future<RatesModel> result;
  TextEditingController usdController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  //Getting RatesModel and All Currencies
  @override
  void initState() {
    super.initState();
    setState(() {
      result = fetchrates();
      allcurrencies = fetchcurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Open Exchange Flutter')),

        //Future Builder for Getting Exchange Rates
        body: Form(
          key: formkey,
          child: FutureBuilder<RatesModel>(
            future: result,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/currency.jpeg'),
                        fit: BoxFit.cover)),
                child: Center(
                  child: Card(
                    child: Container(
                        width: 500,
                        padding: EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Open Currency Exchange WebApp',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                              SizedBox(height: 20),

                              //TextFields for Entering USD
                              TextFormField(
                                key: ValueKey('usd'),
                                controller: usdController,
                                decoration:
                                    InputDecoration(hintText: 'Enter USD'),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  //Future Builder for getting all currencies for dropdown list
                                  Expanded(
                                    child: FutureBuilder<Map>(
                                      future: allcurrencies,
                                      builder: (context, currSnapshot) {
                                        if (currSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        return DropdownButton<String>(
                                          value: dropdownValue,
                                          icon: const Icon(
                                              Icons.arrow_drop_down_rounded),
                                          iconSize: 24,
                                          elevation: 16,
                                          isExpanded: true,
                                          underline: Container(
                                            height: 2,
                                            color: Colors.grey.shade400,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropdownValue = newValue!;
                                            });
                                          },
                                          items: currSnapshot.data!.keys
                                              .toSet()
                                              .toList()
                                              .map<DropdownMenuItem<String>>(
                                                  (value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),

                                  //Convert Button
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          answer = usdController.text +
                                              ' USD = ' +
                                              convert(
                                                  snapshot.data!.rates,
                                                  usdController.text,
                                                  dropdownValue) +
                                              ' ' +
                                              dropdownValue;
                                        });
                                      },
                                      child: Text('Convert'),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .primaryColor)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),

                              //Final Output
                              SizedBox(height: 10),
                              Container(child: Text(answer))
                            ])),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
