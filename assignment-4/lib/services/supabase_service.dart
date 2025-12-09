import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/submission.dart';

class SupabaseService {
  final _client = Supabase.instance.client;
  final String table = "submissions";

  Future<List<Submission>> getAll() async {
    final response = await _client.from(table).select().order('created_at', ascending: false);
    return response.map((e) => Submission.fromJson(e)).toList();
  }

  Future<void> insert(Submission s) async {
    await _client.from(table).insert(s.toJson());
  }

  Future<void> update(int id, Submission s) async {
    await _client.from(table).update(s.toJson()).eq("id", id);
  }

  Future<void> delete(int id) async {
    await _client.from(table).delete().eq("id", id);
  }
}
