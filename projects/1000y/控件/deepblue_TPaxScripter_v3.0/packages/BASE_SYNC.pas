////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_SYNC.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}

unit BASE_SYNC;
interface

procedure _BeginRead;
procedure _EndRead;
procedure _BeginWrite;
procedure _EndWrite;

procedure Initialization_BASE_SYNC;
procedure Finalization_BASE_SYNC;

implementation

{$ifdef FP}


procedure _BeginRead;
begin
end;

procedure _EndRead;
begin
end;

procedure _BeginWrite;
begin
end;

procedure _EndWrite;
begin
end;

procedure Initialization_BASE_SYNC;
begin
end;

procedure Finalization_BASE_SYNC;
begin
end;


{$else}

uses
  SysUtils;
var
  S: TMultiReadExclusiveWriteSynchronizer;

procedure _BeginRead;
begin
  S.BeginRead;
end;

procedure _EndRead;
begin
  S.EndRead;
end;

procedure _BeginWrite;
begin
  S.BeginWrite;
end;

procedure _EndWrite;
begin
  S.EndWrite;
end;

procedure Initialization_BASE_SYNC;
begin
  S := TMultiReadExclusiveWriteSynchronizer.Create;
end;

procedure Finalization_BASE_SYNC;
begin
  S.Free;
end;

{$endif}

end.










