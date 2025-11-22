# 📚 Guide du Débutant - Application OM_PAY Flutter

## 🎯 Introduction

Bienvenue ! Ce guide explique chaque fichier de l'application de manière simple pour les débutants.

---

## 📁 Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── api_service/                 # Communication avec le serveur
│   └── api_service.dart
├── dto/                         # Modèles de données (Request/Response)
│   ├── request/                 # Données envoyées au serveur
│   └── response/                # Données reçues du serveur
├── screens/                     # Tous les écrans de l'application
│   ├── auth/                    # Écrans d'authentification
│   └── home/                    # Écrans principaux
├── services/                    # Logique métier
├── theme/                       # Couleurs et styles
├── utils/                       # Outils et constantes
└── widgets/                     # Composants réutilisables
```

---

## 🚀 Fichier Principal

### 📄 **main.dart** - Point d'entrée de l'application

#### **Rôle** : Démarrer l'application et configurer les paramètres de base

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();  // Initialiser Flutter
  
  // Forcer le mode portrait (empêcher la rotation horizontale)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());  // Lancer l'application
}
```

**Explication simple** :
- `main()` = La première fonction qui s'exécute
- `ensureInitialized()` = Préparer Flutter avant de démarrer
- `setPreferredOrientations` = Bloquer l'écran en mode vertical
- `runApp()` = Afficher l'application

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OM_PAY',
      theme: AppTheme.darkTheme,      // Thème sombre
      debugShowCheckedModeBanner: false,  // Enlever le bandeau "DEBUG"
      initialRoute: '/login',          // Premier écran = Login
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/activate': (context) => ActivateAccountScreen(...),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
```

**Explication** :
- `MaterialApp` = Le conteneur principal de l'app
- `theme` = Les couleurs et styles de l'app
- `initialRoute` = Le premier écran affiché (Login)
- `routes` = La carte des écrans disponibles

---

## 🎨 Thème et Styles

### 📄 **theme/app_colors.dart** - Toutes les couleurs de l'application

```dart
class AppColors {
  // Couleurs Orange Money
  static const Color primaryOrange = Color(0xFFFF6600);  // Orange principal
  static const Color darkOrange = Color(0xFFE55A00);     // Orange foncé
  
  // Couleurs de fond
  static const Color darkBackground = Color(0xFF1A1A1A); // Fond noir
  static const Color cardBackground = Color(0xFF2A2A2A); // Fond des cartes
  
  // Couleurs de texte
  static const Color textPrimary = Color(0xFFFFFFFF);    // Texte blanc
  static const Color textSecondary = Color(0xFFB0B0B0);  // Texte gris
  
  // Statuts
  static const Color greenSuccess = Color(0xFF00C853);   // Vert (succès)
  static const Color redError = Color(0xFFFF1744);       // Rouge (erreur)
}
```

**Comment utiliser** :
```dart
Container(
  color: AppColors.primaryOrange,  // Fond orange
  child: Text('Hello', style: TextStyle(color: AppColors.textPrimary)),
)
```

### 📄 **theme/app_text_styles.dart** - Tous les styles de texte

```dart
class AppTextStyles {
  // Grands titres
  static const header1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  // Titres moyens
  static const header2 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  
  // Petits titres
  static const header3 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  
  // Texte normal
  static const body = TextStyle(fontSize: 16, color: AppColors.textPrimary);
  
  // Petit texte
  static const caption = TextStyle(fontSize: 14, color: AppColors.textSecondary);
}
```

**Comment utiliser** :
```dart
Text('Bienvenue', style: AppTextStyles.header1),
Text('Connexion', style: AppTextStyles.header2),
Text('Détails', style: AppTextStyles.caption),
```

---

## 🌐 Communication avec le Serveur

### 📄 **api_service/api_service.dart** - Envoie et reçoit des données du serveur

#### **Rôle** : Parler avec le backend (serveur Spring Boot)

```dart
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;  // Singleton (une seule instance)
  
  String? _token;  // Token JWT pour l'authentification
  
  // Génère les headers HTTP
  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {'Content-Type': 'application/json'};
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';  // Ajouter le token
    }
    return headers;
  }
}
```

**Singleton** = Une seule instance partagée dans toute l'app

#### **Méthode POST** - Envoyer des données

```dart
Future<Map<String, dynamic>> post(
  String endpoint,            // '/auth/login'
  Map<String, dynamic> data,  // { telephone: '771234567', motDePasse: 'pass' }
  {bool includeAuth = false}
) async {
  final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
  
  final response = await http.post(
    url,
    headers: _getHeaders(includeAuth: includeAuth),
    body: json.encode(data),  // Transformer en JSON
  );
  
  if (response.statusCode == 200 || response.statusCode == 201) {
    return json.decode(response.body);  // Succès
  } else {
    // Extraire le message d'erreur du serveur
    final errorBody = json.decode(response.body);
    throw Exception(errorBody['message'] ?? 'Erreur HTTP ${response.statusCode}');
  }
}
```

**Flux de données** :
```
Flutter App  --POST-->  Serveur Spring Boot
    {                       ↓
      telephone: "771234567",   Traite la requête
      motDePasse: "pass"        ↓
    }                       Répond
