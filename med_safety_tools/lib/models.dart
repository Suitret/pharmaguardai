class SafetyCheckResult {
  final String risk;
  final String? trigger;
  final String? drug;
  final String? reason;
  
  SafetyCheckResult({
    required this.risk,
    this.trigger,
    this.drug,
    this.reason,
  });
  
  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {'risk': risk};
    
    if (trigger != null) result['trigger'] = trigger;
    if (drug != null) result['drug'] = drug;
    if (reason != null) result['reason'] = reason;
    
    return result;
  }
}