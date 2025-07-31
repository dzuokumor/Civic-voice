// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'CivicVoice';

  @override
  String get anonymous => '100% Anonyme';

  @override
  String get anonymousDescription =>
      'Signalez des problèmes de gouvernance en toute sécurité sans révéler votre identité. Votre vie privée est notre priorité.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get submitReport => 'Soumettre un rapport';

  @override
  String get reportSubmitted => 'Rapport soumis!';

  @override
  String get reportSubmittedDescription =>
      'Votre rapport a été soumis anonymement';

  @override
  String get copyCode => 'Copier le code';

  @override
  String get returnHome => 'Retour à l\'accueil';

  @override
  String get trackReport => 'Suivre le rapport';

  @override
  String get checkStatus => 'Vérifier le statut';

  @override
  String get moderatorAccess => 'Accès modérateur';

  @override
  String get loginSecurely => 'Connexion sécurisée';

  @override
  String get publicDashboard => 'Tableau de bord public';

  @override
  String get requestDataPackage => 'Demander des données';

  @override
  String get settings => 'Paramètres';

  @override
  String get reportTitle => 'Titre du rapport';

  @override
  String get briefTitle => 'Titre bref et clair du problème';

  @override
  String get category => 'Catégorie';

  @override
  String get selectCategory => 'Sélectionnez une catégorie';

  @override
  String get location => 'Localisation';

  @override
  String get searchCity => 'Rechercher une ville';

  @override
  String get descriptionOptional => 'Description (Optionnelle)';

  @override
  String get detailedInfo =>
      'Fournissez des informations détaillées sur le problème...';

  @override
  String get addAttachment => 'Ajouter une pièce jointe';

  @override
  String get addAttachmentOptional => 'Ajouter une pièce jointe (Optionnelle)';

  @override
  String get attachmentTypes => 'Photos, documents ou autres preuves';

  @override
  String get submitAnonymously => 'Soumettre anonymement';

  @override
  String get privacyNotice =>
      'Votre rapport est complètement anonyme. Nous ne collectons aucune information personnelle pouvant vous identifier.';

  @override
  String get helpPrivacy => 'Aide & Confidentialité';

  @override
  String get completeAnonymity => 'Anonymat complet';

  @override
  String get anonymityDescription =>
      'Vos informations personnelles ne sont jamais collectées ou stockées. Les rapports ne peuvent pas être retracés jusqu\'à vous.';

  @override
  String get whatToInclude => 'Que inclure';

  @override
  String get includeDescription =>
      '• Description claire et factuelle\n• Localisation spécifique\n• Documents justificatifs si disponibles\n• Date et heure si possible';

  @override
  String get reportProcess => 'Processus de rapport';

  @override
  String get processDescription =>
      'Les rapports sont examinés par des modérateurs vérifiés et peuvent être publiés sur le tableau de bord public après vérification.';

  @override
  String get gotIt => 'Compris';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get submitReportAction => 'Soumettre un rapport';

  @override
  String get trackStatusAction => 'Suivre le statut';

  @override
  String get browseReports => 'Parcourir les rapports';

  @override
  String get appSettings => 'Paramètres';

  @override
  String get recentReports => 'Rapports récents';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get platformStatistics => 'Statistiques de la plateforme';

  @override
  String get totalReports => 'Total des rapports';

  @override
  String get allSubmissions => 'Toutes les soumissions';

  @override
  String get recentReportsCount => 'Rapports récents';

  @override
  String get lastVerified => '3 derniers vérifiés';

  @override
  String welcomeBack(Object userName) {
    return 'Bon retour, $userName!';
  }

  @override
  String get makeDifference => 'Prêt à faire la différence aujourd\'hui?';

  @override
  String get welcomeGuest => 'Bienvenue sur CivicVoice!';

  @override
  String get browseSubmit => 'Parcourez les rapports ou soumettez anonymement';

  @override
  String get registerPrompt =>
      'Inscrivez-vous en tant que chercheur ou modérateur pour accéder aux fonctionnalités avancées';

  @override
  String get privacyProtected =>
      'Votre vie privée est protégée par un chiffrement de bout en bout';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get requestResearchData => 'Demander des données de recherche';

  @override
  String get purchaseDescription =>
      'Achetez des données de rapports de gouvernance anonymisées à des fins de recherche.';

  @override
  String get organization => 'Organisation';

  @override
  String get researchInstitution =>
      'Votre institution ou organisation de recherche';

  @override
  String get researchPurpose => 'Objectif de la recherche';

  @override
  String get explainUsage =>
      'Expliquez comment vous prévoyez d\'utiliser ces données';

  @override
  String get dataFilters => 'Filtres de données (Optionnels)';

  @override
  String get categoryFilter => 'Filtre par catégorie';

  @override
  String get allCategories => 'Toutes les catégories';

  @override
  String get dateRangeFilter => 'Filtre par période';

  @override
  String get allDates => 'Toutes les dates';

  @override
  String get pricingInformation => 'Informations de tarification';

  @override
  String get pricePerReport => '• 0,50 par rapport';

  @override
  String get minimumPurchase => '• Achat minimum : 10,00 ';

  @override
  String get downloadExpires => '• Téléchargement expire dans 24 heures';

  @override
  String get anonymizedData => '• Données entièrement anonymisées';

  @override
  String get getQuote => 'Obtenir un devis & Acheter';

  @override
  String reportsFound(Object count) {
    return 'Rapports trouvés : $count';
  }

  @override
  String totalCost(Object amount) {
    return 'Coût total : $amount ';
  }

  @override
  String get paymentNote =>
      'Remarque : Ceci est une démo. L\'intégration du paiement serait complétée ici.';

  @override
  String get cancel => 'Annuler';

  @override
  String get proceedPayment => 'Procéder au paiement';

  @override
  String get moderatorDashboard => 'Tableau de bord modérateur';

  @override
  String get reportsOverview => 'Aperçu des rapports';

  @override
  String get pending => 'En attente';

  @override
  String get verified => 'Vérifié';

  @override
  String get rejected => 'Rejeté';

  @override
  String get filterReports => 'Filtrer les rapports';

  @override
  String get status => 'Statut';

  @override
  String get selectStatus => 'Sélectionner un statut';

  @override
  String reportsList(Object status) {
    return 'Rapports $status';
  }

  @override
  String get reportDetails => 'Détails du rapport';

  @override
  String get reportInformation => 'Informations sur le rapport';

  @override
  String get referenceCode => 'Code de référence';

  @override
  String get language => 'Langue';

  @override
  String get submitted => 'Soumis';

  @override
  String get statusLabel => 'Statut';

  @override
  String get locationDetails => 'Détails de localisation';

  @override
  String get coordinates => 'Coordonnées';

  @override
  String get notAvailable => 'Non disponible';

  @override
  String get mapPreview => 'Aperçu de la carte';

  @override
  String get integrationPending => 'Intégration en attente';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get evidenceFile => 'Fichier de preuve';

  @override
  String get fileAvailable => 'Fichier disponible pour examen';

  @override
  String get view => 'Voir';

  @override
  String get noAttachments => 'Aucune pièce jointe fournie';

  @override
  String get moderationActions => 'Actions de modération';

  @override
  String get moderationNotes => 'Notes de modération';

  @override
  String get reasoning =>
      'Fournissez un raisonnement détaillé pour votre décision...';

  @override
  String get verifyReport => 'Vérifier le rapport';

  @override
  String get rejectReport => 'Rejeter le rapport';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get joinCivicVoice => 'Rejoindre CivicVoice';

  @override
  String get createAccountDescription => 'Créez votre compte pour commencer';

  @override
  String get emailAddress => 'Adresse e-mail';

  @override
  String get enterEmail => 'Entrez votre e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get strongPassword => 'Créez un mot de passe fort';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get reenterPassword => 'Entrez à nouveau votre mot de passe';

  @override
  String get agreeTerms =>
      'J\'accepte les Conditions d\'utilisation et la Politique de confidentialité';

  @override
  String get generalPublic => 'Grand public';

  @override
  String get generalPublicDescription =>
      'Parcourir les rapports\nSoumettre anonymement\nSuivre les soumissions';

  @override
  String get researchers => 'Chercheurs';

  @override
  String get researchersDescription =>
      'Accès aux exportations de données\nAnalyses avancées\nTéléchargements en masse';

  @override
  String get moderators => 'Modérateurs';

  @override
  String get moderatorsDescription =>
      'Vérifier les rapports • Gérer le contenu • Accès administratif';

  @override
  String get mostUsers => 'La plupart des utilisateurs';

  @override
  String get startBrowsing => 'Commencer à naviguer';

  @override
  String get coreFeatures =>
      'Accédez à toutes les fonctionnalités principales sans compte';

  @override
  String get continueGuest => 'Continuer en tant qu\'invité';

  @override
  String get professionalAccess => 'Accès professionnel';

  @override
  String get forProfessionals =>
      'Pour les chercheurs et modérateurs de contenu';

  @override
  String get register => 'S\'inscrire';

  @override
  String get signIn => 'Se connecter';

  @override
  String get trackYourReport => 'Suivez votre rapport';

  @override
  String get enterCredentials =>
      'Entrez vos identifiants pour vérifier le statut de votre rapport anonyme.';

  @override
  String get referenceCodeHint =>
      'Entrez votre code de référence à 8 caractères';

  @override
  String get passphrase => 'Phrase secrète';

  @override
  String get enterPassphrase => 'Entrez votre phrase secrète';

  @override
  String get trackReportButton => 'Suivre le rapport';

  @override
  String get statusHistory => 'Historique des statuts';

  @override
  String get latest => 'Dernier';

  @override
  String get reportTitleLabel => 'Titre du rapport';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get submittedLabel => 'Soumis';

  @override
  String get lastUpdated => 'Dernière mise à jour';

  @override
  String get helpSupport => 'Aide & Support';

  @override
  String get howToUse => 'Comment utiliser CivicVoice';

  @override
  String get technicalSupport =>
      'Pour le support technique, contactez : support@civicvoice.app';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get dataCollection => 'Collecte de données';

  @override
  String get dataUsage => 'Utilisation des données';

  @override
  String get dataSecurity => 'Sécurité des données';

  @override
  String get aboutApp => 'À propos de CivicVoice';

  @override
  String get appVersion => 'CivicVoice v1.0.0';

  @override
  String get appDescription =>
      'Une plateforme sécurisée pour le signalement anonyme et la transparence de la gouvernance.';

  @override
  String get appFeatures => 'Fonctionnalités';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get areYouSure => 'Êtes-vous sûr de vouloir vous déconnecter?';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get selectTheme => 'Sélectionner le thème';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get account => 'Compte';

  @override
  String get guestUser => 'Utilisateur invité';

  @override
  String get limitedAccess =>
      'Accès limité • Connectez-vous pour les fonctionnalités complètes';

  @override
  String get signedIn => 'Connecté';

  @override
  String roleTools(Object role) {
    return 'OUTILS $role';
  }

  @override
  String get reportManagement => 'Gestion des rapports';

  @override
  String get detailedModeration => 'Modération détaillée des rapports';

  @override
  String get dataExport => 'Exportation de données';

  @override
  String get downloadResearch =>
      'Acheter et télécharger des données de recherche';

  @override
  String get appearance => 'Apparence';

  @override
  String get notifications => 'Notifications';

  @override
  String get support => 'Support';

  @override
  String get about => 'À propos';

  @override
  String get corruption => 'Corruption';

  @override
  String get infrastructure => 'Infrastructure';

  @override
  String get healthcare => 'Santé';

  @override
  String get education => 'Éducation';

  @override
  String get environment => 'Environnement';

  @override
  String get publicSafety => 'Sécurité publique';

  @override
  String get transportation => 'Transport';

  @override
  String get housing => 'Logement';

  @override
  String get employment => 'Emploi';

  @override
  String get other => 'Autre';
}
