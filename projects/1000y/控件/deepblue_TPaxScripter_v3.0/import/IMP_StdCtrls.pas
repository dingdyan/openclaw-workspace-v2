////////////////////////////////////////////////////////////////////////////
// PAXScript Importing
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003. All rights reserved.                                  
// Code Version: 1.5
// ========================================================================
// Unit: IMP_StdCtrls.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

// Imports classes:
//
//   TButton
//   TButtonControl
//   TCheckBox
//   TComboBox
//   TCustomCheckBox
//   TCustomComboBox
//   TCustomEdit
//   TCustomGroupBox
//   TCustomLabel
//   TCustomListBox
//   TCustomMemo
//   TEdit
//   TGroupBox
//   TLabel
//   TListBox
//   TMemo
//   TRadioButton
//   TScrollBar
//   TStaticText

unit IMP_StdCtrls;
interface
uses
  Classes,
{$IFDEF LINUX}
  Types,
  QGraphics,
  QStdCtrls,
{$ELSE}
  Graphics,
  StdCtrls,
{$ENDIF}
  PaxScripter;

type
  TMemoStrings = class(TStrings);
  TListBoxStrings = class(TStrings);
  TCustomComboBoxStrings = class(TStrings);
  TComboBoxStrings = class(TCustomComboBoxStrings);


implementation

// --------------TCustomComboBox------------------------------------------------

function TCustomComboBox_GetCharCase: TEditCharCase;
begin
 result := TCustomComboBox(_Self).CharCase;
end;

procedure TCustomComboBox_SetCharCase(Value: TEditCharCase);
begin
 TCustomComboBox(_Self).CharCase := Value;
end;

function TCustomComboBox_GetCanvas: TCanvas;
begin
 result := TCustomComboBox(_Self).Canvas;
end;

function TCustomComboBox_GetDroppedDown: Boolean;
begin
 result := TCustomComboBox(_Self).DroppedDown;
end;

procedure TCustomComboBox_SetDroppedDown(Value: Boolean);
begin
 TCustomComboBox(_Self).DroppedDown := Value;
end;

function TCustomComboBox_GetItems: TStrings;
begin
 result := TCustomComboBox(_Self).Items;
end;

procedure TCustomComboBox_SetItems(Value: TStrings);
begin
 TCustomComboBox(_Self).Items := Value;
end;

function TCustomComboBox_GetItemIndex: Integer;
begin
 result := TCustomComboBox(_Self).ItemIndex;
end;

procedure TCustomComboBox_SetItemIndex(Value: Integer);
begin
 TCustomComboBox(_Self).ItemIndex := Value;
end;

function TCustomComboBox_GetSelLength: Integer;
begin
 result := TCustomComboBox(_Self).SelLength;
end;

procedure TCustomComboBox_SetSelLength(Value: Integer);
begin
 TCustomComboBox(_Self).SelLength := Value;
end;

function TCustomComboBox_GetSelStart: Integer;
begin
 result := TCustomComboBox(_Self).SelStart;
end;

procedure TCustomComboBox_SetSelStart(Value: Integer);
begin
 TCustomComboBox(_Self).SelStart := Value;
end;

function TCustomComboBox_GetSelText: string;
begin
 result := TCustomComboBox(_Self).SelText;
end;

procedure TCustomComboBox_SetSelText(const Value: string);
begin
 TCustomComboBox(_Self).SelText := Value;
end;

//----------TCustomEdit --------------------------------------------------------

function TCustomEdit_GetModified: Boolean;
begin
 result := TCustomEdit(_Self).Modified;
end;

procedure TCustomEdit_SetModified(Value: Boolean);
begin
 TCustomEdit(_Self).Modified := Value;
end;

function TCustomEdit_GetSelLength: Integer;
begin
 result := TCustomEdit(_Self).SelLength;
end;

procedure TCustomEdit_SetSelLength(Value: Integer);
begin
 TCustomEdit(_Self).SelLength := Value;
end;

function TCustomEdit_GetSelStart: Integer;
begin
 result := TCustomEdit(_Self).SelStart;
