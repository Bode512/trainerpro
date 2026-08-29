import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  String? _error;
  bool _emailVerificationSent = false;
  bool _needsEmailVerification = false;
  bool _obscurePassword = true;

  final _auth = FirebaseAuth.instance;
  final _google = GoogleSignIn();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static const List<String> _blockedDomains = [];

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    if (!_emailRegExp.hasMatch(email)) {
      return false;
    }
    final domain = email.split('@').last.toLowerCase();
    if (_blockedDomains.contains(domain)) {
      return false;
    }
    return true;
  }

  Future<void> _emailAuth() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (!_isValidEmail(email)) {
      setState(() {
        _error = 'Email no válido o dominio no permitido';
      });
      return;
    }
    if (pass.length < 6) {
      setState(() {
        _error = 'La contraseña debe tener al menos 6 caracteres';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
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
            _error =
                'Verifica tu correo electrónico. Revisa tu bandeja de entrada.';
          });
          return;
        }
      } else {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
        await cred.user?.updateDisplayName(
          _sanitizeInput(_nameCtrl.text.trim()),
        );
        await _saveUserToFirestore(cred.user);
        await cred.user?.sendEmailVerification();
        setState(() {
          _emailVerificationSent = true;
        });
        await _auth.signOut();
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = _translateError(e.code);
      });
    } catch (e) {
      setState(() {
        _error = 'Error de autenticación';
      });
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _googleAuth() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) {
        setState(() {
          _loading = false;
        });
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
      setState(() {
        _error = 'Error al iniciar sesión con Google';
      });
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _guestAuth() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cred = await _auth.signInAnonymously();
      await _saveUserToFirestore(cred.user);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = _translateError(e.code);
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudo entrar como invitado';
      });
    }
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  String _sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>]'), '').trim();
  }

  Future<void> _saveUserToFirestore(User? user) async {
    if (user == null) {
      return;
    }
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
    final palette = getPalette(AppTheme.deepSlate);

    return Scaffold(
      backgroundColor: palette.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppleDesignSystem.spacing28,
            ),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.accent.withValues(alpha: 0.1),
                        border: Border.all(
                          color: palette.accent.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        size: 32,
                        color: palette.accent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "TRAINER PRO",
                      style: AppleDesignSystem.title2.copyWith(
                        color: palette.accent,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _needsEmailVerification
                          ? "Verifica tu correo para continuar"
                          : (_isLogin
                                ? "Inicia sesión para continuar"
                                : "Crea tu cuenta"),
                      style: AppleDesignSystem.footnote.copyWith(
                        color: palette.textTertiary,
                      ),
                    ),

                    if (_emailVerificationSent) ...[
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(
                          AppleDesignSystem.spacing20,
                        ),
                        decoration: BoxDecoration(
                          color: palette.success.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(
                            AppleDesignSystem.radiusL,
                          ),
                          border: Border.all(
                            color: palette.success.withValues(alpha: 0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: palette.success.withValues(alpha: 0.12),
                              ),
                              child: Icon(
                                LucideIcons.mailCheck,
                                color: palette.success,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Correo de verificación enviado",
                              style: AppleDesignSystem.subheadline.copyWith(
                                color: palette.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Revisa ${_emailCtrl.text.trim()} y haz click en el enlace para activar tu cuenta.",
                              textAlign: TextAlign.center,
                              style: AppleDesignSystem.caption1.copyWith(
                                color: palette.textTertiary,
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _emailVerificationSent = false;
                                    _isLogin = true;
                                  });
                                },
                                child: const Text(
                                  "INICIAR SESIÓN",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 40),

                      if (!_isLogin) ...[
                        _buildField(_nameCtrl, "Nombre", LucideIcons.user),
                        const SizedBox(height: 14),
                      ],
                      _buildField(
                        _emailCtrl,
                        "Email",
                        LucideIcons.mail,
                        keyboard: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        _passCtrl,
                        "Contraseña",
                        LucideIcons.lock,
                        obscure: _obscurePassword,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          child: Icon(
                            _obscurePassword
                                ? LucideIcons.eyeOff
                                : LucideIcons.eye,
                            size: 18,
                            color: palette.textQuaternary,
                          ),
                        ),
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(
                            AppleDesignSystem.spacing12,
                          ),
                          decoration: BoxDecoration(
                            color: palette.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(
                              AppleDesignSystem.radiusS,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.alertCircle,
                                size: 16,
                                color: palette.error,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: AppleDesignSystem.caption1.copyWith(
                                    color: palette.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _emailAuth,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isLogin ? "INICIAR SESIÓN" : "REGISTRARSE",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: palette.separator.withValues(alpha: 0.5),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppleDesignSystem.spacing16,
                            ),
                            child: Text(
                              "O",
                              style: AppleDesignSystem.caption1.copyWith(
                                color: palette.textQuaternary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: palette.separator.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: _loading ? null : _googleAuth,
                          icon: const Icon(LucideIcons.globe, size: 18),
                          label: const Text(
                            "Continuar con Google",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton.icon(
                          onPressed: _loading ? null : _guestAuth,
                          icon: Icon(
                            LucideIcons.user,
                            size: 18,
                            color: palette.textTertiary,
                          ),
                          label: Text(
                            "Entrar como invitado",
                            style: AppleDesignSystem.subheadline.copyWith(
                              color: palette.textTertiary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),
                      GestureDetector(
                        onTap: () => setState(() {
                          _isLogin = !_isLogin;
                          _error = null;
                          _needsEmailVerification = false;
                        }),
                        child: RichText(
                          text: TextSpan(
                            text: _isLogin
                                ? "¿No tienes cuenta? "
                                : "¿Ya tienes cuenta? ",
                            style: AppleDesignSystem.footnote.copyWith(
                              color: palette.textTertiary,
                            ),
                            children: [
                              TextSpan(
                                text: _isLogin ? "Regístrate" : "Inicia sesión",
                                style: AppleDesignSystem.footnote.copyWith(
                                  color: palette.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType? keyboard,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    final palette = getPalette(AppTheme.deepSlate);
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      obscureText: obscure,
      style: AppleDesignSystem.subheadline.copyWith(
        color: palette.textPrimary,
      ),
      decoration: AppleComponents.inputDecoration(
        palette: palette,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: palette.textQuaternary),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