Flutter App  <--JSON--  { token: "abc123", user: {...} }
```

#### **Méthode GET** - Récupérer des données

```dart
Future<Map<String, dynamic>> getWithAuth(String endpoint) async {
  final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
  
  final response = await http.get(
    url,
    headers: _getHeaders(includeAuth: true),  // Avec token
  );
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    // Messages d'erreur clairs
    if (response.statusCode == 404) {
      throw Exception('Ressource non trouvée');
    } else if (response.statusCode == 401) {
      throw Exception('Session expirée. Veuillez vous reconnecter');
    }
    // ... autres codes HTTP
  }
}
```

**Codes HTTP expliqués** :
- **200** = OK (Succès)
- **201** = Créé (Ressource créée avec succès)
- **400** = Mauvaise requête (Données invalides)
- **401** = Non autorisé (Token expiré ou manquant)
- **404** = Non trouvé (Ressource inexistante)
- **500** = Erreur serveur

---

## 📦 Modèles de Données (DTO)

### 📄 **dto/request/login_request.dart** - Données pour se connecter

```dart
class LoginRequest {
  final String telephone;
  final String motDePasse;
  
  LoginRequest({
    required this.telephone,
    required this.motDePasse,
  });
  
  // Transformer en JSON pour l'envoyer au serveur
  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone,
      'motDePasse': motDePasse,
    };
  }
}
```

**Usage** :
```dart
final request = LoginRequest(
  telephone: '771234567',
  motDePasse: 'Password123!',
);

final json = request.toJson();
// Résultat: { "telephone": "771234567", "motDePasse": "Password123!" }

// Envoyer au serveur
await apiService.post('/auth/login', json);
```

### 📄 **dto/response/auth_response.dart** - Réponse après connexion

```dart
class AuthResponse {
  final String? token;
  final UserResponse? user;
  final String? message;
  
  AuthResponse({this.token, this.user, this.message});
  
  // Créer depuis JSON reçu du serveur
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AuthResponse(
      token: data?['token'],
      user: data?['utilisateur'] != null 
          ? UserResponse.fromJson(data['utilisateur']) 
          : null,
      message: json['message'],
    );
  }
}
```

**Flux** :
```
Serveur envoie JSON →  Flutter transforme en objet AuthResponse
{                      ↓
  "data": {           AuthResponse(
    "token": "abc",     token: "abc",
    "utilisateur": {    user: UserResponse(...),
      "nom": "Diop"   )
    }
  }
}
```

### 📄 **dto/response/transaction_response.dart** - Une transaction

```dart
class TransactionResponse {
  final int id;
  final String typeTransaction;      // TRANSFERT, PAIEMENT, DEPOT, RETRAIT
  final double montant;
  final String statut;               // TERMINE, EN_COURS, ECHOUE
  final String reference;            // TRX123456
  final String dateCreation;
  final String? compteExpediteur;    // OM8000380279
  final String? compteDestinataire;  // OM2665616523
  
  // Propriété calculée (getter)
  String get formattedMontant {
    return montant.toStringAsFixed(0)  // Enlever les décimales
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',  // Ajouter des espaces
        ) + ' FCFA';
  }
  
  // Créer depuis JSON
  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      id: json['id'],
      typeTransaction: json['typeTransaction'],
      montant: (json['montant'] as num).toDouble(),
      statut: json['statut'],
      reference: json['reference'],
      dateCreation: json['dateCreation'],
      compteExpediteur: json['compteExpediteur'],
      compteDestinataire: json['compteDestinataire'],
    );
  }
}
```

**Usage** :
```dart
final transaction = TransactionResponse.fromJson({...});
print(transaction.formattedMontant);  // "50 000 FCFA"
```

---

## 🏗️ Services (Logique Métier)

### 📄 **services/auth_service.dart** - Gestion de l'authentification

```dart
class AuthService {
  final ApiService _apiService = ApiService();
  
