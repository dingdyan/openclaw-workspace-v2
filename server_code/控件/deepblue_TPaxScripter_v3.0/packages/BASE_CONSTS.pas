////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_CONSTS.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit BASE_CONSTS;
interface

resourcestring
  errInternalError = 'Internal error';
  errExpected = ' expected';
  errSyntaxError = 'Syntax error';
  errNotAccessToPrivateMember = 'Not access to private member %s of class %s';
  errModuleNotFound = 'Module %s not found';
  errFileNotFound = 'File %s not found';
  errUndeclaredIdentifier = 'Undeclared identifier %s';
  errIllegalCharacter = 'Illegal character';
  errIdentifierExpected = 'Identifier expected';
  errConstantExpected = 'Constant expected';
  errLabelExpected = 'Label expected';
  errInvalidString = 'Invalid string';
  errInvalidEscapeSequence = 'nvalid escape sequence';
  errInvalidFormatString = 'Invalid format string';
  errNotEnoughParameters = 'Not enough parameters';
  errTooManyParameters = 'Too many parameters';
  errLabelAlreadyDefined = 'Label already defined';
  errIdentifierIsRedeclared = 'Redeclared identifier %s';
  errLabelIsNotFound = 'Label not found';
  errStatementIsNotAllowedHere = 'Statement is not allowed here';
  errClassOrNamespaceIsNotFound = 'Class or namespace not found';
  errConstructorIsNotFound = 'Constructor not found';
  errIncompatibleTypes = 'Incompatible types';
  errFunctionNotFound = 'Function "%s" not found';
  errMethodNotFound = 'Method "%s" not found';
  errPropertyIsNotFound = 'Property "%s" not found';
  errPropertyIsNotFoundInClass = 'Property "%s" not found in class %s';
  errMemberIsNotAccessible = 'Member "%s" is not accessible';
  errDefaultPropertyIsNotFound = 'Default property not found';
  errTooManyActualParameters = 'Too many actual parameters';
  errClassIsNotImported = 'Class "%s" not imported';
  errClassIsNotFound = 'Class "%s" not found';
  errCannotWriteReadOnlyProperty = 'Cannot write read-only property %s';
  errUnknownLanguage = 'Unknown language';
  errIncorrectFileExtension = 'Incorrect file extension ';
  errIncorrectUsageOfRefParameter = 'Incorrect usage of reference parameter';
  errTypeNotFound = 'type %s not found';
  errIncompatibleTypesExt = 'Incompatible types %s and %s';
  errOperatorNotApplicable = 'Operator not applicable to this operand type';
  errOverloadedMethodNotFound = 'Overloaded method not found';
  errOverloadableOperatorExpected = 'Overloadable operator expected';
  errLeftSideCannotBeAssignedTo = 'Left side cannot be assigned to';
  errCannotApplyToScalar = 'Cannot apply [] to a scalar variable';
  errRankMismatch = 'Rank mismatch';

  errCannotLoadDll = 'Cannot load dll %s ';
  errDllFunctionIsNotFound = 'Function %s not found in dll %s';

  errInvalidCompilerDirective = 'Invalid compiler directive';
  errMissingENDIFdirective = 'Missing ENDIF directive';
  errIncorrectCompiledModuleVersion = 'Incorrect compiled module version %s. Expected %s';
  errTypeMismatch = 'Type mismatch!';
  errStream_position_must_be_equal_0 = 'Stream position must be equal 0';
  errIncorrect_parameters_in_RegisterStdRoutineEx = 'Incorrect parameters in RegisterStdRoutineEx';
  errIncorrect_parameters_in_RegisterStdMethodEx = 'Incorrect parameters in RegisterStdMethodEx';
  errUnregisteredLanguage = 'Unregistered language ';
  errIncorrectIdentifier = 'Incorrect identifier %s in For-Next loop';
  err_X_expected_but_Y_fond = '"%s" expected, but "%s" found';
  errInterfaceNotImported = 'Interface "%s" not imported';
  errGetRecordByIndex = 'Error in TDefinitionList.GetRecordByIndex';
  errDynamicArrayNotInitialized = 'Dynamic array not initialized';
  errClassNotRegistered = 'Class "%s" not registered';
  errPropertyNotFoundInClass = 'Property "%s" not found in class "%s"';
  err_Incorrect_string_in_StringToBinary = 'Incorrect string in StringToBinary';
  err_Incorrect_string_in_StringToOctal = 'Incorrect string in StringToOctal';
  errCannotAssignConstant = 'Cannot assign constant ';
  errVariantToScriptObjectConversion = 'Variant to script object conversion error';
  errScripterDosNotContainAnyModule = 'Scripter have not modules to compile';
  errNotAssignedOnVirtualObjectMethodCallEventHandler = 'Not assigned OnVirtualObjectMethodCall event handler';
  errNotAssignedOnVirtualObjectPutPropertyEventHandler = 'Not assigned OnVirtualObjectPutProperty event handler';


  errScript = '"%s"'#13#10'Module: "%s"'#13#10'Line number: "%d"'#13#10'Line: "%s"'#13#10;



implementation
end.