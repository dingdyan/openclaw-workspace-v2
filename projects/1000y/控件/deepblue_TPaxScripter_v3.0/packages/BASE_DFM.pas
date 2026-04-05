////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_DFM.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit BASE_DFM;

interface

uses
{$IFDEF WIN32}
  Windows,
{$ENDIF}
  TypInfo,
  SysUtils,
  Classes,
  BASE_SYS;

procedure ConvertDfmFile(const DfmFileName: String; UsedUnits, Output: TStrings;
                         AsUnit: Boolean = true; const Src: TStrings = nil; const PaxLanguage: String = 'paxPascal');
procedure ConvertXfmFile(const XfmFileName: String; UsedUnits, Output: TStrings;
                         AsUnit: Boolean = true; const Src: TStrings = nil; const PaxLanguage: String = 'paxPascal');
procedure SaveStr(S, FileName: String);
procedure RegisterUsedClasses;
procedure ConvDFMStringtoScript(const s: String; UsedUnits, Output: TStrings; AsUnit: Boolean = true;
                                const UnitName: String = ''; const Src: TStrings = nil; const PaxLanguage: String = 'paxPascal');

procedure ConvDFMToPaxPascalScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings; AsUnit: Boolean = true;
                          Src: TStrings = nil);
procedure ConvDFMToPaxBasicScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings; AsUnit: Boolean = true;
                          Src: TStrings = nil);
procedure ConvDFMToPaxCScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings; AsUnit: Boolean = true;
                              Src: TStrings = nil);
procedure ConvDFMToPaxJavaScriptScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings;
                          AsUnit: Boolean = false;
                          Src: TStrings = nil);

implementation

function _InheritsFrom(const ClassName1, ClassName2: String): Boolean;
var
  Class1, Class2: TClass;
begin
  result := false;
  Class1 := GetClass(ClassName1);
  if Class1 = nil then
    Exit;
  Class2 := GetClass(ClassName2);
  if Class2 = nil then
    Exit;
  result := Class1.InheritsFrom(Class2);
end;