  // 1️⃣ INSCRIPTION
  Future<AuthResponse> register({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String motDePasse,
    String? codePin,
  }) async {
    try {
      // Créer la requête
      final request = RegisterRequest(
        nom: nom,
        prenom: prenom,
        telephone: telephone,
        email: email,
        motDePasse: motDePasse,
        codePin: codePin,
      );
      
      // Envoyer au serveur
      final response = await _apiService.post(
        ApiConstants.registerEndpoint,
        request.toJson(),
      );
      
      // Transformer la réponse en objet
      return AuthResponse.fromJson(response);
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }
  
  // 2️⃣ CONNEXION
  Future<void> login({
    required String telephone,
    required String motDePasse,
  }) async {
    try {
      final request = LoginRequest(
        telephone: telephone,
        motDePasse: motDePasse,
      );
      
      final response = await _apiService.post(
        ApiConstants.loginEndpoint,
        request.toJson(),
      );
      
      final data = response['data'];
      final token = data['token'];
      
      // Sauvegarder le token dans ApiService
      _apiService.token = token;
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }
  
  // 3️⃣ VÉRIFIER SI CONNECTÉ
  bool isLoggedIn() {
    return _apiService.token != null && _apiService.token!.isNotEmpty;
  }
  
  // 4️⃣ RÉCUPÉRER LE PROFIL
  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiService.getWithAuth(
      ApiConstants.profilEndpoint,
    );
    return response['data'];
  }
  
  // 5️⃣ DÉCONNEXION
  void logout() {
    _apiService.token = null;
  }
}
```

**Scénario d'utilisation** :
```dart
final authService = AuthService();

// Inscription
await authService.register(
  nom: 'Diop',
  prenom: 'Moussa',
  telephone: '771234567',
  email: 'moussa@test.com',
  motDePasse: 'Password123!',
);

// Connexion
await authService.login(
  telephone: '771234567',
  motDePasse: 'Password123!',
);

// Vérifier si connecté
if (authService.isLoggedIn()) {
  print('Utilisateur connecté');
}

// Récupérer le profil
final profile = await authService.getProfile();
print('Nom: ${profile['nom']}');

// Déconnexion
authService.logout();
```

### 📄 **services/transaction_service.dart** - Gestion des transactions

```dart
class TransactionService {
  final ApiService _apiService = ApiService();
  final CompteService _compteService = CompteService();
  
