abstract class MasterServiceRepository{

  Future<dynamic> getUserDetails(String url);
  Future<dynamic> registration(Map obj, String url);
  Future<dynamic> fetchbillingsToday(String url);
  Future<dynamic> fetchbillingsMonthly(String url);
  Future<dynamic> getRecentTransations(String url);
  Future<dynamic> getBillingsAllTransactions(String url);

}