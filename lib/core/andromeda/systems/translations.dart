import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';

class TranslationManager extends ChangeNotifier {
  static final TranslationManager _instance = TranslationManager._internal();
  factory TranslationManager() => _instance;
  TranslationManager._internal();

  static const String _languageKey = 'selected_language';

  static const String defaultLanguage = 'en-US';
  Locale _currentLocale = const Locale(defaultLanguage);
  Locale get currentLocale => _currentLocale;

  static final Map<String, String> supportedLanguages = {
    'en-US': 'English',
    'cs-CZ': 'Čeština',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
  };

  static final Map<String, Map<String, String>> _localizedValues = {
    'en-US': {
      // general
      'main-about': 'About',
      'main-settings': 'Settings',
      'main-applications': 'Applications',
      'main-no-applications': 'No applications found',
      'main-edit-app': 'Edit',
      'main-remove-app': 'Remove',
      'main-designer-app': 'Designer',
      'main-remove-app-confirm': 'Are you sure you want to remove this application?',
      'main-remove-app-cancel': 'Cancel',
      'main-remove-app-remove': 'Remove',
      'main-remote-applications': 'Remote Applications',
      'main-custom-applications': 'Custom Applications',

      // about page
      'about-version': 'Version: {0}',
      'about-description': """
Andromeda is an innovative mobile platform for creating and managing custom applications in a secure environment.

With Andromeda, you can create two types of applications:
- Remote applications that synchronize with the server via API
- Local applications that you can create and easily share with others

Each application can be secured with a password or biometric verification for maximum data security.

Andromeda thus brings revolution to mobile development - no complex development tools, no compilation, no installation files.
      """,
      'about-description-2': "All you need is your idea and Andromeda",

      // add application page
      'addapp-close': 'Close',
      'addapp-appbar-title': 'Add application',
      'addapp-server-url': 'Server URL',
      'addapp-api-key': 'API Key',
      'addapp-submit': 'Submit',
      'addapp-change-icon': 'Change icon',
      'addapp-select-icon': 'Select an icon',
      'addapp-no-icons-found': 'No icons found',
      'addapp-search-icon': 'Search...',
      'addapp-label': 'Label',
      'addapp-enter-label-hint': 'Enter a label for this application',
      'addapp-please-enter-label': 'Please enter a label',
      'addapp-please-enter-server-url': 'Please enter server URL',
      'addapp-please-enter-api-key': 'Please enter API key',
      'addapp-new-application': 'New application',
      'addapp-secure-instance': 'Secure this instance',
      'addapp-secure-instance-desc': 'Add authentication protection',
      'addapp-auth-method': 'Authentication method',
      'addapp-password-auth': 'Password',
      'addapp-biometric-auth': 'Biometric',
      'addapp-password': 'Password',
      'addapp-password-too-short': 'Password must be at least 6 characters',
      'addapp-biometric-will-be-required': 'Biometric authentication will be required to access this instance',
      'addapp-authenticate-to-add-application': 'Authenticate to add application',
      'addapp-biometric-auth-failed': 'Biometric authentication failed',
      'addapp-please-select-auth-method': 'Please select an authentication method',
      'addapp-fill-from': 'Fill from',
      'addapp-camera-required-for-qr': 'Camera permission is required to scan QR codes',
      'addapp-invalid-qr-format': 'Invalid QR code format',
      'addapp-qr-code': 'QR Code',
      'addapp-is-custom': 'Custom application',
      'addapp-is-custom-desc': 'You will have the option to create a custom application',

      // edit application page
      'editapp-application-not-found': 'Application not found',
      'editapp-appbar-title': 'Edit application',
      'editapp-select-icon': 'Select icon',
      'editapp-no-icons-found': 'No icons found',
      'editapp-search-icon': 'Search...',
      'editapp-close': 'Close',
      'editapp-change-icon': 'Change icon',
      'editapp-label': 'Label',
      'editapp-enter-label-hint': 'Enter a label for this application',
      'editapp-please-enter-label': 'Please enter a label',
      'editapp-server-url': 'Server URL',
      'editapp-api-key': 'API Key',
      'editapp-enter-new-api-key-optional': 'Enter new API key (optional)',
      'editapp-save-changes': 'Save changes',

      // qr scanner
      'qr-scan-qr': 'Scan QR Code',

      // language
      'sys-language': 'Language',

      // theme
      'sys-theme': 'Theme',
      'sys-system-theme': 'System Theme',
      'sys-light-theme': 'Light Theme',
      'sys-dark-theme': 'Dark Theme',
    },
    'cs-CZ': {
      // general
      'main-about': 'O aplikaci',
      'main-settings': 'Nastavení',
      'main-applications': 'Aplikace',
      'main-no-applications': 'Nebyly nalezeny žádné aplikace',
      'main-edit-app': 'Upravit',
      'main-remove-app': 'Odstranit',
      'main-designer-app': 'Návrhář',
      'main-remove-app-confirm': 'Opravdu chcete odstranit tuto aplikaci?',
      'main-remove-app-cancel': 'Zrušit',
      'main-remove-app-remove': 'Odstranit',
      'main-remote-applications': 'Vzdálené Aplikace',
      'main-custom-applications': 'Vlastní Aplikace',

      // about page
      'about-version': 'Verze: {0}',
      'about-description': """
Andromeda je inovativní mobilní platforma pro vytváření a správu vlastních aplikací v zabezpečeném prostředí.

S Andromedou můžete vytvářet dva typy aplikací:
- Vzdálené aplikace, které se synchronizují se serverem pomocí API
- Lokální aplikace, které si můžete vytvořit a jednoduše sdílet s ostatními

Každou aplikaci lze zabezpečit heslem nebo biometrickým ověřením pro maximální bezpečnost vašich dat.

Andromeda tak přináší revoluci v mobilním vývoji - žádné složité vývojové nástroje, žádná kompilace, žádné instalační soubory.
      """,
      'about-description-2': "Stačí jen váš nápad a Andromeda",

      // add application page
      'addapp-close': 'Zavřít',
      'addapp-appbar-title': 'Přidat aplikaci',
      'addapp-server-url': 'URL Serveru',
      'addapp-api-key': 'API Klíč',
      'addapp-submit': 'Přidat',
      'addapp-change-icon': 'Změnit ikonu',
      'addapp-select-icon': 'Vyberte ikonu',
      'addapp-no-icons-found': 'Nebyly nalezeny žádné ikony',
      'addapp-search-icon': 'Hledat...',
      'addapp-label': 'Štítek',
      'addapp-enter-label-hint': 'Zadejte štítek pro tuto aplikaci',
      'addapp-please-enter-label': 'Prosím zadejte štítek',
      'addapp-please-enter-server-url': 'Prosím zadejte URL serveru',
      'addapp-please-enter-api-key': 'Prosím zadejte API klíč',
      'addapp-new-application': 'Nová aplikace',
      'addapp-secure-instance': 'Zabezpečit tuto instanci',
      'addapp-secure-instance-desc': 'Přidat ochranu autentizací',
      'addapp-auth-method': 'Metoda autentizace',
      'addapp-password-auth': 'Heslo',
      'addapp-biometric-auth': 'Biometrická',
      'addapp-password': 'Heslo',
      'addapp-password-too-short': 'Heslo musí mít alespoň 6 znaků',
      'addapp-biometric-will-be-required': 'Biometrická autentizace bude vyžadována pro přístup k této instanci',
      'addapp-authenticate-to-add-application': 'Autentizujte se pro přidání aplikace',
      'addapp-biometric-auth-failed': 'Biometrická autentizace selhala',
      'addapp-please-select-auth-method': 'Prosím vyberte metodu autentizace',
      'addapp-fill-from': 'Vyplnit z',
      'addapp-camera-required-for-qr': 'Je vyžadováno povolení kamery pro skenování QR kódů',
      'addapp-invalid-qr-format': 'Neplatný formát QR kódu',
      'addapp-qr-code': 'QR Kód',
      'addapp-is-custom': 'Vlastní aplikace',
      'addapp-is-custom-desc': 'Budete mít možnost vytvořit vlastní aplikaci',

      // edit application page
      'editapp-application-not-found': 'Aplikace nebyla nalezena',
      'editapp-appbar-title': 'Upravit aplikaci',
      'editapp-select-icon': 'Vyberte ikonu',
      'editapp-no-icons-found': 'Nebyly nalezeny žádné ikony',
      'editapp-search-icon': 'Hledat...',
      'editapp-close': 'Zavřít',
      'editapp-change-icon': 'Změnit ikonu',
      'editapp-label': 'Štítek',
      'editapp-enter-label-hint': 'Zadejte štítek pro tuto aplikaci',
      'editapp-please-enter-label': 'Prosím zadejte štítek',
      'editapp-server-url': 'URL Serveru',
      'editapp-api-key': 'API Klíč',
      'editapp-enter-new-api-key-optional': 'Zadejte nový API klíč (volitelné)',
      'editapp-save-changes': 'Uložit změny',

      // qr scanner
      'qr-scan-qr': 'Skenovat QR Kód',

      // language
      'sys-language': 'Jazyk',

      // theme
      'sys-theme': 'Vzhled',
      'sys-system-theme': 'Systémový',
      'sys-light-theme': 'Světlý',
      'sys-dark-theme': 'Tmavý',
    },
    // TODO: other languages
    'es': {
      // general
      'main-about': 'Acerca de',
      'main-settings': 'Ajustes',
      'main-applications': 'Aplicaciones',
      'main-no-applications': 'No se encontraron aplicaciones',
      'main-edit-app': 'Editar',
      'main-remove-app': 'Eliminar',
      'main-designer-app': 'Diseñador',
      'main-remove-app-confirm': '¿Está seguro de que desea eliminar esta aplicación?',
      'main-remove-app-cancel': 'Cancelar',
      'main-remove-app-remove': 'Eliminar',
      'main-remote-applications': 'Aplicaciones Remotas',
      'main-custom-applications': 'Aplicaciones Personalizadas',

      // about page
      'about-version': 'Versión: {0}',
      'about-description': """
Andromeda es una plataforma móvil innovadora para crear y gestionar aplicaciones personalizadas en un entorno seguro.

Con Andromeda, puedes crear dos tipos de aplicaciones:
- Aplicaciones remotas que se sincronizan con el servidor a través de API
- Aplicaciones locales que puedes crear y compartir fácilmente con otros

Cada aplicación puede protegerse con contraseña o verificación biométrica para máxima seguridad de datos.

Andromeda trae así una revolución al desarrollo móvil - sin herramientas complejas, sin compilación, sin archivos de instalación.
      """,
      'about-description-2': "Solo necesitas tu idea y Andromeda",

      // add application page
      'addapp-close': 'Cerrar',
      'addapp-appbar-title': 'Añadir aplicación',
      'addapp-server-url': 'URL del Servidor',
      'addapp-api-key': 'Clave API',
      'addapp-submit': 'Agregar',
      'addapp-change-icon': 'Cambiar icono',
      'addapp-select-icon': 'Seleccionar icono',
      'addapp-no-icons-found': 'No se encontraron iconos',
      'addapp-search-icon': 'Buscar...',
      'addapp-label': 'Etiqueta',
      'addapp-enter-label-hint': 'Introduzca una etiqueta para esta aplicación',
      'addapp-please-enter-label': 'Por favor, introduzca una etiqueta',
      'addapp-please-enter-server-url': 'Por favor, introduzca la URL del servidor',
      'addapp-please-enter-api-key': 'Por favor, introduzca la clave API',
      'addapp-new-application': 'Nueva aplicación',
      'addapp-secure-instance': 'Asegurar esta instancia',
      'addapp-secure-instance-desc': 'Añadir protección de autenticación',
      'addapp-auth-method': 'Método de autenticación',
      'addapp-password-auth': 'Contraseña',
      'addapp-biometric-auth': 'Biométrica',
      'addapp-password': 'Contraseña',
      'addapp-password-too-short': 'La contraseña debe tener al menos 6 caracteres',
      'addapp-biometric-will-be-required': 'Se requerirá autenticación biométrica para acceder a esta instancia',
      'addapp-authenticate-to-add-application': 'Autentíquese para añadir la aplicación',
      'addapp-biometric-auth-failed': 'La autenticación biométrica falló',
      'addapp-please-select-auth-method': 'Por favor, seleccione un método de autenticación',
      'addapp-fill-from': 'Rellenar desde',
      'addapp-camera-required-for-qr': 'Se requiere permiso de cámara para escanear códigos QR',
      'addapp-invalid-qr-format': 'Formato de código QR inválido',
      'addapp-qr-code': 'Código QR',
      'addapp-is-custom': 'Aplicación personalizada',
      'addapp-is-custom-desc': 'Podrá crear una aplicación personalizada',

      // edit application page
      'editapp-application-not-found': 'No se encontró la aplicación',
      'editapp-appbar-title': 'Editar aplicación',
      'editapp-select-icon': 'Seleccionar icono',
      'editapp-no-icons-found': 'No se encontraron iconos',
      'editapp-search-icon': 'Buscar...',
      'editapp-close': 'Cerrar',
      'editapp-change-icon': 'Cambiar icono',
      'editapp-label': 'Etiqueta',
      'editapp-enter-label-hint': 'Introduzca una etiqueta para esta aplicación',
      'editapp-please-enter-label': 'Por favor, introduzca una etiqueta',
      'editapp-server-url': 'URL del Servidor',
      'editapp-api-key': 'Clave API',
      'editapp-enter-new-api-key-optional': 'Introduzca nueva clave API (opcional)',
      'editapp-save-changes': 'Guardar cambios',

      // qr scanner
      'qr-scan-qr': 'Escanear Código QR',

      // language
      'sys-language': 'Idioma',

      // theme
      'sys-theme': 'Tema',
      'sys-system-theme': 'Sistema',
      'sys-light-theme': 'Claro',
      'sys-dark-theme': 'Oscuro',
    },
    'fr': {
      // general
      'main-about': 'À propos',
      'main-settings': 'Paramètres',
      'main-applications': 'Applications',
      'main-no-applications': 'Aucune application trouvée',
      'main-edit-app': 'Modifier',
      'main-remove-app': 'Supprimer',
      'main-designer-app': 'Designer',
      'main-remove-app-confirm': 'Voulez-vous vraiment supprimer cette application ?',
      'main-remove-app-cancel': 'Annuler',
      'main-remove-app-remove': 'Supprimer',
      'main-remote-applications': 'Applications Distantes',
      'main-custom-applications': 'Applications Personnalisées',

      // about page
      'about-description': """
Andromeda est une plateforme mobile innovante pour créer et gérer des applications personnalisées dans un environnement sécurisé.

Avec Andromeda, vous pouvez créer deux types d'applications :
- Des applications distantes qui se synchronisent avec le serveur via API
- Des applications locales que vous pouvez créer et partager facilement avec d'autres

Chaque application peut être sécurisée par mot de passe ou vérification biométrique pour une sécurité maximale des données.

Andromeda apporte ainsi une révolution dans le développement mobile - pas d'outils complexes, pas de compilation, pas de fichiers d'installation.
      """,
      'about-description-2': "Il suffit de votre idée et d'Andromeda",

      // add application page
      'addapp-close': 'Fermer',
      'addapp-appbar-title': 'Ajouter une application',
      'addapp-server-url': 'URL du Serveur',
      'addapp-api-key': 'Clé API',
      'addapp-submit': 'Ajouter',
      'addapp-change-icon': 'Changer l\'icône',
      'addapp-select-icon': 'Sélectionner une icône',
      'addapp-no-icons-found': 'Aucune icône trouvée',
      'addapp-search-icon': 'Rechercher...',
      'addapp-label': 'Étiquette',
      'addapp-enter-label-hint': 'Entrez une étiquette pour cette application',
      'addapp-please-enter-label': 'Veuillez entrer une étiquette',
      'addapp-please-enter-server-url': 'Veuillez entrer l\'URL du serveur',
      'addapp-please-enter-api-key': 'Veuillez entrer la clé API',
      'addapp-new-application': 'Nouvelle application',
      'addapp-secure-instance': 'Sécuriser cette instance',
      'addapp-secure-instance-desc': 'Ajouter une protection par authentification',
      'addapp-auth-method': 'Méthode d\'authentification',
      'addapp-password-auth': 'Mot de passe',
      'addapp-biometric-auth': 'Biométrique',
      'addapp-password': 'Mot de passe',
      'addapp-password-too-short': 'Le mot de passe doit contenir au moins 6 caractères',
      'addapp-biometric-will-be-required': 'L\'authentification biométrique sera requise pour accéder à cette instance',
      'addapp-authenticate-to-add-application': 'Authentifiez-vous pour ajouter l\'application',
      'addapp-biometric-auth-failed': 'L\'authentification biométrique a échoué',
      'addapp-please-select-auth-method': 'Veuillez sélectionner une méthode d\'authentification',
      'addapp-fill-from': 'Remplir à partir de',
      'addapp-camera-required-for-qr': 'L\'autorisation de la caméra est requise pour scanner les codes QR',
      'addapp-invalid-qr-format': 'Format de code QR invalide',
      'addapp-qr-code': 'Code QR',
      'addapp-is-custom': 'Application personnalisée',
      'addapp-is-custom-desc': 'Vous pourrez créer une application personnalisée',

      // edit application page
      'editapp-application-not-found': 'Application non trouvée',
      'editapp-appbar-title': 'Modifier l\'application',
      'editapp-select-icon': 'Sélectionner une icône',
      'editapp-no-icons-found': 'Aucune icône trouvée',
      'editapp-search-icon': 'Rechercher...',
      'editapp-close': 'Fermer',
      'editapp-change-icon': 'Changer l\'icône',
      'editapp-label': 'Étiquette',
      'editapp-enter-label-hint': 'Entrez une étiquette pour cette application',
      'editapp-please-enter-label': 'Veuillez entrer une étiquette',
      'editapp-server-url': 'URL du Serveur',
      'editapp-api-key': 'Clé API',
      'editapp-enter-new-api-key-optional': 'Entrez une nouvelle clé API (optionnel)',
      'editapp-save-changes': 'Sauvegarder les modifications',

      // qr scanner
      'qr-scan-qr': 'Scanner le Code QR',

      // language
      'sys-language': 'Langue',

      // theme
      'sys-theme': 'Thème',
      'sys-system-theme': 'Système',
      'sys-light-theme': 'Clair',
      'sys-dark-theme': 'Sombre',
    },
    'de': {
      // general
      'main-about': 'Über',
      'main-settings': 'Einstellungen',
      'main-applications': 'Anwendungen',
      'main-no-applications': 'Keine Anwendungen gefunden',
      'main-edit-app': 'Bearbeiten',
      'main-remove-app': 'Entfernen',
      'main-designer-app': 'Designer',
      'main-remove-app-confirm': 'Möchten Sie diese Anwendung wirklich entfernen?',
      'main-remove-app-cancel': 'Abbrechen',
      'main-remove-app-remove': 'Entfernen',
      'main-remote-applications': 'Remote-Anwendungen',
      'main-custom-applications': 'Benutzerdefinierte Anwendungen',

      // about page
      'about-version': 'Version: {0}',
      'about-description': """
Andromeda ist eine innovative mobile Plattform zur Erstellung und Verwaltung individueller Anwendungen in einer sicheren Umgebung.

Mit Andromeda können Sie zwei Arten von Anwendungen erstellen:
- Remote-Anwendungen, die sich über API mit dem Server synchronisieren
- Lokale Anwendungen, die Sie selbst erstellen und einfach mit anderen teilen können

Jede Anwendung kann mit Passwort oder biometrischer Verifizierung für maximale Datensicherheit geschützt werden.

Andromeda bringt damit eine Revolution in die mobile Entwicklung - keine komplexen Entwicklungstools, keine Kompilierung, keine Installationsdateien.
      """,
      'about-description-2': "Sie brauchen nur Ihre Idee und Andromeda",

      // add application page
      'addapp-close': 'Schließen',
      'addapp-appbar-title': 'Anwendung hinzufügen',
      'addapp-server-url': 'Server-URL',
      'addapp-api-key': 'API-Schlüssel',
      'addapp-submit': 'Hinzufügen',
      'addapp-change-icon': 'Symbol ändern',
      'addapp-select-icon': 'Symbol auswählen',
      'addapp-no-icons-found': 'Keine Symbole gefunden',
      'addapp-search-icon': 'Suchen...',
      'addapp-label': 'Bezeichnung',
      'addapp-enter-label-hint': 'Geben Sie eine Bezeichnung für diese Anwendung ein',
      'addapp-please-enter-label': 'Bitte geben Sie eine Bezeichnung ein',
      'addapp-please-enter-server-url': 'Bitte geben Sie die Server-URL ein',
      'addapp-please-enter-api-key': 'Bitte geben Sie den API-Schlüssel ein',
      'addapp-new-application': 'Neue Anwendung',
      'addapp-secure-instance': 'Diese Instanz sichern',
      'addapp-secure-instance-desc': 'Authentifizierungsschutz hinzufügen',
      'addapp-auth-method': 'Authentifizierungsmethode',
      'addapp-password-auth': 'Passwort',
      'addapp-biometric-auth': 'Biometrisch',
      'addapp-password': 'Passwort',
      'addapp-password-too-short': 'Das Passwort muss mindestens 6 Zeichen lang sein',
      'addapp-biometric-will-be-required': 'Biometrische Authentifizierung wird für den Zugriff auf diese Instanz benötigt',
      'addapp-authenticate-to-add-application': 'Authentifizieren Sie sich, um die Anwendung hinzuzufügen',
      'addapp-biometric-auth-failed': 'Biometrische Authentifizierung fehlgeschlagen',
      'addapp-please-select-auth-method': 'Bitte wählen Sie eine Authentifizierungsmethode',
      'addapp-fill-from': 'Ausfüllen von',
      'addapp-camera-required-for-qr': 'Kameraberechtigung wird für das Scannen von QR-Codes benötigt',
      'addapp-invalid-qr-format': 'Ungültiges QR-Code-Format',
      'addapp-qr-code': 'QR-Code',
      'addapp-is-custom': 'Benutzerdefinierte Anwendung',
      'addapp-is-custom-desc': 'Sie können eine benutzerdefinierte Anwendung erstellen',

      // edit application page
      'editapp-application-not-found': 'Anwendung nicht gefunden',
      'editapp-appbar-title': 'Anwendung bearbeiten',
      'editapp-select-icon': 'Symbol auswählen',
      'editapp-no-icons-found': 'Keine Symbole gefunden',
      'editapp-search-icon': 'Suchen...',
      'editapp-close': 'Schließen',
      'editapp-change-icon': 'Symbol ändern',
      'editapp-label': 'Bezeichnung',
      'editapp-enter-label-hint': 'Geben Sie eine Bezeichnung für diese Anwendung ein',
      'editapp-please-enter-label': 'Bitte geben Sie eine Bezeichnung ein',
      'editapp-server-url': 'Server-URL',
      'editapp-api-key': 'API-Schlüssel',
      'editapp-enter-new-api-key-optional': 'Neuen API-Schlüssel eingeben (optional)',
      'editapp-save-changes': 'Änderungen speichern',

      // qr scanner
      'qr-scan-qr': 'QR-Code scannen',

      // language
      'sys-language': 'Sprache',

      // theme
      'sys-theme': 'Design',
      'sys-system-theme': 'System',
      'sys-light-theme': 'Hell',
      'sys-dark-theme': 'Dunkel',
    },
  };

  Future<void> init() async {
    final savedLanguage = await Storage.loadDirect(_languageKey);
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    await Storage.saveDirect(_languageKey, languageCode);
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  String getCurrentLanguage() {
    return _currentLocale.languageCode;
  }

  String tr(String key) {
    return _localizedValues[_currentLocale.languageCode]?[key] ?? 
          _localizedValues['en']?[key] ?? 
          key;
  }
}

// Global translation function
String tr(String key) => TranslationManager().tr(key);