  // 1️⃣ FAIRE UN TRANSFERT
  Future<TransactionResponse> transfert({
    required String telephoneDestinataire,
    required double montant,
  }) async {
    try {
      final request = TransfertRequest(
        telephoneDestinataire: telephoneDestinataire,
        montant: montant,
      );
      
      final response = await _apiService.post(
        ApiConstants.transfertEndpoint,
        request.toJson(),
        includeAuth: true,  // Avec token d'authentification
      );
      
      final transactionData = response['data'];
      return TransactionResponse.fromJson(transactionData);
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }
  
  // 2️⃣ RÉCUPÉRER L'HISTORIQUE
  Future<List<TransactionResponse>> getHistorique() async {
    try {
      // D'abord récupérer le numéro de compte
      final numeroCompte = await _compteService.getNumeroCompte();
      
      // Puis récupérer les transactions
      final response = await _apiService.getWithAuth(
        '${ApiConstants.historiqueEndpoint}/$numeroCompte',
      );
      
      final data = response['data'];
      
      if (data is List) {
        // Transformer chaque JSON en objet TransactionResponse
        return data
            .map((json) => TransactionResponse.fromJson(json))
            .toList();
      } else {
        throw Exception('Format de données invalide');
      }
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }
}
```

**Usage** :
```dart
final transactionService = TransactionService();

// Faire un transfert
final transaction = await transactionService.transfert(
  telephoneDestinataire: '779876543',
  montant: 5000,
);
print('Transfert réussi: ${transaction.reference}');

// Récupérer l'historique
final historique = await transactionService.getHistorique();
for (var t in historique) {
  print('${t.typeTransaction}: ${t.formattedMontant}');
}
```

---

## 🖥️ Écrans (Screens)

### 📄 **screens/auth/login_screen.dart** - Écran de connexion

#### **Structure**

```dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Contrôleurs pour récupérer le texte des champs
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Service d'authentification
  final _authService = AuthService();
  
  // États de l'interface
  bool _isLoading = false;        // Afficher le chargement ?
  bool _obscurePassword = true;   // Masquer le mot de passe ?
  String? _phoneError;            // Message d'erreur du téléphone
  String? _passwordError;         // Message d'erreur du mot de passe
  
  @override
  void dispose() {
    // Nettoyer les contrôleurs quand l'écran est détruit
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

**Explication** :
- `StatefulWidget` = Un écran qui peut changer (boutons, texte...)
- `TextEditingController` = Permet de lire ce que l'utilisateur tape
- `bool _isLoading` = true → afficher un spinner, false → masquer
- `String? _phoneError` = null → pas d'erreur, "texte" → afficher l'erreur

#### **Méthode de connexion**

```dart
Future<void> _handleLogin() async {
  // Effacer les anciennes erreurs
  setState(() {
    _phoneError = null;
    _passwordError = null;
  });
  
  // Validation des champs
  bool hasError = false;
  
  if (_phoneController.text.isEmpty) {
    setState(() => _phoneError = ErrorMessages.telephoneRequis);
    hasError = true;
  }
  
  if (_passwordController.text.isEmpty) {
    setState(() => _passwordError = ErrorMessages.motDePasseRequis);
    hasError = true;
  }
  
  if (hasError) return;  // Arrêter si erreurs
  
  // Afficher le chargement
  setState(() => _isLoading = true);
  
  try {
    // Tenter la connexion
    await _authService.login(
      telephone: _phoneController.text.trim(),
      motDePasse: _passwordController.text,
    );
    
    // Arrêter le chargement
    setState(() => _isLoading = false);
    
    // Rediriger vers l'écran d'accueil
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  } catch (e) {
    // En cas d'erreur
    setState(() => _isLoading = false);
    
    String errorMessage = ErrorMessages.parseBackendError(e);
    
    // Afficher l'erreur sous le bon champ
    if (errorMessage.contains('mot de passe')) {
      setState(() => _passwordError = errorMessage);
    } else {
      setState(() => _phoneError = errorMessage);
    }
  }
}
```

**Flux de l'interface** :
```
1. Utilisateur remplit les champs
2. Utilisateur clique sur "Connexion"
3. Validation des champs
4. Si erreurs → afficher sous les champs
5. Si OK → Afficher spinner de chargement
6. Envoyer au serveur
7. Si succès → Rediriger vers /home
8. Si erreur → Afficher message d'erreur
```

#### **Interface (Widget build)**

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.darkBackground,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Logo
            Image.asset('assets/logo.png', height: 100),
            
            SizedBox(height: 40),
            
            // Titre
            Text('Connexion', style: AppTextStyles.header1),
            
            SizedBox(height: 40),
            
            // Champ téléphone
            CustomTextField(
              controller: _phoneController,
              label: 'Numéro de téléphone',
              hint: '77 123 45 67',
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              errorText: _phoneError,  // Afficher l'erreur si existe
            ),
            
            SizedBox(height: 20),
            
            // Champ mot de passe
            CustomTextField(
              controller: _passwordController,
              label: 'Mot de passe',
              hint: 'Votre mot de passe',
              prefixIcon: Icons.lock,
              obscureText: _obscurePassword,  // Masquer le texte
              errorText: _passwordError,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            
            SizedBox(height: 40),
            
            // Bouton de connexion
            CustomButton(
              text: 'Se connecter',
              onPressed: _handleLogin,
              isLoading: _isLoading,  // Afficher le spinner si true
            ),
            
            SizedBox(height: 20),
            
            // Lien vers inscription
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Pas de compte ? '),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(color: AppColors.primaryOrange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
```

### 📄 **screens/home/home_screen.dart** - Écran principal

#### **Structure de base**

```dart
class _HomeScreenState extends State<HomeScreen> {
  // Type de transaction sélectionné
  TransactionType _selectedType = TransactionType.transfer;
  
  // Contrôleurs des champs
  final _numberController = TextEditingController();
  final _amountController = TextEditingController();
  
  // Services
  final _compteService = CompteService();
  final _transactionService = TransactionService();
  final _paiementService = PaiementMarchandService();
  final _authService = AuthService();
  
  // Données affichées
  double _balance = 0;
  String _userName = '';
  String _userPhone = '';
  List<TransactionResponse> _transactions = [];
  
  // États
  bool _isLoading = true;
  bool _isProcessing = false;
  String? _numberError;
  String? _amountError;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();  // Charger les données au démarrage
  }
}
```

#### **Chargement des données**

```dart
Future<void> _loadUserData() async {
  try {
    // Charger en parallèle
    final profile = await _authService.getProfile();
    final solde = await _compteService.consulterMonSolde();
    final historique = await _transactionService.getHistorique();
    
    // Mettre à jour l'interface
    setState(() {
      _userName = '${profile['prenom']} ${profile['nom']}';
      _userPhone = profile['telephone'];
      _balance = solde;
      _transactions = historique;
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    
    // Afficher une notification d'erreur
    if (mounted) {
      CustomSnackbar.showError(
        context,
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}
```

#### **Gestion de la transaction**

```dart
Future<void> _handleTransaction() async {
  // Effacer les erreurs
  setState(() {
    _numberError = null;
    _amountError = null;
  });
  
  // Validation
  bool hasError = false;
  
  if (_numberController.text.isEmpty) {
    setState(() => _numberError = _selectedType == TransactionType.pay 
      ? 'Le code marchand est requis'
      : 'Le destinataire est requis');
    hasError = true;
  }
  
  if (_amountController.text.isEmpty) {
    setState(() => _amountError = 'Le montant est requis');
    hasError = true;
  } else {
    final montant = double.tryParse(_amountController.text);
    if (montant == null || montant <= 0) {
      setState(() => _amountError = 'Montant invalide');
      hasError = true;
    } else if (montant > _balance) {
      setState(() => _amountError = 'Solde insuffisant');
      hasError = true;
    }
  }
  
  if (hasError) return;
  
  setState(() => _isProcessing = true);
  
  try {
    final montant = double.parse(_amountController.text);
    
    if (_selectedType == TransactionType.transfer) {
      // Transfert
      await _transactionService.transfert(
        telephoneDestinataire: _numberController.text.trim(),
        montant: montant,
      );
    } else {
      // Paiement marchand
      await _paiementService.paiement(
        codeMarchand: _numberController.text.trim(),
        montant: montant,
      );
    }
    
    setState(() => _isProcessing = false);
    
    // Notification de succès
    CustomSnackbar.showSuccess(
      context,
      _selectedType == TransactionType.pay
          ? 'Paiement effectué avec succès'
          : 'Transfert effectué avec succès',
    );
    
    // Effacer les champs
    _numberController.clear();
    _amountController.clear();
    
    // Recharger les données
    _loadUserData();
  } catch (e) {
    setState(() => _isProcessing = false);
    
    String errorMessage = ErrorMessages.parseBackendError(e);
    
    // Afficher l'erreur sous le champ approprié
    if (errorMessage.contains('téléphone') || 
        errorMessage.contains('marchand')) {
      setState(() => _numberError = errorMessage);
    } else {
      setState(() => _amountError = errorMessage);
    }
  }
}
```

#### **Interface**

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: CustomDrawer(...),  // Menu latéral
    appBar: AppBar(
      title: Text('OM_PAY'),
      actions: [
        IconButton(
          icon: Icon(Icons.qr_code),
          onPressed: _showQRCode,
        ),
      ],
    ),
    body: _isLoading
        ? Center(child: CircularProgressIndicator())  // Spinner de chargement
        : RefreshIndicator(
            onRefresh: _loadUserData,  // Tirer pour actualiser
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Carte de solde
                  BalanceCard(
                    balance: _balance,
                    userName: _userName,
                    userPhone: _userPhone,
                  ),
                  
                  // Toggle Transférer / Payer
                  TransactionTypeToggle(
                    selectedType: _selectedType,
                    onChanged: (type) => setState(() => _selectedType = type),
                  ),
                  
                  // Champ numéro (téléphone ou code marchand)
                  CustomTextField(
                    controller: _numberController,
                    label: _selectedType == TransactionType.pay
                        ? 'Code Marchand'
                        : 'Numéro de téléphone',
                    errorText: _numberError,
                  ),
                  
                  // Champ montant
                  CustomTextField(
                    controller: _amountController,
                    label: 'Montant',
                    keyboardType: TextInputType.number,
                    errorText: _amountError,
                  ),
                  
                  // Bouton de validation
                  CustomButton(
                    text: 'Valider',
                    onPressed: _handleTransaction,
                    isLoading: _isProcessing,
                  ),
                  
                  // Liste des transactions récentes
                  ...transactions.map((t) => TransactionCard(
                    transaction: t,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetailScreen(
                            transaction: t,
                          ),
                        ),
                      );
                    },
                  )),
                ],
              ),
            ),
          ),
  );
}
```

---

## 🧩 Widgets Réutilisables

### 📄 **widgets/custom_button.dart** - Bouton personnalisé

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  
  const CustomButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,  // Largeur totale
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,  // Désactiver si chargement
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)  // Spinner
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}
```

**Usage** :
```dart
CustomButton(
  text: 'Se connecter',
  onPressed: () => print('Clic !'),
  isLoading: false,
)

// Avec chargement
CustomButton(
  text: 'Chargement...',
  onPressed: () {},
  isLoading: true,  // Affiche un spinner
)
```

### 📄 **widgets/custom_text_field.dart** - Champ de texte personnalisé

```dart
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  
  const CustomTextField({
    this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(label, style: AppTextStyles.caption),
        SizedBox(height: 8),
        
        // Champ de saisie
        TextField(
          controller: controller,
          obscureText: obscureText,  // Masquer le texte (mot de passe)
          keyboardType: keyboardType,
          style: TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null 
                ? Icon(prefixIcon, color: AppColors.primaryOrange)
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.redError),
            ),
          ),
        ),
        
        // Message d'erreur
        if (errorText != null) ...[
          SizedBox(height: 8),
          Text(
            errorText!,
            style: TextStyle(
              color: AppColors.redError,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
```

**Usage** :
```dart
final controller = TextEditingController();

CustomTextField(
  controller: controller,
  label: 'Téléphone',
  hint: '77 123 45 67',
  prefixIcon: Icons.phone,
  keyboardType: TextInputType.phone,
  errorText: 'Numéro invalide',  // null si pas d'erreur
)
```

### 📄 **widgets/custom_snackbar.dart** - Notifications élégantes

```dart
class CustomSnackbar {
  // Succès (vert avec ✓)
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.greenSuccess,
        behavior: SnackBarBehavior.floating,  // Flottant
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }
  
  // Erreur (rouge avec ⚠)
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.redError,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
  
  // Information (bleu avec ℹ)
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFF2196F3),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
```

**Usage** :
```dart
// Succès
CustomSnackbar.showSuccess(context, 'Transfert réussi');

// Erreur
CustomSnackbar.showError(context, 'Solde insuffisant');

// Info
CustomSnackbar.showInfo(context, 'Téléchargement en cours...');
```

---

## 📄 **screens/home/transaction_detail_screen.dart** - Détails d'une transaction

### **Méthodes utilitaires**

```dart
// Formater le montant: 50000 → "50 000"
String _formatAmount(double amount) {
  return amount.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]} ',
  );
}

// Formater la date: "2025-11-17T14:30:00" → "17/11/2025 à 14:30"
String _formatDate(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute}';
  } catch (e) {
    return dateStr;
  }
}

// Choisir l'icône selon le type
IconData _getTransactionIcon() {
  switch (transaction.typeTransaction.toUpperCase()) {
    case 'TRANSFERT': return Icons.send_rounded;
    case 'DEPOT': return Icons.account_balance_wallet_rounded;
    case 'RETRAIT': return Icons.money_rounded;
    case 'PAIEMENT': return Icons.shopping_bag_rounded;
    default: return Icons.receipt_rounded;
  }
}

// Choisir la couleur selon le type
Color _getTransactionColor() {
  switch (transaction.typeTransaction.toUpperCase()) {
    case 'DEPOT': return AppColors.greenSuccess;  // Vert
    case 'RETRAIT':
    case 'PAIEMENT': return AppColors.redError;   // Rouge
    case 'TRANSFERT': return AppColors.primaryOrange; // Orange
    default: return AppColors.textSecondary;
  }
}
```

### **Widgets de construction**

```dart
// Titre de section
Widget _buildSectionTitle(String title) {
  return Text(title, style: AppTextStyles.header3);
}

// Carte avec fond coloré
Widget _buildDetailCard(List<Widget> children) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(children: children),
  );
}

// Ligne de détail (icône + label + valeur + bouton copier)
Widget _buildDetailRow(
  String label,        // "Référence"
  String value,        // "TRX123456"
  IconData icon,       // Icons.tag
  {
    bool isBold = false,
    Color? valueColor,
    bool canCopy = false,
    BuildContext? context,
  }
) {
  return Row(
    children: [
      // Icône dans un carré orange
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.primaryOrange),
      ),
      
      SizedBox(width: 16),
      
      // Label + Valeur
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),  // Petit texte gris
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      
      // Bouton copier
      if (canCopy && context != null)
        IconButton(
          icon: Icon(Icons.copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            CustomSnackbar.showSuccess(context, 'Référence copiée');
          },
        ),
    ],
  );
}
```

### **Interface complète**

```dart
@override
Widget build(BuildContext context) {
  final color = _getTransactionColor();
  
  return Scaffold(
    appBar: AppBar(
      title: Text('Détails de la transaction'),
      actions: [
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            CustomSnackbar.showInfo(context, 'Partage de la transaction');
          },
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // 1. Header avec montant et icône
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
            ),
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                // Icône dans un cercle
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getTransactionIcon(), size: 40, color: color),
                ),
                
                SizedBox(height: 16),
                
                // Type
                Text(
                  transaction.typeTransaction,
                  style: TextStyle(fontSize: 16, color: color),
                ),
                
                SizedBox(height: 8),
                
                // Montant en gros
                Text(
                  '${_formatAmount(transaction.montant)} FCFA',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                
                SizedBox(height: 16),
                
                // Badge statut
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.greenSuccess,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(transaction.statut),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // 2. Informations
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Informations de la transaction'),
                SizedBox(height: 16),
                _buildDetailCard([
                  _buildDetailRow(
                    'Référence',
                    transaction.reference,
                    Icons.tag,
                    canCopy: true,
                    context: context,
                  ),
                  Divider(height: 32),
                  _buildDetailRow(
                    'Date',
                    _formatDate(transaction.dateCreation),
                    Icons.calendar_today,
                  ),
                ]),
                
                SizedBox(height: 24),
                
                // 3. Montant
                _buildSectionTitle('Détails du montant'),
                SizedBox(height: 16),
                _buildDetailCard([
                  _buildDetailRow(
                    'Montant',
                    '${_formatAmount(transaction.montant)} FCFA',
                    Icons.attach_money,
                  ),
                  Divider(height: 32),
                  _buildDetailRow(
                    'Frais',
                    '500 FCFA',
                    Icons.receipt,
                  ),
                  Divider(height: 32),
                  _buildDetailRow(
                    'Total',
                    '${_formatAmount(transaction.montant + 500)} FCFA',
                    Icons.account_balance,
                    isBold: true,
                  ),
                ]),
                
                SizedBox(height: 32),
                
                // 4. Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          CustomSnackbar.showInfo(
                            context,
                            'Téléchargement du reçu...',
                          );
                        },
                        icon: Icon(Icons.download),
                        label: Text('Télécharger'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          CustomSnackbar.showInfo(
                            context,
                            'Répéter la transaction',
                          );
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Répéter'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

## 🛠️ Utilitaires

### 📄 **utils/error_messages.dart** - Messages d'erreur centralisés

```dart
class ErrorMessages {
  // Authentification
  static const String telephoneRequis = 'Le numéro de téléphone est obligatoire';
  static const String telephoneInvalide = 'Format de téléphone invalide';
  static const String motDePasseRequis = 'Le mot de passe est obligatoire';
  static const String motDePasseIncorrect = 'Mot de passe incorrect';
  
  // Compte
  static const String soldeInsuffisant = 'Solde insuffisant';
  static const String compteNonTrouve = 'Compte non trouvé';
  
  // Transaction
  static const String montantRequis = 'Le montant est obligatoire';
  static const String montantInvalide = 'Montant invalide';
  static const String destinataireRequis = 'Le destinataire est requis';
  
  // Succès
  static const String transfertReussi = 'Transfert effectué avec succès';
  static const String paiementReussi = 'Paiement effectué avec succès';
  
  // Parser les erreurs du backend
  static String parseBackendError(dynamic error) {
    if (error == null) return 'Erreur interne';
    
    final errorString = error.toString().toLowerCase();
    
    // HTTP 401
    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return motDePasseIncorrect;
    }
    
    // HTTP 404 avec contexte
    if (errorString.contains('404')) {
      if (errorString.contains('marchand')) return 'Marchand non trouvé';
      if (errorString.contains('compte')) return compteNonTrouve;
      if (errorString.contains('utilisateur')) return 'Utilisateur non trouvé';
      return 'Ressource non trouvée';
    }
    
    // Solde
    if (errorString.contains('solde insuffisant')) {
      return soldeInsuffisant;
    }
    
    // Message brut nettoyé
    String cleanError = error.toString()
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .trim();
    
    return cleanError.isNotEmpty ? cleanError : 'Erreur interne';
  }
}
```

**Usage** :
```dart
try {
  await authService.login(...);
} catch (e) {
  String message = ErrorMessages.parseBackendError(e);
  print(message);  // "Mot de passe incorrect" au lieu de "HTTP 401"
}
```

### 📄 **utils/constants.dart** - Constantes de l'application

```dart
class ApiConstants {
  // URL du serveur
  static const String baseUrl = 'https://om-pay-spring-boot-1.onrender.com/api';
  
  // Endpoints d'authentification
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String verifyCodeSecretEndpoint = '/auth/verify-code-secret';
  
  // Endpoints de compte
  static const String profilEndpoint = '/utilisateurs/profil';
  static const String soldeEndpoint = '/comptes/mon-solde';
  
  // Endpoints de transaction
  static const String transfertEndpoint = '/transactions/transfert';
  static const String paiementEndpoint = '/transactions/paiement-marchand';
  static const String historiqueEndpoint = '/transactions/historique';
}
```

**Usage** :
```dart
final response = await apiService.post(
  ApiConstants.loginEndpoint,  // '/auth/login'
  data,
);
```

---

## 🎓 Concepts Clés pour Débutants

### **1. StatelessWidget vs StatefulWidget**

```dart
// StatelessWidget = Ne change jamais
class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('logo.png');  // Toujours pareil
  }
}

// StatefulWidget = Peut changer (boutons, champs, etc.)
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;  // Variable qui change
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Compte: $count'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;  // Changer et rafraîchir l'écran
            });
          },
          child: Text('Incrémenter'),
        ),
      ],
    );
  }
}
```

### **2. Async/Await - Attendre une réponse**

```dart
// Sans async/await (mauvais)
void login() {
  authService.login(...);  // Ne attend pas la réponse !
  Navigator.push(...);     // Navigue trop tôt !
}

// Avec async/await (bon)
Future<void> login() async {
  await authService.login(...);  // Attend la réponse
  Navigator.push(...);           // Navigue après
}

// Avec gestion d'erreur
Future<void> login() async {
  try {
    await authService.login(...);  // Essayer
    Navigator.push(...);           // Si succès
  } catch (e) {
    print('Erreur: $e');           // Si échec
  }
}
```

### **3. setState - Rafraîchir l'écran**

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool isLoading = false;
  
  void loadData() async {
    setState(() {
      isLoading = true;  // 1. Afficher le spinner
    });
    
    await Future.delayed(Duration(seconds: 2));  // Simuler chargement
    
    setState(() {
      isLoading = false;  // 2. Masquer le spinner
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()  // Spinner si true
        : Text('Données chargées');    // Texte si false
  }
}
```

### **4. Navigation entre écrans**

```dart
// Aller vers un écran
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Aller vers un écran et supprimer l'ancien
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => HomeScreen()),
);