const
  AP = '''';
  AP2 = '"';

function InsAssignment(const S: String; var Failure: boolean): String;
var
  P: Integer;
begin
  result := S;
  P := Pos(' = ', S);
  if P > 0 then
  begin
    Insert(':', result, P + 1);
    Failure := false;
  end
  else
    Failure := true;
end;

function StartBinData(const S: String): boolean;
begin
  if Length(S) = 0 then
    result := false
  else
    result := S[Length(S)] = '{';
end;

function ContinueBinData(const S: String): boolean;
begin
  if Length(S) = 0 then
    result := false
  else
    result := (S[1] in ['0'..'9','A'..'F']) and (Pos('=', S) = 0) and
                                                (Pos('}', S) = 0);
end;

function EndBinData(const S: String): boolean;
begin
  if Length(S) = 0 then
    result := false
  else
    result := S[Length(S)] = '}';
end;

function StartStringData(const S: String): boolean;
begin
  if Length(S) = 0 then
    result := false
  else
    result := S[Length(S)] = '(';
end;

function ContinueStringData(const S: String): boolean;
begin
  if Length(S) = 0 then
    result := false
  else
    result := (S[1] = AP) and (Pos('=', S) = 0) and
                              (Pos(')', S) = 0);
end;

function EndStringData(const S: String): boolean;
begin
  if Length(S) = 0 then
    result := false
  else
    result := S[Length(S)] = ')';
end;

var
  OBJECT_SWITCH: boolean = false;
  COLLECTION_ITEM_SWITCH: boolean = false;
  ObjName: String;

function StartCollectionItem(const S: String): boolean;
begin
  result := StrEql(S, 'item') and OBJECT_SWITCH;
  if result then
    COLLECTION_ITEM_SWITCH := true;
end;

function EndCollectionItem(const S: String): boolean;
begin
  result := (StrEql(S, 'end') or StrEql(S, 'end>')) and COLLECTION_ITEM_SWITCH;
  if result then
    COLLECTION_ITEM_SWITCH := false;
end;

function StartObjectData(const S: String): boolean;
begin
  if Length(S) = 0 then
    result := false
  else
    result := S[Length(S)] = '<';

  if result then
  begin
    OBJECT_SWITCH := true;
    ObjName := Trim(Copy(S, 1, Pos('=', S) - 1));
  end;
end;

function EndObjectData(const S: String): boolean;
begin
  if Length(S) = 0 then
    result := false
  else
    result := S[Length(S)] = '>';

  if result then
    OBJECT_SWITCH := false;
end;

function ContinueObjectData(const S: String): boolean;
begin
  result := OBJECT_SWITCH and (not EndObjectData(S));

  if result then
    result := result;
end;

procedure ConvDFMtoScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings; AsUnit: Boolean = true;
                          Src: TStrings = nil; const PaxLanguage: String = 'paxPascal');
begin
  if PaxLanguage = 'paxPascal' then
    ConvDfmToPaxPascalScript(DfmFileName, ms, UsedUnits, Output, AsUnit, Src)
  else if PaxLanguage = 'paxC' then
    ConvDfmToPaxCScript(DfmFileName, ms, UsedUnits, Output, AsUnit, Src)
  else if PaxLanguage = 'paxBasic' then
    ConvDfmToPaxBasicScript(DfmFileName, ms, UsedUnits, Output, AsUnit, Src)
  else if PaxLanguage = 'paxJavaScript' then
    ConvDfmToPaxJavaScriptScript(DfmFileName, ms, UsedUnits, Output, false, Src);
end;

function ExtractAncestorClassName(L: TStrings): String;
var
  I, P1, P2: Integer;
  S: String;
begin
  result := 'TForm';
  if L = nil then Exit;

  for I:=0 to L.Count - 1 do
  begin
    S := TRIM(UpperCase(L[I]));
    P1 := Pos('CLASS(', S);
    if P1 > 0 then
    begin
      P2 := Pos(')', S);
      if P2 > 0 then
      begin
        result := Copy(S, P1 + 6, P2 - P1 - 6);
        Exit;
      end;
    end;
  end;
end;

////////////////  PAX PASCAL //////////////////////////////////

procedure ConvDFMToPaxPascalScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings; AsUnit: Boolean = true;
                          Src: TStrings = nil);
var
  I, J, J1: Integer;
  InputList: TStringList;
  S, ClassName, FormName, Indent,
  AnObject, AClass, SaveObject: String;
  Failure: boolean;
  C: TClass;
  MainPropList: TStringList;

  K: Integer;
  StackObj, StackCls: array[1..100] of String;
  Pos_S: Integer;
  Need_S: Boolean;
  UnitName: String;

  searchStr, headerStr: String;
  IsEvent: Boolean;
  PosConstructor: Integer;
  EventHandlerList: TStringList;
  HeaderList: TStringList;

  AncestorClassName: String;
  isInherited: Boolean;
begin
  PosConstructor := 0;

  UnitName := DfmFileName;
  I := Pos('.', DfmFileName);
  if I > 0 then
    UnitName := Copy(UnitName, 1, I - 1);

  RegisterUsedClasses;

  InputList := TStringList.Create;
  MainPropList := TStringList.Create;
  EventHandlerList := TStringList.Create;
  HeaderList := TStringList.Create;

  Need_S := false;

  try
    ms.Seek(0, 0);
    InputList.LoadFromStream(ms);

    for I:=0 to InputList.Count - 1 do
    begin
      S := TrimLeft(InputList[I]) + ' ';
      if StrEql('object ', Copy(S, 1, 7)) then
      begin
        S := TrimRight(Copy(S, Pos(':', S) + 1, 100));
        ClassName := Trim(S);
        break;
      end;
    end;

    for I:=UsedUnits.Count - 1 downto 0 do
    begin
      S := Trim(UsedUnits[I]);
      if S = '' then
        UsedUnits.Delete(I);
    end;

    if AsUnit then
    begin
      Output.Add('unit ' + UnitName + ';');
      Output.Add('interface');
    end;

    if UsedUnits.Count > 0 then
    begin
      Output.Add('uses');
      for I:=0 to UsedUnits.Count - 1 do
      begin
        S := Trim(UsedUnits[I]);
        if I = UsedUnits.Count - 1 then
          Output.Add('  ' + S + ';')
        else
          Output.Add('  ' + S + ',');
      end;
    end;

    K := 0;

    Indent := '  ';

    for I:=0 to InputList.Count - 1 do
    begin
      if I = 0 then
        Output.Add('type');

      S := TrimLeft(InputList[I]) + ' ';

      if      StartObjectData(TrimRight(S)) then
        continue
      else if EndObjectData(TrimRight(S)) then
        continue
      else if ContinueObjectData(TrimRight(S)) then
        continue
      else if StrEql('object ', Copy(S, 1, 7)) or StrEql('inherited ', Copy(S, 1, 10)) then
      begin
        AncestorClassName := 'TForm';
        IsInherited := false;

        if Pos('inherited ', S) = 1 then
        begin
          IsInherited := true;
          S := StringReplace(S, 'inherited ', 'object ', []);
          AncestorClassName := Copy(S, Pos(':', S) + 1, Length(S));
          AncestorClassName := Trim(AncestorClassName);
          C := GetClass(AncestorClassName);
          if C <> nil then
          begin
            C := C.ClassParent;
            AncestorClassName := C.ClassName;
          end
          else
            AncestorClassName := 'TForm';
        end;

        if AncestorClassName = 'TForm' then
          AncestorClassName := ExtractAncestorClassName(src);

        Inc(K);

        if K = 1 then
        begin
          FormName := Copy(S, 1, Pos(':', S) - 1);
          Delete(FormName, 1, 7);
          FormName := TrimLeft(FormName);
          S := TrimLeft(Copy(S, Pos(':', S) + 1, 100));
          ClassName := TrimRight(S);
          Output.Add(Indent + ClassName + ' = class(' + AncestorClassName + ')');
        end
        else
        begin
          Delete(S, 1, 7);
          S := Trim(S);

          if not IsInherited then
            Output.Add(Indent + '  ' + S + ';');
        end;
      end
      else if (StrEql('end ', Copy(S, 1, 4))) and (not OBJECT_SWITCH) then
      begin
        Dec(K);

        if K = 0 then
        begin
          Output.Add(Indent + '  constructor Create(AOwner: TComponent);');
          PosConstructor := Output.Count;
          Output.Add(Indent + 'end;');
        end;
      end;
    end;

    OBJECT_SWITCH := false;

    Output.Add('');
    Output.Add('var');
    Output.Add('  ' + FormName + ': ' + ClassName + ';');

    if AsUnit then
      Output.Add('implementation');

    Output.Add('');
    Output.Add('constructor ' + ClassName + '.Create(AOwner: TComponent);');
    Pos_S := Output.Add('begin');
    Output.Add('  inherited;');

  // constructor's body

    K := 0;
    Indent := '';

//  for I:=0 to InputList.Count - 1 do
    I := -1;
    while I < InputList.Count - 2 do
    begin
      Inc(I);

      S := TrimLeft(InputList[I]) + ' ';

      if StrEql('object ', Copy(S, 1, 7)) or StrEql('inherited ', Copy(S, 1, 10)) then
      begin
        IsInherited := false;
        if Pos('inherited ', S) = 1 then
        begin
          S := StringReplace(S, 'inherited ', 'object ', []);
          IsInherited := true;
        end;

        Inc(K);

        if K = 1 then
        begin
          StackObj[K] := 'Self';
          StackCls[K] := 'TForm';
        end
        else
        begin
          Delete(S, 1, 7);
          S := Trim(S);
          AnObject := Copy(S, 1, Pos(':', S) - 1);
          AClass := TrimLeft(Copy(S, Pos(':', S) + 1, 100));

          if anObject = '' then
            anObject := '_' + AClass;

          if (FindGlobalComponent(AnObject) = nil) and (IsInherited = false) then
            Output.Add(Indent + AnObject + ' := ' + AClass +  '.Create(' + StackObj[K-1] + ');');

          Output.Add(Indent + AnObject + '.Name := ' + AP + AnObject + AP + ';');
          C := GetClass(AClass);
          if Assigned(C) then
          begin
            if _InheritsFrom(C.ClassName, 'TControl') then
              Output.Add(Indent + AnObject + '.Parent := ' + StackObj[K-1] + ';');

            if HasPublishedProperty(C, 'caption', nil) then
              Output.Add(Indent + AnObject + '.Caption := ' + AP + AP + ';');
            if HasPublishedProperty(C, 'text', nil) then
              Output.Add(Indent + AnObject + '.Text := ' + AP + AP + ';');
            if HasPublishedProperty(C, 'lines', nil) then
              Output.Add(Indent + AnObject + '.Lines.Text := ' + AP + AP + ';');

            if _InheritsFrom(C.ClassName, 'TMenuItem') then
            begin
              if StrEql('TMainMenu', StackCls[K-1]) then
                Output.Add(Indent + StackObj[K-1] + '.Items.Add(' + AnObject + ');')
              else if StrEql('TPopUpMenu', StackCls[K-1]) then
                Output.Add(Indent + StackObj[K-1] + '.Items.Add(' + AnObject + ');')
              else
                Output.Add(Indent + StackObj[K-1] + '.Add(' + AnObject + ');');
            end;
          end;

          Output.Add(Indent + 'with ' + AnObject + ' do');

          Output.Add(Indent + 'begin');

          StackObj[K] := AnObject;
          StackCls[K] := AClass;
        end;

        Indent := Indent + '  ';
      end
      else if (StrEql('end ', Copy(S, 1, 4))) and (not OBJECT_SWITCH) then
      begin
        Dec(K);
        Delete(Indent, 1, 2);

        if K > 0 then
          Output.Add(Indent + 'end;');
      end
      else
      begin
        if StrEql('TextHeight ', Copy(S, 1, 11)) then
          continue;
        if StrEql('TextWidth ', Copy(S, 1, 10)) then
          continue;

        S := TrimRight(S);
        S := StringReplace(S, '<>', 'nil', [rfReplaceAll]);

        if      StartBinData(S) then
        begin
          Need_S := true;

          SaveObject := Copy(S, 1, Pos('.', S) - 1);
          Output.Add(Indent + '_S := ');
          continue;
        end
        else if ContinueBinData(S) then
        begin
          Output.Add(Indent + AP + S + AP + '+');
          continue;
        end
        else if EndBinData(S) then
        begin
          Delete(S, Length(S), 1);
          Output.Add(Indent + AP + S + AP + ';');
          if SaveObject <> '' then
            Output.Add(Indent + '_AssignBmp(' + SaveObject+ ', _S);');
          continue;
        end
        else if StartStringData(S) then
        begin
          SaveObject := Copy(S, 1, Pos('.', S) - 1);
          continue;
        end
        else if EndStringData(S) then
        begin
          Delete(S, Length(S), 1);
          Output.Add(Indent + SaveObject + '.Add(' + S + ');');
          continue;
        end
        else if ContinueStringData(S) then
        begin
          if (Length(S) > 0) then
            if S[Length(S)] = '+' then
               S := Copy(S, 1, Length(S) - 1);

          Output.Add(Indent + SaveObject + '.Add(' + S + ');');
          continue;
        end
        else if StartCollectionItem(S) then
        begin
          Output.Add(Indent + 'with ' + ObjName + '.' + S + '.Add do');
          Output.Add(Indent + 'begin');
          continue;
        end
        else if EndCollectionItem(S) then
        begin
          Output.Add(Indent + 'end;');
          if Pos('>', S) > 0 then
            Output.Add('end;');
          continue;
        end
        else if ContinueObjectData(S) then
        begin
//          continue;
        end
        else if StartObjectData(S) then
        begin
          continue;
        end
        else if EndObjectData(S) then
        begin
          continue;
        end;

        S := InsAssignment(S, Failure);

        if not Failure then
        begin
          IsEvent := StrEql('On', Copy(S, 1, 2));

          Failure := IsEvent and (Src = nil);

          if IsEvent and (Src <> nil) then
          begin
            searchStr := UpperCase(ClassName + '.' + Trim(Copy(S, Pos('=', S) + 1, Length(S))) + '(');
            for J:=0 to Src.Count - 1 do
              if Pos(searchStr, UpperCase(Src[J])) > 0 then
              begin
                headerStr := Src[J];

                J1 := Pos(ClassName + '.', headerStr);
                Delete(headerStr, J1, Length(ClassName) + 1);

                HeaderList.Add('    ' + headerStr);

                for J1 := J to Src.Count - 1 do
                begin
                  EventHandlerList.Add(Src[J1]);
                  if StrEql('end;', Copy(Src[J1], 1, 4)) then
                    break;
                end;
              end;
          end;
        end;

        if not Failure then
        begin
          if K = 1 then
            MainPropList.Add(Indent + S + ';')
          else
            Output.Add(Indent + S + ';');
        end;
      end;
    end;

    for I:=0 to MainPropList.Count - 1 do
      Output.Add(MainPropList[I]);

    Output.Add('end;');

    if Need_S then
      Output.Insert(Pos_S, 'var _S: String;');

    for J:=HeaderList.Count - 1 downto 0 do
      Output.Insert(PosConstructor, HeaderList[J]);

    for J:=0 to EventHandlerList.Count - 1 do
      Output.Add(EventHandlerList[J]);

    if AsUnit then
      Output.Add('end.');

  finally
    EventHandlerList.Free;
    MainPropList.Free;
    InputList.Free;
    HeaderList.Free;
  end;
end;

////////////////  PAX C //////////////////////////////////

procedure ConvDFMToPaxCScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings;
                              AsUnit: Boolean = true;
                              Src: TStrings = nil);
var
  I, J, J1: Integer;
  InputList: TStringList;
  S, ClassName, FormName, Indent,
  AnObject, AClass, SaveObject: String;
  Failure: boolean;
  C: TClass;
  MainPropList: TStringList;

  K: Integer;
  StackObj, StackCls: array[1..100] of String;
  Pos_S: Integer;
  Need_S: Boolean;
  UnitName: String;

  searchStr, headerStr: String;
  IsEvent: Boolean;
  EventHandlerList: TStringList;
  HeaderList: TStringList;

  P: Integer;

  AncestorClassName: String;
  IsInherited: Boolean;
begin
  IsInherited := false;
  
  P := 0;
  UnitName := DfmFileName;
  I := Pos('.', DfmFileName);
  if I > 0 then
    UnitName := Copy(UnitName, 1, I - 1);

  RegisterUsedClasses;

  InputList := TStringList.Create;
  MainPropList := TStringList.Create;
  EventHandlerList := TStringList.Create;
  HeaderList := TStringList.Create;

  Need_S := false;

  try
    ms.Seek(0, 0);
    InputList.LoadFromStream(ms);

    for I:=0 to InputList.Count - 1 do
    begin
      S := TrimLeft(InputList[I]) + ' ';
      if StrEql('object ', Copy(S, 1, 7)) then
      begin
        S := TrimRight(Copy(S, Pos(':', S) + 1, 100));
        ClassName := Trim(S);
        break;
      end;
    end;

    for I:=UsedUnits.Count - 1 downto 0 do
    begin
      S := Trim(UsedUnits[I]);
      if S = '' then
        UsedUnits.Delete(I);
    end;

    if UsedUnits.Count > 0 then
    begin
      Output.Add('using');
      for I:=0 to UsedUnits.Count - 1 do
      begin
        S := Trim(UsedUnits[I]);
        if I = UsedUnits.Count - 1 then
          Output.Add('  ' + S + ';')
        else
          Output.Add('  ' + S + ',');
      end;
    end;

    K := 0;

    Indent := '  ';

    for I:=0 to InputList.Count - 1 do
    begin
      S := TrimLeft(InputList[I]) + ' ';

      if      StartObjectData(TrimRight(S)) then
        continue
      else if EndObjectData(TrimRight(S)) then
        continue
      else if ContinueObjectData(TrimRight(S)) then
        continue
      else if StrEql('object ', Copy(S, 1, 7)) or StrEql('inherited ', Copy(S, 1, 10)) then
      begin
        AncestorClassName := 'TForm';

        if Pos('inherited ', S) = 1 then
        begin
          S := StringReplace(S, 'inherited ', 'object ', []);
          AncestorClassName := Copy(S, Pos(':', S) + 1, Length(S));
          AncestorClassName := Trim(AncestorClassName);
          C := GetClass(AncestorClassName);
          if C <> nil then
          begin
            C := C.ClassParent;
            AncestorClassName := C.ClassName;
          end
          else
            AncestorClassName := 'TForm';
        end;

        if AncestorClassName = 'TForm' then
          AncestorClassName := ExtractAncestorClassName(src);

        Inc(K);

        if K = 1 then
        begin
          FormName := Copy(S, 1, Pos(':', S) - 1);
          Delete(FormName, 1, 7);
          FormName := TrimLeft(FormName);
          S := TrimLeft(Copy(S, Pos(':', S) + 1, 100));
          ClassName := TrimRight(S);

          if AsUnit then
          begin
            Output.Add('namespace '  + UnitName);
            Output.Add('{');
          end;

          Output.Add('class '  + ClassName + ' :' + AncestorClassName);
          Output.Add('{');

          P := Output.Count;
        end
        else
        begin
          Delete(S, 1, 7);
          S := TrimLeft(S);
          S := TrimRight(S);
        end;
      end
      else if (StrEql('end ', Copy(S, 1, 4))) and (not OBJECT_SWITCH) then
      begin
        Dec(K);
      end;
    end;

    OBJECT_SWITCH := false;

    Output.Add('');
    Output.Add('  void ' + ClassName + '(TComponent AOwner)');
    Pos_S := Output.Add('  {');
    Output.Add('    this = base.Create(AOwner);');

  // constructor's body

    K := 0;
    Indent := '  ';

//    for I:=0 to InputList.Count - 1 do
    I := -1;
    while I < InputList.Count - 2 do
    begin
      Inc(I);

      S := TrimLeft(InputList[I]) + ' ';

      if StrEql('object ', Copy(S, 1, 7)) or StrEql('inherited ', Copy(S, 1, 10)) then
      begin
        if Pos('inherited ', S) = 1 then
        begin
          S := StringReplace(S, 'inherited ', 'object ', []);
        end;

        Inc(K);

        if K = 1 then
        begin
          StackObj[K] := 'this';
          StackCls[K] := 'TForm';
        end
        else
        begin

          Delete(S, 1, 7);
          S := Trim(S);
          AnObject := Copy(S, 1, Pos(':', S) - 1);
          AClass := TrimLeft(Copy(S, Pos(':', S) + 1, 100));

          if anObject = '' then
            anObject := '_' + AClass;

          if (FindGlobalComponent(AnObject) = nil) and (IsInherited = false) then
            Output.Add(Indent + AnObject + ' = new ' + AClass +  '(' + StackObj[K-1] + ');');

          HeaderList.Add('  ' + AClass + ' ' + AnObject + ';');


          Output.Add(Indent + AnObject + '.Name = ' + AP + AnObject + AP + ';');
          C := GetClass(AClass);
          if Assigned(C) then
          begin
            if _InheritsFrom(C.ClassName, 'TControl') then
              Output.Add(Indent + AnObject + '.Parent = ' + StackObj[K-1] + ';');

            if HasPublishedProperty(C, 'caption', nil) then
              Output.Add(Indent + AnObject + '.Caption = ' + AP + AP + ';');
            if HasPublishedProperty(C, 'text', nil) then
              Output.Add(Indent + AnObject + '.Text = ' + AP + AP + ';');
            if HasPublishedProperty(C, 'lines', nil) then
              Output.Add(Indent + AnObject + '.Lines.Text = ' + AP + AP + ';');

            if _InheritsFrom(C.ClassName, 'TMenuItem') then
            begin
              if StrEql('TMainMenu', StackCls[K-1]) then
                Output.Add(Indent + StackObj[K-1] + '.Items.Add(' + AnObject + ');')
              else if StrEql('TPopUpMenu', StackCls[K-1]) then
                Output.Add(Indent + StackObj[K-1] + '.Items.Add(' + AnObject + ');')
              else
                Output.Add(Indent + StackObj[K-1] + '.Add(' + AnObject + ');');
            end;
          end;

          Output.Add(Indent + 'with (' + AnObject + ')');
          Output.Add(Indent + '{');

          StackObj[K] := AnObject;
          StackCls[K] := AClass;
        end;

        Indent := Indent + '  ';
      end
      else if (StrEql('end ', Copy(S, 1, 4))) and (not OBJECT_SWITCH) then
      begin
        Dec(K);
        Delete(Indent, 1, 2);

        if K > 0 then
          Output.Add(Indent + '}');
      end
      else
      begin
        if StrEql('TextHeight ', Copy(S, 1, 11)) then
          continue;
        if StrEql('TextWidth ', Copy(S, 1, 10)) then
          continue;

        S := TrimRight(S);

        if      StartBinData(S) then
        begin
          Need_S := true;

          SaveObject := Copy(S, 1, Pos('.', S) - 1);
          Output.Add(Indent + '_S = ');
          continue;
        end
        else if ContinueBinData(S) then
        begin
          Output.Add(Indent + AP + S + AP + '+');
          continue;
        end
        else if EndBinData(S) then
        begin
          Delete(S, Length(S), 1);
          Output.Add(Indent + AP + S + AP + ';');
          if SaveObject <> '' then
            Output.Add(Indent + '_AssignBmp(' + SaveObject+ ', _S);');
          continue;
        end
        else if StartStringData(S) then
        begin
          SaveObject := Copy(S, 1, Pos('.', S) - 1);
          continue;
        end
        else if ContinueStringData(S) then
        begin
          if (Length(S) > 0) then
            if S[Length(S)] = '+' then
               S := Copy(S, 1, Length(S) - 1);

          Output.Add(Indent + SaveObject + '.Add(' + S + ');');
          continue;
        end
        else if EndStringData(S) then
        begin
          Delete(S, Length(S), 1);
          Output.Add(Indent + SaveObject + '.Add(' + S + ');');
          continue;
        end
        else if StartObjectData(S) then
        begin
          continue;
        end
        else if EndObjectData(S) then
        begin
          continue;
        end
        else if ContinueObjectData(S) then
        begin
          continue;
        end;

        S := StringReplace(S, ' False', 'false', [rfIgnoreCase]);

        IsEvent := StrEql('On', Copy(S, 1, 2));

        Failure := IsEvent and (Src = nil);

        if IsEvent and (Src <> nil) then
        begin
          searchStr := UpperCase(ClassName + '.' + Trim(Copy(S, Pos('=', S) + 1, Length(S))) + '(');
          for J:=0 to Src.Count - 1 do
            if Pos(searchStr, UpperCase(Src[J])) > 0 then
            begin
              headerStr := Src[J];

              J1 := Pos(ClassName + '.', headerStr);
              Delete(headerStr, J1, Length(ClassName) + 1);

              HeaderList.Add('    ' + headerStr);

              for J1 := J to Src.Count - 1 do
              begin
                EventHandlerList.Add(Src[J1]);
                if StrEql('end;', Copy(Src[J1], 1, 4)) then
                  break;
              end;
            end;
        end;

        if not Failure then
        begin
          if K = 1 then
            MainPropList.Add(Indent + S + ';')
          else
            Output.Add(Indent + S + ';');
        end;
      end;
    end;

    for I:=0 to MainPropList.Count - 1 do
      Output.Add(MainPropList[I]);

    Output.Add('  }');
    Output.Add('}');

    if Need_S then
      Output.Insert(Pos_S, 'String _S;');

    for J:=HeaderList.Count - 1 downto 0 do
      Output.Insert(P, HeaderList[J]);

    Output.Add('');
    Output.Add(ClassName + ' ' + FormName + ';');

    if AsUnit then
      Output.Add('}');

    for J:=0 to EventHandlerList.Count - 1 do
      Output.Add(EventHandlerList[J]);

  finally
    EventHandlerList.Free;
    MainPropList.Free;
    InputList.Free;
    HeaderList.Free;
  end;
end;

////////////////  PAX BASIC //////////////////////////////////

procedure ConvDFMToPaxBasicScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings;
                              AsUnit: Boolean = true;
                              Src: TStrings = nil);
var
  I, J, J1: Integer;
  InputList: TStringList;
  S, ClassName, FormName, Indent,
  AnObject, AClass, SaveObject: String;
  Failure: boolean;
  C: TClass;
  MainPropList: TStringList;

  K: Integer;
  StackObj, StackCls: array[1..100] of String;
  Pos_S: Integer;
  Need_S: Boolean;
  UnitName: String;

  searchStr, headerStr: String;
  IsEvent: Boolean;
  EventHandlerList: TStringList;
  HeaderList: TStringList;

  P: Integer;

  AncestorClassName: String;
  IsInherited: Boolean;
begin
  IsInherited:=false;
  P := 0;
  UnitName := DfmFileName;
  I := Pos('.', DfmFileName);
  if I > 0 then
    UnitName := Copy(UnitName, 1, I - 1);

  RegisterUsedClasses;

  InputList := TStringList.Create;
  MainPropList := TStringList.Create;
  EventHandlerList := TStringList.Create;
  HeaderList := TStringList.Create;

  Need_S := false;

  try
    ms.Seek(0, 0);
    InputList.LoadFromStream(ms);

    for I:=0 to InputList.Count - 1 do
    begin
      S := TrimLeft(InputList[I]) + ' ';
      if StrEql('object ', Copy(S, 1, 7)) then
      begin
        S := TrimRight(Copy(S, Pos(':', S) + 1, 100));
        ClassName := Trim(S);
        break;
      end;
    end;

    for I:=UsedUnits.Count - 1 downto 0 do
    begin
      S := Trim(UsedUnits[I]);
      if S = '' then
        UsedUnits.Delete(I);
    end;

    if UsedUnits.Count > 0 then
    begin
      S := 'Imports ';
      for I:=0 to UsedUnits.Count - 1 do
      begin
        if I = UsedUnits.Count - 1 then
          S := S + '  ' + Trim(UsedUnits[I])
        else
          S := S + '  ' + Trim(UsedUnits[I]) + ',';
      end;
      Output.Add(S);
    end;

    K := 0;

    Indent := '  ';

    for I:=0 to InputList.Count - 1 do
    begin
      S := TrimLeft(InputList[I]) + ' ';

      if      StartObjectData(TrimRight(S)) then
        continue
      else if EndObjectData(TrimRight(S)) then
        continue
      else if ContinueObjectData(TrimRight(S)) then
        continue
      else if StrEql('object ', Copy(S, 1, 7)) or StrEql('inherited ', Copy(S, 1, 10)) then
      begin
        AncestorClassName := 'TForm';

        if Pos('inherited ', S) = 1 then
        begin
          S := StringReplace(S, 'inherited ', 'object ', []);
          AncestorClassName := Copy(S, Pos(':', S) + 1, Length(S));
          AncestorClassName := Trim(AncestorClassName);
          C := GetClass(AncestorClassName);
          if C <> nil then
          begin
            C := C.ClassParent;
            AncestorClassName := C.ClassName;
          end
          else
            AncestorClassName := 'TForm';
        end;

        if AncestorClassName = 'TForm' then
          AncestorClassName := ExtractAncestorClassName(src);

        Inc(K);

        if K = 1 then
        begin
          FormName := Copy(S, 1, Pos(':', S) - 1);
          Delete(FormName, 1, 7);
          FormName := TrimLeft(FormName);
          S := TrimLeft(Copy(S, Pos(':', S) + 1, 100));
          ClassName := TrimRight(S);

          if AsUnit then
          begin
            Output.Add('Namespace '  + UnitName);
          end;

          Output.Add('Class '  + ClassName);
          Output.Add(' Inherits ' + AncestorClassName);

          P := Output.Count;
        end
        else
        begin
          Delete(S, 1, 7);
          S := TrimLeft(S);
          S := TrimRight(S);
        end;
      end
      else if (StrEql('end ', Copy(S, 1, 4))) and (not OBJECT_SWITCH) then
      begin
        Dec(K);
      end;
    end;

    OBJECT_SWITCH := false;

    Output.Add('');
    Output.Add('  Sub New(AOwner As TComponent)');
    Pos_S := Output.Add('  ');
    Output.Add('    Me = MyBase.Create(AOwner)');

  // constructor's body

    K := 0;
    Indent := '  ';

//    for I:=0 to InputList.Count - 1 do
    I := -1;
    while I < InputList.Count - 2 do
    begin
      Inc(I);

      S := TrimLeft(InputList[I]) + ' ';

      if StrEql('object ', Copy(S, 1, 7)) or StrEql('inherited ', Copy(S, 1, 10)) then
      begin
        if Pos('inherited ', S) = 1 then
        begin
          S := StringReplace(S, 'inherited ', 'object ', []);
        end;

        Inc(K);

        if K = 1 then
        begin
          StackObj[K] := 'Me';
          StackCls[K] := 'TForm';
        end
        else
        begin
          Delete(S, 1, 7);
          S := Trim(S);
          AnObject := Copy(S, 1, Pos(':', S) - 1);
          AClass := TrimLeft(Copy(S, Pos(':', S) + 1, 100));

          if anObject = '' then
            anObject := '_' + AClass;

          if (FindGlobalComponent(AnObject) = nil) and (IsInherited = false) then
            Output.Add(Indent + AnObject + ' = New ' + AClass +  '(' + StackObj[K-1] + ')');

          HeaderList.Add('  Dim ' + AnObject + ' As ' + AClass);


          Output.Add(Indent + AnObject + '.Name = ' + AP2 + AnObject + AP2);
          C := GetClass(AClass);
          if Assigned(C) then
          begin
            if _InheritsFrom(C.ClassName, 'TControl') then
              Output.Add(Indent + AnObject + '.Parent = ' + StackObj[K-1]);

            if HasPublishedProperty(C, 'caption', nil) then
              Output.Add(Indent + AnObject + '.Caption = ' + AP2 + AP2);
            if HasPublishedProperty(C, 'text', nil) then
              Output.Add(Indent + AnObject + '.Text = ' + AP2 + AP2);
            if HasPublishedProperty(C, 'lines', nil) then
              Output.Add(Indent + AnObject + '.Lines.Text = ' + AP2 + AP2);

            if _InheritsFrom(C.ClassName, 'TMenuItem') then
            begin
              if StrEql('TMainMenu', StackCls[K-1]) then
                Output.Add(Indent + StackObj[K-1] + '.Items.Add(' + AnObject + ')')
              else if StrEql('TPopUpMenu', StackCls[K-1]) then
                Output.Add(Indent + StackObj[K-1] + '.Items.Add(' + AnObject + ')')
              else
                Output.Add(Indent + StackObj[K-1] + '.Add(' + AnObject + ')');
            end;
          end;

          Output.Add(Indent + 'With ' + AnObject);

          StackObj[K] := AnObject;
          StackCls[K] := AClass;
        end;

        Indent := Indent + '  ';
      end
      else if (StrEql('end ', Copy(S, 1, 4))) and (not OBJECT_SWITCH) then
      begin
        Dec(K);
        Delete(Indent, 1, 2);

        if K > 0 then
          Output.Add(Indent + 'End With');
      end
      else
      begin
        if StrEql('TextHeight ', Copy(S, 1, 11)) then
          continue;
        if StrEql('TextWidth ', Copy(S, 1, 10)) then
          continue;

        S := TrimRight(S);

        if      StartBinData(S) then
        begin
          Need_S := true;

          SaveObject := Copy(S, 1, Pos('.', S) - 1);
          Output.Add(Indent + '_S = ');
          continue;
        end
        else if ContinueBinData(S) then
        begin
          Output.Add(Indent + AP2 + S + AP2 + '+');
          continue;
        end
        else if EndBinData(S) then
        begin
          Delete(S, Length(S), 1);
          Output.Add(Indent + AP2 + S + AP2);
          if SaveObject <> '' then
            Output.Add(Indent + '_AssignBmp(' + SaveObject+ ', _S)');
          continue;
        end
        else if StartStringData(S) then
        begin
          SaveObject := Copy(S, 1, Pos('.', S) - 1);
          continue;
        end
        else if ContinueStringData(S) then
        begin
          if (Length(S) > 0) then
            if S[Length(S)] = '+' then
               S := Copy(S, 1, Length(S) - 1);
        
          Output.Add(Indent + SaveObject + '.Add(' + S + ')');
          continue;
        end
        else if EndStringData(S) then
        begin
          Delete(S, Length(S), 1);
          Output.Add(Indent + SaveObject + '.Add(' + S + ')');
          continue;
        end
        else if StartObjectData(S) then
        begin
          continue;
        end
        else if EndObjectData(S) then
        begin
          continue;
        end
        else if ContinueObjectData(S) then
        begin
          continue;
        end;

        S := StringReplace(S, ' False', 'false', [rfIgnoreCase]);
        S := StringReplace(S, '''', '"', [rfReplaceAll, rfIgnoreCase]);

        IsEvent := StrEql('On', Copy(S, 1, 2));

        Failure := IsEvent and (Src = nil);

        if IsEvent and (Src <> nil) then
        begin
          searchStr := UpperCase(ClassName + '.' + Trim(Copy(S, Pos('=', S) + 1, Length(S))) + '(');
          for J:=0 to Src.Count - 1 do
            if Pos(searchStr, UpperCase(Src[J])) > 0 then
            begin
              headerStr := Src[J];

              J1 := Pos(ClassName + '.', headerStr);
              Delete(headerStr, J1, Length(ClassName) + 1);

              HeaderList.Add('    ' + headerStr);

              for J1 := J to Src.Count - 1 do
              begin
                EventHandlerList.Add(Src[J1]);
                if StrEql('end;', Copy(Src[J1], 1, 4)) then
                  break;
              end;
            end;
        end;

        if not Failure then
        begin
          if K = 1 then
            MainPropList.Add(Indent + S)
          else
            Output.Add(Indent + S);
        end;
      end;
    end;

    for I:=0 to MainPropList.Count - 1 do
      Output.Add(MainPropList[I]);

    Output.Add('  End Sub');
    Output.Add('End Class');

    if Need_S then
      Output.Insert(Pos_S, 'Dim _S As String');

    for J:=HeaderList.Count - 1 downto 0 do
      Output.Insert(P, HeaderList[J]);

    Output.Add('');
    Output.Add('Dim ' + FormName + ' As ' + ClassName);

    if AsUnit then
      Output.Add('End Namespace');

    for J:=0 to EventHandlerList.Count - 1 do
      Output.Add(EventHandlerList[J]);

  finally
    EventHandlerList.Free;
    MainPropList.Free;
    InputList.Free;
    HeaderList.Free;
  end;
