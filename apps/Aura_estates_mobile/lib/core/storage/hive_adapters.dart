import 'package:aura_estates/features/properties/data/models/user_data.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<UserData>()])
class HiveAdapters {}
