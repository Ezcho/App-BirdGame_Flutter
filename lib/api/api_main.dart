// lib/api/api_main.dart

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:bird_raise_app/token/chrome_token.dart';
import 'package:bird_raise_app/token/mobile_secure_token.dart';

class ApiMain {
  static final Uri _userUrl = Uri.parse('http://3.27.57.243:8080/api/v1/user');

  static Future<Map<String, dynamic>?> fetchUserInfo() async {
    String? token;

    if (kIsWeb) {
      token = getChromeAccessToken();
    } else {
      token = await getAccessToken();
    }

    if (token == null) {
      print('⚠️ 토큰이 없습니다.');
      return null;
    }

    final response = await http.get(
      _userUrl,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print('✅ 사용자 정보 조회 성공');
      return jsonDecode(response.body);
    } else {
      print('❌ 사용자 정보 호출 실패: ${response.statusCode}');
      return null;
    }
  }

  /// 로그아웃: 로컬 토큰 삭제
  static Future<void> logout() async {
    if (kIsWeb) {
      print("🌐 로그아웃 (웹): localStorage 삭제");
      clearChromeAccessToken();
    } else {
      print("📱 로그아웃 (모바일): secure storage 삭제");
      await deleteTokens();
    }
  }

  Future<void> feed(String itemCode) async {
    String? token;
    if (kIsWeb) {
      token = getChromeAccessToken();
    } else {
      token = await getAccessToken();
    }
    if (token == null) {
      print('⚠️ 토큰이 없습니다.');
      return null;
    }
    final response = await http.post(
      Uri.parse('http://3.27.57.243:8080/api/v1/bird/feed'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'itemCode': itemCode,
        'amount': 1,
      }),
    );

    if (response.statusCode == 200) {
      print('✅ 아이템 사용 성공');
      return jsonDecode(response.body);
    } else {
      print('❌ 아이템 사용 실패: ${response.statusCode}');
      return null;
    }
  }
}
