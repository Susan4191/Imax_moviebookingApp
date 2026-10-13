import 'package:fluttertoast/fluttertoast.dart';
import 'package:imax_movie_ticket_booking/utils/app_color.dart';

class AppToast {
  static void showSuccess(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: AppColor.green,
      textColor: AppColor.white,
      fontSize: 14.0,
    );
  }

  static void showError(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: AppColor.red,
      textColor: AppColor.white,
      fontSize: 14.0,
    );
  }

  static void showInfo(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: AppColor.themeColor,
      textColor: AppColor.white,
      fontSize: 14.0,
    );
  }
}