end;

procedure TCustomEdit_SetSelStart(Value: Integer);
begin
 TCustomEdit(_Self).SelStart := Value;
end;

function TCustomEdit_GetSelText: string;
begin
 result := TCustomEdit(_Self).SelText;
end;

procedure TCustomEdit_SetSelText(const Value: string);
begin
 TCustomEdit(_Self).SelText := Value;
end;

//--------------------TCustomListBox--------------------------------------------
function TCustomListBox_GetCanvas: TCanvas;
begin
 result := TCustomListBox(_Self).Canvas;
end;

function TCustomListBox_GetItems: TStrings;
begin
 result := TCustomListBox(_Self).Items;
end;

procedure TCustomListBox_SetItems(Value: TStrings);
begin
 TCustomListBox(_Self).Items := Value;
end;

function TCustomListBox_GetItemIndex: Integer;
begin
 result := TCustomListBox(_Self).ItemIndex;
end;

procedure TCustomListBox_SetItemIndex(Value: Integer);
begin
 TCustomListBox(_Self).ItemIndex := Value;
end;

function TCustomListBox_GetSelCount: Integer;
begin
 result := TCustomListBox(_Self).SelCount;
end;

function TCustomListBox_GetSelected(Index: Integer): Boolean;
begin
 result := TCustomListBox(_Self).Selected[Index];
end;

procedure TCustomListBox_SetSelected(Index: Integer; Value: Boolean);
begin
 TCustomListBox(_Self).Selected[Index] := Value;
end;

function TCustomListBox_GetTopIndex: Integer;
begin
 result := TCustomListBox(_Self).TopIndex;
end;

procedure TCustomListBox_SetTopIndex(Value: Integer);
begin
 TCustomListBox(_Self).TopIndex := Value;
end;

//---------------------TListBox-------------------------------------------------
function TListBox_GetItemIndex: Integer;
begin
  result := TListBox(_Self).ItemIndex;
end;

var
  H: Integer;

initialization

  RegisterClassType(TMemoStrings, -1);
  RegisterClassType(TListboxStrings, -1);
  RegisterClassType(TComboBoxStrings, -1);
  RegisterClassType(TCustomComboBoxStrings, -1);


  H := RegisterNamespace('StdCtrls');

//---- TButton -----------------------------------------------------------------

  RegisterClassType(TButton, H);
  RegisterMethod(TButton, 'constructor Create(AOwner: TComponent); override;',
                 @TButton.Create);
  RegisterMethod(TButton, 'procedure Click; override;',
                 @TButton.Click);

//---- TButtonControl ----------------------------------------------------------

  RegisterClassType(TButtonControl, H);
  RegisterMethod(TButtonControl, 'constructor Create(AOwner: TComponent); override;',
                 @TButtonControl.Create);

//---- TCustomCheckBox ---------------------------------------------------------

  RegisterClassType(TCustomCheckBox, H);
  RegisterMethod(TCustomCheckBox, 'constructor Create(AOwner: TComponent); override;',
                 @TCustomCheckBox.Create);

//---- TCheckBox ---------------------------------------------------------------

  RegisterClassType(TCheckBox, H);
  RegisterMethod(TCheckBox, 'constructor Create(AOwner: TComponent); override;',
                 @TCheckBox.Create);

