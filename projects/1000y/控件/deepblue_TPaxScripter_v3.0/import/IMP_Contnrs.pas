unit IMP_contnrs;
interface
uses
  SysUtils,
  Classes,
  contnrs,
  BASE_EXTERN,
  PaxScripter;
procedure RegisterIMP_contnrs;
implementation
function TObjectList__GetOwnsObjects(Self:TObjectList):Boolean;
begin
  result := Self.OwnsObjects;
end;
procedure TObjectList__PutOwnsObjects(Self:TObjectList;const Value: Boolean);
begin
  Self.OwnsObjects := Value;
end;
function TObjectList__GetItems(Self:TObjectList;Index: Integer):TObject;
begin
  result := Self.Items[Index];
end;
procedure TObjectList__PutItems(Self:TObjectList;Index: Integer;const Value: TObject);
begin
  Self.Items[Index] := Value;
end;
function TComponentList__GetItems(Self:TComponentList;Index: Integer):TComponent;
begin
  result := Self.Items[Index];
end;
procedure TComponentList__PutItems(Self:TComponentList;Index: Integer;const Value: TComponent);
begin
  Self.Items[Index] := Value;
end;
function TClassList__GetItems(Self:TClassList;Index: Integer):TClass;
begin
  result := Self.Items[Index];
end;
procedure TClassList__PutItems(Self:TClassList;Index: Integer;const Value: TClass);
begin
  Self.Items[Index] := Value;
