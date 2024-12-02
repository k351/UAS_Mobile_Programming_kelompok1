import 'dart:convert'; // Importing the dart:convert library for JSON encoding/decoding
import 'package:http/http.dart'
    as http; // Importing the http package for making HTTP requests

/// Fetches the geographical coordinates (latitude and longitude) for a given address.
///
/// This function uses the Nominatim API from OpenStreetMap to perform a geocoding operation.
/// It takes an address as input and returns a map containing the latitude and longitude
/// as doubles, or null if the coordinates cannot be found or if an error occurs.
///
/// [address] - The address for which to find the coordinates.
/// Returns a [Map<String, double>?] containing 'latitude' and 'longitude', or null.
Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
  // Construct the URL for the Nominatim API with the specified address
  final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?format=json&q=$address');

  try {
    // Make an HTTP GET request to the Nominatim API
    final response = await http.get(url);

    // Check if the response status code indicates success (200 OK)
    if (response.statusCode == 200) {
      // Decode the JSON response into a Dart object
      final data = json.decode(response.body);

      // Check if the data is not empty (i.e., coordinates were found)
      if (data.isNotEmpty) {
        // Extract the latitude and longitude from the first result
        final latitude = double.parse(data[0]['lat']);
        final longitude = double.parse(data[0]['lon']);

        // Return a map containing the latitude and longitude
        return {'latitude': latitude, 'longitude': longitude};
      } else {
        // Log a message if no coordinates were found for the given address
        print('No coordinates found for this address.');
        return null; // Return null if no results were found
      }
    } else {
      // Log a message if the request failed with a non-200 status code
      print('Request failed with status: ${response.statusCode}');
      return null; // Return null in case of an unsuccessful request
    }
  } catch (e) {
    // Catch and log any errors that occur during the HTTP request or JSON parsing
    print('Error during geocoding: $e');
    return null; // Return null if an error occurs
  }
}
