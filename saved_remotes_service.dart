import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedRemotesService {
  static const _key = 'cnr_saved_remotes';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<List<Map<String, String>>> loadSavedRemotes() async {
    final jsonStr = _prefs?.getString(_key);
    if (jsonStr == null) return [];
    final List list = json.decode(jsonStr) as List;
    return list.map((e) => Map<String, String>.from(e)).toList();
  }

  static Future<void> saveSavedRemotes(List<Map<String, String>> remotes) async {
    final jsonStr = json.encode(remotes);
    await _prefs?.setString(_key, jsonStr);
  }

  static Future<void> addRemote(Map<String, String> remote) async {
    final current = await loadSavedRemotes();
    // avoid duplicates
    if (!current.any((r) => r['device'] == remote['device'] && r['brand'] == remote['brand'])) {
      current.add(remote);
      await saveSavedRemotes(current);
    }
  }

  static Future<void> removeRemote(Map<String, String> remote) async {
    final current = await loadSavedRemotes();
    current.removeWhere((r) => r['device'] == remote['device'] && r['brand'] == remote['brand']);
    await saveSavedRemotes(current);
  }
}