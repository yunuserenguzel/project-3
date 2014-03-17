module ErrorHelper
end

ErrorCodeUnknown = 100


ErrorCodeMissingParameter = 101
ErrorCodeInvalidParameter = 102

ErrorCodeParameterTypeError = 103
ErrorCodeInvalidParameterPhone = 201
ErrorCodeParameterExists = 202
ErrorCodeEmailExists = 211
ErrorCodeUsernameExists = 212

ErrorCodePasswordMismatch = 220

ErrorCodeAuthenticationRequired = 300


ErrorCodeActiveRecordNotFound = 6000


ErrorCodeTextShouldNotBeEmpty = 6200

ErrorCodePermissionDenied = 310
ErrorCodeUsernameOrPasswordIsWrong = 320

ErrorDescriptionTable = {
  ErrorCodeUnknown => 'Unknown Error',
  ErrorCodePasswordMismatch => 'Password Mismatch',
  ErrorCodeInvalidParameter => "Invalid Parameter",
  ErrorCodeMissingParameter => 'Missing Parameter',
  ErrorCodeParameterExists => 'Parameter Exists ',
  ErrorCodeInvalidParameterPhone => "Invalid Parameter 'Phone'",
  ErrorCodeAuthenticationRequired => 'Authentication Required',
  ErrorCodeUsernameOrPasswordIsWrong => "Invalid username or password",
  ErrorCodeActiveRecordNotFound => "Active Record Not Found Error",
  ErrorCodeParameterTypeError => "Parameter Type Error",
  ErrorCodeTextShouldNotBeEmpty => "text should not be empty",
  ErrorCodePermissionDenied => "Permission Denied"

}