end;

////////////////  PAX JAVASCRIPT //////////////////////////////////

procedure ConvDFMToPaxJavaScriptScript(const DfmFileName: String; ms: TStream; UsedUnits, Output: TStrings;
                                 AsUnit: Boolean = false;
                                 Src: TStrings = nil);
var
  I, J, J1: Integer;
  InputList: TStringList;
  S, ClassName, FormName, Indent,
  AnObject, AClass, SaveObject: String;
  Failure: boolean;
  C: TClass;
  MainPropList: TStringList;

  K: Integer;
  StackObj, StackCls: array[1..100] of String;
  Pos_S: Integer;
  Need_S: Boolean;
  UnitName: String;

  searchStr, headerStr: String;
  IsEvent: Boolean;
  EventHandlerList: TStringList;
  HeaderList: TStringList;
begin
  UnitName := DfmFileName;
  I := Pos('.', DfmFileName);
  if I > 0 then
    UnitName := Copy(UnitName, 1, I - 1);

  RegisterUsedClasses;

  InputList := TStringList.Create;
  MainPropList := TStringList.Create;
  EventHandlerList := TStringList.Create;
  HeaderList := TStringList.Create;

  Need_S := false;

  try
    ms.Seek(0, 0);
    InputList.LoadFromStream(ms);

    for I:=0 to InputList.Count - 1 do
    begin
      S := TrimLeft(InputList[I]) + ' ';
      if StrEql('object ', Copy(S, 1, 7)) then
      begin
        S := TrimRight(Copy(S, Pos(':', S) + 1, 100));
        ClassName := Trim(S);
        break;
      end;
    end;

    for I:=UsedUnits.Count - 1 downto 0 do
    begin
      S := Trim(UsedUnits[I]);
      if S = '' then
        UsedUnits.Delete(I);
    end;

    if UsedUnits.Count > 0 then
    begin
      Output.Add('using');
      for I:=0 to UsedUnits.Count - 1 do
      begin
        S := Trim(UsedUnits[I]);
        if I = UsedUnits.Count - 1 then
          Output.Add('  ' + S + ';')
        else
          Output.Add('  ' + S + ',');
      end;
    end;

    K := 0;

    Indent := '  ';

    for I:=0 to InputList.Count - 1 do
    begin
      S := TrimLeft(InputList[I]) + ' ';

      if      StartObjectData(TrimRight(S)) then
        continue
      else if EndObjectData(TrimRight(S)) then
        continue
      else if ContinueObjectData(TrimRight(S)) then
        continue
      else if StrEql('object ', Copy(S, 1, 7)) then
      begin
        Inc(K);

        if K = 1 then
        begin
          FormName := Copy(S, 1, Pos(':', S) - 1);
          Delete(FormName, 1, 7);
          FormName := TrimLeft(FormName);
          S := TrimLeft(Copy(S, Pos(':', S) + 1, 100));
          ClassName := TrimRight(S);

          if AsUnit then
          begin
            Output.Add('namespace '  + UnitName);
            Output.Add('{');
          end;
        end
        else
        begin
          Delete(S, 1, 7);
          S := TrimLeft(S);
          S := TrimRight(S);
        end;
      end
      else if (StrEql('end ', Copy(S, 1, 4))) and (not OBJECT_SWITCH) then
      begin
        Dec(K);
      end;
    end;

    OBJECT_SWITCH := false;

    Output.Add('');
    Output.Add('  function ' + ClassName + '(AOwner)');
    Pos_S := Output.Add('  {');
    Output.Add('    this = new TForm(AOwner);');

  // constructor's body

    K := 0;
    Indent := '  ';

    for I:=0 to InputList.Count - 1 do
    begin
      S := TrimLeft(InputList[I]) + ' ';

      if      StrEql('object ', Copy(S, 1, 7)) then
      begin
        Inc(K);

        if K = 1 then
        begin
          StackObj[K] := 'this';
          StackCls[K] := 'TForm';
        end
        else
        begin
          Delete(S, 1, 7);
          S := Trim(S);
          AnObject := Copy(S, 1, Pos(':', S) - 1);
          AClass := TrimLeft(Copy(S, Pos(':', S) + 1, 100));

          if anObject = '' then
            anObject := '_' + AClass;

          Output.Add(Indent + AnObject + ' = new ' + AClass +  '(' + StackObj[K-1] + ');');

          HeaderList.Add('  ' + AClass + ' ' + AnObject + ';');

          Output.Add(Indent + AnObject + '.Name = ' + AP + AnObject + AP + ';');
          C := GetClass(AClass);
          if Assigned(C) then
          begin
            if _InheritsFrom(C.ClassName, 'TControl') then
              Output.Add(Indent + AnObject + '.Parent = ' + StackObj[K-1] + ';');

            if HasPublishedProperty(C, 'caption', nil) then
              Output.Add(Indent + AnObject + '.Caption = ' + AP + AP + ';');
            if HasPublishedProperty(C, 'text', nil) then
              Output.Add(Indent + AnObject + '.Text = ' + AP + AP + ';');
            if HasPublishedProperty(C, 'lines', nil) then
              Output.Add(Indent + AnObject + '.Lines.Text = ' + AP + AP + ';');

            if _InheritsFrom(C.ClassName, 'TMenuItem') then
            begin
              if StrEql('TMainMenu', StackCls[K-1]) then
                Output.Add(Indent + StackObj[K-1] + '.Items.Add(' + AnObject + ');')
              else if StrEql('TPopUpMenu', StackCls[K-1]) then
                Output.Add(Indent + StackObj[K-1] + '.Items.Add(' + AnObject + ');')
              else
                Output.Add(Indent + StackObj[K-1] + '.Add(' + AnObject + ');');
            end;
          end;

          StackObj[K] := AnObject;
          StackCls[K] := AClass;
        end;

        Indent := Indent + '  ';
      end
      else if (StrEql('end ', Copy(S, 1, 4))) and (not OBJECT_SWITCH) then
      begin
        Dec(K);
        Delete(Indent, 1, 2);
      end
      else
      begin
        if StrEql('TextHeight ', Copy(S, 1, 11)) then
          continue;
        if StrEql('TextWidth ', Copy(S, 1, 10)) then
          continue;

        S := TrimRight(S);

        if      StartBinData(S) then
        begin
          Need_S := true;

          SaveObject := Copy(S, 1, Pos('.', S) - 1);
          Output.Add(Indent + '_S = ');
          continue;
        end
        else if ContinueBinData(S) then
        begin
          Output.Add(Indent + AP + S + AP + '+');
          continue;
        end
        else if EndBinData(S) then
        begin
          Delete(S, Length(S), 1);
          Output.Add(Indent + AP + S + AP + ';');
          if SaveObject <> '' then
            Output.Add(Indent + '_AssignBmp(' + SaveObject+ ', _S);');
          continue;
        end
        else if StartStringData(S) then
        begin
          SaveObject := Copy(S, 1, Pos('.', S) - 1);
          continue;
        end
        else if ContinueStringData(S) then
        begin
          if (Length(S) > 0) then
            if S[Length(S)] = '+' then
               S := Copy(S, 1, Length(S) - 1);

          Output.Add(Indent + SaveObject + '.Add(' + S + ');');
          continue;
        end
        else if EndStringData(S) then
        begin
          Delete(S, Length(S), 1);
          Output.Add(Indent + SaveObject + '.Add(' + S + ');');
          continue;
        end
        else if StartObjectData(S) then
        begin
          continue;
        end
        else if EndObjectData(S) then
        begin
          continue;
        end
        else if ContinueObjectData(S) then
        begin
          continue;
        end;

        S := StringReplace(S, ' False', 'false', [rfIgnoreCase]);

        IsEvent := StrEql('On', Copy(S, 1, 2));

        Failure := IsEvent and (Src = nil);

        if IsEvent and (Src <> nil) then
        begin
          searchStr := UpperCase(ClassName + '.' + Trim(Copy(S, Pos('=', S) + 1, Length(S))) + '(');
          for J:=0 to Src.Count - 1 do
            if Pos(searchStr, UpperCase(Src[J])) > 0 then
            begin
              headerStr := Src[J];

              J1 := Pos(ClassName + '.', headerStr);
              Delete(headerStr, J1, Length(ClassName) + 1);

              HeaderList.Add('    ' + headerStr);

              for J1 := J to Src.Count - 1 do
              begin
                EventHandlerList.Add(Src[J1]);
                if StrEql('end;', Copy(Src[J1], 1, 4)) then
                  break;
              end;
            end;
        end;

        if not Failure then
        begin
          if K = 1 then
            MainPropList.Add(Indent + 'this.' + S + ';')
          else
            Output.Add(Indent + AnObject + '.' + S + ';');
        end;
      end;
    end;

    for I:=0 to MainPropList.Count - 1 do
      Output.Add(MainPropList[I]);

    Output.Add('  }');

    if Need_S then
      Output.Insert(Pos_S, 'var _S;');

    Output.Add('');
    Output.Add('var ' + FormName + ';');

    if AsUnit then
      Output.Add('}');

    for J:=0 to EventHandlerList.Count - 1 do
      Output.Add(EventHandlerList[J]);

  finally
    EventHandlerList.Free;
    MainPropList.Free;
    InputList.Free;
    HeaderList.Free;
  end;
