import 'dart:convert';
import 'dart:developer';
import 'package:blood_bank/services/location/location_helper.dart';
import '../../constanst.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  Future<dynamic> getLocByCiytyName(String cityName) async {
    //we use this method when user input name of the city
    var url =
        ('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');
    http.Response response = await http.get(Uri.parse(url));

    // NetworkingHelper networkingHelper = NetworkingHelper(uri);
    //  var weatherData = await networkingHelper.getData();
    //return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    //we use this method to search with uri using location lat and lon for searching
    LocationHelper location = LocationHelper();
    await location.getCurrentLocation();
    if (!location.isDenied) {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey';
      try {
        http.Response response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          return {"error": false, "value": jsonDecode(response.body)};
        }
        return {"error": true, "message": "--error--"};
      } catch (e) {
        return {"error": true, "message": "$e"};
      }

      //var weatherData = await networkingHelper.getData();
      //  return weatherData;
    }
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