//---- TCustomComboBox ---------------------------------------------------------

  RegisterClassType(TCustomComboBox, H);
  RegisterMethod(TCustomComboBox, 'constructor Create(AOwner: TComponent); override;',
                 @TCustomComboBox.Create);
  RegisterMethod(TCustomComboBox, 'procedure Clear;',
                 @TCustomComboBox.Clear);
  RegisterMethod(TCustomComboBox, 'function Focused: Boolean; override;',
                 @TCustomComboBox.Focused);
  RegisterMethod(TCustomComboBox, 'procedure SelectAll;',
                 @TCustomComboBox.SelectAll);
  RegisterMethod(TCustomComboBox, 'function GetCharCase: TEditCharCase;',
                 @TCustomComboBox_GetCharCase, Fake);
  RegisterMethod(TCustomComboBox, 'procedure SetCharCase(Value: TEditCharCase);',
                 @TCustomComboBox_SetCharCase, Fake);
  RegisterProperty(TCustomComboBox, 'property CharCase: TEditCharCase read'
                 +' GetCharCase write SetCharCase;');
  RegisterMethod(TCustomComboBox, 'function GetCanvas: TCanvas;',
                 @TCustomComboBox_GetCanvas, Fake);
  RegisterProperty(TCustomComboBox, 'property Canvas: TCanvas read GetCanvas;');
  RegisterMethod(TCustomComboBox, 'function GetDroppedDown: Boolean;',
                 @TCustomComboBox_GetDroppedDown, Fake);
  RegisterMethod(TCustomComboBox, 'procedure SetDroppedDown(Value: Boolean);',
                 @TCustomComboBox_SetDroppedDown, Fake);
  RegisterProperty(TCustomComboBox, 'property DroppedDown: Boolean read'
                 +' GetDroppedDown write SetDroppedDown;');
  RegisterMethod(TCustomComboBox, 'function GetItems: TStrings;',
                 @TCustomComboBox_GetItems, Fake);
  RegisterMethod(TCustomComboBox, 'procedure SetItems(Value: TStrings);',
                 @TCustomComboBox_SetItems, Fake);
  RegisterProperty(TCustomComboBox, 'property Items: TStrings read GetItems'
                 +' write SetItems;');
  RegisterMethod(TCustomComboBox, 'function GetItemIndex: Integer;',
                 @TCustomComboBox_GetItemIndex, Fake);
  RegisterMethod(TCustomComboBox, 'procedure SetItemIndex(Value: Integer);',
                 @TCustomComboBox_SetItemIndex, Fake);
  RegisterProperty(TCustomComboBox, 'property ItemIndex: Integer read'
                 +' GetItemIndex write SetItemIndex;');
  RegisterMethod(TCustomComboBox, 'function GetSelLength: Integer;',
                 @TCustomComboBox_GetSelLength, Fake);
  RegisterMethod(TCustomComboBox, 'procedure SetSelLength(Value: Integer);',
                 @TCustomComboBox_SetSelLength, Fake);
  RegisterProperty(TCustomComboBox, 'property SelLength: Integer read'
                 +' GetSelLength write SetSelLength;');
  RegisterMethod(TCustomComboBox, 'function GetSelStart: Integer;',
                 @TCustomComboBox_GetSelStart, Fake);
  RegisterMethod(TCustomComboBox, 'procedure SetSelStart(Value: Integer);',
                 @TCustomComboBox_SetSelStart, Fake);
  RegisterProperty(TCustomComboBox, 'property SelStart: Integer read GetSelStart'
                 +' write SetSelStart;');
  RegisterMethod(TCustomComboBox, 'function GetSelText: string;',
                 @TCustomComboBox_GetSelText, Fake);
  RegisterMethod(TCustomComboBox, 'procedure SetSelText(const Value: string);',
                 @TCustomComboBox_SetSelText, Fake);
  RegisterProperty(TCustomComboBox, 'property SelText: string read GetSelText'
                 +' write SetSelText;');

//---- TComboBox ---------------------------------------------------------------

  RegisterClassType(TComboBox, H);
  RegisterMethod(TComboBox, 'constructor Create(AOwner: TComponent); override;',
                 @TComboBox.Create);