end;

function IsTextDFM(const FileName: String): Boolean;
var
  T: Text;
  Line: string;
begin
  Result := False;
  {$i-}
  Assign(T, FileName);
  Reset(T);
  while not EOF(T) do
  begin
    ReadLn(T, Line);
    if TrimLeft(TrimRight(Line)) <> '' then
    begin
      if (Pos('OBJECT',TrimLeft(UpperCase(Line))) = 1) or
         (Pos('INLINE',TrimLeft(UpperCase(Line))) = 1) or
         (Pos('INHERITED',TrimLeft(UpperCase(Line))) = 1)
      then
        Result := True;
      Break;
    end;
  end;
   {$i+}
  Close(T);
end;

procedure ConvertDfmFile(const DfmFileName: String; UsedUnits, Output: TStrings;
                         AsUnit: Boolean = true; const Src: TStrings = nil; const PaxLanguage: String = 'paxPascal');
var
  fs: TFileStream;
  ms: TMemoryStream;
  TextDfm: Boolean;
begin
  TextDfm := IsTextDFM(DfmFileName);
  fs := TFileStream.Create(DfmFileName, fmOpenRead);
  ms := TMemoryStream.Create;
  try
    if TextDfm = False then
    begin
      ObjectResourceToText(fs, ms);
      ConvDFMtoScript(DfmFileName, ms, UsedUnits, Output, AsUnit, Src, paxLanguage);
    end
    else
      ConvDFMtoScript(DfmFileName, fs, UsedUnits, Output, AsUnit, Src, paxLanguage);
  finally
    fs.Free;
    ms.Free;
  end;
