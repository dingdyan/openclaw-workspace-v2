////////////////////////////////////////////////////////////////////////////
// PAXScript IDE
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2004. All rights reserved.                                  
// Code Version: 2.6
// ========================================================================
// Unit: fmExplorer.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit fmExplorer;
interface

uses
  Classes,
{$IFDEF LINUX}
  QComCtrls;
{$ELSE}
  ComCtrls;
{$ENDIF}  

type
  PNodeRec = ^TNodeRec;
  TNodeRec = record
    NParams, NFields, NConsts, NMethods, NProperties, NClasses,
    NStructures, NEnums: TTreeNode;
  end;

  TPosObject = class
    Module, Position, Length: Integer;
    constructor Create(Module, Position, Length: Integer);
  end;

implementation

constructor TPosObject.Create(Module, Position, Length: Integer);
begin
  Self.Module := Module;
  Self.Position := Position;
  Self.Length := Length;
end;

end.
