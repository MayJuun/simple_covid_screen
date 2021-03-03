import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

import 'api.dart';
import 'this_smart_client.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: CovidScreen());
}

class CovidScreen extends StatefulWidget {
  @override
  _CovidScreenState createState() => _CovidScreenState();
}

class _CovidScreenState extends State<CovidScreen> {
  var sxs = [false, true];
  final contact = [false, true];
  final isolating = [false, true];
  final travel = [false, true];
  final waiting = [false, true];
  bool anyTrue() =>
      sxs[0] || contact[0] || isolating[0] || travel[0] || waiting[0];

  @override
  Widget build(BuildContext context) {
    Widget submit() => anyTrue()
        ? FloatingActionButton.extended(
            onPressed: () => _sendCondition(anyTrue()),
            label: Text('Submit!'),
          )
        : Container();

    Widget bottom() => anyTrue()
        ? Container()
        : FloatingActionButton.extended(
            onPressed: () => _sendCondition(anyTrue()),
            label: Text('Submit!'),
          );

    ToggleButtons yesNo(List<bool> isSelected) => ToggleButtons(
        children: [Text('Yes'), Text('No')],
        onPressed: (_) {
          setState(() {
            isSelected[0] = !isSelected[0];
            isSelected[1] = !isSelected[1];
          });
        },
        isSelected: isSelected);

    var _screenSize = MediaQuery.of(context).size;
    var _fontSize = _screenSize.width * .04;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Covid Screen'),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                width: _screenSize.width * .8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: _screenSize.height * .07),
                    Text(
                      'Have you experienced any of the following '
                      'symptoms in the past 48 hours:',
                      style: TextStyle(
                          fontSize: _fontSize, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    Text(
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
                      style: TextStyle(fontSize: _fontSize),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: _screenSize.height * .03),
                    yesNo(sxs),
                    SizedBox(height: _screenSize.height * .07),
                    Text(
                      'Have you been in close physical contact in '
                      'the last 14 days with:'
                      '\n• Anyone who is known to have laboratory-confirmed '
                      'COVID-19?'
                      '\nOR'
                      '\n• Anyone who has any symptoms consistent with COVID-19?',
                      style: TextStyle(fontSize: _fontSize),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: _screenSize.height * .03),
                    yesNo(contact),
                    SizedBox(height: _screenSize.height * .07),
                    Text(
                      'Are you isolating or quarantining because you may '
                      'have been exposed to a person with COVID-19 or are '
                      'worried that you may be sick with COVID-19?',
                      style: TextStyle(fontSize: _fontSize),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: _screenSize.height * .03),
                    yesNo(isolating),
                    SizedBox(height: _screenSize.height * .07),
                    Text(
                      'Have you traveled in the past 10 days?',
                      style: TextStyle(fontSize: _fontSize),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: _screenSize.height * .03),
                    yesNo(travel),
                    SizedBox(height: _screenSize.height * .07),
                    Text(
                      'Are you currently waiting on the results of a COVID-19 test?',
                      style: TextStyle(fontSize: _fontSize),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: _screenSize.height * .03),
                    yesNo(waiting),
                    SizedBox(height: _screenSize.height * .07),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [bottom()],
                    ),
                    SizedBox(height: _screenSize.height * .07),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: submit(),
        ),
      ),
    );
  }
}

Future<void> _sendCondition(bool present) async {
  // if (present) {
  //   try {
  //     final client = ThisSmartClient().client(Mihin.mihinUrl,
  //         Mihin.mihinClientId, Mihin.redirectUrl, Mihin.mihinClientSecret);
  //     final attempt = await client.login();
  //     final upload = FhirRequest.create(
  //         base: Uri.parse(Mihin.mihinUrl), resource: covidCondition());
  //     final request = await upload.request(headers: await client.authHeaders);
  //     print(request?.toJson());
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  try {
    var grant = oauth2.AuthorizationCodeGrant(
      Mihin.mihinClientId,
      Uri.parse(
          'https://smart-auth.interopland.com/r9rtfzdz/45353/mihinss/oauth2/authorize'),
      Uri.parse(
          'https://smart-auth.interopland.com/r9rtfzdz/45353/mihinss/oauth2/token'),
      secret: Mihin.mihinClientSecret,
    );

    var authorizationUrl =
        grant.getAuthorizationUrl(Uri.parse(Mihin.redirectUrl));

    if (await canLaunch(authorizationUrl.toString())) {
      await launch(authorizationUrl.toString());
    }
  } catch (e) {
    print(e);
  }
}

Condition covidCondition() => Condition(
      subject: Reference(reference: 'Patient/50443'),
      clinicalStatus: CodeableConcept(
        coding: [
          Coding(
            system: FhirUri(
                'http://terminology.hl7.org/CodeSystem/condition-clinical'),
            code: Code('active'),
            display: 'Active',
          ),
        ],
      ),
      category: [
        CodeableConcept(
          coding: [
            Coding(
              system: FhirUri(
                  'http://hl7.org/fhir/us/core/CodeSystem/condition-category'),
              code: Code('health-concern'),
            )
          ],
        )
      ],
      code: CodeableConcept(
        coding: [
          Coding(
            system: FhirUri('http://snomed.info/sct'),
            code: Code('3947197012'),
            display: 'Suspected disease caused by severe acute '
                'respiratory coronavirus 2 (situation)',
          ),
        ],
        text: 'Suspected disease caused by severe acute '
            'respiratory coronavirus 2 (situation)',
      ),
      onsetPeriod: Period(
        start: FhirDateTime(DateTime.now()),
      ),
    );
