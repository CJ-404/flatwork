import 'package:flutter_riverpod/flutter_riverpod.dart';


//this value should be fetched from backend
final progressProvider = StateProvider<double>((ref) => 0.0);