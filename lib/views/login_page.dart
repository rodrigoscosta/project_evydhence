import 'package:flutter/material.dart';
import 'package:project_evydhence/components/button.dart';
import 'package:project_evydhence/components/text_input_form_field.dart';
import 'package:project_evydhence/views/client_list_page.dart';
import 'package:universal_platform/universal_platform.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final AuthService _authService = GetIt.I<AuthService>();
  final _formKey = GlobalKey<FormState>();

  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;
  bool _enableSubmitButton = false;
  bool _isHidden = true;

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

  _handleLogin(String usuario, String senha) async {
    setState(() {
      _isLoading = true;
    });

    return _successfulLoginRedirect();

    // final result = await _authService.login(usuario, senha);
    // final loginSucceeded = result.item1;
    // final loginErrors = result.item2;
    // if (loginSucceeded) {
    //   return _successfulLoginRedirect();
    // }

    // setState(() {
    //   _senhaController.clear();
    //   _isLoading = false;
    // });
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

  /// Função utilizada como listener de um [TextEditingController].
  ///
  /// Define o state [_enableSubmitButton] como o retorno da função
  /// [_shouldEnableSubmitButton].
  void _enableSubmitButtonListener() {
    setState(() {
      _enableSubmitButton = _shouldEnableSubmitButton();
    });
  }

  /// Valida se todos [TextEditingController.text] não estão vazios e se
  /// [_usuarioController.text] e [_senhaController.text]
  /// são iguais.
  bool _shouldEnableSubmitButton() {
    final usuario = _usuarioController.text;
    final senha = _senhaController.text;

    return usuario.isNotEmpty && senha.isNotEmpty;
  }

  _successfulLoginRedirect() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ClientListPage()), //Trocar para a page seguinte
      );

  Future<bool> _onWillPop() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
    return false;
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            title: Container(
              height: 150.0,
              width: 150.0,
              decoration: const BoxDecoration(
                image:
                    DecorationImage(image: ExactAssetImage('images/icon.png')),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
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
                      child: const Text(
                        'Bem-vindo!',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
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
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: Wrap(
                              runSpacing: 26.0,
                              children: [
                                // if (_errorMessage.isNotEmpty)
                                //   _buildErrorAlert(),
                                TextInputFormField(
                                  //enabled: !_isLoading,
                                  controller: _usuarioController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Usuário inválido';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    hintText: 'Usuário',
                                  ),
                                ),
                                TextInputFormField(
                                  //enabled: !_isLoading,
                                  controller: _senhaController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Senha inválida';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () {
                                    _onLoginButtonPressed();
                                  },
                                  obscureText: _isHidden,
                                  decoration: InputDecoration(
                                      hintText: 'Senha',
                                      suffixIcon: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          setState(() {
                                            _isHidden = !_isHidden;
                                          });
                                        },
                                        child: Icon(
                                          _isHidden
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          semanticLabel: _isHidden
                                              ? 'Mostrar senha'
                                              : 'Ocultar Senha',
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Button(
                            flavor: ButtonFlavor.elevated,
                            onPressed: _enableSubmitButton
                                ? _onLoginButtonPressed
                                : null,
                            // onPressed: () {
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const HomePage()), //Trocar para a page seguinte
                            //   );
                            // },
                            child: const Text('ACESSAR MINHA CONTA'),
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