end;

procedure ConvertXfmFile(const XfmFileName: String; UsedUnits, Output: TStrings;
                         AsUnit: Boolean = true; const Src: TStrings = nil; const PaxLanguage: String = 'paxPascal');
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(XfmFileName, fmOpenRead);
  try
    ConvDFMtoScript(XfmFileName, fs, UsedUnits, Output, AsUnit, Src, paxLanguage);
  finally
    fs.Free;
  end;
end;

procedure SaveStr(S, FileName: String);
var
  f: TFileStream;
  I, J, K, L: Integer;
  S1: String;
  Buff: array[0..1000] of byte;
begin
  S := Copy(S, 9, Length(S) - 8);

  L := Length(S) div 2;
  K := 1;
  for I:=0 to L - 1 do
  begin
    S1 := '$' + Copy(S, K, 2);
    J := StrToInt(S1);
    Buff[I] := J;

    Inc(K, 2);
  end;

  f := TFileStream.Create(FileName, fmCreate);
  f.WriteBuffer(Buff, L);
  f.Free;
end;

{$IFNDEF LINUX}

{$IFDEF FP}
procedure SearchClasses(AnInstance: Cardinal; UsedClasses: TList);
begin
end;
{$ELSE}

procedure SearchClasses(AnInstance: Cardinal; UsedClasses: TList);
type
   PPointer = ^Pointer;

   PIMAGE_DOS_HEADER = ^IMAGE_DOS_HEADER;
   IMAGE_DOS_HEADER = packed record { DOS .EXE header }
      e_magic : WORD; { Magic number }
      e_cblp : WORD; { Bytes on last page of file }
      e_cp : WORD; { Pages in file }
      e_crlc : WORD; { Relocations }
      e_cparhdr : WORD; { Size of header in paragraphs }
      e_minalloc : WORD; { Minimum extra paragraphs needed }
      e_maxalloc : WORD; { Maximum extra paragraphs needed }
      e_ss : WORD; { Initial (relative) SS value }
      e_sp : WORD; { Initial SP value }
      e_csum : WORD; { Checksum }
      e_ip : WORD; { Initial IP value }
      e_cs : WORD; { Initial (relative) CS value }
      e_lfarlc : WORD; { File address of relocation table }
      e_ovno : WORD; { Overlay number }
      e_res : packed array [0..3] of WORD; { Reserved words }
      e_oemid : WORD; { OEM identifier (for e_oeminfo) }
      e_oeminfo : WORD; { OEM information; e_oemid specific }
      e_res2 : packed array [0..9] of WORD; { Reserved words }
      e_lfanew : LongWord; { File address of new exe header }
   end;

   PIMAGE_NT_HEADERS = ^IMAGE_NT_HEADERS;
   IMAGE_NT_HEADERS = packed record
      Signature : DWORD;
      FileHeader : IMAGE_FILE_HEADER;
      OptionalHeader : IMAGE_OPTIONAL_HEADER;
   end;

   PIMAGE_SECTION_HEADER = ^IMAGE_SECTION_HEADER;
   IMAGE_SECTION_HEADER = packed record
      Name : packed array [0..IMAGE_SIZEOF_SHORT_NAME-1] of Char;
      VirtualSize : DWORD; // or VirtualSize (union);
      VirtualAddress : DWORD;
      SizeOfRawData : DWORD;
      PointerToRawData : DWORD;
      PointerToRelocations : DWORD;
      PointerToLinenumbers : DWORD;
      NumberOfRelocations : WORD;
      NumberOfLinenumbers : WORD;
      Characteristics : DWORD;
   end;

