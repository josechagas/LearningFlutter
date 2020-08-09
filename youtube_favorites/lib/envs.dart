enum Environment { DEV, PROD }

class Constants {
  static Map<String, dynamic> _config;
  static Environment currentEnvironment = Environment.DEV;

  static void setEnvironment(Environment env) {
    currentEnvironment = env;
    switch (env) {
      case Environment.DEV:
        _config = _Config.debugConstants;
        break;
      case Environment.PROD:
        _config = _Config.prodConstants;
        break;
    }
  }

  static String get youtubeApiKey {
    return _config[_Config.YOUTUBE_API_KEY];
  }
}

class _Config {
  static const YOUTUBE_API_KEY = 'YOUTUBE_API_KEY';

  static Map<String, dynamic> debugConstants = {
    YOUTUBE_API_KEY: 'Add youtube api here',
  };

  static Map<String, dynamic> prodConstants = {
    YOUTUBE_API_KEY: '',
  };
}