// Revenir en arrière
Navigator.pop(context);

// Avec routes nommées
Navigator.pushNamed(context, '/login');
Navigator.pushReplacementNamed(context, '/home');
```

### **5. TextEditingController - Lire les champs**

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final controller = TextEditingController();
  
  @override
  void dispose() {
    controller.dispose();  // Nettoyer
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,  // Connecter le contrôleur
          decoration: InputDecoration(labelText: 'Nom'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Valeur: ${controller.text}');  // Lire la valeur
            controller.clear();  // Effacer le champ
          },
          child: Text('Valider'),
        ),
      ],
    );
  }
}
```

---

## 🚀 Flux Complet d'une Transaction

```
1. Utilisateur ouvre l'app
   ↓
2. main.dart démarre → initialRoute: '/login'
   ↓
3. LoginScreen s'affiche
   ↓
4. Utilisateur remplit téléphone + mot de passe
   ↓
5. Utilisateur clique "Connexion"
   ↓
6. _handleLogin() appelé
   ↓
7. Validation des champs
   ↓
8. setState(() => _isLoading = true)  → Affiche spinner
   ↓
9. authService.login(...)
   ↓
10. ApiService.post('/auth/login', {...})
    ↓
11. http.post() → Envoie au serveur Spring Boot
    ↓
12. Serveur répond { "data": { "token": "abc123" } }
    ↓
13. ApiService sauvegarde le token
    ↓
14. setState(() => _isLoading = false)  → Masque spinner
    ↓
15. Navigator.pushReplacementNamed('/home')
    ↓
16. HomeScreen s'affiche
    ↓
17. initState() → _loadUserData()
    ↓
18. Récupère profil + solde + historique
    ↓
19. setState() → Affiche les données
    ↓
20. Utilisateur fait un transfert
    ↓
21. _handleTransaction() appelé
    ↓
22. Validation + setState(_isProcessing = true)
    ↓
23. transactionService.transfert(...)
    ↓
24. ApiService.post('/transactions/transfert', {...}, includeAuth: true)
    ↓
25. Serveur traite et répond avec la transaction
    ↓
26. CustomSnackbar.showSuccess("Transfert réussi")
    ↓
27. _loadUserData() → Actualise solde + historique
    ↓
28. setState() → Affiche nouveau solde
```