end;
procedure TOrderedList_Create(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
TOrderedList(Self).Create();
end;
procedure TOrderedList_Count(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
   result.PValue^ := TOrderedList(Self).Count();
end;
procedure TOrderedList_AtLeast(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
   result.PValue^ := TOrderedList(Self).AtLeast(Params[0].PValue^);
end;
procedure TOrderedList_Push(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
TOrderedList(Self).Push(Params[0].AsPointer);
end;
procedure TOrderedList_Pop(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
   result.AsPointer := TOrderedList(Self).Pop();
end;
procedure TOrderedList_Peek(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
   result.AsPointer := TOrderedList(Self).Peek();
end;
procedure RegisterIMP_contnrs;
var H: Integer;
begin
  H := RegisterNamespace('contnrs', -1);
  // Begin of class TObjectList
  RegisterClassType(TObjectList, H);
  RegisterMethod(TObjectList,
       'constructor Create; overload;',
       @TObjectList.Create);
  RegisterMethod(TObjectList,
       'constructor Create(AOwnsObjects: Boolean); overload;',
       @TObjectList.Create);
  RegisterMethod(TObjectList,
       'function Add(AObject: TObject): Integer;',
       @TObjectList.Add);
  RegisterMethod(TObjectList,
       'function Remove(AObject: TObject): Integer;',
       @TObjectList.Remove);
  RegisterMethod(TObjectList,
       'function IndexOf(AObject: TObject): Integer;',
       @TObjectList.IndexOf);
  RegisterMethod(TObjectList,
       'procedure Insert(Index: Integer; AObject: TObject);',
       @TObjectList.Insert);
  RegisterMethod(TObjectList,
       'function TObjectList__GetOwnsObjects(Self:TObjectList):Boolean;',
       @TObjectList__GetOwnsObjects, true);
  RegisterMethod(TObjectList,
       'procedure TObjectList__PutOwnsObjects(Self:TObjectList;const Value: Boolean);',
       @TObjectList__PutOwnsObjects, true);
  RegisterProperty(TObjectList,
       'property OwnsObjects:Boolean read TObjectList__GetOwnsObjects write TObjectList__PutOwnsObjects;');
  RegisterMethod(TObjectList,
       'function TObjectList__GetItems(Self:TObjectList;Index: Integer):TObject;',
       @TObjectList__GetItems, true);
  RegisterMethod(TObjectList,
       'procedure TObjectList__PutItems(Self:TObjectList;Index: Integer;const Value: TObject);',
       @TObjectList__PutItems, true);
  RegisterProperty(TObjectList,
       'property Items[Index: Integer]:TObject read TObjectList__GetItems write TObjectList__PutItems;default;');
  // End of class TObjectList
  // Begin of class TComponentList
  RegisterClassType(TComponentList, H);
  RegisterMethod(TComponentList,
       'destructor Destroy; override;',
       @TComponentList.Destroy);
  RegisterMethod(TComponentList,
       'function Add(AComponent: TComponent): Integer;',
       @TComponentList.Add);
  RegisterMethod(TComponentList,
       'function Remove(AComponent: TComponent): Integer;',
       @TComponentList.Remove);
  RegisterMethod(TComponentList,
       'function IndexOf(AComponent: TComponent): Integer;',
       @TComponentList.IndexOf);
  RegisterMethod(TComponentList,
       'procedure Insert(Index: Integer; AComponent: TComponent);',
       @TComponentList.Insert);
  RegisterMethod(TComponentList,
       'function TComponentList__GetItems(Self:TComponentList;Index: Integer):TComponent;',
       @TComponentList__GetItems, true);
  RegisterMethod(TComponentList,
       'procedure TComponentList__PutItems(Self:TComponentList;Index: Integer;const Value: TComponent);',
       @TComponentList__PutItems, true);
  RegisterProperty(TComponentList,
       'property Items[Index: Integer]:TComponent read TComponentList__GetItems write TComponentList__PutItems;default;');
  RegisterMethod(TComponentList,
       'constructor Create(AOwnsObjects: Boolean); overload;',
       @TComponentList.Create);
  // End of class TComponentList
  // Begin of class TClassList
  RegisterClassType(TClassList, H);
  RegisterMethod(TClassList,
       'function Add(aClass: TClass): Integer;',
       @TClassList.Add);
  RegisterMethod(TClassList,
       'function Remove(aClass: TClass): Integer;',
       @TClassList.Remove);
  RegisterMethod(TClassList,
       'function IndexOf(aClass: TClass): Integer;',
       @TClassList.IndexOf);
  RegisterMethod(TClassList,
       'procedure Insert(Index: Integer; aClass: TClass);',
       @TClassList.Insert);
  RegisterMethod(TClassList,
       'function TClassList__GetItems(Self:TClassList;Index: Integer):TClass;',
       @TClassList__GetItems, true);
  RegisterMethod(TClassList,
       'procedure TClassList__PutItems(Self:TClassList;Index: Integer;const Value: TClass);',
       @TClassList__PutItems, true);
  RegisterProperty(TClassList,
       'property Items[Index: Integer]:TClass read TClassList__GetItems write TClassList__PutItems;default;');
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TClassList
  // Begin of class TOrderedList
  RegisterClassType(TOrderedList, H);
  RegisterStdMethod(TOrderedList,'Create',TOrderedList_Create,0);
  RegisterMethod(TOrderedList,
       'destructor Destroy; override;',
       @TOrderedList.Destroy);
  RegisterStdMethod(TOrderedList,'Count',TOrderedList_Count,0);
  RegisterStdMethod(TOrderedList,'AtLeast',TOrderedList_AtLeast,1);
  RegisterStdMethod(TOrderedList,'Push',TOrderedList_Push,1);
  RegisterStdMethod(TOrderedList,'Pop',TOrderedList_Pop,0);
  RegisterStdMethod(TOrderedList,'Peek',TOrderedList_Peek,0);
  RegisterMethod(TOrderedList,
       'constructor Create;',
       @TOrderedList.Create);
  // End of class TOrderedList
  // Begin of class TStack
  RegisterClassType(TStack, H);
  RegisterMethod(TStack,
       'constructor Create;',
       @TStack.Create);
  // End of class TStack
  // Begin of class TObjectStack
  RegisterClassType(TObjectStack, H);
  RegisterMethod(TObjectStack,
       'procedure Push(AObject: TObject);',
       @TObjectStack.Push);
  RegisterMethod(TObjectStack,
       'function Pop: TObject;',
       @TObjectStack.Pop);
  RegisterMethod(TObjectStack,
       'function Peek: TObject;',
       @TObjectStack.Peek);
  RegisterMethod(TObjectStack,
       'constructor Create;',
       @TObjectStack.Create);
  // End of class TObjectStack
  // Begin of class TQueue
  RegisterClassType(TQueue, H);
  RegisterMethod(TQueue,
       'constructor Create;',
       @TQueue.Create);
  // End of class TQueue
  // Begin of class TObjectQueue
  RegisterClassType(TObjectQueue, H);
  RegisterMethod(TObjectQueue,
       'procedure Push(AObject: TObject);',
       @TObjectQueue.Push);
  RegisterMethod(TObjectQueue,
       'function Pop: TObject;',
       @TObjectQueue.Pop);
  RegisterMethod(TObjectQueue,
       'function Peek: TObject;',
       @TObjectQueue.Peek);
  RegisterMethod(TObjectQueue,
       'constructor Create;',
       @TObjectQueue.Create);
  // End of class TObjectQueue
end;
initialization
  RegisterIMP_contnrs;
end.
