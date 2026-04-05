////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PaxScripterRegister.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PaxScripterRegister;

interface

uses
  Classes,
  PaxScripter,
  PaxPascal,
  PaxBasic,
  PaxC,
  PaxJavaScript,
  PaxDfm;

procedure Register;

Implementation

procedure Register;
begin
  RegisterComponents('PAXScripter', [TPaxScripter,
                                     TPaxPascal,
                                     TPaxBasic,
                                     TPaxC,
                                     TPaxJavaScript,
                                     TPaxDfmConverter]);
end;

end.
