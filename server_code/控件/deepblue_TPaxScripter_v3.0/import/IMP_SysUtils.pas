{$IFDEF VER140}
  {$DEFINE Delphi6_UP}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE Delphi6_UP}
{$ENDIF}

unit IMP_sysutils;
interface
uses
  Windows,
  SysConst,
  sysutils,
{$IFDEF Delphi6_UP}
  Variants,
{$ENDIF}
  BASE_EXTERN,
  PaxScripter;
procedure RegisterIMP_sysutils;
implementation

procedure _FileRead(MethodBody: TPAXMethodBody);
var
  H, Count, VT: Integer;
  V: Variant;
  S: String;
  P: Pointer;
begin
  with MethodBody do
  begin
    H := Params[0].AsVariant;
    V := Params[1].AsVariant;
    P := Pointer(Integer(@V) + 8);
    Count := Params[2].AsVariant;
    VT := VarType(V);
    case VT of
      varString:
      begin
        P := AllocMem(Count + 1);
        FillChar(P^, Count + 1, 0);
        try
          Result.AsInteger := FileRead(H, P^, Count);
        finally
          S := String(Pchar(P));
          FreeMem(P, Count + 1);
        end;
        Params[1].AsVariant := S;
      end;
      varVariant:
      begin
        Result.AsInteger := FileRead(H, V, Count);
        Params[1].AsVariant := V;
      end;
      else
      begin
        Result.AsInteger := FileRead(H, P^, Count);
        Params[1].AsVariant := V;
      end;
    end;
  end;
end;

procedure _FileWrite(MethodBody: TPAXMethodBody);
var
  H, Count, VT: Integer;
  V: Variant;
  I: Integer;
  D: Double;
  B: Boolean;
  S: String;
begin
  with MethodBody do
  begin
    H := Params[0].AsVariant;
    V := Params[1].AsVariant;
    Count := Params[2].AsVariant;
    VT := VarType(V);
    case VT of
      varInteger:
      begin
        I := V;
        Result.AsInteger := FileWrite(H, I, Count);
      end;
      varDouble:
      begin
        D := V;
        Result.AsInteger := FileWrite(H, D, Count);
      end;
      varBoolean:
      begin
        B := V;
        Result.AsInteger := FileWrite(H, B, Count);
      end;
      varString:
      begin
        S := V;
        Result.AsInteger := FileWrite(H, Pointer(S)^, Count);
      end;
      varVariant:
      begin
        V := V;
        Result.AsInteger := FileWrite(H, V, Count);
      end;
    end;
  end;
end;

function TLanguages_ReadCount:Integer;
begin
  result := TLanguages(_Self).Count;
end;
function TLanguages_ReadName(Index: Integer):String;
begin
  result := TLanguages(_Self).Name[Index];
end;
function TLanguages_ReadNameFromLocaleID(ID: LCID):String;
begin
  result := TLanguages(_Self).NameFromLocaleID[ID];
end;
function TLanguages_ReadNameFromLCID(const ID: string):String;
begin
  result := TLanguages(_Self).NameFromLCID[ID];
end;
function TLanguages_ReadID(Index: Integer):String;
begin
  result := TLanguages(_Self).ID[Index];
end;
function TLanguages_ReadLocaleID(Index: Integer):LCID;
begin
  result := TLanguages(_Self).LocaleID[Index];
end;
function TLanguages_ReadExt(Index: Integer):String;
begin
  result := TLanguages(_Self).Ext[Index];
end;
function Exception_ReadHelpContext:Integer;
begin
  result := Exception(_Self).HelpContext;
end;
procedure Exception_WriteHelpContext(const Value: Integer);
begin
  Exception(_Self).HelpContext := Value;
end;
function Exception_ReadMessage:String;
begin
  result := Exception(_Self).Message;
end;
procedure Exception_WriteMessage(const Value: String);
begin
  Exception(_Self).Message := Value;
end;
procedure _StringReplace(MethodBody: TPAXMethodBody);
var
  Flags: TReplaceFlags;
begin
  with MethodBody do
  begin
    Flags := [];
    result.AsString := StringReplace(Params[0].AsString, Params[1].AsString, Params[2].AsString, Flags);
  end;
end;

