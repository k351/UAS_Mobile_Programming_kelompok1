import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
  final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?format=json&q=$address');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Geocoding Response: $data'); // Print raw data for debugging
      if (data.isNotEmpty) {
        final latitude = double.parse(data[0]['lat']);
        final longitude = double.parse(data[0]['lon']);
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        print('No coordinates found for this address.');
        return null;
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error during geocoding: $e');
    return null;
  }
}
