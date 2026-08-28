import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  String? _error;
  bool _emailVerificationSent = false;
  bool _needsEmailVerification = false;

  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static const List<String> _blockedDomains = [];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    if (!_emailRegExp.hasMatch(email)) return false;
    final domain = email.split('@').last.toLowerCase();
    if (_blockedDomains.contains(domain)) return false;
    return true;
  }

  Future<void> _emailAuth() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (!_isValidEmail(email)) {
      setState(() { _error = 'Email no válido o dominio no permitido'; });
      return;
    }
    if (pass.length < 6) {
      setState(() { _error = 'La contraseña debe tener al menos 6 caracteres'; });
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      if (_isLogin) {
        final cred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        if (cred.user != null && !cred.user!.emailVerified) {
          await _auth.signOut();
          setState(() {
            _needsEmailVerification = true;
            _error = 'Verifica tu correo electrónico. Revisa tu bandeja de entrada.';
          });
          return;
        }
      } else {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
        await cred.user?.updateDisplayName(_sanitizeInput(_nameCtrl.text.trim()));
        await _saveUserToFirestore(cred.user);
        await cred.user?.sendEmailVerification();
        setState(() { _emailVerificationSent = true; });
        await _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      setState(() { _error = _translateError(e.code); });
    } catch (e) {
      setState(() { _error = 'Error de autenticación'; });
    }
    if (mounted) setState(() { _loading = false; });
  }

  Future<void> _googleAuth() async {
    setState(() { _loading = true; _error = null; });
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) {
        setState(() { _loading = false; });
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      if (cred.user != null && !cred.user!.emailVerified) {
        await cred.user!.sendEmailVerification();
      }
      await _saveUserToFirestore(cred.user);
    } catch (e) {
      setState(() { _error = 'Error al iniciar sesión con Google'; });
    }
    if (mounted) setState(() { _loading = false; });
  }

  String _sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>]'), '').trim();
  }

  Future<void> _saveUserToFirestore(User? user) async {
    if (user == null) return;
    final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      await doc.set({
        'name': _sanitizeInput(user.displayName ?? ''),
        'email': user.email ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'emailVerified': user.emailVerified,
      }, SetOptions(merge: true));
    }
  }

  String _translateError(String code) {
    switch (code) {
      case 'weak-password':
      case 'invalid-email':
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email o contraseña incorrectos';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera unos minutos';
      case 'network-request-failed':
        return 'Error de conexión';
      default:
        return 'Error de autenticación';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.dumbbell, size: 40, color: Color(0xFF3B82F6)),
                ),
                const SizedBox(height: 16),
                const Text(
                  "TRAINER PRO",
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 6),

                if (_emailVerificationSent) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(LucideIcons.mailCheck, color: Colors.greenAccent, size: 32),
                        const SizedBox(height: 10),
                        const Text(
                          "Correo de verificación enviado",
                          style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Revisa ${_emailCtrl.text.trim()} y haz click en el enlace para activar tu cuenta.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              setState(() {
                                _emailVerificationSent = false;
                                _isLogin = true;
                              });
                            },
                            child: const Text("INICIAR SESIÓN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Text(
                    _needsEmailVerification
                        ? "Verifica tu correo para continuar"
                        : (_isLogin ? "Inicia sesión para continuar" : "Crea tu cuenta"),
                    style: const TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                  const SizedBox(height: 40),

                  if (!_isLogin) ...[
                    _buildField(_nameCtrl, "Nombre", LucideIcons.user),
                    const SizedBox(height: 14),
                  ],
                  _buildField(_emailCtrl, "Email", LucideIcons.mail, keyboard: TextInputType.emailAddress),
                  const SizedBox(height: 14),
                  _buildField(_passCtrl, "Contraseña", LucideIcons.lock, obscure: true),

                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      ),
                      child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                    ),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _loading ? null : _emailAuth,
                      child: _loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(
                              _isLogin ? "INICIAR SESIÓN" : "REGISTRARSE",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: 13),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white10)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("O", style: TextStyle(color: Colors.white24, fontSize: 12)),
                      ),
                      const Expanded(child: Divider(color: Colors.white10)),
                    ],
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _loading ? null : _googleAuth,
                      icon: const Icon(LucideIcons.chrome, size: 18, color: Colors.white70),
                      label: const Text(
                        "Continuar con Google",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => setState(() {
                      _isLogin = !_isLogin;
                      _error = null;
                      _needsEmailVerification = false;
                    }),
                    child: RichText(
                      text: TextSpan(
                        text: _isLogin ? "¿No tienes cuenta? " : "¿Ya tienes cuenta? ",
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                        children: [
                          TextSpan(
                            text: _isLogin ? "Regístrate" : "Inicia sesión",
                            style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String hint, IconData icon, {TextInputType? keyboard, bool obscure = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
        prefixIcon: Icon(icon, size: 18, color: Colors.white24),
        filled: true,
        fillColor: const Color(0xFF12162A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3B82F6)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
