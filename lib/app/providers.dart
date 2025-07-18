import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/services/providers/blogs_provider.dart';
import 'package:e_cell_website/services/providers/certificate_provider.dart';
import 'package:e_cell_website/services/providers/events_provider.dart';
import 'package:e_cell_website/services/providers/gallery_provider.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/services/providers/recruitment_provider.dart';
import 'package:e_cell_website/services/providers/speakers_provider.dart';
import 'package:e_cell_website/services/providers/subscription_provider.dart';
import 'package:e_cell_website/services/providers/team_members_provider.dart';
import 'package:e_cell_website/services/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => OngoingEventProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => BlogProvider()),
    ChangeNotifierProvider(create: (_) => TeamProvider()),
    ChangeNotifierProvider(create: (_) => SpeakerProvider()),
    ChangeNotifierProvider(create: (_) => EventProvider()),
    ChangeNotifierProvider(create: (_) => GalleryProvider()),
    ChangeNotifierProvider(create: (_) => CertificateProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => RecruitmentProvider()),
    ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
  ];
}