var
   DosHeader: PIMAGE_DOS_HEADER;
   NTHeader: PIMAGE_NT_HEADERS;
   SectionHeader: PIMAGE_SECTION_HEADER;
   pCodeBegin,
   pCodeEnd: PChar;
   pCode,
   p: PChar;

   function GetSectionHeader(const ASectionName: string): Boolean;
   var
      i: Integer;
   begin
      SectionHeader := PIMAGE_SECTION_HEADER(NTHeader);
      Inc(PIMAGE_NT_HEADERS(SectionHeader));
      Result := True;
      for i := 0 to NTHeader.FileHeader.NumberOfSections - 1 do
      begin
         if Strlicomp(SectionHeader.Name, PChar(ASectionName),
               IMAGE_SIZEOF_SHORT_NAME) = 0 then
            Exit;
         Inc(SectionHeader);
      end;
      Result := False;
   end;

   function InRangeOrNil(APointer, pMin, pMax: Pointer): Boolean;
   begin
     if (APointer = nil) or
        ((Integer(APointer) >= Integer(pMin))
          and (Integer(APointer) <= Integer(pMax))) then
          result := true
     else
       result := false;
   end;

   function IsIdent(p: PChar): Boolean;
   var
      lg,
      i: Integer;
   begin
      lg := ord(p^);
      Inc(p);
      Result := (lg > 0) and (p^ in ['A'..'Z', 'a'..'z', '_']);
      if not Result then
         Exit;
      for i := 2 to lg do
      begin
         inc(p);
         if not (p^ in ['0'..'9', 'A'..'Z', 'a'..'z', '_']) then
         begin
            Result := False;
            Exit;
         end;
      end;
   end;

   begin
   { Read the DOS header }
   DosHeader := PIMAGE_DOS_HEADER(AnInstance);
   if not DosHeader.e_magic = IMAGE_DOS_SIGNATURE then // POUnrecognizedFileFormat;
   begin
      ErrMessageBox('No IMAGE_DOS_SIGNATURE');
      Exit;
   end;
   { Read the NT header (PE format) }
   //NTHeader := PIMAGE_NT_HEADERS(Longint(DosHeader) + DosHeader.e_lfanew);
   NTHeader := PIMAGE_NT_HEADERS(LongWord(DosHeader) + DosHeader.e_lfanew);
   if IsBadReadPtr(NTHeader, SizeOf(IMAGE_NT_HEADERS)) or
      (NTHeader.Signature <> IMAGE_NT_SIGNATURE) then // PONotAPEFile
      Exit;
   { Find the code section }
   if not GetSectionHeader('CODE') then // PONoInitializedData;
      Exit;
   { Computes beginning & end of the code section }
   pCodeBegin := PChar(AnInstance + SectionHeader.VirtualAddress);
   pCodeEnd := pCodeBegin + (SectionHeader.SizeOfRawData - 3);
   pCode := pCodeBegin;
   while pCode < pCodeEnd do
   begin
      p := PPointer(pCode)^;
      { Search for a class }
      if (p = (pCode - vmtSelfPtr)) and // Is it SelfPtr pointer?
         InRangeOrNil(PPointer(p+vmtClassName)^, p, pCodeEnd) and
         InRangeOrNil(PPointer(p+vmtDynamicTable)^, p, pCodeEnd) and
         InRangeOrNil(PPointer(p+vmtMethodTable)^, p, pCodeEnd) and
         InRangeOrNil(PPointer(p+vmtFieldTable)^, p, pCodeEnd) and
         InRangeOrNil(PPointer(p+vmtTypeInfo)^, pCodeBegin, pCodeEnd) and
         InRangeOrNil(PPointer(p+vmtInitTable)^, pCodeBegin, pCodeEnd) and
         InRangeOrNil(PPointer(p+vmtAutoTable)^, pCodeBegin, pCodeEnd) and
         InRangeOrNil(PPointer(p+vmtIntfTable)^, pCodeBegin, pCodeEnd) and
         IsIdent(PPointer(p+vmtClassName)^) then
      begin
        if UsedClasses.IndexOf(p) = -1 then
          UsedClasses.Add(TClass(p));
        Inc(pCode, 4);
      end
      else
         Inc(pCode);
  end;
