// Họ tên: Đặng Đức Mạnh   |   MSSV: 26A4041643   |   Lab 7.3 - Quản lý focus & bàn phím
import 'package:flutter/material.dart';

void main() => runApp(const Lab73App());

class Lab73App extends StatelessWidget {
  const Lab73App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Lab 7.3',
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const RegisterScreen(),
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();

  // FocusNode cho từng ô
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _hidePass = true;
  bool _hideConfirm = true;

  double _strength = 0;
  String _strengthLabel = '';
  Color _strengthColor = Colors.grey;

  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  @override
  void dispose() {
    for (final c in [_nameCtl, _emailCtl, _passCtl, _confirmCtl]) {
      c.dispose();
    }
    for (final f in [_nameFocus, _emailFocus, _passFocus, _confirmFocus]) {
      f.dispose();
    }
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập họ tên';
    if (v.trim().length < 2) return 'Họ tên tối thiểu 2 ký tự';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
    if (!_emailRegex.hasMatch(v.trim())) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePass(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (v.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Cần ít nhất 1 chữ hoa';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Cần ít nhất 1 chữ thường';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Cần ít nhất 1 chữ số';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
    if (v != _passCtl.text) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  void _updateStrength(String p) {
    int score = 0;
    if (p.length >= 8) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[a-z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]'))) score++;

    setState(() {
      _strength = p.isEmpty ? 0 : score / 5;
      if (p.isEmpty) {
        _strengthLabel = '';
        _strengthColor = Colors.grey;
      } else if (score <= 2) {
        _strengthLabel = 'Yếu';
        _strengthColor = Colors.red;
      } else if (score <= 4) {
        _strengthLabel = 'Trung bình';
        _strengthColor = Colors.orange;
      } else {
        _strengthLabel = 'Mạnh';
        _strengthColor = Colors.green;
      }
    });
  }

  // Submit: nếu lỗi thì focus vào ô lỗi đầu tiên
  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      if (_validateName(_nameCtl.text) != null) {
        _nameFocus.requestFocus();
      } else if (_validateEmail(_emailCtl.text) != null) {
        _emailFocus.requestFocus();
      } else if (_validatePass(_passCtl.text) != null) {
        _passFocus.requestFocus();
      } else {
        _confirmFocus.requestFocus();
      }
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đăng ký thành công 🎉'),
        content: Text('Xin chào ${_nameCtl.text.trim()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          FocusScope.of(context).unfocus(), // chạm ngoài để ẩn bàn phím
      child: Scaffold(
        appBar: AppBar(title: const Text('Lab 7.3 - Focus & bàn phím')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtl,
                    focusNode: _nameFocus,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateName,
                    onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtl,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                    onFieldSubmitted: (_) => _passFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passCtl,
                    focusNode: _passFocus,
                    obscureText: _hidePass,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePass ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _hidePass = !_hidePass),
                      ),
                    ),
                    validator: _validatePass,
                    onChanged: _updateStrength,
                    onFieldSubmitted: (_) => _confirmFocus.requestFocus(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: _strength,
                          color: _strengthColor,
                          backgroundColor: Colors.grey.shade300,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 80,
                        child: Text(
                          _strengthLabel,
                          style: TextStyle(
                            color: _strengthColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmCtl,
                    focusNode: _confirmFocus,
                    obscureText: _hideConfirm,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _hideConfirm = !_hideConfirm),
                      ),
                    ),
                    validator: _validateConfirm,
                    onFieldSubmitted: (_) => _submit(), // Enter = gửi form
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Đăng ký'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
