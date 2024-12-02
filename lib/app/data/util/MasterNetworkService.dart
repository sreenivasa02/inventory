import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:login_sessions_apps/app/data/util/api_endpoints.dart';
import 'package:login_sessions_apps/app/data/util/master_service_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'master_service_repository.dart';

class MasterNetWorkService{
   MasterServiceRepository masterServiceRepository=Get.put(MasterServiceRepositoryImpl());



  startMasterServices(bool showProgressbar) async {


    await masterServiceRepository.getUserDetails(ApiEndPoint.userDetailsUrl);

  }

  getfetchbillingsToday() async {
    try {

      var response = await masterServiceRepository.fetchbillingsToday(ApiEndPoint.fetchTodayBills);


      final Map<String, dynamic> parsedJson = response is String
          ? json.decode(response)
          : response;

      // Log the response for debugging
      var data=parsedJson['data']??[];

      // Return the response if needed
      return data;
    } catch (e) {
      // Catch and log any errors
      print("Error in getRecentBillsMasterServices: $e");
      throw Exception("Failed to fetch recent bills: $e");
    }
  }
   getfetchbillingsMonthly() async {
     try {

       var response = await masterServiceRepository.fetchbillingsMonthly(ApiEndPoint.fetchMonthlyBills);


       final Map<String, dynamic> parsedJson = response is String
           ? json.decode(response)
           : response;

       // Log the response for debugging
       var data=parsedJson['data']??[];

       // Return the response if needed
       return data;
     } catch (e) {
       // Catch and log any errors
       print("Error in getRecentBillsMasterServices: $e");
       throw Exception("Failed to fetch recent bills: $e");
     }
   }

   getRecentBillsMasterServices() async {
     try {

       var response = await masterServiceRepository.getRecentTransations(ApiEndPoint.recentBillings);


       final Map<String, dynamic> parsedJson = response is String
           ? json.decode(response)
           : response;

       // Log the response for debugging
       var data=parsedJson['data']??[];

       // Return the response if needed
       return data;
     } catch (e) {
       // Catch and log any errors
       print("Error in getRecentBillsMasterServices: $e");
       throw Exception("Failed to fetch recent bills: $e");
     }
   }
   getAllTransactionMasterServices() async {
     try {

       var response = await masterServiceRepository.getRecentTransations(ApiEndPoint.allBillingsTransactions);


       final Map<String, dynamic> parsedJson = response is String
           ? json.decode(response)
           : response;

       // Log the response for debugging
       var data=parsedJson['data']??[];

       // Return the response if needed
       return data;
     } catch (e) {
       // Catch and log any errors
       print("Error in getRecentBillsMasterServices: $e");
       throw Exception("Failed to fetch recent bills: $e");
     }
   }


}