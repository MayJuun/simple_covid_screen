import 'package:fhir/r4.dart';
import 'package:fhir_auth/r4.dart';
import 'package:fhir_auth/r4/smart_client.dart';

class ThisSmartClient {
  SmartClient client(
    String baseUrl,
    String clientId,
    String redirectUrl,
    String secret,
  ) =>
      SmartClient(
        baseUrl: FhirUri(baseUrl),
        clientId: clientId,
        redirectUri: FhirUri(redirectUrl),
        scopes: Scopes(
          clinicalScopes: [
            Tuple3(
              Role.patient,
              R4ResourceType.Patient,
              Interaction.any,
            ),
            Tuple3(
              Role.patient,
              R4ResourceType.Condition,
              Interaction.any,
            ),
          ],
          openid: true,
          offlineAccess: true,
        ),
        secret: secret,
      );
}