end;

{$ENDIF}

function EnumModulesFunc(HInstance: Integer; Data: Pointer): Boolean;
begin
  result := true;
  TList(Data).Add(Pointer(HInstance));
end;

procedure RegisterUsedClasses;
var
  I: Integer;
  AClass: TClass;
  UsedClasses, UsedModules: TList;
begin
  UsedModules := TList.Create;
{$IFNDEF FP}
  EnumModules(EnumModulesFunc, UsedModules);
{$ENDIF}

  UsedClasses := TList.Create;
  for I:=0 to UsedModules.Count - 1 do
    SearchClasses(Cardinal(UsedModules[I]), UsedClasses);

  for I:=0 to UsedClasses.Count - 1 do
  begin
    AClass := TClass(UsedClasses[I]);
    if AClass.InheritsFrom(TPersistent) then
    begin
      if GetClass(Aclass.ClassName) = nil then
      begin
        try
          Classes.RegisterClass(TPersistentClass(AClass));
        except
        end;
      end;
    end;
  end;

  UsedClasses.Free;
  UsedModules.Free;
end;
{$ELSE}
procedure RegisterUsedClasses;
begin
end;
{$ENDIF}

procedure ConvDFMStringToScript(const s: String; UsedUnits, Output: TStrings; AsUnit: Boolean = true;
                                const UnitName: String = ''; const Src: TStrings = nil; const PaxLanguage: String = 'paxPascal');
var
  ms: TStream;
  L: TStringList;
begin
  ms := TMemoryStream.Create;
  L := TStringList.Create;
  try
    L.Text := s;
    L.SaveToStream(ms);
    if UnitName = '' then
      ConvDFMtoScript('temp', ms, UsedUnits, Output, AsUnit, Src, paxLanguage)
    else
      ConvDFMtoScript(UnitName, ms, UsedUnits, Output, AsUnit, Src, paxLanguage);
  finally
    ms.Free;
    L.Free;
  end;
end;

end.

