class MenuOption {
  final int optID;
  final int typeOption;
  final String optCode;
  final String optName;
  final String optIcon;
  final int? optParent;
  final int optOrder;
  final int secStatus;
  final int usrCreateID;
  final DateTime secCreate;
  final int? usrUpdateID;
  final DateTime? secUpdate;

  final MenuOption? secOptionParent; // Puede ser null si no es un submenú
  // Listas para opciones de submenú, niveles, permisos especiales y transacciones
  final List<MenuOption> secOptionChild;
  final List<SecOptionLevel> secOptionLevel;
  final List<SecOptionSpecialPermission> secOptionSpecialPermission;
  final List<SecOptionTransaction> secOptionTransaction;

  MenuOption({
    required this.optID,
    required this.typeOption,
    required this.optCode,
    required this.optName,
    required this.optIcon,
    this.optParent,
    required this.optOrder,
    required this.secStatus,
    required this.usrCreateID,
    required this.secCreate,
    this.usrUpdateID,
    this.secUpdate,
    this.secOptionParent,
    this.secOptionChild = const [],
    this.secOptionLevel = const [],
    this.secOptionSpecialPermission = const [],
    this.secOptionTransaction = const [],
  });
}

class SecOptionTransaction {
  final int ottID;
  final int optID;
  final int typeOperation;
  final int secStatus;
  final int usrCreateID;
  final DateTime secCreate;
  final int? usrUpdateID;
  final DateTime? secUpdate;

  final MenuOption? secOption;

  SecOptionTransaction({
    required this.ottID,
    required this.optID,
    required this.typeOperation,
    required this.secStatus,
    required this.usrCreateID,
    required this.secCreate,
    this.usrUpdateID,
    this.secUpdate,
    this.secOption,
  });
}

class SecOptionSpecialPermission {
  final int ospID;
  final int optID;
  final String ospPermission;
  final String ospDescription;
  final int secStatus;
  final int usrCreateID;
  final DateTime secCreate;
  final int? usrUpdateID;
  final DateTime? secUpdate;

  final MenuOption? secOption;

  SecOptionSpecialPermission({
    required this.ospID,
    required this.optID,
    required this.ospPermission,
    required this.ospDescription,
    required this.secStatus,
    required this.usrCreateID,
    required this.secCreate,
    this.usrUpdateID,
    this.secUpdate,
    this.secOption,
  });
}

class SecOptionLevel {
  final int olvID;
  final int optID;
  final int typeLevel;
  final int secStatus;
  final int usrCreateID;
  final DateTime secCreate;
  final int? usrUpdateID;
  final DateTime? secUpdate;

  final MenuOption? secOption;

  SecOptionLevel({
    required this.olvID,
    required this.optID,
    required this.typeLevel,
    required this.secStatus,
    required this.usrCreateID,
    required this.secCreate,
    this.usrUpdateID,
    this.secUpdate,
    this.secOption,
  });
}
