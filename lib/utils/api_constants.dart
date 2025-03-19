class ApiConstants{


  static String getBaseUrl(String storeUrl){
    return "https://$storeUrl.opalpay.us";
  }

  static String generateParametrizedEndpoint(String endpoint, [Map<String, String>? params]) {
    if (params == null || params.isEmpty) {
      return endpoint;
    }
    String queryString = params.entries
        .map((entry) => "${entry.key}=${Uri.encodeComponent(entry.value)}")
        .join("&");
    return "$endpoint?$queryString";
  }

  static String middleRoute="/public/api";



  static String postSell="${middleRoute}/sell_return";
  static String placeOrder="${middleRoute}/place_order";
  static String getSellReturn="${middleRoute}/get_sale_detail";
  static String addCustomer="${middleRoute}/add_customer";
  static String postDraft="${middleRoute}/post_draft";
  static String getProducts="${middleRoute}/get_products";
  static String  posQuotation="${middleRoute}/pos_quotation";
  static String  sendSmsEmailApi="${middleRoute}/send_sms_email_api";
  static String sendRemoveCartItemsAlert="${middleRoute}/send_remove_cart_item_alert";




  static String headerAuthorizationKey="OPAL-PAY-API-KEY";
  static String headerAuthorizationValue="#bk_api_opal_v1_1_1@";




}