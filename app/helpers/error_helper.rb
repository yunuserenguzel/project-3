module ErrorHelper
end

ErrorCodeUnknown = 100
ErrorCodeMissingParameter = 101
ErrorCodeInvalidParameter = 102

ErrorCodeParameterTypeError = 103

ErrorCodeInvalidParameterPhone = 201

ErrorCodeAuthenticationRequired = 300

ErrorCodeActiveRecordNotFound = 6000


ErrorCodeTextShouldNotBeEmpty = 6200

ErrorCodePermissionDenied = 310

ErrorDescriptionTable = {
    ErrorCodeUnknown => 'Unknown Error',
    ErrorCodeInvalidParameter => "Invalid Parameter",
    ErrorCodeMissingParameter => 'Missing Parameter',
    ErrorCodeInvalidParameterPhone => "Invalid Parameter 'Phone'",
    ErrorCodeAuthenticationRequired => 'Authentication Required',

    ErrorCodeActiveRecordNotFound => "Active Record Not Found Error",
    ErrorCodeParameterTypeError => "Parameter Type Error",

    ErrorCodeTextShouldNotBeEmpty => "text should not be empty",
    ErrorCodePermissionDenied => "Permission Denied"

}