procedure RegisterIMP_sysutils;
var H: Integer;
begin
  H := RegisterNamespace('sysutils', -1);
  RegisterConstant('FmOpenRead', $0000, H);
  RegisterConstant('FmOpenWrite', $0001, H);
  RegisterConstant('FmOpenReadWrite', $0002, H);
  RegisterConstant('FmShareCompat', $0000, H);
  RegisterConstant('FmShareExclusive', $0010, H);
  RegisterConstant('FmShareDenyWrite', $0020, H);
  RegisterConstant('FmShareDenyRead', $0030, H);
  RegisterConstant('FmShareDenyNone', $0040, H);
  RegisterConstant('FaReadOnly', $00000001, H);
  RegisterConstant('FaHidden', $00000002, H);
  RegisterConstant('FaSysFile', $00000004, H);
  RegisterConstant('FaVolumeID', $00000008, H);
  RegisterConstant('FaDirectory', $00000010, H);
  RegisterConstant('FaArchive', $00000020, H);
  RegisterConstant('FaAnyFile', $0000003F, H);
  RegisterConstant('FmClosed', $D7B0, H);
  RegisterConstant('FmInput', $D7B1, H);
  RegisterConstant('FmOutput', $D7B2, H);
  RegisterConstant('FmInOut', $D7B3, H);
  RegisterConstant('DateDelta', 693594, H);
  RegisterRTTIType(TypeInfo(TFloatValue));
  RegisterRTTIType(TypeInfo(TFloatFormat));
  RegisterRTTIType(TypeInfo(TMbcsByteType));
  // Begin of class TLanguages
  RegisterClassType(TLanguages, H);
  RegisterMethod(TLanguages,
       'constructor Create;',
       @TLanguages.Create);
  RegisterMethod(TLanguages,
       'function IndexOf(ID: LCID): Integer;',
       @TLanguages.IndexOf);
  RegisterMethod(TLanguages,
       'function TLanguages_ReadCount:Integer;',
       @TLanguages_ReadCount, Fake);
  RegisterProperty(TLanguages,
       'property Count:Integer read TLanguages_ReadCount;');
  RegisterMethod(TLanguages,
       'function TLanguages_ReadName(Index: Integer):String;',
       @TLanguages_ReadName, Fake);
  RegisterProperty(TLanguages,
       'property Name[Index: Integer]:String read TLanguages_ReadName;');
  RegisterMethod(TLanguages,
       'function TLanguages_ReadNameFromLocaleID(ID: LCID):String;',
       @TLanguages_ReadNameFromLocaleID, Fake);
  RegisterProperty(TLanguages,
       'property NameFromLocaleID[ID: LCID]:String read TLanguages_ReadNameFromLocaleID;');
  RegisterMethod(TLanguages,
       'function TLanguages_ReadNameFromLCID(const ID: string):String;',
       @TLanguages_ReadNameFromLCID, Fake);
  RegisterProperty(TLanguages,
       'property NameFromLCID[const ID: string]:String read TLanguages_ReadNameFromLCID;');
  RegisterMethod(TLanguages,
       'function TLanguages_ReadID(Index: Integer):String;',
       @TLanguages_ReadID, Fake);
  RegisterProperty(TLanguages,
       'property ID[Index: Integer]:String read TLanguages_ReadID;');
  RegisterMethod(TLanguages,
       'function TLanguages_ReadLocaleID(Index: Integer):LCID;',
       @TLanguages_ReadLocaleID, Fake);
  RegisterProperty(TLanguages,
       'property LocaleID[Index: Integer]:LCID read TLanguages_ReadLocaleID;');
  RegisterMethod(TLanguages,
       'function TLanguages_ReadExt(Index: Integer):String;',
       @TLanguages_ReadExt, Fake);
  RegisterProperty(TLanguages,
       'property Ext[Index: Integer]:String read TLanguages_ReadExt;');
  // End of class TLanguages
  // Begin of class Exception
  RegisterClassType(Exception, H);
  RegisterMethod(Exception,
       'constructor Create(const Msg: string);',
       @Exception.Create);
  RegisterMethod(Exception,
       'constructor CreateFmt(const Msg: string; const Args: array of const);',
       @Exception.CreateFmt);
  RegisterMethod(Exception,
       'constructor CreateRes(Ident: Integer); overload;',
       @Exception.CreateRes);
  RegisterMethod(Exception,
       'constructor CreateRes(ResStringRec: PResStringRec); overload;',
       @Exception.CreateRes);
  RegisterMethod(Exception,
       'constructor CreateResFmt(Ident: Integer; const Args: array of const); overload;',
       @Exception.CreateResFmt);
  RegisterMethod(Exception,
       'constructor CreateResFmt(ResStringRec: PResStringRec; const Args: array of const); overload;',
       @Exception.CreateResFmt);
  RegisterMethod(Exception,
       'constructor CreateHelp(const Msg: string; AHelpContext: Integer);',
       @Exception.CreateHelp);
  RegisterMethod(Exception,
       'constructor CreateFmtHelp(const Msg: string; const Args: array of const;      AHelpContext: Integer);',
       @Exception.CreateFmtHelp);
  RegisterMethod(Exception,
       'constructor CreateResHelp(Ident: Integer; AHelpContext: Integer); overload;',
       @Exception.CreateResHelp);
  RegisterMethod(Exception,
       'constructor CreateResHelp(ResStringRec: PResStringRec; AHelpContext: Integer); overload;',
       @Exception.CreateResHelp);
  RegisterMethod(Exception,
       'constructor CreateResFmtHelp(ResStringRec: PResStringRec; const Args: array of const;      AHelpContext: Integer); overload;',
       @Exception.CreateResFmtHelp);
  RegisterMethod(Exception,
       'constructor CreateResFmtHelp(Ident: Integer; const Args: array of const;      AHelpContext: Integer); overload;',
       @Exception.CreateResFmtHelp);
  RegisterMethod(Exception,
       'function Exception_ReadHelpContext:Integer;',
       @Exception_ReadHelpContext, Fake);
  RegisterMethod(Exception,
       'procedure Exception_WriteHelpContext(const Value: Integer);',
       @Exception_WriteHelpContext, Fake);
  RegisterProperty(Exception,
       'property HelpContext:Integer read Exception_ReadHelpContext write Exception_WriteHelpContext;');
  RegisterMethod(Exception,
       'function Exception_ReadMessage:String;',
       @Exception_ReadMessage, Fake);
  RegisterMethod(Exception,
       'procedure Exception_WriteMessage(const Value: String);',
       @Exception_WriteMessage, Fake);
  RegisterProperty(Exception,
       'property Message:String read Exception_ReadMessage write Exception_WriteMessage;');
  // End of class Exception
  // Begin of class EHeapException
  RegisterClassType(EHeapException, H);
  RegisterMethod(EHeapException,
       'procedure FreeInstance; override;',
       @EHeapException.FreeInstance);
  RegisterMethod(EHeapException,
       'constructor Create(const Msg: string);',
       @EHeapException.Create);
  // End of class EHeapException
  // Begin of class EInOutError
  RegisterClassType(EInOutError, H);
  RegisterMethod(EInOutError,
       'constructor Create(const Msg: string);',
       @EInOutError.Create);
  // End of class EInOutError
  // Begin of class EExternal
  RegisterClassType(EExternal, H);
  RegisterMethod(EExternal,
       'constructor Create(const Msg: string);',
       @EExternal.Create);
  // End of class EExternal
  // Begin of class EWin32Error
  RegisterClassType(EWin32Error, H);
  RegisterMethod(EWin32Error,
       'constructor Create(const Msg: string);',
       @EWin32Error.Create);
  // End of class EWin32Error
  RegisterVariable('EmptyStr', 'STRING',@EmptyStr, H);
  RegisterVariable('Win32Platform', 'INTEGER',@Win32Platform, H);
  RegisterVariable('Win32MajorVersion', 'INTEGER',@Win32MajorVersion, H);
  RegisterVariable('Win32MinorVersion', 'INTEGER',@Win32MinorVersion, H);
  RegisterVariable('Win32BuildNumber', 'INTEGER',@Win32BuildNumber, H);
  RegisterVariable('Win32CSDVersion', 'STRING',@Win32CSDVersion, H);
  RegisterVariable('CurrencyString', 'STRING',@CurrencyString, H);
  RegisterVariable('CurrencyFormat', 'BYTE',@CurrencyFormat, H);
  RegisterVariable('NegCurrFormat', 'BYTE',@NegCurrFormat, H);
  RegisterVariable('ThousandSeparator', 'CHAR',@ThousandSeparator, H);
  RegisterVariable('DecimalSeparator', 'CHAR',@DecimalSeparator, H);
  RegisterVariable('CurrencyDecimals', 'BYTE',@CurrencyDecimals, H);
  RegisterVariable('DateSeparator', 'CHAR',@DateSeparator, H);
  RegisterVariable('ShortDateFormat', 'STRING',@ShortDateFormat, H);
  RegisterVariable('LongDateFormat', 'STRING',@LongDateFormat, H);
  RegisterVariable('TimeSeparator', 'CHAR',@TimeSeparator, H);
  RegisterVariable('TimeAMString', 'STRING',@TimeAMString, H);
  RegisterVariable('TimePMString', 'STRING',@TimePMString, H);
  RegisterVariable('ShortTimeFormat', 'STRING',@ShortTimeFormat, H);
  RegisterVariable('LongTimeFormat', 'STRING',@LongTimeFormat, H);
  RegisterVariable('TwoDigitYearCenturyWindow', 'WORD',@TwoDigitYearCenturyWindow, H);
  RegisterVariable('ListSeparator', 'CHAR',@ListSeparator, H);
  RegisterRoutine('function Languages: TLanguages;', @Languages, H);
  RegisterRoutine('function AllocMem(Size: Cardinal): Pointer;', @AllocMem, H);
  RegisterRoutine('procedure AddExitProc(Proc: TProcedure);', @AddExitProc, H);
  RegisterRoutine('function NewStr(const S: string): PString;', @NewStr, H);
  RegisterRoutine('procedure DisposeStr(P: PString);', @DisposeStr, H);
  RegisterRoutine('procedure AssignStr(var P: PString; const S: string);', @AssignStr, H);
  RegisterRoutine('procedure AppendStr(var Dest: string; const S: string);', @AppendStr, H);
  RegisterRoutine('function UpperCase(const S: string): string;', @UpperCase, H);
  RegisterRoutine('function LowerCase(const S: string): string;', @LowerCase, H);
  RegisterRoutine('function CompareStr(const S1, S2: string): Integer;', @CompareStr, H);
  RegisterRoutine('function CompareMem(P1, P2: Pointer; Length: Integer): Boolean;', @CompareMem, H);
  RegisterRoutine('function CompareText(const S1, S2: string): Integer;', @CompareText, H);
  RegisterRoutine('function SameText(const S1, S2: string): Boolean;', @SameText, H);
  RegisterRoutine('function AnsiUpperCase(const S: string): string;', @AnsiUpperCase, H);
  RegisterRoutine('function AnsiLowerCase(const S: string): string;', @AnsiLowerCase, H);
  RegisterRoutine('function AnsiCompareStr(const S1, S2: string): Integer;', @AnsiCompareStr, H);
  RegisterRoutine('function AnsiSameStr(const S1, S2: string): Boolean;', @AnsiSameStr, H);
  RegisterRoutine('function AnsiCompareText(const S1, S2: string): Integer;', @AnsiCompareText, H);
  RegisterRoutine('function AnsiSameText(const S1, S2: string): Boolean;', @AnsiSameText, H);
  RegisterRoutine('function AnsiStrComp(S1, S2: PChar): Integer;', @AnsiStrComp, H);
  RegisterRoutine('function AnsiStrIComp(S1, S2: PChar): Integer;', @AnsiStrIComp, H);
  RegisterRoutine('function AnsiStrLComp(S1, S2: PChar; MaxLen: Cardinal): Integer;', @AnsiStrLComp, H);
  RegisterRoutine('function AnsiStrLIComp(S1, S2: PChar; MaxLen: Cardinal): Integer;', @AnsiStrLIComp, H);
  RegisterRoutine('function AnsiStrLower(Str: PChar): PChar;', @AnsiStrLower, H);
  RegisterRoutine('function AnsiStrUpper(Str: PChar): PChar;', @AnsiStrUpper, H);
  RegisterRoutine('function AnsiLastChar(const S: string): PChar;', @AnsiLastChar, H);
  RegisterRoutine('function AnsiStrLastChar(P: PChar): PChar;', @AnsiStrLastChar, H);
  RegisterRoutine('function Trim(const S: string): string;', @Trim, H);
  RegisterRoutine('function TrimLeft(const S: string): string;', @TrimLeft, H);
  RegisterRoutine('function TrimRight(const S: string): string;', @TrimRight, H);
  RegisterRoutine('function QuotedStr(const S: string): string;', @QuotedStr, H);
  RegisterRoutine('function AnsiQuotedStr(const S: string; Quote: Char): string;', @AnsiQuotedStr, H);
  RegisterRoutine('function AnsiExtractQuotedStr(var Src: PChar; Quote: Char): string;', @AnsiExtractQuotedStr, H);
  RegisterRoutine('function AdjustLineBreaks(const S: string): string;', @AdjustLineBreaks, H);
  RegisterRoutine('function IsValidIdent(const Ident: string): Boolean;', @IsValidIdent, H);
  RegisterRoutine('function IntToStr(Value: Integer): string; overload;', @IntToStr, H);
  RegisterRoutine('function IntToStr(Value: Int64): string; overload;', @IntToStr, H);
  RegisterRoutine('function IntToHex(Value: Integer; Digits: Integer): string; overload;', @IntToHex, H);
  RegisterRoutine('function IntToHex(Value: Int64; Digits: Integer): string; overload;', @IntToHex, H);
  RegisterRoutine('function StrToInt(const S: string): Integer;', @StrToInt, H);
  RegisterRoutine('function StrToInt64(const S: string): Int64;', @StrToInt64, H);
  RegisterRoutine('function StrToIntDef(const S: string; Default: Integer): Integer;', @StrToIntDef, H);
  RegisterRoutine('function StrToInt64Def(const S: string; Default: Int64): Int64;', @StrToInt64Def, H);
  RegisterRoutine('function LoadStr(Ident: Integer): string;', @LoadStr, H);
  RegisterRoutine('function FmtLoadStr(Ident: Integer; const Args: array of const): string;', @FmtLoadStr, H);
  RegisterRoutine('function FileOpen(const FileName: string; Mode: LongWord): Integer;', @FileOpen, H);
  RegisterRoutine('function FileCreate(const FileName: string): Integer;', @FileCreate, H);
