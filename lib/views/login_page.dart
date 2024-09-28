import 'package:flutter/material.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/text_input_form_field.dart';
import 'package:project_evydhence/routes/app_routes.dart';
import 'package:universal_platform/universal_platform.dart';

class LoginPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const LoginPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;
  bool _enableSubmitButton = false;
  bool _isHidden = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _usuarioController.addListener(_enableSubmitButtonListener);
    _senhaController.addListener(_enableSubmitButtonListener);
    Future.delayed(Duration.zero, () async {
      if (UniversalPlatform.isWeb) return;
    });
  }

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _toggleTheme(bool isDarkMode) {
    widget.onThemeChanged(isDarkMode);
  }

  _handleLogin(String usuario, String senha) async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    final login = usuario == 'admin' && senha == 'admin';
    final loginSucceeded = login;
    if (loginSucceeded) {
      return _successfulLoginRedirect();
    }

    setState(() {
      _senhaController.clear();
      _isLoading = false;
      _errorMessage = 'Usuário ou senha incorretos';
    });
  }

  _onLoginButtonPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await _handleLogin(
      _usuarioController.text,
      _senhaController.text,
    );
  }

  void _enableSubmitButtonListener() {
    setState(() {
      _enableSubmitButton = _shouldEnableSubmitButton();
    });
  }

  bool _shouldEnableSubmitButton() {
    final usuario = _usuarioController.text;
    final senha = _senhaController.text;

    return usuario.isNotEmpty && senha.isNotEmpty;
  }

  _successfulLoginRedirect() => Navigator.of(context).pushNamed(
        AppRoutes.clientPage,
      );

  _buildErrorAlert() => SizedBox(
        height: 80.0,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(18.0),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 4.0,
                color: Color.fromRGBO(182, 22, 22, 1),
              ),
            ),
            color: Color.fromRGBO(241, 141, 141, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: const Icon(
                  Icons.cancel,
                  color: Color.fromRGBO(182, 22, 22, 1),
                ),
              ),
              Expanded(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Color.fromRGBO(0, 0, 17, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            centerTitle: false,
            title: Container(
              height: 150.0,
              width: 150.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                image:
                    DecorationImage(image: ExactAssetImage('images/icon.png')),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isDarkMode ? Icons.brightness_2 : Icons.brightness_5,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                  Switch(
                    value: widget.isDarkMode,
                    onChanged: (value) {
                      _toggleTheme(value);
                    },
                    activeColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    inactiveThumbColor: Colors.white,
                    activeTrackColor: Colors.blueAccent,
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 40.0),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: true,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14.0),
                      child: Text(
                        'Bem-vindo!',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                          color: widget.isDarkMode
                              ? Colors.white70
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.only(top: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_errorMessage.isNotEmpty) _buildErrorAlert(),
                          SizedBox(
                            height: 60.0,
                            child: TextInputFormField(
                              controller: _usuarioController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Usuário inválido';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: widget.isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.white,
                                hintText: 'Usuário',
                                hintStyle: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60.0,
                            child: TextInputFormField(
                              controller: _senhaController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Senha inválida';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              obscureText: _isHidden,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: widget.isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.white,
                                hintText: 'Senha',
                                hintStyle: TextStyle(
                                  color: widget.isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: widget.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),

                          // Botão
                          Button(
                            flavor: ButtonFlavor.elevated,
                            onPressed: _enableSubmitButton
                                ? _onLoginButtonPressed
                                : null,
                            child: Text(
                              'ACESSAR MINHA CONTA',
                              style: TextStyle(
                                color: widget.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
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
