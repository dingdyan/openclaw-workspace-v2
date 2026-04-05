////////////////////////////////////////////////////////////////////////////
// PAXScript Importing
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003. All rights reserved.                                  
// Code Version: 1.5
// ========================================================================
// Unit: IMP_Menus.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

// Imports classes:
//    TMainMenu,
//    TMenu,
//    TMenuItem,
//    TPopupMenu,
//    TPopupList,
//    TPopupItemStack

unit IMP_Menus;
interface
uses
  Classes,
{$IFDEF WIN32}
  Windows,
{$ENDIF}
{$IFDEF LINUX}
  Types,
  QImglist,
  QMenus,
{$ELSE}
  Imglist,
  Menus,
{$ENDIF}
  PaxScripter;

implementation

//-------TMenuItem--------------------------------------------------------------

function TMenuItem_GetCount: Integer;
begin
 result := TMenuItem(_Self).Count;
end;

function TMenuItem_GetItem(Index: Integer): TMenuItem;
begin
 result := TMenuItem(_Self).Items[Index];
end;

function TMenuItem_GetMenuIndex: Integer;
begin
 result := TMenuItem(_Self).MenuIndex;
end;

procedure TMenuItem_SetMenuIndex(Value: Integer);
begin
 TMenuItem(_Self).MenuIndex := Value;
end;

function TMenuItem_GetParent: TMenuItem;
begin
 result := TMenuItem(_Self).Parent;
end;

//------TMenu-------------------------------------------------------------------

function TMenu_GetImages: TCustomImageList;
begin
  result := TMenu(_Self).Images;
end;

procedure TMenu_SetImages(Value: TCustomImageList);
begin
 TMenu(_Self).Images := Value;
end;

//--------TPopupMenu------------------------------------------------------------

function TPopupMenu_GetPopupComponent: TComponent;
begin
 result := TPopupMenu(_Self).PopupComponent;
end;

procedure TPopupMenu_SetPopupComponent(Value: TComponent);
begin
 TPopupMenu(_Self).PopupComponent := Value;
end;

var
  H: Integer;

initialization

  H := RegisterNamespace('Menus');

//---- TMenuItem----------------------------------------------------------------

  RegisterClassType(TMenuItem, H);
  RegisterMethod(TMenuItem, 'constructor Create(AOwner: TComponent); override;',
                @TMenuItem.Create);
  RegisterMethod(TMenuItem, 'procedure InitiateAction; virtual;',
                @TMenuItem.InitiateAction);
  RegisterMethod(TMenuItem, 'procedure Insert(Index: Integer; Item: TMenuItem);',
                @TMenuItem.Insert);
  RegisterMethod(TMenuItem, 'procedure Delete(Index: Integer);',
                @TMenuItem.Delete);
  RegisterMethod(TMenuItem, 'procedure Clear;',
                @TMenuItem.Clear);
  RegisterMethod(TMenuItem, 'function Find(ACaption: string): TMenuItem;',
                @TMenuItem.Find);
  RegisterMethod(TMenuItem, 'function IsLine: Boolean;',
                @TMenuItem.IsLine);
  RegisterMethod(TMenuItem, 'function InsertNewLineBefore(AItem: TMenuItem): Integer;',
                @TMenuItem.InsertNewLineBefore);
  RegisterMethod(TMenuItem, 'function InsertNewLineAfter(AItem: TMenuItem): Integer;',
                @TMenuItem.InsertNewLineAfter);
  RegisterMethod(TMenuItem, 'function RethinkHotkeys: Boolean;',
                @TMenuItem.RethinkHotkeys);
  RegisterMethod(TMenuItem, 'procedure Click; virtual;',
                @TMenuItem.Click);
  RegisterMethod(TMenuItem, 'function IndexOf(Item: TMenuItem): Integer;',
                @TMenuItem.IndexOf);
  RegisterMethod(TMenuItem, 'function GetParentComponent: TComponent; override;',
                @TMenuItem.GetParentComponent);
  RegisterMethod(TMenuItem, 'function GetParentMenu: TMenu;',
                @TMenuItem.GetParentMenu);
  RegisterMethod(TMenuItem, 'function HasParent: Boolean; override;',
                @TMenuItem.HasParent);
  RegisterMethod(TMenuItem, 'procedure Add(Item: TMenuItem); overload;',
                @TMenuItem.Add);
  RegisterMethod(TMenuItem, 'procedure Remove(Item: TMenuItem);',
                @TMenuItem.Remove);
  RegisterMethod(TMenuItem, 'function GetCount: Integer;',
                @TMenuItem_GetCount, Fake);
  RegisterProperty(TMenuItem, 'property Count: Integer read GetCount;');
  RegisterMethod(TMenuItem, 'function GetItem(Index: Integer): TMenuItem;',
                @TMenuItem_GetItem, Fake);
  RegisterProperty(TMenuItem, 'property Items[Index: Integer]: TMenuItem read'
                +' GetItem;');
  RegisterMethod(TMenuItem, 'function GetMenuIndex: Integer;',
                @TMenuItem_GetMenuIndex, Fake);
  RegisterMethod(TMenuItem, 'procedure SetMenuIndex(Value: Integer);',
                @TMenuItem_SetMenuIndex, Fake);
  RegisterProperty(TMenuItem, 'property MenuIndex: Integer read GetMenuIndex'
                +' write SetMenuIndex;');
  RegisterMethod(TMenuItem, 'function GetParent: TMenuItem;',
                @TMenuItem_GetParent, Fake);
  RegisterProperty(TMenuItem, 'property Parent: TMenuItem read GetParent;');

