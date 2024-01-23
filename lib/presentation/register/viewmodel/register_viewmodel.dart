import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_mvvm/app/functions.dart';
import 'package:ecommerce_mvvm/domain/usecase/register_usercase.dart';
import 'package:ecommerce_mvvm/presentation/base/baseviewmodel.dart';
import 'package:ecommerce_mvvm/presentation/common/freezed_data_classes.dart';
import 'package:ecommerce_mvvm/presentation/register/view/register_view.dart';
import 'package:ecommerce_mvvm/presentation/resources/strings_manager.dart';

import '../../state_renderer/state_renderer.dart';
import '../../state_renderer/state_renderer_impl.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  final StreamController userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController mobileNumberCodeStreamController =
      StreamController<String>.broadcast();
  final StreamController mobileNumberStreamController =
      StreamController<String>.broadcast();
  final StreamController emailStreamController =
      StreamController<String>.broadcast();
  final StreamController passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController profilePictureStreamController =
      StreamController<File>.broadcast();
  final StreamController areAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final StreamController isUserRegisteredSuccessfully =
      StreamController<bool>();
  final RegisterUseCase _registerUseCase;
  RegisterViewModel(this._registerUseCase);
  var registerObject = RegisterObject("", "", "", "", "", "");

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    userNameStreamController.close();
    mobileNumberStreamController.close();
    emailStreamController.close();
    passwordStreamController.close();
    profilePictureStreamController.close();
    mobileNumberCodeStreamController.close();
    areAllInputsValidStreamController.close();
    isUserRegisteredSuccessfully.close();
    super.dispose();
  }

  @override
  Sink get inputEmail => emailStreamController.sink;

  @override
  Sink get inputUserName => userNameStreamController.sink;

  @override
  Sink get inputMobileNumber => mobileNumberStreamController.sink;

  @override
  Sink get inputPassword => passwordStreamController.sink;

  @override
  Sink get inputProfilePicture => profilePictureStreamController.sink;

  @override
  Sink get inputAllInputsValid => areAllInputsValidStreamController.sink;

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      registerObject = registerObject.copyWith(userName: userName);
    } else {
      registerObject = registerObject.copyWith(userName: "");
    }
    validate();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      registerObject = registerObject.copyWith(countryMobileCode: "");
    }
    validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      registerObject = registerObject.copyWith(email: email);
    } else {
      registerObject = registerObject.copyWith(email: "");
    }
    validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isIsMobileNumberValid(mobileNumber)) {
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      registerObject = registerObject.copyWith(mobileNumber: "");
    }
    validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      registerObject = registerObject.copyWith(password: password);
    } else {
      registerObject = registerObject.copyWith(password: "");
    }
    validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      registerObject =
          registerObject.copyWith(profilePicture: profilePicture.path);
    } else {
      registerObject = registerObject.copyWith(profilePicture: "");
    }
    validate();
  }

  @override
  Stream<bool> get outIsUserNameValid => userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<String?> get outputErrorUserName => outIsUserNameValid
      .map((isUserName) => isUserName ? null : AppStrings.userNameInvalid.tr());

  @override
  Stream<bool> get outIsEmailValid =>
      emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outIsEmailValid
      .map((isEmail) => isEmail ? null : AppStrings.invalidEmail.tr());

  @override
  Stream<bool> get outIsMobileNumberValid =>
      mobileNumberCodeStreamController.stream
          .map((mobileNumber) => _isIsMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outIsMobileNumberValid.map((isIsMobileNumberValid) =>
          isIsMobileNumberValid ? null : AppStrings.mobileNumberInvalid.tr());

  @override
  Stream<bool> get outIsPasswordValid => passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword =>
      outIsPasswordValid.map((isPasswordValid) =>
          isPasswordValid ? null : AppStrings.passwordInvalid.tr());

  @override
  Stream<File> get outIsProfilePicture =>
      profilePictureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputAreAllInputsValid =>
      areAllInputsValidStreamController.stream.map((_) => _areAllInputsValid());

  //private functions
  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isIsMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputsValid() {
    return registerObject.countryMobileCode.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.userName.isNotEmpty &&
        registerObject.profilePicture.isNotEmpty;
  }

  validate() {
    inputAllInputsValid.add(null);
  }

  @override
  register() async {
    inputState.add(LoadingState(
      stateRendererType: StateRendererType.popupLoadingState,
    ));
    (await _registerUseCase.execute(RegisterUseCaseInput(
            registerObject.userName,
            registerObject.countryMobileCode,
            registerObject.mobileNumber,
            registerObject.email,
            registerObject.password,
            registerObject.profilePicture)))
        .fold(
            (failure) => {
                  print("==========Eror ${failure.message}"),
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message))
                }, (data) {
      inputState.add(ContentState());
      isUserRegisteredSuccessfully.add(true);
      //  isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }
}

mixin RegisterViewModelInput {
  Sink get inputUserName;

  Sink get inputMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilePicture;
  Sink get inputAllInputsValid;
  setUserName(String userName);
  setMobileNumber(String mobileNumber);
  setCountryCode(String countryCode);
  setEmail(String email);
  setPassword(String password);
  setProfilePicture(File profilePicture);
  register();
}
mixin RegisterViewModelOutput {
  Stream<bool> get outIsUserNameValid;
  Stream<String?> get outputErrorUserName;

  Stream<bool> get outIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<File> get outIsProfilePicture;
  Stream<bool> get outputAreAllInputsValid;
}
