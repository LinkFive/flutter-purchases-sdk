enum Recurrence {
  /// The billing plan payment recurs for a fixed number of billing period set
  /// in billingCycleCount.
  finiteRecurring,

  /// until it gets canceled
  infiniteRecurring,

  /// one time charge
  nonRecurring;

  @override
  String toString(){
    return name;
  }
}