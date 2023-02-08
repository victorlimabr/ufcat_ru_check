abstract class AppConstants {
  String get sigaaBaseUrl;
}

class StagingAppConstants extends AppConstants {
  @override
  String get sigaaBaseUrl => 'https://sigaa.sistemas.ufg.br/api';
}