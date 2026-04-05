////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 2.9
// ========================================================================
// Unit: PaxImport.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit PaxImport;

interface

uses
  TypInfo;

type
  TPaxRegisterNamespace = function (const Name: String;
                            OwnerIndex: Integer = -1;
                            UserData: Integer = 0): Integer;
  TPaxRegisterClassType = function (PClass: TClass;
                            OwnerIndex: Integer = -1;
                            UserData: Integer = 0): Integer;

  TPaxRegisterRTTIType = function (pti: PTypeInfo;
                                  UserData: Integer = 0): Integer;
  TPaxRegisterMethod = procedure (PClass: TClass; const Header: String;
                                  Address: Pointer;
                                  Fake: Boolean = false;
                                  UserData: Integer = 0);
  TPaxRegisterBCBMethod = procedure (PClass: TClass; const Header: String;
                                     Address: Pointer;
                                     Fake: Boolean = false;
                                     UserData: Integer = 0);
  TPaxRegisterProperty = procedure (PClass: TClass;
                                    const PropDef: String;
                                    UserData: Integer = 0);
  TPaxRegisterRoutine = procedure (const Header: String; Address: Pointer;
                                   OwnerIndex: Integer = -1;
                                   UserData: Integer = 0);

  TPaxRegisterConstant = procedure (const Name: String; const Value: Variant;
                                   OwnerIndex: Integer = -1;
                                   UserData: Integer = 0);
  TPaxRegisterVariable = procedure (const Name, TypeName: String; Address: Pointer;
                                    OwnerIndex: Integer = -1;
                                    UserData: Integer = 0);

  TRegisterInterfaceType = function (const Name: String; const Guid: TGuid;
                               const ParentName: String; const ParentGuid: TGUID;
                               OwnerIndex: Integer = -1;
                               UserData: Integer = 0): Integer;

  TRegisterInterfaceMethod = procedure (const Guid: TGUID; const Header: String;
                                  MethodIndex: Integer = -1;
                                  UserData: Integer = 0);

  TRegisterInterfaceProperty =  procedure (const guid: TGUID; const PropDef: String;
                           UserData: Integer = 0);

  TPaxRegisterProcs = record
    RegisterNamespace: TPaxRegisterNamespace;
    RegisterClassType: TPaxRegisterClassType;
    RegisterRTTIType: TPaxRegisterRTTIType;
    RegisterMethod: TPaxRegisterMethod;
    RegisterBCBMethod: TPaxRegisterBCBMethod;
    RegisterProperty: TPaxRegisterProperty;
    RegisterRoutine: TPaxRegisterRoutine;
    RegisterConstant: TPaxRegisterConstant;
    RegisterVariable: TPaxRegisterVariable;
    RegisterInterfaceType: TRegisterInterfaceType;
    RegisterInterfaceMethod: TRegisterInterfaceMethod;
    RegisterInterfaceProperty: TRegisterInterfaceProperty;
  end;

  TPaxRegisterDllProc = procedure (R: TPaxRegisterProcs);

implementation

end.

