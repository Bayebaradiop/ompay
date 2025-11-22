# Structure DTO - Orange Money Flutter App

## 📁 Architecture DTO (Data Transfer Objects)

Cette application suit les bonnes pratiques en séparant les **entités** (backend) des **DTO** (frontend).

### Structure des dossiers

```
lib/
├── dto/
│   ├── request/           # DTO pour les requêtes vers l'API
│   │   ├── login_request.dart
│   │   ├── register_request.dart
│   │   ├── verify_code_request.dart
│   │   ├── transfert_request.dart
│   │   └── paiement_request.dart
│   │
│   └── response/          # DTO pour les réponses de l'API
│       ├── auth_response.dart
│       ├── user_response.dart
│       ├── compte_response.dart
│       ├── transaction_response.dart
│       └── profile_response.dart
│
├── services/              # Services utilisant les DTO
│   ├── auth_service.dart
│   ├── compte_service.dart
│   ├── transaction_service.dart
│   └── PaiementMarchandService.dart
│
└── screens/               # UI utilisant les DTO Response
    ├── auth/
    └── home/
```

## 📝 DTO Request (Requêtes)

### LoginRequest
```dart
{
  "telephone": "771234567",
  "motDePasse": "Password123!"
}
```

### RegisterRequest
```dart
{
  "nom": "Diop",
  "prenom": "Moussa",
  "telephone": "771234567",
  "email": "moussa@test.com",
  "motDePasse": "Password123!",
  "role": "CLIENT"
}
```

### TransfertRequest
```dart
{
  "telephoneDestinataire": "779876543",
  "montant": 5000.0
}
```

### PaiementRequest
```dart
{
  "codeMarchand": "SHOP001",
  "montant": 2500.0
}
```

## 📦 DTO Response (Réponses)

### AuthResponse
```dart
{
  "success": true,
  "message": "Connexion réussie",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "codeSecret": "123456",
  "user": UserResponse
}
```

### UserResponse
```dart
{
  "id": 1,
  "nom": "Diop",
  "prenom": "Moussa",
  "telephone": "771234567",
  "email": "moussa@test.com",
  "role": "CLIENT",
  "statut": "ACTIF"
}
```

### CompteResponse
```dart
{
  "id": 1,
  "numeroCompte": "OM8000380279",
  "solde": 50000.0,
  "typeCompte": "PRINCIPAL",
  "statut": "ACTIF"
}
```

### TransactionResponse
```dart
{
  "id": 1,
  "reference": "TRX20250117001",
  "typeTransaction": "TRANSFERT",
  "montant": 5000.0,
  "frais": 50.0,
  "montantTotal": 5050.0,
  "statut": "REUSSIE",
  "compteExpediteur": "OM8000380279",
  "compteDestinataire": "OM2665616523",
  "dateCreation": "2025-01-17T10:30:00",
  "nouveauSolde": 44950.0
}
```

## ✅ Avantages de l'architecture DTO

### 1. **Séparation des préoccupations**
- ✅ Frontend : DTO (communication API)
- ✅ Backend : Entités (base de données)

### 2. **Typage fort**
- ✅ Validation automatique avec Dart
- ✅ Autocomplétion dans l'IDE
- ✅ Détection d'erreurs à la compilation

### 3. **Sérialisation/Désérialisation**
- ✅ Méthodes `toJson()` pour les requêtes
- ✅ Méthodes `fromJson()` pour les réponses
- ✅ Conversion automatique des types

### 4. **Maintenabilité**
- ✅ Facile à modifier si l'API change
- ✅ Code plus lisible et organisé
- ✅ Tests unitaires simplifiés

### 5. **Sécurité**
- ✅ Pas d'exposition des entités internes
- ✅ Contrôle des données échangées
- ✅ Validation des champs

## 🔄 Flux de données

```
┌─────────────┐     Request DTO      ┌─────────────┐
│             │ ─────────────────────> │             │
│   Flutter   │                        │  Spring     │
│   Frontend  │ <───────────────────── │  Backend    │
│             │     Response DTO       │             │
└─────────────┘                        └─────────────┘
```

## 📚 Exemple d'utilisation

### Service avec DTO
```dart
Future<void> login({
  required String telephone,
  required String motDePasse,
}) async {
  // Créer le DTO de requête
  final request = LoginRequest(
    telephone: telephone,
    motDePasse: motDePasse,
  );

  // Envoyer la requête
  final response = await _apiRepository.post(
    ApiConstants.loginEndpoint,
    request.toJson(),  // Conversion automatique en JSON
  );

  // Recevoir le DTO de réponse
  final authResponse = AuthResponse.fromJson(response);
  
  if (authResponse.token != null) {
    _apiRepository.token = authResponse.token!;
  }
}
```

### UI avec Response DTO
```dart
List<TransactionResponse> _transactions = [];

void _loadTransactions() async {
  _transactions = await _transactionService.getHistorique();
  
  // Utilisation directe des propriétés typées
  for (var transaction in _transactions) {
    print('Montant: ${transaction.formattedMontant}');
    print('Date: ${transaction.formattedDate}');
  }
}
```

## 🚀 Bonne pratique professionnelle

Cette architecture est conforme aux standards de l'industrie et recommandée par votre professeur car elle :

- ✅ Respecte le principe de responsabilité unique (SRP)
- ✅ Facilite les tests unitaires
- ✅ Améliore la maintenabilité du code
- ✅ Prépare pour une architecture en microservices
- ✅ Permet l'évolution indépendante du frontend et backend

---

**Note** : L'ancien dossier `entitties/` peut maintenant être supprimé car tous les fichiers utilisent les DTO.
