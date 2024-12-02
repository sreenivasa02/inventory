import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:login_sessions_apps/app/data/util/master_service_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as di;
class MasterServiceRepositoryImpl implements MasterServiceRepository {

  final di.Dio dio = di.Dio();
  Future<void> getUserDetails(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the token
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      print("Authorization token is missing. Please login again.");
      Get.snackbar('Error', 'Authorization token is missing. Please login again.');
      return;
    }

    try {
      print("Sending GET request to: $url");

      // Make the GET request
      di.Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include Bearer if required
          },
        ),
      );

      print("Response: ${response.statusCode} - ${response.data}");

      // Handle success
      if (response.statusCode == 200) {
        // Parse response data
        var data = response.data['data'];

        if (data != null) {
          print("User details fetched successfully: $data");

          // Example: Save user details to SharedPreferences
          await prefs.setString('username', data['username'] ?? '');
          await prefs.setString('email', data['email'] ?? '');
          await prefs.setString('role', data['roleName'] ?? '');
          await prefs.setString('userId', data['userId']?.toString() ?? '');


          print("User details saved to SharedPreferences.");
        } else {
          print("No user details found in the response.");
        }
      } else {
        // Handle non-200 status codes
        print("Failed to fetch user details. Response: ${response.data}");
        Get.snackbar('Error', response.data['message'] ?? 'Failed to fetch user details');
      }
    } on DioError catch (dioError) {
      // Handle Dio-specific errors
      if (dioError.response != null) {
        print("DioError: ${dioError.response?.statusCode} - ${dioError.response?.data}");
        Get.snackbar('Error', dioError.response?.data['message'] ?? 'Something went wrong');
      } else {
        print("DioError without response: $dioError");
        Get.snackbar('Error', 'Failed to connect to the server');
      }
    } catch (e) {
      // Handle other exceptions
      print("Error during user details fetch: $e");
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  Future<dynamic> registration(Map<dynamic, dynamic> obj, String url) async {
    try {
      // Make the POST request
      di.Response response = await dio.post(
        url,
        data: obj,
      );

      print("response.data====${response.data}");
      return response.data; // Return the data only, matching `Future<dynamic>`
    } on DioError catch (dioError) {
      // Handle Dio-specific errors
      if (dioError.response != null) {
        // Extract the error response
        var errorData = dioError.response?.data;
        String errorMessage = "An unexpected error occurred.";

        if (errorData is Map<String, dynamic> && errorData.containsKey("data")) {
          // Parse and extract the user-friendly message
          errorMessage = errorData["data"] ?? errorMessage;
        }

        // Display the user-friendly error message
        Get.snackbar("Error", errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);

        print("DioError Response: $errorData");
      } else {
        // Handle cases where no response is received
        print("DioError: ${dioError.message}");
        Get.snackbar("Error", "Failed to connect to the server.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }

      throw Exception("Error during request: ${dioError.message}");
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      Get.snackbar("Error", "Unexpected error occurred.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);

      throw Exception("Unexpected error: $e");
    }
  }

  Future<dynamic> fetchbillingsToday(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      // Make the POST request
      di.Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include Bearer if required
          },
        ),
      );

      print("response.data====${response.data}");
      return response.data; // Return the data only, matching `Future<dynamic>`
    } on DioError catch (dioError) {
      // Handle Dio-specific errors
      if (dioError.response != null) {
        // Extract the error response
        var errorData = dioError.response?.data;
        String errorMessage = "An unexpected error occurred.";

        if (errorData is Map<String, dynamic> && errorData.containsKey("data")) {
          // Parse and extract the user-friendly message
          errorMessage = errorData["data"] ?? errorMessage;
        }

        // Display the user-friendly error message
        Get.snackbar("Error", errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);

        print("DioError Response: $errorData");
      } else {
        // Handle cases where no response is received
        print("DioError: ${dioError.message}");
        Get.snackbar("Error", "Failed to connect to the server.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }

      throw Exception("Error during request: ${dioError.message}");
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      Get.snackbar("Error", "Unexpected error occurred.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);

      throw Exception("Unexpected error: $e");
    }
  }
  Future<dynamic> fetchbillingsMonthly(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      // Make the POST request
      di.Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include Bearer if required
          },
        ),
      );

      print("response.data====${response.data}");
      return response.data; // Return the data only, matching `Future<dynamic>`
    } on DioError catch (dioError) {
      // Handle Dio-specific errors
      if (dioError.response != null) {
        // Extract the error response
        var errorData = dioError.response?.data;
        String errorMessage = "An unexpected error occurred.";

        if (errorData is Map<String, dynamic> && errorData.containsKey("data")) {
          // Parse and extract the user-friendly message
          errorMessage = errorData["data"] ?? errorMessage;
        }

        // Display the user-friendly error message
        Get.snackbar("Error", errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);

        print("DioError Response: $errorData");
      } else {
        // Handle cases where no response is received
        print("DioError: ${dioError.message}");
        Get.snackbar("Error", "Failed to connect to the server.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }

      throw Exception("Error during request: ${dioError.message}");
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      Get.snackbar("Error", "Unexpected error occurred.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);

      throw Exception("Unexpected error: $e");
    }
  }
  Future<dynamic> getRecentTransations(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      // Make the POST request
      di.Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include Bearer if required
          },
        ),
      );

      print("response.data====${response.data}");
      return response.data; // Return the data only, matching `Future<dynamic>`
    } on DioError catch (dioError) {
      // Handle Dio-specific errors
      if (dioError.response != null) {
        // Extract the error response
        var errorData = dioError.response?.data;
        String errorMessage = "An unexpected error occurred.";

        if (errorData is Map<String, dynamic> && errorData.containsKey("data")) {
          // Parse and extract the user-friendly message
          errorMessage = errorData["data"] ?? errorMessage;
        }

        // Display the user-friendly error message
        Get.snackbar("Error", errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);

        print("DioError Response: $errorData");
      } else {
        // Handle cases where no response is received
        print("DioError: ${dioError.message}");
        Get.snackbar("Error", "Failed to connect to the server.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }

      throw Exception("Error during request: ${dioError.message}");
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      Get.snackbar("Error", "Unexpected error occurred.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);

      throw Exception("Unexpected error: $e");
    }
  }

  Future<dynamic> getBillingsAllTransactions(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      // Make the POST request
      di.Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // Include Bearer if required
          },
        ),
      );

      print("response.data====${response.data}");
      return response.data; // Return the data only, matching `Future<dynamic>`
    } on DioError catch (dioError) {
      // Handle Dio-specific errors
      if (dioError.response != null) {
        // Extract the error response
        var errorData = dioError.response?.data;
        String errorMessage = "An unexpected error occurred.";

        if (errorData is Map<String, dynamic> && errorData.containsKey("data")) {
          // Parse and extract the user-friendly message
          errorMessage = errorData["data"] ?? errorMessage;
        }

        // Display the user-friendly error message
        Get.snackbar("Error", errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);

        print("DioError Response: $errorData");
      } else {
        // Handle cases where no response is received
        print("DioError: ${dioError.message}");
        Get.snackbar("Error", "Failed to connect to the server.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }

      throw Exception("Error during request: ${dioError.message}");
    } catch (e) {
      // Handle other exceptions
      print("Error: $e");
      Get.snackbar("Error", "Unexpected error occurred.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);

      throw Exception("Unexpected error: $e");
    }
  }

}