import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../models/login_data.dart';
import '../auth_provider/auth_provider.dart';

class MultiUserProvider extends ChangeNotifier {
  final GetStorage _box = GetStorage('accounts');
  List<LoginData> _savedAccounts = [];

  List<LoginData> get savedAccounts => _savedAccounts;

  MultiUserProvider() {
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    final List<dynamic>? storedAccounts = _box.read('saved_accounts');
    if (storedAccounts != null) {
      _savedAccounts = storedAccounts
          .map((e) => LoginData.fromJson(e))
          .toList();
    }
    notifyListeners();
  }

  Future<void> addAccount(LoginData data) async {
    final index = _savedAccounts.indexWhere((element) =>
      element.userid == data.userid && element.logintype == data.logintype);

    if (index != -1) {
      _savedAccounts[index] = data;
    } else {
      _savedAccounts.add(data);
    }
    
    await _saveToStorage();
    notifyListeners();
  }
  
  Future<void> removeAccount(int index) async {
    if (index >= 0 && index < _savedAccounts.length) {
      _savedAccounts.removeAt(index);
      await _saveToStorage();
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    final List<Map<String, dynamic>> jsonList = 
        _savedAccounts.map((e) => e.toJson()).toList();
    await _box.write('saved_accounts', jsonList);
  }

  bool isCurrentAccount(LoginData account) {
    final box = GetStorage();
    final currentUserId = box.read('userid');
    final currentType = box.read('type');
    return account.userid == currentUserId && account.logintype == currentType;
  }

  Future<void> switchAccount(BuildContext context, LoginData account) async {
      final box = GetStorage();
      
       box.write("currentyearfrom", account.currentyearfrom );
       box.write("currentyearto", account.currentyearto );
       box.write("userid", account.userid );
       box.write("type", account.logintype);
       box.write("sid", account.sid );
       box.write("tname", account.tname ?? "");
       box.write("regno", account.regno );
       box.write("email", account.email );
       box.write("empId", account.empId );
       box.write("roleid", account.roleid ?? "");
       box.write("rolename", account.rolename ?? "");
       box.write("sessionenddate", account.sessionenddate);
       box.write("position", account.position ?? "");
       box.write("sessionstartdate", account.sessionstartdate);
       box.write("createddate", account.createddate);
       
       box.write("remember", true);

       // Update AuthProvider state
       // ignore: use_build_context_synchronously
       final authProvider = Provider.of<AuthProvider>(context, listen: false);
       await authProvider.loadRememberedUser(); 
  }
  
  Future<void> ensureCurrentAccountSaved() async {
    final box = GetStorage();
    if (box.read('userid') != null) {
       final currentUser = LoginData(
        logintype: box.read('type') ?? '',
        userid: box.read('userid') ?? '',
        username: box.read('username') ?? '',
        empId: box.read('empId') ?? '',
        email: box.read('email') ?? '',
        photo: box.read('photo') ?? '',
        createddate: box.read('createddate') ?? '',
        roleid: box.read('roleid'),
        position: box.read('position'),
        tname: box.read('tname'),
        rolename: box.read('rolename'),
        regno: box.read('regno') ?? '',
        sid: box.read('sid') ?? '',
        currentyearfrom: box.read('currentyearfrom') ?? '',
        currentyearto: box.read('currentyearto') ?? '',
        sessionstartdate: box.read('sessionstartdate') ?? '',
        sessionenddate: box.read('sessionenddate') ?? '',
      );
      await addAccount(currentUser);
    }
  }
}
