import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/routing_class.dart';
import 'package:Sublin/models/transportation_type_enum.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/screens/user_my_sublin_screen.dart';
import 'package:Sublin/services/provider_user_service.dart';
import 'package:Sublin/utils/get_list_of_address_info_from_list_of_provider_users_and_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'user_my_lib_screen_debug.mocks.dart';

@GenerateMocks([ProviderUserService, AddressInfoProvider])
main() async {
  var userService = MockProviderUserService();
  var addressInfo = MockAddressInfoProvider();

  when(addressInfo.getListOfAddressInfoFromListOfProviderUsersAndUser())
      .thenReturn([
    AddressInfo(
        title: 'AddressInfo',
        sponsor: 'Sergey',
        formattedAddress: 'Berlin',
        transportationType: TransportationType.public,
        byProvider: true)
  ]);
  when(addressInfo.getListOfAddressInfoFromListOfProviderUsersAndUser(
          providerUserList: anyNamed('providerUserList'),
          user: anyNamed('user'),
          localRequest: anyNamed('localRequest')))
      .thenAnswer((_) => [
            AddressInfo(
                title: 'AddressInfo 2',
                sponsor: 'Sergey 2',
                formattedAddress: 'Berlin 2',
                transportationType: TransportationType.public,
                byProvider: true)
          ]);

  when(userService.getProvidersWithProviderPlanEmailOnly(
          email: anyNamed('email')))
      .thenAnswer((_) async => [ProviderUser(providerName: 'Test Provider 2')]);
  when(userService.getProvidersFromCommunesWithProviderPlanAll(communes: []))
      .thenAnswer((_) async => [ProviderUser(providerName: 'Test Provider')]);

  runApp(MaterialApp(
      home: MultiProvider(providers: [
    Provider<User>(create: (_) => User()),
    Provider<Routing>(create: (_) => Routing()),
    Provider<ProviderUserService>.value(value: userService),
    Provider<AddressInfoProvider>.value(value: addressInfo)
  ], child: UserMySublinScreen())));
}
