import 'package:fhir_auth/r4.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: MyHomePage());
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FhirClient client = SmartClient();
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Have you experienced any of the following '
              'symptoms in the past 48 hours:'
              '\n• fever or chills'
              '\n• cough'
              '\n• shortness of breath or difficulty breathing'
              '\n• fatigue'
              '\n• muscle or body aches'
              '\n• headache'
              '\n• new loss of taste or smell'
              '\n• sore throat'
              '\n• congestion or runny nose'
              '\n• nausea or vomiting'
              '\n• diarrhea',
            ),
            Text(
                '''Have you been in close physical contact in the last 14 days with:
• Anyone who is known to have laboratory-confirmed COVID-19?
OR
• Anyone who has any symptoms consistent with COVID-19?'''),
            Text(
                '''Are you isolating or quarantining because you may have been exposed to a person
with COVID-19 or are worried that you may be sick with COVID-19?'''),
            Text(
                '''Are you currently waiting on the results of a COVID-19 test?'''),
            Text('Have you traveled in the past 10 days?'),
          ],
        ),
      ),
    );
  }
}
