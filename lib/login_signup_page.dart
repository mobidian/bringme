import 'package:flutter/material.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:bringme/services/crud.dart';
import 'package:bringme/services/userData.dart';
import 'package:bringme/services/deliveryManData.dart';
import 'primary_button.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

enum FormType { login, register, registerAsPro }

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();

  CrudMethods crudObj = new CrudMethods();

  String _email;
  String _password;
  String _name;
  String _surname;
  String _phone;

  //livreur
  String _typeOfRemorque = 'Utilitaire 3m3';
  String _immatriculation;

  String _errorMessage;

  FormType _formType = FormType.login;

  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      try {
        String userId = _formType == FormType.login
            ? await widget.auth.signIn(_email, _password)
            : await widget.auth.createUser(_email, _password);
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }

        if (_formType == FormType.register) {
          UserData userData = new UserData(
            name: _name,
            surname: _surname,
            mail: _email,
            phone: _phone,
          );

          crudObj.createOrUpdateUserData(userData.getDataMap());
        }

        if (_formType == FormType.registerAsPro) {
          DeliveryManData deliveryManData = new DeliveryManData(
              name: _name,
              surname: _surname,
              mail: _email,
              phone: _phone,
              typeOfRemorque: _typeOfRemorque,
              immatriculation: _immatriculation);

          crudObj.createOrUpdateDeliveryManData(deliveryManData.getDataMap());
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _formType = FormType.login;
    super.initState();
  }

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _errorMessage = '';
    });
  }

  void moveToRegisterAsPro() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.registerAsPro;
      _errorMessage = '';
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _errorMessage = '';
    });
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('email'),
        decoration: InputDecoration(
          labelText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
            return 'Saisissez un e-mail valide';
          }
        },
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _buildNameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('namefield'),
        decoration: InputDecoration(
          labelText: 'Prénom',
          icon: new Icon(
            Icons.perm_identity,
            color: Colors.grey,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un prénom';
          }
        },
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget _buildSurnameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('surnamefield'),
        decoration: InputDecoration(
          labelText: 'Nom',
          icon: new Icon(
            Icons.perm_identity,
            color: Colors.grey,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Saisissez un nom';
          }
        },
        onSaved: (value) => _surname = value.trim(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('password'),
        decoration: InputDecoration(
            labelText: 'Mot de passe',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        controller: _passwordTextController,
        obscureText: true,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return '6 caractères minimum sont requis';
          }
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _builConfirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Confirmez le mot de passe',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        obscureText: true,
        validator: (String value) {
          if (_passwordTextController.text != value) {
            return 'Le mot de passe ne correspond pas';
          }
        },
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        maxLines: 1,
        key: new Key('phonefield'),
        decoration: InputDecoration(
          labelText: 'Téléphone',
          icon: new Icon(
            Icons.phone,
            color: Colors.grey,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return 'numéro invalide';
          }
        },
        onSaved: (value) => _phone = value.trim(),
      ),
    );
  }

  Widget _buildTypeOfRemorqueField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.airport_shuttle,
            color: Colors.grey[500],
          ),
          SizedBox(
            width: 15,
          ),
          DropdownButton<String>(
            value: _typeOfRemorque,
            icon: Icon(Icons.arrow_downward),
            iconSize: 17,
            elevation: 16,
            style: TextStyle(color: Colors.grey[600]),
            underline: Container(
              height: 1,
              color: Colors.grey[500],
            ),
            onChanged: (String newValue) {
              setState(() {
                _typeOfRemorque = newValue;
              });
            },
            items: <String>[
              'Citadine & Compact',
              'Berline & break',
              'Utilitaire 3m3',
              'Utilitaire 6m3',
              'Utilitaire 9m3',
              'Utilitaire 12m3',
              'Utilitaire 14m3',
              'Utilitaire 20m3',
              'Utilitaire 20m3 avec plateau de chargement',
              'Véhicule isotherme ou frigorifique'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildImmatriculationField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        key: new Key('immatriculationfield'),
        decoration: InputDecoration(
          labelText: 'Immatriculation',
          icon: new Icon(
            Icons.assignment,
            color: Colors.grey,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Immatriculation invalide';
          }
        },
        onSaved: (value) => _immatriculation = value.trim(),
      ),
    );
  }

  Widget submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            PrimaryButton(
              key: new Key('login'),
              text: 'Connexion',
              height: 44.0,
              onPressed: validateAndSubmit,
            ),
            FlatButton(
                key: new Key('need-account'),
                child: Text("Créer un compte"),
                onPressed: moveToRegister),
          ],
        );
      default:
        return ListView(
          shrinkWrap: true,
          children: <Widget>[
            PrimaryButton(
                key: new Key('register'),
                text: 'Créer',
                height: 44.0,
                onPressed: validateAndSubmit),
            FlatButton(
                key: new Key('need-login'),
                child: Text("Déjà un compte ? Se connecter"),
                onPressed: moveToLogin),
          ],
        );
    }
  }

  Widget _showCircularProgress() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget comptePro() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FlatButton(
        onPressed: moveToRegisterAsPro,
        child: Text('Créer un compte Pro'),
      ),
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _buildForm() {
    return new Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildEmailField(),
          _formType == FormType.register ? _buildNameField() : Container(),
          _formType == FormType.registerAsPro
              ? _buildNameField()
              : Container(),
          _formType == FormType.register
              ? _buildSurnameField()
              : Container(),
          _formType == FormType.registerAsPro
              ? _buildSurnameField()
              : Container(),
          _formType == FormType.register ? _buildPhoneField() : Container(),
          _formType == FormType.registerAsPro
              ? _buildPhoneField()
              : Container(),
          _formType == FormType.registerAsPro
              ? _buildTypeOfRemorqueField()
              : Container(),
          _formType == FormType.registerAsPro
              ? _buildImmatriculationField()
              : Container(),
          _buildPasswordField(),
          _formType == FormType.register
              ? _builConfirmPasswordTextField()
              : Container(),
          _formType == FormType.registerAsPro
              ? _builConfirmPasswordTextField()
              : Container(),
          _isLoading == false ? submitWidgets() : _showCircularProgress(),
          showErrorMessage(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Bring Me beta'),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildForm(),
                    ),
                  ],
                ),
                _formType == FormType.registerAsPro ? Container() : comptePro(),
              ],
            ),
          ),
        ));
  }
}
