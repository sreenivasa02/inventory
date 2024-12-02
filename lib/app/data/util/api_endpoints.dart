import 'package:login_sessions_apps/app/data/util/network_constants.dart';

class ApiEndPoint {
  static String registrationUrl = "${NetWorkContants().rootUrl}auth/register";

  static String loginUrl = '${NetWorkContants().rootUrl}auth/mobileLogin';
  static String userDetailsUrl = '${NetWorkContants().rootUrl}auth/getUserDetails';
  static String fetchMonthlyBills = '${NetWorkContants().rootUrl}billing/fetchbillings/monthly';
  static String fetchTodayBills = '${NetWorkContants().rootUrl}billing/fetchbillings/today';
  static String recentBillings = '${NetWorkContants().rootUrl}billing/recentbillings';
  static String allBillingsTransactions = '${NetWorkContants().rootUrl}billing/getBillings';
}