//  RegisterRoutine('function FileRead(Handle: Integer; var Buffer; Count: LongWord): Integer;', @FileRead, H);
//  RegisterRoutine('function FileWrite(Handle: Integer; const Buffer; Count: LongWord): Integer;', @FileWrite, H);

  RegisterStdRoutine('FileRead', _FileRead, 3, H);
  RegisterStdRoutine('FileWrite', _FileWrite, 3, H);

  RegisterRoutine('function FileSeek(Handle, Offset, Origin: Integer): Integer; overload;', @FileSeek, H);
  RegisterRoutine('function FileSeek(Handle: Integer; const Offset: Int64; Origin: Integer): Int64; overload;', @FileSeek, H);
  RegisterRoutine('procedure FileClose(Handle: Integer);', @FileClose, H);
  RegisterRoutine('function FileAge(const FileName: string): Integer;', @FileAge, H);
  RegisterRoutine('function FileExists(const FileName: string): Boolean;', @FileExists, H);
  RegisterRoutine('function FindFirst(const Path: string; Attr: Integer;  var F: TSearchRec): Integer;', @FindFirst, H);
  RegisterRoutine('function FindNext(var F: TSearchRec): Integer;', @FindNext, H);
  RegisterRoutine('procedure FindClose(var F: TSearchRec);', @FindClose, H);
  RegisterRoutine('function FileGetDate(Handle: Integer): Integer;', @FileGetDate, H);
  RegisterRoutine('function FileSetDate(Handle: Integer; Age: Integer): Integer;', @FileSetDate, H);
  RegisterRoutine('function FileGetAttr(const FileName: string): Integer;', @FileGetAttr, H);
  RegisterRoutine('function FileSetAttr(const FileName: string; Attr: Integer): Integer;', @FileSetAttr, H);
  RegisterRoutine('function DeleteFile(const FileName: string): Boolean;', @DeleteFile, H);
  RegisterRoutine('function RenameFile(const OldName, NewName: string): Boolean;', @RenameFile, H);
  RegisterRoutine('function ChangeFileExt(const FileName, Extension: string): string;', @ChangeFileExt, H);
  RegisterRoutine('function ExtractFilePath(const FileName: string): string;', @ExtractFilePath, H);
  RegisterRoutine('function ExtractFileDir(const FileName: string): string;', @ExtractFileDir, H);
  RegisterRoutine('function ExtractFileDrive(const FileName: string): string;', @ExtractFileDrive, H);
  RegisterRoutine('function ExtractFileName(const FileName: string): string;', @ExtractFileName, H);
  RegisterRoutine('function ExtractFileExt(const FileName: string): string;', @ExtractFileExt, H);
  RegisterRoutine('function ExpandFileName(const FileName: string): string;', @ExpandFileName, H);
  RegisterRoutine('function ExpandUNCFileName(const FileName: string): string;', @ExpandUNCFileName, H);
  RegisterRoutine('function ExtractRelativePath(const BaseName, DestName: string): string;', @ExtractRelativePath, H);
  RegisterRoutine('function ExtractShortPathName(const FileName: string): string;', @ExtractShortPathName, H);
  RegisterRoutine('function FileSearch(const Name, DirList: string): string;', @FileSearch, H);
  RegisterRoutine('function DiskFree(Drive: Byte): Int64;', @DiskFree, H);
  RegisterRoutine('function DiskSize(Drive: Byte): Int64;', @DiskSize, H);
  RegisterRoutine('function FileDateToDateTime(FileDate: Integer): TDateTime;', @FileDateToDateTime, H);
  RegisterRoutine('function DateTimeToFileDate(DateTime: TDateTime): Integer;', @DateTimeToFileDate, H);
  RegisterRoutine('function GetCurrentDir: string;', @GetCurrentDir, H);
  RegisterRoutine('function SetCurrentDir(const Dir: string): Boolean;', @SetCurrentDir, H);
  RegisterRoutine('function CreateDir(const Dir: string): Boolean;', @CreateDir, H);
  RegisterRoutine('function RemoveDir(const Dir: string): Boolean;', @RemoveDir, H);
  RegisterRoutine('function StrLen(const Str: PChar): Cardinal;', @StrLen, H);
  RegisterRoutine('function StrEnd(const Str: PChar): PChar;', @StrEnd, H);
  RegisterRoutine('function StrMove(Dest: PChar; const Source: PChar; Count: Cardinal): PChar;', @StrMove, H);
  RegisterRoutine('function StrCopy(Dest: PChar; const Source: PChar): PChar;', @StrCopy, H);
  RegisterRoutine('function StrECopy(Dest:PChar; const Source: PChar): PChar;', @StrECopy, H);
  RegisterRoutine('function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar;', @StrLCopy, H);
  RegisterRoutine('function StrPCopy(Dest: PChar; const Source: string): PChar;', @StrPCopy, H);
  RegisterRoutine('function StrPLCopy(Dest: PChar; const Source: string;  MaxLen: Cardinal): PChar;', @StrPLCopy, H);
  RegisterRoutine('function StrCat(Dest: PChar; const Source: PChar): PChar;', @StrCat, H);
  RegisterRoutine('function StrLCat(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar;', @StrLCat, H);
  RegisterRoutine('function StrComp(const Str1, Str2: PChar): Integer;', @StrComp, H);
  RegisterRoutine('function StrIComp(const Str1, Str2: PChar): Integer;', @StrIComp, H);
  RegisterRoutine('function StrLComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;', @StrLComp, H);
  RegisterRoutine('function StrLIComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;', @StrLIComp, H);
  RegisterRoutine('function StrScan(const Str: PChar; Chr: Char): PChar;', @StrScan, H);
  RegisterRoutine('function StrRScan(const Str: PChar; Chr: Char): PChar;', @StrRScan, H);
  RegisterRoutine('function StrPos(const Str1, Str2: PChar): PChar;', @StrPos, H);
  RegisterRoutine('function StrUpper(Str: PChar): PChar;', @StrUpper, H);
  RegisterRoutine('function StrLower(Str: PChar): PChar;', @StrLower, H);
  RegisterRoutine('function StrPas(const Str: PChar): string;', @StrPas, H);
  RegisterRoutine('function StrAlloc(Size: Cardinal): PChar;', @StrAlloc, H);
  RegisterRoutine('function StrBufSize(const Str: PChar): Cardinal;', @StrBufSize, H);
  RegisterRoutine('function StrNew(const Str: PChar): PChar;', @StrNew, H);
  RegisterRoutine('procedure StrDispose(Str: PChar);', @StrDispose, H);
  RegisterRoutine('function Format(const Format: string; const Args: array of const): string;', @Format, H);
  RegisterRoutine('procedure FmtStr(var Result: string; const Format: string;  const Args: array of const);', @FmtStr, H);
  RegisterRoutine('function StrFmt(Buffer, Format: PChar; const Args: array of const): PChar;', @StrFmt, H);
  RegisterRoutine('function StrLFmt(Buffer: PChar; MaxLen: Cardinal; Format: PChar;  const Args: array of const): PChar;', @StrLFmt, H);
  RegisterRoutine('function FormatBuf(var Buffer; BufLen: Cardinal; const Format;  FmtLen: Cardinal; const Args: array of const): Cardinal;', @FormatBuf, H);
  RegisterRoutine('function FloatToStr(Value: Extended): string;', @FloatToStr, H);
  RegisterRoutine('function CurrToStr(Value: Currency): string;', @CurrToStr, H);
  RegisterRoutine('function FloatToStrF(Value: Extended; Format: TFloatFormat;  Precision, Digits: Integer): string;', @FloatToStrF, H);
  RegisterRoutine('function CurrToStrF(Value: Currency; Format: TFloatFormat;  Digits: Integer): string;', @CurrToStrF, H);
  RegisterRoutine('function FloatToText(Buffer: PChar; const Value; ValueType: TFloatValue;  Format: TFloatFormat; Precision, Digits: Integer): Integer;', @FloatToText, H);
  RegisterRoutine('function FormatFloat(const Format: string; Value: Extended): string;', @FormatFloat, H);
  RegisterRoutine('function FormatCurr(const Format: string; Value: Currency): string;', @FormatCurr, H);
  RegisterRoutine('function FloatToTextFmt(Buffer: PChar; const Value; ValueType: TFloatValue;  Format: PChar): Integer;', @FloatToTextFmt, H);
  RegisterRoutine('function StrToFloat(const S: string): Extended;', @StrToFloat, H);
  {$IFDEF Delphi6_UP}
    RegisterRoutine('function StrToFloatDef(const S: string;  const Default: Extended): Extended; overload;', @StrToFloatDef, H);
    RegisterRoutine('function StrToFloatDef(const S: string; const Default: Extended;  const FormatSettings: TFormatSettings): Extended; overload;', @StrToFloatDef, H);
    RegisterRoutine('function StrToBool(const S: string): Boolean;', @StrToBool, H);
    RegisterRoutine('function StrToBoolDef(const S: string; const Default: Boolean): Boolean;', @StrToBoolDef, H);
    RegisterRoutine('function BoolToStr(B: Boolean; UseBoolStrs: Boolean): string;', @BoolToStr, H);
    RegisterRoutine('function StrToDateTimeDef(const S: string; const Default: TDateTime): TDateTime; overload;',
                    @StrToDateTimeDef, H);
    RegisterRoutine('function StrToDateTimeDef(const S: string; const Default: TDateTime; const FormatSettings: TFormatSettings): TDateTime; overload;',
                    @StrToDateTimeDef, H);
    RegisterRoutine('function DirectoryExists(const Directory: string): Boolean;', @DirectoryExists, H);
  {$ENDIF}
  RegisterRoutine('function StrToCurr(const S: string): Currency;', @StrToCurr, H);
  RegisterRoutine('function TextToFloat(Buffer: PChar; var Value;  ValueType: TFloatValue): Boolean;', @TextToFloat, H);
  RegisterRoutine('procedure FloatToDecimal(var Result: TFloatRec; const Value;  ValueType: TFloatValue; Precision, Decimals: Integer);', @FloatToDecimal, H);
  RegisterRoutine('function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp;', @DateTimeToTimeStamp, H);
  RegisterRoutine('function TimeStampToDateTime(const TimeStamp: TTimeStamp): TDateTime;', @TimeStampToDateTime, H);
  RegisterRoutine('function MSecsToTimeStamp(MSecs: Comp): TTimeStamp;', @MSecsToTimeStamp, H);
  RegisterRoutine('function TimeStampToMSecs(const TimeStamp: TTimeStamp): Comp;', @TimeStampToMSecs, H);
  RegisterRoutine('function EncodeDate(Year, Month, Day: Word): TDateTime;', @EncodeDate, H);
  RegisterRoutine('function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;', @EncodeTime, H);
  RegisterRoutine('procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word);', @DecodeDate, H);
  RegisterRoutine('procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word);', @DecodeTime, H);
  RegisterRoutine('procedure DateTimeToSystemTime(DateTime: TDateTime; var SystemTime: TSystemTime);', @DateTimeToSystemTime, H);
  RegisterRoutine('function SystemTimeToDateTime(const SystemTime: TSystemTime): TDateTime;', @SystemTimeToDateTime, H);
  RegisterRoutine('function DayOfWeek(Date: TDateTime): Integer;', @DayOfWeek, H);
  RegisterRoutine('function Date: TDateTime;', @Date, H);
  RegisterRoutine('function Time: TDateTime;', @Time, H);
  RegisterRoutine('function Now: TDateTime;', @Now, H);
  RegisterRoutine('function IncMonth(const Date: TDateTime; NumberOfMonths: Integer): TDateTime;', @IncMonth, H);
  RegisterRoutine('procedure ReplaceTime(var DateTime: TDateTime; const NewTime: TDateTime);', @ReplaceTime, H);
  RegisterRoutine('procedure ReplaceDate(var DateTime: TDateTime; const NewDate: TDateTime);', @ReplaceDate, H);
  RegisterRoutine('function IsLeapYear(Year: Word): Boolean;', @IsLeapYear, H);
  RegisterRoutine('function DateToStr(Date: TDateTime): string;', @DateToStr, H);
  RegisterRoutine('function TimeToStr(Time: TDateTime): string;', @TimeToStr, H);
  RegisterRoutine('function DateTimeToStr(DateTime: TDateTime): string;', @DateTimeToStr, H);
  RegisterRoutine('function StrToDate(const S: string): TDateTime;', @StrToDate, H);
  RegisterRoutine('function StrToTime(const S: string): TDateTime;', @StrToTime, H);
  RegisterRoutine('function StrToDateTime(const S: string): TDateTime;', @StrToDateTime, H);
  RegisterRoutine('function FormatDateTime(const Format: string; DateTime: TDateTime): string;', @FormatDateTime, H);
  RegisterRoutine('procedure DateTimeToString(var Result: string; const Format: string;  DateTime: TDateTime);', @DateTimeToString, H);
  RegisterRoutine('function SysErrorMessage(ErrorCode: Integer): string;', @SysErrorMessage, H);
  RegisterRoutine('function GetLocaleStr(Locale, LocaleType: Integer; const Default: string): string;', @GetLocaleStr, H);
  RegisterRoutine('function GetLocaleChar(Locale, LocaleType: Integer; Default: Char): Char;', @GetLocaleChar, H);
  RegisterRoutine('procedure GetFormatSettings;', @GetFormatSettings, H);
  RegisterRoutine('function ExceptObject: TObject;', @ExceptObject, H);
  RegisterRoutine('function ExceptAddr: Pointer;', @ExceptAddr, H);
  RegisterRoutine('function ExceptionErrorMessage(ExceptObject: TObject; ExceptAddr: Pointer;  Buffer: PChar; Size: Integer): Integer;', @ExceptionErrorMessage, H);
  RegisterRoutine('procedure ShowException(ExceptObject: TObject; ExceptAddr: Pointer);', @ShowException, H);
  RegisterRoutine('procedure Abort;', @Abort, H);
  RegisterRoutine('procedure OutOfMemoryError;', @OutOfMemoryError, H);
  RegisterRoutine('procedure Beep;', @Beep, H);
  RegisterRoutine('function ByteType(const S: string; Index: Integer): TMbcsByteType;', @ByteType, H);
  RegisterRoutine('function StrByteType(Str: PChar; Index: Cardinal): TMbcsByteType;', @StrByteType, H);
  RegisterRoutine('function ByteToCharLen(const S: string; MaxLen: Integer): Integer;', @ByteToCharLen, H);
  RegisterRoutine('function CharToByteLen(const S: string; MaxLen: Integer): Integer;', @CharToByteLen, H);
  RegisterRoutine('function ByteToCharIndex(const S: string; Index: Integer): Integer;', @ByteToCharIndex, H);
  RegisterRoutine('function CharToByteIndex(const S: string; Index: Integer): Integer;', @CharToByteIndex, H);
  RegisterRoutine('function IsPathDelimiter(const S: string; Index: Integer): Boolean;', @IsPathDelimiter, H);
  RegisterRoutine('function IsDelimiter(const Delimiters, S: string; Index: Integer): Boolean;', @IsDelimiter, H);
  RegisterRoutine('function IncludeTrailingBackslash(const S: string): string;', @IncludeTrailingBackslash, H);
  RegisterRoutine('function ExcludeTrailingBackslash(const S: string): string;', @ExcludeTrailingBackslash, H);
  RegisterRoutine('function LastDelimiter(const Delimiters, S: string): Integer;', @LastDelimiter, H);
  RegisterRoutine('function AnsiCompareFileName(const S1, S2: string): Integer;', @AnsiCompareFileName, H);
  RegisterRoutine('function AnsiLowerCaseFileName(const S: string): string;', @AnsiLowerCaseFileName, H);
  RegisterRoutine('function AnsiUpperCaseFileName(const S: string): string;', @AnsiUpperCaseFileName, H);
  RegisterRoutine('function AnsiPos(const Substr, S: string): Integer;', @AnsiPos, H);
  RegisterRoutine('function AnsiStrPos(Str, SubStr: PChar): PChar;', @AnsiStrPos, H);
  RegisterRoutine('function AnsiStrRScan(Str: PChar; Chr: Char): PChar;', @AnsiStrRScan, H);
  RegisterRoutine('function AnsiStrScan(Str: PChar; Chr: Char): PChar;', @AnsiStrScan, H);
