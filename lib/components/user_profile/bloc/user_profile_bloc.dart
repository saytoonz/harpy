import 'dart:async';

import 'package:dart_twitter_api/api/users/user_service.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_event.dart';
import 'package:harpy/components/user_profile/bloc/user_profile_state.dart';
import 'package:harpy/core/api/twitter/parse_entities.dart';
import 'package:harpy/core/api/twitter/user_data.dart';
import 'package:harpy/core/service_locator.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    UserData user,
    String screenName,
  })  : assert(user != null || screenName != null),
        super(LoadingUserState()) {
    add(InitializeUserEvent(user: user, screenName: screenName));
  }

  /// The [UserData] for the user to display.
  ///
  /// Set with an [InitializeUserEvent].
  UserData user;

  /// The [Entities] used by the [TwitterText] for the user description.
  Entities _userEntities;
  Entities get userEntities {
    if (_userEntities != null) {
      return _userEntities;
    }

    _userEntities = Entities()..urls = user?.entities?.description?.urls;

    if (user?.description != null) {
      parseEntities(user.description, _userEntities);
    }

    return _userEntities;
  }

  final UserService userService = app<TwitterApi>().userService;

  static UserProfileBloc of(BuildContext context) =>
      BlocProvider.of<UserProfileBloc>(context);

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    yield* event.applyAsync(currentState: state, bloc: this);
  }
}