---

## 📌 Résumé pour Débutant

### **Les fichiers principaux** :

1. **main.dart** → Démarre l'app, définit les routes
2. **api_service.dart** → Communique avec le serveur
3. **auth_service.dart** → Login, register, logout
4. **transaction_service.dart** → Transferts, historique
5. **login_screen.dart** → Écran de connexion
6. **home_screen.dart** → Écran principal
7. **transaction_detail_screen.dart** → Détails d'une transaction
8. **custom_snackbar.dart** → Notifications élégantes

### **Les concepts importants** :

- **Widget** = Un élément visuel (bouton, texte, image...)
- **StatefulWidget** = Widget qui peut changer
- **setState()** = Rafraîchir l'écran
- **async/await** = Attendre une réponse du serveur
- **Controller** = Lire ce que l'utilisateur tape
- **Navigator** = Changer d'écran
- **try/catch** = Gérer les erreurs

### **Le flux de données** :

```
Utilisateur → TextField → Controller
                ↓
            Button onClick
                ↓
            Service (login, transfert...)
                ↓
            ApiService
                ↓
            HTTP Request
                ↓
            Serveur Spring Boot
                ↓
            HTTP Response
                ↓
            DTO (fromJson)
                ↓
            setState()
                ↓
            UI se rafraîchit
```

---

## 🎉 Conclusion

Vous avez maintenant une compréhension complète de l'application OM_PAY Flutter !

**Points clés à retenir** :

✅ Chaque fichier a un rôle précis
✅ Les services gèrent la logique métier
✅ Les écrans affichent l'interface
✅ Les widgets sont réutilisables
✅ Les DTOs transportent les données
✅ ApiService communique avec le serveur
✅ setState() rafraîchit l'interface
✅ async/await gère l'asynchrone

**Pour aller plus loin** :

- Lisez la documentation Flutter : https://flutter.dev/docs
- Pratiquez en modifiant les widgets
- Ajoutez de nouvelles fonctionnalités
- Expérimentez avec les styles et couleurs

Bon courage dans votre apprentissage ! 🚀
