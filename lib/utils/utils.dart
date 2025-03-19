import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:mime/mime.dart';
import 'package:opalsystem/widgets/CustomWidgets/custom_text_widgets.dart';

import '../CloverDesign/Dashboard Pages/Add Item Inventory V1/Add Item/add_item_inventory.dart';
import '../CloverDesign/Dashboard Pages/Add Item Inventory V1/Brands/brands_new_clover.dart';
import '../CloverDesign/Dashboard Pages/Add Item Inventory V1/Categories/categories_new_cover.dart';
import '../CloverDesign/Dashboard Pages/Add Item Inventory V1/Items/items_new_clover.dart';
import '../CloverDesign/Dashboard Pages/Add Item Inventory V1/Selling Price Groups/selling_price_groups_new_clover.dart';
import '../CloverDesign/Dashboard Pages/Add Item Inventory V1/Units/units_new_clover.dart';
import '../CloverDesign/Dashboard Pages/Add Item Inventory V1/Variants/variants_new_clover.dart';

class MyUtility {
  static String? getMimeType(String filePath) {
    final mimeType = lookupMimeType(filePath);
    log("getMimeType: ${mimeType}");
    return mimeType;
  }

  static bool checkVideoMimeType(String filePath) {
    final mimeType = lookupMimeType(filePath);
    // log("checkVideoMimeType: ${mimeType}");
    return mimeType!.startsWith('video/');
  }

  static Future<Uint8List> getThumbnailPath(String videoFilePath) async {
    var uint8list = await VideoThumbnail.thumbnailData(
      video: videoFilePath,
      imageFormat: ImageFormat.JPEG,
      maxWidth:
          128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return uint8list;
  }

  static int getMaxValue(List<int> list) {
    if (list.isEmpty) {
      throw ArgumentError("The list cannot be empty.");
    }
    int maxVal = list[0];
    for (int j = 0; j < list.length; j++) {
      if (list[j] > maxVal) {
        maxVal = list[j];
      }
    }
    return maxVal;
  }


 static  double fixedWidthCloverNewDesign=200;


  static const String variants = 'Variants';
  static const String items = 'Items';
  static const String sellingPriceGroup = 'Selling Price Group';
  static const String units = 'Units';
  static const String categories = 'Categories';
  static const String brands = 'Brands';
  static const String addItem = 'Add_Item';

  static const Map<String, Widget> screens = {
    variants: VariantsNewClover(),
    items: ItemsNewClover(),
    sellingPriceGroup: SellingPriceGroupsNewClover(),
    units: UnitsNewClover(),
    categories: CategoriesNewClover(),
    brands: BrandsNewClover(),
    addItem: AddItemInventory(),
  };

 static Widget getScreenContent(String menu) {
   return screens[menu] ??
       Container(
         child: Center(
           child: CustomText(text: "Error state"),
         ),
       );
    }



  static const Map<String, List<String>> parentChildStates = {
    items: [addItem],
    categories: [],
    variants: [],
    units: [],
    brands: [],
    sellingPriceGroup: [],
  };


  static String getParentState(String state) {
    for (var entry in parentChildStates.entries) {
      if (entry.key == state || entry.value.contains(state)) {
        return entry.key;
      }
    }
    return state;
  }

}



