unit ProClass;

interface
uses Windows, Controls, Messages, SysUtils, Classes, A2Form, A2Img, Graphics, Deftype;
type

    TTA2ILabelList = class                                                      //小地图使用
        A2Form: TA2Form;
        Owner: TWinControl;
        data: TList;
        //  posLabel:TA2ILabel;
        poslist: tstringlist;
    private

    protected

    public
        ColorImage: TA2Image;
        constructor Create(aA2Form: TA2Form; AOwner: TWinControl; acolor: tcolor);
        destructor Destroy; override;
        procedure ItemAdd(aLeft, atop, gx, gy, aWidth, aHeight: integer; aCaption, aHint: string);
        procedure ItemClear();
        function ItemGet(id: integer): pointer;

        procedure onMouseEnter(Sender: TObject);
        procedure OnMouseLeave(Sender: TObject);
        procedure onMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
    published

    end;

implementation
uses fmain;

procedure TTA2ILabelList.onMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
begin
    GameHint.setText(integer(Sender), TA2ILabel(Sender).Hint + #13#10 + poslist.Strings[TA2ILabel(Sender).Tag]);
end;

procedure TTA2ILabelList.onMouseEnter(Sender: TObject);
begin

    //  posLabel.Caption := poslist.Strings[TA2ILabel(Sender).Tag];
end;

procedure TTA2ILabelList.OnMouseLeave(Sender: TObject);
begin
    // posLabel.Caption := '';        // format('坐标[%d:%d]', []);

    GameHint.Close;
end;

procedure TTA2ILabelList.ItemAdd(aLeft, aTop, gx, gy, aWidth, aHeight: integer; aCaption, aHint: string);
var
    t: TA2ILabel;
begin
    t := TA2ILabel.Create(Owner);

    t.Visible := false;
    t.Parent := Owner;
    t.ADXForm := A2Form;
    t.Width := aWidth;
    t.Height := aHeight;

    t.Tag := data.Count;
    t.A2Image := ColorImage;
    t.Caption := aCaption;
    t.Left := aLeft - (t.Width div 2);
    t.Top := aTop - (t.Height div 2);
    t.Hint := aHint;

    //    t.FHint.Ftype := hstTransparent;
      //  t.FHint.setText(aHint);

        //t.ShowHint := true;
    t.Visible := true;
    t.BringToFront;
    t.OnMouseMove := onMouseMove;
    t.OnMouseEnter := onMouseEnter;
    t.OnMouseLeave := OnMouseLeave;
    // t.BColor := acolor;
    data.Add(t);
    poslist.Add(format('坐标[%d,%d]', [gx, gy]));
end;

function TTA2ILabelList.ItemGet(id: integer): pointer;
begin
    result := nil;
    if (id < 0) or (id >= data.Count) then exit;
    result := data.Items[id];
end;

procedure TTA2ILabelList.ItemClear();
var
    i: integer;
    t: TA2ILabel;
begin
    if data.Count <= 0 then exit;
    for i := 0 to data.Count - 1 do
    begin
        t := data.Items[i];
        t.Free;
    end;

    data.Clear;
    poslist.Clear;
end;

constructor TTA2ILabelList.Create(aA2Form: TA2Form; AOwner: TWinControl; acolor: tcolor);
begin
    inherited Create;
    data := TList.Create;
    Owner := AOwner;
    A2Form := aA2Form;
//    if Assigned(A2Form) then        A2Form.FA2Hint.Ftype := hstTransparent;
    ColorImage := TA2Image.Create(4, 4, 0, 0);
    ColorImage.Clear(ColorSysToDxColor(acolor));
    poslist := tstringlist.Create;
    //  posLabel := aposLabel;
end;

destructor TTA2ILabelList.Destroy;
var
    i: integer;
    t: TA2ILabel;
begin
    for i := 0 to data.Count - 1 do
    begin
        t := data[i];
        t.Free;
    end;
    poslist.Free;
    data.Free;
    ColorImage.Free;
    inherited Destroy;
end;
end.