//---- TCustomEdit -------------------------------------------------------------

  RegisterClassType(TCustomEdit, H);
  RegisterMethod(TCustomEdit, 'constructor Create(AOwner: TComponent); override;',
                 @TCustomEdit.Create);
  RegisterMethod(TCustomEdit, 'procedure Clear; virtual;',
                 @TCustomEdit.Clear);
  RegisterMethod(TCustomEdit, 'procedure ClearSelection;',
                 @TCustomEdit.ClearSelection);
  RegisterMethod(TCustomEdit, 'procedure CopyToClipboard;',
                 @TCustomEdit.CopyToClipboard);
  RegisterMethod(TCustomEdit, 'procedure CutToClipboard;',
                 @TCustomEdit.CutToClipboard);
  RegisterMethod(TCustomEdit, 'procedure DefaultHandler(var Message); override;',
                 @TCustomEdit.DefaultHandler);
  RegisterMethod(TCustomEdit, 'procedure PasteFromClipboard;',
                 @TCustomEdit.PasteFromClipboard);
  RegisterMethod(TCustomEdit, 'function GetSelTextBuf(Buffer: PChar; BufSize:'
                 +' Integer): Integer; virtual;',
                 @TCustomEdit.GetSelTextBuf);
  RegisterMethod(TCustomEdit, 'procedure SelectAll;',
                 @TCustomEdit.SelectAll);
  RegisterMethod(TCustomEdit, 'procedure SetSelTextBuf(Buffer: PChar);',
                 @TCustomEdit.SetSelTextBuf);
  RegisterMethod(TCustomEdit, 'function GetModified: Boolean;',
                 @TCustomEdit_GetModified, Fake);
  RegisterMethod(TCustomEdit, 'procedure SetModified(Value: Boolean);',
                 @TCustomEdit_SetModified, Fake);
  RegisterProperty(TCustomEdit, 'property Modified: Boolean read GetModified'
                 +' write SetModified;');
  RegisterMethod(TCustomEdit, 'function GetSelLength: Integer;',
                 @TCustomEdit_GetSelLength, Fake);
  RegisterMethod(TCustomEdit, 'procedure SetSelLength(Value: Integer);',
                 @TCustomEdit_SetSelLength, Fake);
  RegisterProperty(TCustomEdit, 'property SelLength: Integer read GetSelLength'
                 +' write SetSelLength;');
  RegisterMethod(TCustomEdit, 'function GetSelStart: Integer;',
                 @TCustomEdit_GetSelStart, Fake);
  RegisterMethod(TCustomEdit, 'procedure SetSelStart(Value: Integer);',
                 @TCustomEdit_SetSelStart, Fake);
  RegisterProperty(TCustomEdit, 'property SelStart: Integer read GetSelStart'
                 +' write SetSelStart;');

//---- TEdit -------------------------------------------------------------------

  RegisterClassType(TEdit, H);
  RegisterMethod(TEdit, 'constructor Create(AOwner: TComponent); override;',
                 @TEdit.Create);

//---- TCustomMemo -------------------------------------------------------------

  RegisterClassType(TCustomMemo, H);
  RegisterMethod(TCustomMemo, 'constructor Create(AOwner: TComponent); override;',
                 @TCustomMemo.Create);

//---- TMemo--------------------------------------------------------------------

  RegisterClassType(TMemo, H);
  RegisterMethod(TMemo, 'constructor Create(AOwner: TComponent); override;',
                 @TMemo.Create);

//---- TRadioButton ------------------------------------------------------------

  RegisterClassType(TRadioButton, H);
  RegisterMethod(TRadioButton, 'constructor Create(AOwner: TComponent); override;',
                 @TRadioButton.Create);