//---- TMenu -------------------------------------------------------------------

  RegisterClassType(TMenu, H);
  RegisterMethod(TMenu, 'constructor Create(AOwner: TComponent); override;',
                @TMenu.Create);
  RegisterMethod(TMenu, 'function FindItem(Value: Integer; Kind: TFindItemKind): TMenuItem;',
                @TMenu.FindItem);
  RegisterMethod(TMenu, 'function IsShortCut(var Message: TWMKey): Boolean; dynamic;',
                @TMenu.IsShortCut);
  RegisterMethod(TMenu, 'function GetImages: TCustomImageList;',
                @TMenu_GetImages, Fake);
  RegisterMethod(TMenu, 'procedure SetImages(Value: TCustomImageList);',
                @TMenu_SetImages, Fake);
  RegisterProperty(TMenu, 'property Images: TCustomImageList read GetImages'
                +' write SetImages;');

//---- TMainMenu----------------------------------------------------------------

  RegisterClassType(TMainMenu, H);
  RegisterMethod(TMainMenu, 'constructor Create(AOwner: TComponent); override;',
                @TMainMenu.Create);
  RegisterMethod(TMainMenu, 'procedure Merge(Menu: TMainMenu);',
                @TMainMenu.Merge);
  RegisterMethod(TMainMenu, 'procedure Unmerge(Menu: TMainMenu);',
                @TMainMenu.Unmerge);

//---- TPopupMenu---------------------------------------------------------------

  RegisterClassType(TPopupMenu, H);
  RegisterMethod(TPopupMenu, 'constructor Create(AOwner: TComponent); override;',
                @TPopupMenu.Create);
  RegisterMethod(TPopupMenu, 'procedure Popup(X, Y: Integer); virtual;',
                @TPopupMenu.Popup);
  RegisterMethod(TPopupMenu, 'function GetPopupComponent: TComponent;',
                @TPopupMenu_GetPopupComponent, Fake);
  RegisterMethod(TPopupMenu, 'procedure SetPopupComponent(Value: TComponent);',
                @TPopupMenu_SetPopupComponent, Fake);
  RegisterProperty(TPopupMenu, 'property PopupComponent: TComponent read'
                +' GetPopupComponent write SetPopupComponent;');

{$IFDEF WIN32}
//---- TPopupList --------------------------------------------------------------

  RegisterClassType(TPopupList, H);
  RegisterMethod(TPopupList, 'constructor Create;',
                 @TPopupList.Create);
  RegisterMethod(TPopupList, 'procedure Add(Popup: TPopupMenu);',
                @TPopupList.Add);
  RegisterMethod(TPopupList, 'procedure Remove(Popup: TPopupMenu);',
                @TPopupList.Remove);
{$ENDIF}  

//---- TMenuItemStack ----------------------------------------------------------

  RegisterClassType(TMenuItemStack, H);
  RegisterMethod(TMenuItemStack, 'constructor Create;',
                 @TMenuItemStack.Create);
  RegisterMethod(TMenuItemStack, 'procedure ClearItem(AItem: TMenuItem);',
                @TMenuItemStack.ClearItem);
end.

