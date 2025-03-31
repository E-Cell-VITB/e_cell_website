import 'package:e_cell_website/services/enums/device.dart';

String getOptimizedImageUrl({
  required String originalUrl,
  required Device device,
}) {
  switch (device) {
    case Device.mobile:
      return originalUrl.replaceFirst(
          '/upload/', '/upload/w_1000,h_800,q_70,f_auto/');
    case Device.tablet:
      return originalUrl.replaceFirst(
          '/upload/', '/upload/w_1600,h_1200,q_80,f_auto/');
    case Device.desktop:
      return originalUrl.replaceFirst(
          '/upload/', '/upload/w_2500,h_1667,q_90,f_auto/');
  }
}