//---- TCustomListBox ----------------------------------------------------------

  RegisterClassType(TCustomListBox, H);
  RegisterMethod(TCustomListBox, 'constructor Create(AOwner: TComponent); override;',
                 @TCustomListBox.Create);
  RegisterMethod(TCustomListBox, 'procedure Clear;',
                 @TCustomListBox.Clear);
  RegisterMethod(TCustomListBox, 'function ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;',
                 @TCustomListBox.ItemAtPos);
  RegisterMethod(TCustomListBox, 'function ItemRect(Index: Integer): TRect;',
                 @TCustomListBox.ItemRect);
  RegisterMethod(TCustomListBox, 'function GetCanvas: TCanvas;',
                 @TCustomListBox_GetCanvas, Fake);
  RegisterProperty(TCustomListBox, 'property Canvas: TCanvas read GetCanvas;');
  RegisterMethod(TCustomListBox, 'function GetItems: TStrings;',
                 @TCustomListBox_GetItems, Fake);
  RegisterMethod(TCustomListBox, 'procedure SetItems(Value: TStrings);',
                 @TCustomListBox_SetItems, Fake);
  RegisterProperty(TCustomListBox, 'property Items: TStrings read GetItems'
                 +' write SetItems;');
  RegisterMethod(TCustomListBox, 'function GetItemIndex: Integer;',
                 @TCustomListBox_GetItemIndex, Fake);
  RegisterMethod(TCustomListBox, 'procedure SetItemIndex(Value: Integer);',
                 @TCustomListBox_SetItemIndex, Fake);
  RegisterProperty(TCustomListBox, 'property ItemIndex: Integer read'
                 +' GetItemIndex write SetItemIndex;');
  RegisterMethod(TCustomListBox, 'function GetSelCount: Integer;',
                 @TCustomListBox_GetSelCount, Fake);
  RegisterProperty(TCustomListBox, 'property SelCount: Integer read GetSelCount;');
  RegisterMethod(TCustomListBox, 'function GetSelected(Index: Integer): Boolean;',
                 @TCustomListBox_GetSelected, Fake);
  RegisterMethod(TCustomListBox, 'procedure SetSelected(Index: Integer; Value: Boolean);',
                 @TCustomListBox_SetSelected, Fake);
  RegisterProperty(TCustomListBox, 'property Selected[Index: Integer]: Boolean'
                 +' read GetSelected write SetSelected;');
  RegisterMethod(TCustomListBox, 'function GetTopIndex: Integer;',
                 @TCustomListBox_GetTopIndex, Fake);
  RegisterMethod(TCustomListBox, 'procedure SetTopIndex(Value: Integer);',
                 @TCustomListBox_SetTopIndex, Fake);
  RegisterProperty(TCustomListBox, 'property TopIndex: Integer read GetTopIndex'
                 +' write SetTopIndex;');

//---- TListBox ----------------------------------------------------------------

  RegisterClassType(TListBox, H);
  RegisterMethod(TListBox, 'constructor Create(AOwner: TComponent); override;',
                 @TListBox.Create);
  RegisterMethod(TListBox, 'function GetItemIndex: Integer;',
                 @TListBox_GetItemIndex, Fake);
  RegisterProperty(TListBox, 'property ItemIndex: Integer read GetItemIndex;');

//---- TScrollBar --------------------------------------------------------------

  RegisterClassType(TScrollBar, H);
  RegisterMethod(TScrollBar, 'constructor Create(AOwner: TComponent); override;',
                 @TScrollBar.Create);
  RegisterMethod(TScrollBar, 'procedure SetParams(APosition, AMin, AMax: Integer);',
                 @TScrollBar.SetParams);

//---- TCustomGroupBox ---------------------------------------------------------

  RegisterClassType(TCustomGroupBox, H);
  RegisterMethod(TCustomGroupBox, 'constructor Create(AOwner: TComponent); override;',
                 @TCustomGroupBox.Create);

//---- TGroupBox ---------------------------------------------------------------

  RegisterClassType(TGroupBox, H);
  RegisterMethod(TGroupBox, 'constructor Create(AOwner: TComponent); override;',
                 @TGroupBox.Create);

//---- TCustomLabel ------------------------------------------------------------

  RegisterClassType(TCustomLabel, H);
  RegisterMethod(TCustomLabel, 'constructor Create(AOwner: TComponent); override;',
                 @TCustomLabel.Create);

//---- TLabel-------------------------------------------------------------------

  RegisterClassType(TLabel, H);
  RegisterMethod(TLabel, 'constructor Create(AOwner: TComponent); override;',
                 @TLabel.Create);
                 
{$IFDEF WIN32}
//---- TStaticText-------------------------------------------------------------------

  RegisterClassType(TStaticText, H);
  RegisterMethod(TStaticText, 'constructor Create(AOwner: TComponent); override;',
                 @TStaticText.Create);
{$ENDIF}

end.
