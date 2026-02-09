import 'dart:convert';
import 'dart:io';
import 'models.dart';

class DrugSafetyTools {
  List<dynamic> interactions = [];
  List<dynamic> pregnancyRisks = [];
  Map<String, dynamic> ingredients = {};
  
  Future<void> initialize() async {
    String interactionsData = await File('data/interactions.json').readAsString();
    interactions = json.decode(interactionsData);
    
    String pregnancyData = await File('data/pregnancy_risks.json').readAsString();
    pregnancyRisks = json.decode(pregnancyData);
    
    String ingredientsData = await File('data/ingredients.json').readAsString();
    ingredients = json.decode(ingredientsData);
  }
  
  String normalizeDrugName(String input) {
    String cleaned = input.trim().toLowerCase();
    
    for (var entry in ingredients.entries) {
      String genericName = entry.key;
      List<String> variants = List<String>.from(entry.value);
      
      if (variants.contains(cleaned)) {
        return genericName;
      }
    }
    
    return cleaned;
  }
  
  SafetyCheckResult checkDrugInteractions(List<String> drugs) {
    if (drugs.length < 2) {
      return SafetyCheckResult(risk: 'SAFE');
    }
    
    List<String> normalized = drugs.map((d) => normalizeDrugName(d)).toList();
    
    for (int i = 0; i < normalized.length; i++) {
      for (int j = i + 1; j < normalized.length; j++) {
        String drugA = normalized[i];
        String drugB = normalized[j];
        
        for (var interaction in interactions) {
          bool matchFound = 
            (interaction['drug_a'] == drugA && interaction['drug_b'] == drugB) ||
            (interaction['drug_a'] == drugB && interaction['drug_b'] == drugA);
          
          if (matchFound) {
            return SafetyCheckResult(
              risk: interaction['risk'],
              trigger: 'drug_interaction',
              drug: '$drugA + $drugB',
              reason: interaction['reason'],
            );
          }
        }
      }
    }
    
    return SafetyCheckResult(risk: 'SAFE');
  }
  
  SafetyCheckResult checkPregnancyRisk(List<String> drugs, bool pregnant) {
    if (!pregnant) {
      return SafetyCheckResult(risk: 'SAFE');
    }
    
    List<String> normalized = drugs.map((d) => normalizeDrugName(d)).toList();
    
    for (String drug in normalized) {
      for (var risk in pregnancyRisks) {
        if (risk['drug'] == drug) {
          return SafetyCheckResult(
            risk: risk['risk'],
            trigger: 'pregnancy',
            drug: drug,
            reason: risk['reason'],
          );
        }
      }
    }
    
    return SafetyCheckResult(risk: 'SAFE');
  }
  
  SafetyCheckResult checkDuplicateIngredients(List<String> drugs) {
    List<String> normalized = drugs.map((d) => normalizeDrugName(d)).toList();
    
    Map<String, List<String>> ingredientCount = {};
    
    for (String drug in normalized) {
      for (var entry in ingredients.entries) {
        String genericName = entry.key;
        List<String> variants = List<String>.from(entry.value);
        
        if (variants.contains(drug)) {
          ingredientCount.putIfAbsent(genericName, () => []).add(drug);
          break;
        }
      }
    }
    
    for (var entry in ingredientCount.entries) {
      if (entry.value.length > 1) {
        return SafetyCheckResult(
          risk: 'HIGH',
          trigger: 'duplicate_ingredient',
          drug: entry.value.join(' + '),
          reason: 'Multiple drugs contain ${entry.key}. Risk of overdose.',
        );
      }
    }
    
    return SafetyCheckResult(risk: 'SAFE');
  }
}