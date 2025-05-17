// lib/api/api_main.dart

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:bird_raise_app/token/chrome_token.dart';
import 'package:bird_raise_app/token/mobile_secure_token.dart';

class ApiMain {
  static final Uri _userUrl = Uri.parse('http://3.27.57.243:8080/api/v1/user');
  // 서버에 로그아웃 API가 있다면 아래에 추가하세요
  // static final Uri _logoutUrl = Uri.parse('http://...');

  /// 사용자 정보 가져오기
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

    // 서버에 로그아웃 API가 있는 경우 아래처럼 추가하세요
    // await http.post(_logoutUrl, headers: {'Authorization': 'Bearer $token'});
  }
}
