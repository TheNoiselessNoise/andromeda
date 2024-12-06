import 'package:andromeda/old-core/core.dart';

// NOTE: i don't really know better way unfortunately
//       any suggestions are welcome

extension UserEntity on EspoEntity {
  String get uUserName => getString('username');
  String get uFirstName => getString('firstName');
  String get uLastName => getString('lastName');
  String get uMiddleName => getString('middleName');
  String get uEmailAddress => getString('emailAddress');
  String get uPhoneNumber => getString('phoneNumber');
  String get uGender => getString('gender');
  Map<String, dynamic> get uEmailAddressData => getMap('emailAddressData');
  Map<String, dynamic> get uPhoneNumberData => getMap('phoneNumberData');
  EntityFieldLink get uDefaultTeam => getLink('defaultTeam');
  EntityFieldLinkMultiple get uRoles => getLinkMultiple('roles');
  EntityFieldLinkMultiple get uPortals => getLinkMultiple('portals');
  EntityFieldLinkMultiple get uPortalRoles => getLinkMultiple('portalRoles');
  EntityFieldLink get uContact => getLink('contact');
  EntityFieldLinkMultiple get uAccounts => getLinkMultiple('accounts');
  EntityFieldLink get uAvatar => getLink('avatar');
}