//  RegisterRoutine('function StringReplace(const S, OldPattern, NewPattern: string;  Flags: TReplaceFlags): string;', @StringReplace, H);
  RegisterConstant('rfReplaceAll', rfReplaceAll, H);
  RegisterConstant('rfIgnoreCase', rfIgnoreCase, H);
  RegisterStdRoutine('StringReplace', _StringReplace, 4, H);

  RegisterRoutine('function WrapText(const Line, BreakStr: string; BreakChars: TSysCharSet;  MaxCol: Integer): string; overload;', @WrapText, H);
  RegisterRoutine('function FindCmdLineSwitch(const Switch: string; SwitchChars: TSysCharSet;  IgnoreCase: Boolean): Boolean;', @FindCmdLineSwitch, H);
  RegisterRoutine('procedure FreeAndNil(var Obj);', @FreeAndNil, H);
  RegisterRoutine('function Supports(const Instance: IUnknown; const Intf: TGUID; out Inst): Boolean; overload;', @Supports, H);
  RegisterRoutine('function Supports(Instance: TObject; const Intf: TGUID; out Inst): Boolean; overload;', @Supports, H);
  RegisterConstant('PfNeverBuild', $00000001, H);
  RegisterConstant('PfDesignOnly', $00000002, H);
  RegisterConstant('PfRunOnly', $00000004, H);
  RegisterConstant('PfIgnoreDupUnits', $00000008, H);
  RegisterInt64Constant('PfModuleTypeMask', $C0000000, H);
  RegisterConstant('PfExeModule', $00000000, H);
  RegisterConstant('PfPackageModule', $40000000, H);
  RegisterConstant('PfProducerMask', $0C000000, H);
  RegisterConstant('PfV3Produced', $00000000, H);
  RegisterConstant('PfProducerUndefined', $04000000, H);
  RegisterConstant('PfBCB4Produced', $08000000, H);
  RegisterConstant('PfDelphi4Produced', $0C000000, H);
  RegisterInt64Constant('PfLibraryModule', $80000000, H);
  RegisterConstant('UfMainUnit', $01, H);
  RegisterConstant('UfPackageUnit', $02, H);
  RegisterConstant('UfWeakUnit', $04, H);
  RegisterConstant('UfOrgWeakUnit', $08, H);
  RegisterConstant('UfImplicitUnit', $10, H);
  RegisterRTTIType(TypeInfo(TNameType));
  RegisterRoutine('function LoadPackage(const Name: string): HMODULE;', @LoadPackage, H);
  RegisterRoutine('procedure UnloadPackage(Module: HMODULE);', @UnloadPackage, H);
  RegisterRoutine('procedure GetPackageInfo(Module: HMODULE; Param: Pointer; var Flags: Integer;  InfoProc: TPackageInfoProc);', @GetPackageInfo, H);
  RegisterRoutine('function GetPackageDescription(ModuleName: PChar): string;', @GetPackageDescription, H);
  RegisterRoutine('procedure InitializePackage(Module: HMODULE);', @InitializePackage, H);
  RegisterRoutine('procedure FinalizePackage(Module: HMODULE);', @FinalizePackage, H);
  RegisterRoutine('procedure RaiseLastWin32Error;', @RaiseLastWin32Error, H);
  RegisterRoutine('function Win32Check(RetVal: BOOL): BOOL;', @Win32Check, H);
  RegisterRoutine('procedure AddTerminateProc(TermProc: TTerminateProc);', @AddTerminateProc, H);
  RegisterRoutine('function CallTerminateProcs: Boolean;', @CallTerminateProcs, H);
  RegisterRoutine('function GDAL: LongWord;', @GDAL, H);
  RegisterRoutine('procedure RCS;', @RCS, H);
  RegisterRoutine('procedure RPR;', @RPR, H);
  RegisterVariable('HexDisplayPrefix', 'STRING',@HexDisplayPrefix, H);
  // Begin of class TMultiReadExclusiveWriteSynchronizer
  RegisterClassType(TMultiReadExclusiveWriteSynchronizer, H);
  RegisterMethod(TMultiReadExclusiveWriteSynchronizer,
       'constructor Create;',
       @TMultiReadExclusiveWriteSynchronizer.Create);
  RegisterMethod(TMultiReadExclusiveWriteSynchronizer,
       'destructor Destroy; override;',
       @TMultiReadExclusiveWriteSynchronizer.Destroy);
  RegisterMethod(TMultiReadExclusiveWriteSynchronizer,
       'procedure BeginRead;',
       @TMultiReadExclusiveWriteSynchronizer.BeginRead);
  RegisterMethod(TMultiReadExclusiveWriteSynchronizer,
       'procedure EndRead;',
       @TMultiReadExclusiveWriteSynchronizer.EndRead);
  RegisterMethod(TMultiReadExclusiveWriteSynchronizer,
       'procedure BeginWrite;',
       @TMultiReadExclusiveWriteSynchronizer.BeginWrite);
  RegisterMethod(TMultiReadExclusiveWriteSynchronizer,
       'procedure EndWrite;',
       @TMultiReadExclusiveWriteSynchronizer.EndWrite);
  // End of class TMultiReadExclusiveWriteSynchronizer
end;
initialization
  RegisterIMP_sysutils;
end.

