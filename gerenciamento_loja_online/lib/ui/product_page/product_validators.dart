import 'package:intl/intl.dart';

class ProductValidator {

  bool validateTitle(String title) => title != null && title.isNotEmpty;
  bool validateDescription(String description) => description != null && description.isNotEmpty;
  bool validatePrice(String price) {
    try {
      final priceValue = NumberFormat.simpleCurrency().parse(price);
      return price != null && price.isNotEmpty && priceValue > 0;
    }
    catch(e){
      print(e);
      return false;
    }
  }
  bool validateImages(List images) => images != null && images.isNotEmpty;


}