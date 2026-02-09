import 'dart:convert';
import 'lib/drug_tools.dart';


void main() async {
  print('=== DRUG SAFETY TOOLS TEST ===\n');
  
  DrugSafetyTools tools = DrugSafetyTools();
  await tools.initialize();
  print('✓ Data loaded\n');
  
  print('TEST 1: Normalize Drug Names');
  print('Input: "PANADOL" → ${tools.normalizeDrugName("PANADOL")}');
  print('Input: "  Brufen  " → ${tools.normalizeDrugName("  Brufen  ")}');
  print('Input: "aspirin" → ${tools.normalizeDrugName("aspirin")}\n');
  
  print('TEST 2: Check Drug Interactions');
  List<String> drugs1 = ["ibuprofen", "diclofenac"];
  var result1 = tools.checkDrugInteractions(drugs1);
  print('Drugs: $drugs1');
  print('Result: ${json.encode(result1.toJson())}\n');
  
  print('TEST 3: Check Pregnancy Risk');
  List<String> drugs2 = ["panadol", "ibuprofen"];
  var result2 = tools.checkPregnancyRisk(drugs2, true);
  print('Drugs: $drugs2 (pregnant: true)');
  print('Result: ${json.encode(result2.toJson())}\n');
  
  print('TEST 4: Check Duplicate Ingredients');
  List<String> drugs3 = ["paracetamol", "panadol", "aspirin"];
  var result3 = tools.checkDuplicateIngredients(drugs3);
  print('Drugs: $drugs3');
  print('Result: ${json.encode(result3.toJson())}\n');
  
  print('TEST 5: Safe Combination');
  List<String> drugs4 = ["paracetamol", "amoxicillin"];
  var result4 = tools.checkDrugInteractions(drugs4);
  print('Drugs: $drugs4');
  print('Result: ${json.encode(result4.toJson())}\n');
  
  print('=== ALL TESTS COMPLETE ===');
}