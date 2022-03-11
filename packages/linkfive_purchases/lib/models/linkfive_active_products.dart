import 'package:linkfive_purchases/models/linkfive_plan.dart';

/// All active and valid LinkFive plans & Products
class LinkFiveActiveProducts {
  /// All active plans
  final List<LinkFivePlan> planList;

  LinkFiveActiveProducts({this.planList = const []});
}
