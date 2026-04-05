unit A2Form;

interface

uses

  Messages, Windows, SysUtils, CommCtrl, Classes, Controls, Forms,
  Graphics, StdCtrls, ExtCtrls,
  A2Img, BmpUtil, MMSystem, ComCtrls;
const
  EDIT_TOGGLE_TIME = 500;

  IMG_LT = 0;
  IMG_TOP = 1;
  IMG_RT = 2;
  IMG_LEFT = 3;
  IMG_BODY = 4;
  IMG_RIGHT = 5;
  IMG_LB = 6;
  IMG_BOTTOM = 7;
  IMG_RB = 8;

  IMG_DOWN = 9;
  IMG_UP = 10;

  IMG_BLOCK_SIZE = 12;

  XCENTER = -12;

type
  TEDITSET = procedure();
  TOnAdxPaint = procedure(aAnsImage: TA2Image) of object;
  TShowMethod = (FSM_NONE, FSM_DITHER, FSM_DARKEN, FSM_ImageOveray);

  TA2ImageShowType = (hst_None, hstTransparent, hstImageOveray); //3种方式 不透明 半透明 透明度
  TA2Hint = class
    FVisible: boolean;
    Fleft: integer;
    Ftop: integer;
    Fback: TA2Image;
    FBackcolor: TCOLOR;
    FTextcolor: tcolor;
    Fbordercolor: tcolor;
    Ftype: TA2ImageShowType;
    FImageOveray: integer; //透明 度
  private
    FHintText: TstringList;
    fshowtimetcik: integer;
  public

    constructor Create;
    destructor Destroy; override;
    procedure Draw;
    procedure setText(atext: string);
    procedure DrawBack(DestImage: TA2Image; x, y: integer);
    procedure setVisible;
  end;
  TA2Form = class(TComponent)

  private
        //        FComponentList:TList;
    FSurface: TA2Image;
    DrawState: boolean;
    FParent: TForm;

    CurFrame: integer;
    FShowMethod: TShowMethod;

    FColor: TColor;
    FImageFileName: string;

    FTransParent: Boolean;

    FOnAdxPaint: TOnAdxPaint;

    procedure DrawDispath;
    procedure DrawDispathHint(aSurface: TA2Image; x, y: integer);
    procedure add(aOb: pointer);
    procedure del(aOb: pointer);

  protected
    procedure Loaded; override;
  public
       // FA2Hint: TA2Hint;
    FImageSurface: TA2Image;
    boImagesurface: boolean;
    FImageOveray: integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint(aSurface: TA2Image);
    procedure setImageSurface(aimg: TA2Image);
    procedure Draw();

    property Surface: TA2Image read FSurface write FSurface;
  published
    property Color: TColor read FColor write FColor;
    property OnAdxPaint: TOnAdxPaint read FOnAdxPaint write FOnAdxpaint;
    property ImageFileName: string read FImageFileName write FImageFileName;

    property ShowMethod: TShowMethod read FShowMethod write FShowMethod;
    property TransParent: Boolean read FTransParent write FTransParent;

  end;

  TA2Gauge = class(TLabel)
  private
    FMinValue: Longint;
    FMaxValue: Longint;
    FCurValue: Longint;

    FForeColor: TColor;
    FBackColor: TColor;

    FADXForm: TA2Form;

    FImageBack: TA2Image;
        //背景
  protected
    procedure Loaded; override;
    procedure _Draw;
    procedure SetForeColor(Value: TColor);
    procedure SetBackColor(Value: TColor);
    procedure SetMinValue(Value: Longint);
    procedure SetMaxValue(Value: Longint);
    procedure SetProgress(Value: Longint);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  published
    property MinValue: Longint read FMinValue write SetMinValue;
    property MaxValue: Longint read FMaxValue write SetMaxValue;
    property Progress: Longint read FCurValue write SetProgress;
    property ForeColor: TColor read FForeColor write SetForeColor;
    property BackColor: TColor read FBackColor write SetBackColor;
    property ADXForm: TA2Form read FADXForm write FADXForm;

  end;

  TA2CheckBox = class(TLabel)
  private
    FSelectImage: TA2Image; //选择 图片
    FSelectNotImage: TA2Image; //非选择 图片
    FEnabledImage: TA2Image; //灰掉 静止使用

    FADXForm: TA2Form;
    FChecked: boolean;

    procedure setChecked(Value: boolean);
    procedure setSelectImage(Value: TA2Image);
    procedure setSelectNotImage(Value: TA2Image);
    procedure setEnabledImage(Value: TA2Image);
    procedure setFADXForm(Value: TA2Form);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;

    property SelectImage: TA2Image read FSelectImage write setSelectImage;
    property SelectNotImage: TA2Image read FSelectNotImage write SetSelectNotImage;
    property EnabledImage: TA2Image read FEnabledImage write SetEnabledImage;
    property Checked: BOOLEAN read FChecked write setChecked;
  published
    property ADXForm: TA2Form read FADXForm write setFADXForm;

  end;

  TA2Label = class(TLabel)
  private
    FPicture: TPicture;

    boEntered: Boolean;
    FADXForm: TA2Form;
    FFontColor: Word;
    FBColor: word;


    function GetCaption: string;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure SetPicture(Value: TPicture);
    procedure SetCaption(Value: string);
    procedure SetFontColor(Value: Word);
    procedure SetBackColor(Value: Word);
    procedure setFADXForm(Value: TA2Form);

  protected
    procedure Loaded; override;
    procedure paint; override;
  public
    NotTransParent: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;

  published
    property ADXForm: TA2Form read FADXForm write setFADXForm;
    property Caption: string read GetCaption write SetCaption;
    property Picture: TPicture read FPicture write SetPicture;
    property FontColor: Word read FFontColor write SetFontColor;
    property BackColor: Word read FBColor write SetBackColor;
  end;

  TA2Panel = class(TPanel)
  private
    FPicture: TPicture;
    FADXForm: TA2Form;
    procedure SetPicture(Value: TPicture);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
  published
    property ADXForm: TA2Form read FADXForm write FADXForm;
    property Picture: TPicture read FPicture write SetPicture;
  end;
  TFA2Image2Alignment = (aaLeftUP, aaRightDown);

    //
  TA2ILabel = class(TLabel)

  private

    FADXForm: TA2Form;

    FPicture: TPicture;
        //        FPicturea2:TA2Image;

    FA2Image: TA2Image;
    FA2ImageRDown: TA2Image; //小图标 右下
    FA2ImageLUP: TA2Image; //小图标 左上
    FA2ImageBACK: TA2Image;

    FBColor: word;
    FOnPaint: TNotifyEvent;
    FGreenCol: integer;
    FGreenadd: integer;
    boEntered: Boolean;
    FA2ShowHint: boolean;
    FImageBack: TA2Image; //背景

    procedure Setcolor(Value: word);
    procedure SetImage(Value: TA2Image);
    procedure SetImageRDown(Value: TA2Image);
    procedure SetImageLUP(Value: TA2Image);
    procedure SetImageBack(Value: TA2Image);
    procedure SetPicture(Value: TPicture);
    procedure SetCaption(Value: string);
    procedure SETFADXForm(Value: TA2Form);

    function GetCaption: string;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    procedure _Draw;

  protected
    procedure Loaded; override;

    procedure Paint; override;

  public
    FImgIndex: INTEGER; //动画
    FDelayTick: integer; //动画
    FA2ImageLib: TA2ImageLib; //动画
    FImgIndexStart, //动画
      FImgIndexMax: integer; //动画
    FTransparentColor: Integer; //动画 过滤掉的颜色

        //        FBaseImage:TA2Image;                                                    //?
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
    property A2Image: TA2Image read FA2Image write SetImage;
    property A2ImageRDown: TA2Image read FA2ImageRDown write SetImageRDown;
    property A2ImageLUP: TA2Image read FA2ImageLUP write SetImageLUP;
    property A2Imageback: TA2Image read fA2Imageback write SetImageBack;
    property BColor: word read FBColor write SetColor;
    property GreenCol: integer read FGreenCol write FGreenCol;
    property GreenAdd: integer read FGreenAdd write FGreenAdd;
    property A2ShowHint: Boolean read FA2ShowHint write FA2ShowHint;

    procedure A2SendToBack();
        //        procedure update(atick:integer);
  published
    property ADXForm: TA2Form read FADXForm write SETFADXForm;
    property Caption: string read GetCaption write SetCaption;
    property Picture: TPicture read FPicture write SetPicture;

    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;

  end;

  TA2Button = class(TLabel)
  private
    FUpImage: TPicture;
    FDownImage: TPicture;

    FEnabledImage: TPicture; //灰掉 静止使用
    FMouseImage: TPicture; //光标

    FUpA2Image: TA2Image;
    FDownA2Image: TA2Image; //按下
    FEnabledA2Image: TA2Image; //灰掉 静止使用
    FMouseA2Image: TA2Image; //光标

    FDown: Boolean;
    FLockDown: Boolean;
    FOldDown: Boolean;
    FCaptured: Boolean;
    boEntered: Boolean;
    FADXForm: TA2Form;
    FFontColor: integer; //没得用 无功能
    FFontSelColor: integer; //没得用 无功能

    procedure SetCaption(Value: string);
    function GetCaption: string;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;

    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;

    procedure SetUpImage(Value: TPicture);
    procedure SetDownImage(Value: TPicture);
    procedure SetEnabledImage(Value: TPicture);
    procedure SetMouseImage(Value: TPicture);

    procedure SetADXForm(Value: TA2Form);

    procedure SetUpA2Image(Value: TA2Image);
    procedure SetDownA2Image(Value: TA2Image);
    procedure SetMouseA2Image(Value: TA2Image);
    procedure SetEnabledA2Image(Value: TA2Image);
  protected
    procedure Loaded; override;
    procedure paint; override;
  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;



    procedure Lockdown(value: boolean);

    property A2Up: TA2Image read FUpA2Image write SetUpA2Image;
    property A2Down: TA2Image read FDownA2Image write SetDownA2Image;
    property A2Mouse: TA2Image read FMouseA2Image write SetMouseA2Image;
    property A2NotEnabled: TA2Image read FEnabledA2Image write SetEnabledA2Image;
  published
    property ADXForm: TA2Form read FADXForm write SetADXForm;
    property Caption: string read GetCaption write SetCaption;
    property FontColor: integer read FFontColor write FFontColor;
    property FontSelColor: integer read FFontSelColor write FFontSelColor;

    property UpImage: TPicture read FUpImage write SetUpImage;
    property DownImage: TPicture read FDownImage write SetDownImage;
    property ImageMouse: TPicture read FMouseImage write SetMouseImage;
    property ImageNotEnabled: TPicture read FEnabledImage write SetEnabledImage;

  end;

  TA2Edit = class(TEdit)
  private
    OldText: string;
    boTail: Boolean;
    FTransParent: Boolean;
    FOnEnter: procedure(Sender: TObject) of object;
    FOnExit: procedure(Sender: TObject) of object;
    FOnChange: procedure(Sender: TObject) of object;
    FOnKeyDown: procedure(Sender: TObject; var Key: Word; Shift: TShiftState) of object;

    Timer: TTimer;
    FADXForm: TA2Form;
    FFontColor: integer;
    FImageBack: TA2Image;
    procedure FocusEnter(Sender: TObject);
    procedure FocusExit(Sender: TObject);

    procedure TextChange(Sender: TObject);
    procedure SelfKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure TimerTimer(Sender: TObject);

  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
    procedure SetFontColor(value: integer);
  published
    property ADXForm: TA2Form read FADXForm write FADXForm;
    property TransParent: Boolean read FTransParent write FTransParent;
    property FontColor: integer read FFontColor write SetFontColor;

  end;
  TA2Memo = class(tmemo)
  private

    MCanvas: TControlCanvas;
    FBackScreen: TA2Image;
    aText: string;
    boTail: Boolean;
    FTransParent: Boolean;

    Timer: TTimer;
    FADXForm: TA2Form;
    boEntered: boolean;
    procedure TimerTimer(Sender: TObject);
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure Change; override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Keyup(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure WndProc(var Message: TMessage); override;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  protected

  public
    FWidthtext: integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint;
    procedure DrawItem;

    procedure DrawItem2;
    procedure DrawItem3;
  published
    property ADXForm: TA2Form read FADXForm write FADXForm;
    property Align;
    property Alignment;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Lines;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TDrawItemState = (TIS_None, TIS_Select, TIS_MouseSelect, TIS_Select_and_MouseSelect);
  TDrawScrollState = (TSS_None, TSS_TopMoving, TSS_BottomMoving, TSS_TrackMoving, TSS_TopClick, TSS_BottomClick, TSS_TrackClick);
  TOnAdxDrawItem = procedure(ASurface: TA2Image; index: integer; aStr: string; Rect: TRect; State: TDrawItemState; fx, fy: integer) of object;

  TOnAdxScrollDraw = procedure(ASurface: TA2Image; Rect: TRect; State: TDrawScrollState) of object;
  TonHint = procedure(Sender: TObject; aindex: integer) of object;
    {1,创建
     2，有变化 修改 }
  TA2ListBox = class(TPanel) //;(TWinControl)

  private

    FBackScreen: TA2Image;
    FADXForm: TA2Form;

    FStringList: TStringList; //文字

    FSurface: TA2Image; //背景
    FScrollTop: TA2Image; //UpImage
    FScrollTrack: TA2Image; //UpImage
    FScrollBottom: TA2Image; //UpImage
    FScrollDTop: TA2Image; // DownImage
    FScrollDTrack: TA2Image; // DownImage
    FScrollDBottom: TA2Image; // DownImage
    FScrollBackImg: TA2Image;

    FFontColor: integer;
    FFontSelColor: integer;
    FEmphasis: Boolean;

    FItemIndex: integer;

    FMouseSelectItemIndex: integer; //鼠标 光带 位置

    FViewIndex: integer;
    ViewItemCount: integer;
    FScrollTrackTopPos: integer;
    FScrollTrackingPos: integer;

    FItemHeight: Word;
    FItemMerginX: Word;
    FItemMerginY: Word;

    FScrollBarView: Boolean;
    ScrollBarWidth: Word;
    ScrollBarHeight: Word;
    ScrollBarTrackHeight: Word;
    CurXMouse, CurYMouse: integer;
    boScrollTop, boScrollTrack, boScrollBottom: Boolean;

    FOnAdxDrawItem: TOnAdxDrawItem;
    FOnAdxScrollDraw: TOnAdxScrollDraw;
    boEntered: boolean;
    FOnHint: TonHint;
    FboautoPro: boolean;
    FboListbox: boolean;
  protected

    procedure Loaded; override;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure DblClick; override;
    procedure WndProc(var Message: TMessage); override;

    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;

  private

    procedure IncItem(value: integer);
    procedure DecItem(value: integer);

    procedure IncItemIndex(value: integer);
    procedure DecItemIndex(value: integer);
    procedure upItemIndex();
  public
    FboAutoSelectIndex: boolean;
    FItemIndexViewState: boolean; //显示 开关
    FMouseViewState: boolean; //显示 光标 开关
    FLayout: TTextLayout;
    FFontSelBACKColor: word; //

        //  function AppKeyDownHook(var Msg:TMessage):Boolean;
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    destructor Destroy; override;
    procedure Clear;
        //   procedure WMPaint(var Message:TWMPaint); message WM_PAINT;
    procedure ADXDrawHint(aTA2Image: TA2Image; x, y: integer);
    procedure AdxPaint; dynamic;
    procedure Paint; override;

    procedure OnMouseWheel(atype: integer);
        //需要 更新 画布
        //----------------------------------------------------------------------
    procedure AddItem(aStr: string); //增加
    procedure DeleteItem(Value: integer); //删除
    procedure SetItem(Value: integer; aItem: string); //修改
    procedure SetItemIndex(Value: integer); //选择 改变
        //----------------------------------------------------------------------
    procedure DrawItem(); //刷新
    procedure DrawScrollBar();
        //________________________________________________________________________
    function GetItem(Value: integer): string;

    function Count: integer;

    procedure SetBackImage(value: TA2Image);
    procedure SetScrollTopImage(UpImage, DownImage: TA2Image);
    procedure SetScrollTrackImage(UpImage, DownImage: TA2Image);
    procedure SetScrollBottomImage(UpImage, DownImage: TA2Image);
    procedure SetScrollBackImage(value: TA2Image);
    procedure SETItemsColor(i: integer; fcol, bcol: word);
    procedure setText(value: string);
        // property Canvas:TCanvas read FCanvas;
    property ItemIndex: integer read FItemIndex write SetItemIndex;
    property Items[value: integer]: string read GetItem write SetItem;
    property StringList: tStringList read FStringList write FStringList;
    property boAutoPro: Boolean read FboautoPro write FboautoPro;

  published
    property boListbox: Boolean read FboListbox write FboListbox;
    property OnHint: TonHint read FOnHint write FOnHint;
    property ADXForm: TA2Form read FADXForm write FADXForm;
    property FontColor: integer read FFontColor write FFontColor;
    property FontSelColor: integer read FFontSelColor write FFontSelColor;
    property ItemHeight: Word read FItemHeight write FItemHeight;
    property ItemMerginX: Word read FItemMerginX write FItemMerginX;
    property ItemMerginY: Word read FItemMerginY write FItemMerginY;
    property FontEmphasis: Boolean read FEmphasis write FEmphasis;
    property ScrollBarView: Boolean read FScrollBarView write FScrollBarView;
    property Align;
        //        property Alignment;
    property Anchors;
    property AutoSize;
        //   property BevelInner;
   //        property BevelOuter;
   //        property BevelWidth;
    property BiDiMode;
        //        property BorderWidth;
                //        property BorderStyle;
    property Caption;
    property Color;
    property Constraints;
        //        property Ctl3D;
        //        property UseDockManager default True;
        //        property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;

    property Font;

    property ParentBiDiMode;

    property ParentColor;

    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;

    property Visible;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnStartDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnAdxDrawItem: TOnAdxDrawItem read FOnAdxDrawItem write FOnAdxDrawItem;
    property OnAdxScrollDraw: TOnAdxScrollDraw read FOnAdxScrollDraw write FOnAdxScrollDraw;

  end;

    {
      TOnAdxDrawItem = procedure (ASurface:TA2Image; index:integer; Rect:TRect; State: Integer) of object;

      TA2ListBox = class (TListBox)
      private
        Ans2ImageLib : TA2ImageLib;
        FAtzFileName : string;
        FADXForm : TA2Form;
        FTransParent : Boolean;
        FOnAdxDrawItem : TOnAdxDrawItem;
      protected
        procedure Loaded; override;
      public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure AdxPaint;
        procedure DrawScrollBar;
      published
        property ADXForm : TA2Form read FADXForm write FADXForm;
        property OnAdxDrawItem: TOnAdxDrawItem read FOnAdxDrawItem write FOnAdxDrawItem;
        property TransParent : Boolean read FTransParent write FTransParent;
        property AtzFileName : string read FAtzFileName write FAtzFileName;
      end;
    }
  TA2ComboBox = class(TComboBox)
  private
    FPictureA2: TA2Image;
    FPicture: TPicture;
    FADXForm: TA2Form;
    FOnChange: procedure(Sender: TObject) of object;

    procedure SetPicture(Value: TPicture);
    procedure setFADXForm(Value: TA2Form);
    procedure TextChange(Sender: TObject);
  protected
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
  published
    property ADXForm: TA2Form read FADXForm write setFADXForm;
    property Picture: TPicture read FPicture write SetPicture;

  end;

  TA2AnimateButton = class(TPanel)
  private
    Timer: TTimer;
    CurFrame: integer;
    boUpProcess: Boolean;
    FAtzImageCount: integer;
    FADXForm: TA2Form;
    Ans2ImageLib: TA2ImageLib;
    FAtzFileName: string;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Loaded; override;
    procedure paint; override;
    procedure TimerTimer(Sender: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
  published
    property ADXForm: TA2Form read FADXForm write FADXForm;
    property AtzFileName: string read FAtzFileName write FAtzFileName;
    property AtzImageCount: integer read FAtzImageCount write FAtzImageCount;
  end;

  TA2ProgressBar = class(TLabel)
  private
    FADXForm: TA2Form;
    FMinValue: integer;
    FMaxValue: integer;
    FValue: integer;
    FBackScreen: TPicture;
    FPicture: TPicture;
    FbackPicture: TPicture;
    procedure SetPicture(Value: TPicture);
    procedure SetPictureback(Value: TPicture);
  protected
    procedure Loaded; override;
    procedure paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; //override;
    procedure Draw;
    procedure SETFADXForm(Value: TA2Form);
    procedure setValue(Value: integer);
    procedure setMaxValue(Value: integer);
    procedure setMixValue(Value: integer);
  published
    property ADXForm: TA2Form read FADXForm write SETFADXForm;
    property Picture: TPicture read FPicture write SetPicture;
    property BackPicture: TPicture read FBACKPicture write SetPictureback;
    property MinValue: integer read FMinValue write setMixValue;
    property MaxValue: integer read FMaxValue write setMaxValue;
    property Value: integer read FValue write setValue;
  end;

  TA2AnimateImage = class(TPanel)
  private
    Timer: TTimer;
    CurFrame: integer;
    FAtzImageCount: integer;
    FADXForm: TA2Form;
    Ans2ImageLib: TA2ImageLib;
    FAtzFileName: string;
  protected
    procedure Loaded; override;
    procedure paint; override;
    procedure TimerTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
  published
    property ADXForm: TA2Form read FADXForm write FADXForm;
    property AtzFileName: string read FAtzFileName write FAtzFileName;
    property AtzImageCount: integer read FAtzImageCount write FAtzImageCount;
  end;
  TA2TreeView = class;
  TA2TreeNode = class
    FLevel: integer;
    FNode: TA2Label;
    FParent: TA2TreeNode;
    Flist: Tlist;
    FADXForm: TA2Form;
    FOwner: TComponent;
    Fopen: boolean;
    FCaption: string;

  private
    procedure Clear();
    procedure close;
    procedure Open;
    procedure SETOpen(v: boolean);

  public
    constructor Create(AOwner: TComponent; aADXForm: TA2Form);
    destructor Destroy; override;
    procedure AdxPaint();
    procedure setTopLeft(var atop, aleft: integer);
    function ADD(aname: string): TA2TreeNode;
    function DEL(aname: string): boolean;
    function get(aname: string): TA2TreeNode;
    procedure setADXForm(aADXForm: TA2Form);
    procedure onMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  published

  end;
  TA2TreeView = class(TPanel)
  private
    FADXForm: TA2Form;
    FColorFont: tcolor;
    FColorBack: tcolor;
    FColorSelectFont: tcolor;
    FColorSelectBack: tcolor;

    procedure Clear();
    function GetBufStart(Buffer: string; var Level: Integer): string;
  public
    FselectTreeNode: TA2TreeNode;
    FTreeNode: TA2TreeNode;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AdxPaint; dynamic;
    procedure ADD(aindex, aname: string);
    procedure DEL(aindex, aname: string);

    procedure setADXForm(aADXForm: TA2Form);
    procedure load(astringlist: tstringlist);
    procedure loadfile(afilename: string);
    function AddChild(Parent: TA2TreeNode; const S: string): TA2TreeNode;

  published

  end;

var
  editset: TEDITSET;
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('A2Ctrl', [TA2Form]);

  RegisterComponents('A2Ctrl', [TA2CheckBox]);
  RegisterComponents('A2Ctrl', [TA2Gauge]);
  RegisterComponents('A2Ctrl', [TA2Label]);
  RegisterComponents('A2Ctrl', [TA2ILabel]);
  RegisterComponents('A2Ctrl', [TA2Panel]);
  RegisterComponents('A2Ctrl', [TA2Button]);
  RegisterComponents('A2Ctrl', [TA2Edit]);
  RegisterComponents('A2Ctrl', [TA2ListBox]);
  RegisterComponents('A2Ctrl', [TA2ComboBox]);
  RegisterComponents('A2Ctrl', [TA2Memo]);
  RegisterComponents('A2Ctrl', [TA2AnimateButton]);
  RegisterComponents('A2Ctrl', [TA2AnimateImage]);
  RegisterComponents('A2Ctrl', [TA2ProgressBar]);
end;

//////////////////////////////////////////
//            TA2Form
//////////////////////////////////////////

procedure TA2Form.setImageSurface(aimg: TA2Image);
begin
  fImageSurface.DrawImage(aimg, 0, 0, false);
end;

constructor TA2Form.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParent := TForm(AOwner);
  FColor := 0;
  FImageOveray := 20;
  CurFrame := 4;
  boImagesurface := false;
    //    FComponentList := TList.Create;
  FSurface := TA2Image.Create(32, 32, 0, 0);
  FImageSurface := TA2Image.Create(32, 32, 0, 0);
//    FA2Hint := TA2Hint.Create;
end;

destructor TA2Form.Destroy;
begin
//    FA2Hint.Free;
  FSurface.Free;
  FImageSurface.Free;
    //    FComponentList.Free;
  inherited Destroy;
end;

procedure TA2Form.add(aOb: pointer);
begin
  del(aOb);
    //    FComponentList.Add(aOb)
end;

procedure TA2Form.del(aOb: pointer);
begin
    //    FComponentList.Remove(aOb);
end;

procedure TA2Form.Loaded;
var
  i: integer;
  compo: TComponent;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then exit;
  FSurface.Setsize(TForm(Owner).Width, TForm(Owner).Height);
  if FImageFileName <> '' then
  begin
    FImageSurface.LoadFromFile(FImageFileName);
    boImagesurface := true;
  end;

    {    FComponentList.Clear;
        for i := 0 to Owner.ComponentCount - 1 do
        begin
            Compo := Owner.Components[i];
            if Compo is TA2Label then FComponentList.Add(Compo)

            else if Compo is TA2ILabel then FComponentList.Add(Compo)
            else if Compo is TA2Button then FComponentList.Add(Compo)

            else if Compo is TA2Listbox then FComponentList.Add(Compo)
            else if Compo is TA2ComboBox then FComponentList.Add(Compo)

                // if Compo is TA2animateImage then ComponentList.Add(Compo);
                // if Compo is TA2animateButton then ComponentList.Add(Compo);
            else if Compo is TA2Memo then FComponentList.Add(Compo)
            else if Compo is TA2Edit then FComponentList.Add(Compo)
            else if Compo is TA2ProgressBar then FComponentList.Add(Compo)
            else if Compo is TA2CheckBox then FComponentList.Add(Compo);

            // if Compo is TA2Panel then ComponentList.Add(Compo);

        end;
     }
end;

procedure TA2Form.DrawDispath;
var
  i: integer;
  Compo: TComponent;
begin

    // for i := 0 to FComponentList.Count - 1 do
  for i := 0 to Owner.ComponentCount - 1 do
  begin
        //        compo := FComponentList[i];
    Compo := Owner.Components[i];
    if Compo is TA2Label then TA2Label(Compo).adxPaint
    else if Compo is TA2ILabel then TA2ILabel(Compo).adxPaint
            //        if Compo is TA2Panel then TA2Panel(Compo).adxPaint;
    else if Compo is TA2Button then TA2Button(Compo).adxPaint
    else if Compo is TA2ListBox then
    begin
      TA2ListBox(Compo).adxPaint;
    end
    else if Compo is TA2ComboBox then TA2ComboBox(Compo).adxPaint

    else if Compo is TA2ProgressBar then TA2ProgressBar(Compo).adxpaint
            // if Compo is TA2Panel then TA2Panel(Compo).adxPaint;
             //      if Compo is TA2animateImage then TA2animateImage(Compo).adxPaint;
    else if Compo is TA2CheckBox then TA2CheckBox(Compo).adxPaint
    else if Compo is TA2Memo then TA2Memo(Compo).adxPaint
    else if Compo is TA2Edit then TA2Edit(Compo).adxPaint
    else if Compo is TA2Gauge then TA2Gauge(Compo).AdxPaint;
  end;

  if assigned(FOnAdxPaint) then FOnAdxPaint(FSurface);
end;

procedure TA2Form.DrawDispathHint(aSurface: TA2Image; x, y: integer);
begin
//    if FA2Hint.FVisible then        FA2Hint.DrawBack(aSurface, X, Y);
  if assigned(FOnAdxPaint) then FOnAdxPaint(FSurface);
end;

procedure TA2Form.Draw();
begin
  DrawState := true;
end;

procedure TA2Form.AdxPaint(aSurface: TA2Image);
begin
  if not Assigned(FParent) then EXIT;
  if not FParent.Visible then EXIT;

  if DrawState then
  begin
    if boImagesurface then
    begin
      if (FSurface.Width <> FImageSurface.Width)
        or (FSurface.Height <> FImageSurface.Height) then
        FSurface.Setsize(FImageSurface.Width, FImageSurface.Height);
      FSurface.Clear(FColor);
      FSurface.DrawImage(FImageSurface, 0, 0, FALSE);
    end
    else
    begin
      if (FSurface.Width <> FParent.Width) or (FSurface.Height <> FParent.Height) then
        FSurface.Setsize(FParent.Width, FParent.Height);
      FSurface.Clear(FColor);
    end;

    DrawDispath;
  end;
  DrawState := false;
  case FShowMethod of
    FSM_NONE: aSurface.DrawImage(FSurface, TForm(Owner).Left, TForm(Owner).Top, FTransparent);
    FSM_DITHER: aSurface.DrawImageDither(FSurface, TForm(Owner).Left, TForm(Owner).Top, CurFrame, FTransparent);
    FSM_DARKEN: aSurface.DrawImageKeyColor(FSurface, TForm(Owner).Left, TForm(Owner).Top, 31, @DECRGBdarkentbl);
    FSM_ImageOveray: aSurface.DrawImageOveray(FSurface, TForm(Owner).Left, TForm(Owner).Top, FImageOveray);
  end;
    //画 提示


   // DrawDispathHint(aSurface, TForm(Owner).Left, TForm(Owner).Top);

end;

//////////////////////////////////////////
//            TA2Label
//////////////////////////////////////////

constructor TA2Label.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  NotTransParent := false;
  FPicture := TPicture.Create;
  FFontColor := WinRGB(31, 31, 31);
  Font := A2FontClass.GetFont;

end;

destructor TA2Label.Destroy;
begin

    //    if Assigned(FADXForm) then FADXForm.FComponentList.Remove(self);
  FPicture.Free;
  inherited destroy;
end;

procedure TA2Label.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TA2Label.MouseMove(Shift: TShiftState; X, Y: Integer);

var
  R: TRect;
begin
  inherited MouseMove(Shift, x, y);

   { if Assigned(FADXForm) then
    begin
        R := Self.ClientRect;
        OffsetRect(R, left, top);
        if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
        with FADXForm do
        begin
            FA2Hint.Fleft := r.Left + x;
            FA2Hint.Ftop := r.Top + y;
            FA2Hint.FVisible := true;
        end;
    end;}
end;

procedure TA2Label.setFADXForm(Value: TA2Form);
begin
  if assigned(ADXForm) then ADXForm.Draw;
  FADXForm := Value;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Label.SetBackColor(Value: Word);
begin
  FBColor := Value;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Label.SetFontColor(Value: Word);
begin
  FFontColor := Value;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Label.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  boEntered := TRUE;
{    if Assigned(FADXForm) then
    begin
        FADXForm.FA2Hint.FVisible := FALSE;
        FADXForm.FA2Hint.setText('');
    end;}
end;

procedure TA2Label.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  boEntered := FALSE;
{    if Assigned(FADXForm) then
    begin
        FADXForm.FA2Hint.FVisible := FALSE;
        FADXForm.FA2Hint.setText('');
    end;}
end;

procedure TA2Label.SetCaption(Value: string);
begin
  inherited Caption := Value;
  boEntered := FALSE;
  if assigned(ADXForm) then ADXForm.Draw;
end;

function TA2Label.GetCaption: string;
begin
  Result := inherited Caption;
end;

procedure TA2Label.AdxPaint;
var
  R, r2: TRect;
  xx, yy, fx, fy: integer;
  DrawStyle: Longint;
  tempimg: TA2Image;
begin
  if (csDesigning in ComponentState) or not Assigned(FADXForm) then exit;
  if not Visible then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;

  if Assigned(FPicture.Graphic) then
  begin
    R := Self.ClientRect;
    OffsetRect(R, left, top);



  end;

  if Text <> '' then
  begin
    tempimg := TA2Image.Create(Width, Height, 0, 0);
    try
      tempimg.Resize(Width, Height);
      tempimg.Clear(FBColor);
      fx := 0;
      fy := 0;
      if Alignment = taCenter then
      begin
        fx := (Width - ATextWidth(text)) div 2;
      end
      else if Alignment = taRightJustify then
      begin
        fx := (Width - ATextWidth(text));
      end;
      if fx < 0 then fx := 0;
      ATextOut(tempimg, fx, fy, FFontColor, Text);

      R := Self.ClientRect;
      OffsetRect(R, left, top);
      if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
      FADXForm.FSurface.DrawImage(tempimg, R.Left, R.Top, not NotTransParent);
    finally
      tempimg.Free;
    end;
        //ATextOut(FADXForm.FSurface, R.Left + fx, R.Top + fy, ColorSysToDxColor(Font.Color), Text);
  end;

end;

procedure TA2Label.paint;
begin
  if Assigned(FPicture.Graphic) then
  begin
    Canvas.Draw(0, 0, FPicture.Graphic);
  end else inherited paint;
end;

procedure TA2Label.Loaded;
begin
  inherited Loaded;

end;

//////////////////////////////////////////
//            TA2Panel
//////////////////////////////////////////

constructor TA2Panel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
end;

destructor TA2Panel.Destroy;
begin
  FPicture.Free;
  inherited destroy;
end;

procedure TA2Panel.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TA2Panel.AdxPaint;
var
  R: TRect;
    //  Can             :TCanvas;
  BaseImage: TA2Image;
  temp: TA2Image;
begin
  if (csDesigning in ComponentState) or not Assigned(FADXForm) then exit;
  if not Visible then exit;

    //  Can := A2GetCanvas;
     // Can.FillRect(Self.ClientRect);

  if Assigned(FPicture.Graphic) then

  begin

    R := Self.ClientRect;
    OffsetRect(R, left, top);
        //  A2DrawCanvas(FADXForm.FSurface, R.Left, R.Top, Width, Height, TRUE);
    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FPicture.Bitmap);
      FADXForm.FSurface.DrawImage(temp, R.Left, R.Top, TRUE);
    finally
      temp.Free;
    end;

  end else
  begin
    BaseImage := TA2Image.Create(Width, Height, 0, 0);

    try
      BaseImage.Clear(ColorSysToDxColor(Color));
      BaseImage.Resize(Width, Height);
      R := Self.ClientRect;
      OffsetRect(R, left, top);
      if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);

      FADXForm.FSurface.DrawImage(BaseImage, R.Left, R.Top, TRUE);
    finally
      BaseImage.Free;
    end;
  end;

  if Text <> '' then
  begin
    R := ClientRect;
    OffsetRect(R, left, top);
    ATextOut(FADXForm.FSurface, R.Left, R.Top, WinRGB(31, 31, 31), Text);
  end;
end;

procedure TA2Panel.paint;
begin
  if Assigned(FPicture.Graphic) then
  begin
    Canvas.Draw(0, 0, FPicture.Graphic);
  end else
    inherited paint;

end;

//////////////////////////////////////////
//            TA2ILabel
//////////////////////////////////////////

constructor TA2ILabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

    //    FPicturea2 := TA2Image.Create(32, 32, 0, 0);
     //   FPicturea2.TransparentColor := 0;
  FPicture := TPicture.Create;
//  Width := WidthBytes(Width);
  FImageBack := TA2Image.Create(Width, Height, 0, 0);
  FImageBack.TransparentColor := 0;
  FA2Image := nil;
  FA2ImageBACK := nil;
  FA2ImageLUP := nil;
  FA2ImageRDown := nil;
  fBColor := 0;
  GreenCol := 0;
  GreenAdd := 0;
  FImgIndex := 0;
  FImgIndexStart := -1;
  FImgIndexMax := -1;
  FDelayTick := 0;
end;

destructor TA2ILabel.Destroy;
begin
    //    FPicturea2.Free;
  FImageBack.Free;
    //    if not (csdesigning in componentstate) then
      //      if Assigned(FADXForm) then
        //        FADXForm.FComponentList.Remove(self);
  FPicture.Free;

  if FA2Image <> nil then FA2Image.Free;
  if FA2ImageBACK <> nil then FA2ImageBACK.Free;
  if FA2ImageLUP <> nil then FA2ImageLUP.Free;
  if FA2ImageRDown <> nil then FA2ImageRDown.Free;
  inherited destroy;
end;

procedure TA2ILabel.SetPicture(Value: TPicture);
var
  temp: TA2Image;
begin
  FPicture.Assign(Value);
  if Assigned(FPicture.Graphic) then
  begin
    temp := TA2Image.Create(FPicture.Width, FPicture.Height, 0, 0);
    try
      temp.LoadFromBitmap(FPicture.Bitmap);
      A2Image := temp;

    finally
      temp.Free;
    end;
  end else
  begin
    A2Image := nil;
  end;

end;

procedure TA2ILabel.CMMouseEnter(var Message: TMessage);
begin
  boEntered := TRUE;
{    if Assigned(FADXForm) then
    begin
        FADXForm.FA2Hint.FVisible := FALSE;
        FADXForm.FA2Hint.setText('');
    end;}
  inherited;

end;

procedure TA2ILabel.CMMouseLeave(var Message: TMessage);
begin
  boEntered := FALSE;
{    if Assigned(FADXForm) then
    begin
        FADXForm.FA2Hint.FVisible := FALSE;
        FADXForm.FA2Hint.setText('');
    end;}
  inherited;

end;

procedure TA2ILabel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
//    if Assigned(FADXForm) then        FADXForm.FA2Hint.FVisible := FALSE;

end;

procedure TA2ILabel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
//    if Assigned(FADXForm) then        FADXForm.FA2Hint.FVisible := FALSE;

end;

procedure TA2ILabel.MouseMove(Shift: TShiftState; X, Y: Integer);

var
  R: TRect;
begin
  inherited MouseMove(Shift, x, y);

  if Assigned(FADXForm) then
  begin
    R := Self.ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
{        with FADXForm do
        begin
            FA2Hint.Fleft := r.Left + x;
            FA2Hint.Ftop := r.Top + y;
            FA2Hint.FVisible := true;
        end;}
  end;
end;

procedure TA2ILabel.SetCaption(Value: string);
begin
  inherited Caption := Value;
  boEntered := FALSE;
  _Draw;
end;

function TA2ILabel.GetCaption: string;
begin
  Result := inherited Caption;
end;
{
procedure TA2ILabel.update(atick:integer);

begin

    if Visible = FALSE then EXIT;
    if not Assigned(FA2ImageLib) then EXIT;
    if FA2ImageLib.Count <= 0 then EXIT;
    if (aTick - FDelayTick) > 100 then
    begin
        FDelayTick := aTick;
        inc(FImgIndex);
        if FImgIndexmax = -1 then
        begin
            if (FImgIndex >= FA2ImageLib.Count) then
                if FImgIndexStart = -1 then
                    FImgIndex := 0
                else FImgIndex := FImgIndexStart;
        end else
        begin
            if FImgIndexmax >= FA2ImageLib.Count then FImgIndexmax := FA2ImageLib.Count - 1;
            if (FImgIndex > FImgIndexmax) then
                if FImgIndexStart = -1 then
                    FImgIndex := 0
                else FImgIndex := FImgIndexStart;
        end;
        A2Image := FA2ImageLib.Images[FImgIndex];
        if Assigned(FA2Image) then
            FA2Image.TransparentColor := FTransparentColor;
        //#080808
    end;

end;
}

procedure TA2ILabel.A2SendToBack();
var
  I: INTEGER;
begin
  SendToBack;
    {    if Assigned(FADXForm) then

            if not (csdesigning in componentstate) then
            begin
                I := FADXForm.FComponentList.IndexOf(self);
                if I = -1 then
                    FADXForm.FComponentList.Add(SELF)
                else
                begin
                    FADXForm.FComponentList.Delete(I);
                    FADXForm.FComponentList.Add(SELF);
                end;
            end;
            }
end;

procedure TA2ILabel.SETFADXForm(Value: TA2Form);
begin
  FADXForm := Value;
end;

procedure TA2ILabel.AdxPaint;
var
  R, r2: TRect;
  xx, yy: integer;
    // Can             :TCanvas;
  s, str: string;
  x, y, fx, fy, x2, y2: integer;

begin
  if (csDesigning in ComponentState) or not Assigned(FADXForm) then exit;
  if not Visible then exit;

  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;

  if (FImageBack.Width <> Width) or (FImageBack.Height <> Height) then _Draw;
    {
     //    update(timeGetTime);
     if Assigned(FPicture.Graphic) then
     begin

         R := Self.ClientRect;
         OffsetRect(R, left, top);
         fx := 0;
         if Alignment = taCenter then
         begin
             fx := (Width - FPicture.Graphic.Width) div 2;
         end
         else if Alignment = taRightJustify then
         begin
             fx := (Width - FPicture.Graphic.Width);
         end;
         if Assigned(Parent) then
             if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
         //  A2DrawCanvas(FADXForm.FSurface, R.Left + fx, R.Top, Width, Height, Transparent);

         FADXForm.FSurface.DrawImage(FPicturea2, R.Left + fx, R.Top, true);

     end;
     if (FImageBack.Width <> Width) or (FImageBack.Height <> Height) then
         FImageBack.Resize(Width, Height);
     FImageBack.Clear(FBColor);
     if assigned(FA2image) or assigned(FA2ImageRDown) or assigned(FA2ImageLUP) then
     begin
         // FBaseImage.Clear(FBColor);

         if assigned(FA2ImageBACK) then
         begin
             x := (Width - FA2ImageBACK.Width) div 2;
             y := (Height - FA2ImageBACK.Height) div 2;
             if FGreenCol = 0 then
                 FImageBack.DrawImage(FA2ImageBACK, x, y, TRUE)
             else FImageBack.DrawImageGreenConvert(FA2ImageBACK, x, y, FGreenCol, FGreenAdd);

         end;
         if assigned(FA2image) then
         begin
             x := (Width - FA2image.Width) div 2;
             y := (Height - FA2image.Height) div 2;
             if FGreenCol = 0 then
                 FImageBack.DrawImage(FA2image, x, y, TRUE)
             else FImageBack.DrawImageGreenConvert(FA2image, x, y, FGreenCol, FGreenAdd);

         end;
         if assigned(FA2ImageRDown) then
         begin
             x2 := (Width - FA2ImageRDown.Width);
             y2 := (Height - FA2ImageRDown.Height);
             if FGreenCol = 0 then FImageBack.DrawImage(FA2ImageRDown, x2, y2, TRUE)
             else FImageBack.DrawImageGreenConvert(FA2ImageRDown, x2, y2, FGreenCol, FGreenAdd);
         end;
         if assigned(FA2ImageLUP) then
         begin
             x2 := 0;
             y2 := 0;
             if FGreenCol = 0 then FImageBack.DrawImage(FA2ImageLUP, x2, y2, TRUE)
             else FImageBack.DrawImageGreenConvert(FA2ImageLUP, x2, y2, FGreenCol, FGreenAdd);
         end;

     end;
     if Text <> '' then
     begin
         R := ClientRect;
         OffsetRect(R, left, top);

         if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
         fx := 0;
         fy := 0;
         if ATextWidth(text) > Width then
         begin
             str := Text;
             while str <> '' do
             begin
                 S := CutLengthString(str, Width);
                 if (fy + ATextHeight('错')) > Height then Break;
                 ATextOut(FImageBack, fx, fy, ColorSysToDxColor(Font.Color), S);
                 fy := fy + ATextHeight('错') + 5;
             end;
         end else
         begin
             if Alignment = taCenter then
             begin
                 fx := (Width - ATextWidth(text)) div 2;
             end
             else if Alignment = taRightJustify then
             begin
                 fx := (Width - ATextWidth(text));
             end;
             if fx < 0 then fx := 0;
             ATextOut(FImageBack, fx, 0, ColorSysToDxColor(Font.Color), Text);

         end;

     end;
    }
  R := Self.ClientRect;
  OffsetRect(R, left, top);
  if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
  FADXForm.FSurface.DrawImage(FImageBack, R.Left, R.Top, Transparent);
  if assigned(FOnPaint) then FOnPaint(self);
end;

procedure TA2ILabel._Draw();
var
  R, r2: TRect;
  xx, yy: integer;
  s, str: string;
  x, y, fx, fy, x2, y2: integer;
begin

  if (FImageBack.Width <> Width) or (FImageBack.Height <> Height) then
    FImageBack.Resize(Width, Height);
  FImageBack.Clear(FBColor);
  if assigned(FA2image) or assigned(FA2ImageRDown) or assigned(FA2ImageLUP) then
  begin
    if assigned(FA2ImageBACK) then
    begin
      x := (Width - FA2ImageBACK.Width) div 2;
      y := (Height - FA2ImageBACK.Height) div 2;
      if FGreenCol = 0 then
        FImageBack.DrawImage(FA2ImageBACK, x, y, Transparent)
      else FImageBack.DrawImageGreenConvert(FA2ImageBACK, x, y, FGreenCol, FGreenAdd);

    end;
    if assigned(FA2image) then
    begin
      x := (Width - FA2image.Width) div 2;
      y := (Height - FA2image.Height) div 2;
      if FGreenCol = 0 then
        FImageBack.DrawImage(FA2image, x, y, Transparent)
      else FImageBack.DrawImageGreenConvert(FA2image, x, y, FGreenCol, FGreenAdd);

    end;
    if assigned(FA2ImageRDown) then
    begin
      x2 := (Width - FA2ImageRDown.Width);
      y2 := (Height - FA2ImageRDown.Height);
      if FGreenCol = 0 then FImageBack.DrawImage(FA2ImageRDown, x2, y2, Transparent)
      else FImageBack.DrawImageGreenConvert(FA2ImageRDown, x2, y2, FGreenCol, FGreenAdd);
    end;
    if assigned(FA2ImageLUP) then
    begin
      x2 := 0;
      y2 := 0;
      if FGreenCol = 0 then FImageBack.DrawImage(FA2ImageLUP, x2, y2, Transparent)
      else FImageBack.DrawImageGreenConvert(FA2ImageLUP, x2, y2, FGreenCol, FGreenAdd);
    end;

  end;
  if Text <> '' then
  begin
    R := ClientRect;
    OffsetRect(R, left, top);

    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
    fx := 0;
    fy := 0;
    if ATextWidth(text) > Width then
    begin
      str := Text;
      while str <> '' do
      begin
        S := CutLengthString(str, Width);
        if (fy + ATextHeight('错')) > Height then Break;
        ATextOut(FImageBack, fx, fy, ColorSysToDxColor(Font.Color), S);
        fy := fy + ATextHeight('错') + 5;
      end;
    end else
    begin
      if Alignment = taCenter then
      begin
        fx := (Width - ATextWidth(text)) div 2;
      end
      else if Alignment = taRightJustify then
      begin
        fx := (Width - ATextWidth(text));
      end;
      if fx < 0 then fx := 0;
      ATextOut(FImageBack, fx, 0, ColorSysToDxColor(Font.Color), Text);

    end;

  end;
  if assigned(ADXForm) then ADXForm.Draw else Paint;
end;
{var
    x, y            :integer;
    x2, y2          :integer;
begin
    if Visible = false then exit;
    if assigned(FA2image) or assigned(FA2ImageRDown) or assigned(FA2ImageLUP) then
    begin
        FBaseImage.Clear(FBColor);
        if assigned(FA2ImageBACK) then
        begin
            x := (Width - FA2ImageBACK.Width) div 2;
            y := (Height - FA2ImageBACK.Height) div 2;

            if FGreenCol = 0 then
                FBaseImage.DrawImage(FA2ImageBACK, x, y, TRUE)
            else FBaseImage.DrawImageGreenConvert(FA2ImageBACK, x, y, FGreenCol, FGreenAdd);
        end;
        if assigned(FA2image) then
        begin
            x := (Width - FA2image.Width) div 2;
            y := (Height - FA2image.Height) div 2;

            if FGreenCol = 0 then
                FBaseImage.DrawImage(FA2image, x, y, TRUE)
            else FBaseImage.DrawImageGreenConvert(FA2image, x, y, FGreenCol, FGreenAdd);
        end;
        if assigned(FA2ImageRDown) then
        begin
            x2 := (Width - FA2ImageRDown.Width);
            y2 := (Height - FA2ImageRDown.Height);
            if FGreenCol = 0 then FBaseImage.DrawImage(FA2ImageRDown, x2, y2, TRUE)
            else FBaseImage.DrawImageGreenConvert(FA2ImageRDown, x2, y2, FGreenCol, FGreenAdd);
        end;
        if assigned(FA2ImageLUP) then
        begin
            x2 := 0;
            y2 := 0;
            if FGreenCol = 0 then FBaseImage.DrawImage(FA2ImageLUP, x2, y2, TRUE)
            else FBaseImage.DrawImageGreenConvert(FA2ImageLUP, x2, y2, FGreenCol, FGreenAdd);
        end;

A2DrawImage(Canvas, 0, 0, FBaseImage);

end;
end;
}

procedure TA2ILabel.paint;
begin
  {if Assigned(FPicture.Graphic) then
  begin
    Canvas.Draw(0, 0, FPicture.Graphic);
  end else inherited paint;
  }
  if not Visible then exit;
  inherited Paint;
    
  A2DrawImage(Canvas, 0, 0, FImageBack);
  if assigned(FOnPaint) then FOnPaint(self);

end;

procedure TA2ILabel.Loaded;
begin
  inherited Loaded;
  Width := WidthBytes(Width);
  if Assigned(FPicture.Graphic) then
  begin
    Picture := FPicture;
  end;
    //        FPictureA2.LoadFromBitmap(FPicture.Bitmap);
end;

procedure TA2ILabel.SetImage(Value: TA2Image);
begin
  if FA2Image <> nil then
  begin
    FA2Image.free;
    FA2Image := nil;
  end;
  if Value <> nil then
  begin
    FA2Image := TA2Image.Create(32, 32, 0, 0);
    Value.CopyImage(FA2Image);
  end;
  _Draw;
end;

procedure TA2ILabel.SetImageRDown(Value: TA2Image);
begin
  if FA2ImageRDown <> nil then
  begin
    FA2ImageRDown.free;
    FA2ImageRDown := nil;
  end;
  if Value <> nil then
  begin
    FA2ImageRDown := TA2Image.Create(32, 32, 0, 0);
    Value.CopyImage(FA2ImageRDown);
  end;
  _Draw;
end;

procedure TA2ILabel.SetImageLUP(Value: TA2Image);
begin
  if FA2ImageLUP <> nil then
  begin
    FA2ImageLUP.free;
    FA2ImageLUP := nil;
  end;
  if Value <> nil then
  begin
    FA2ImageLUP := TA2Image.Create(32, 32, 0, 0);
    Value.CopyImage(FA2ImageLUP);
  end;
  _Draw;
end;

procedure TA2ILabel.SetImageBack(Value: TA2Image);
begin
  if FA2Imageback <> nil then
  begin
    FA2Imageback.free;
    FA2Imageback := nil;
  end;
  if Value <> nil then
  begin
    FA2Imageback := TA2Image.Create(32, 32, 0, 0);
    Value.CopyImage(FA2Imageback);
  end;
  _Draw;
end;

procedure TA2ILabel.Setcolor(Value: word);
begin
  FBColor := Value;
  _Draw;
end;

//////////////////////////////////////////
//            TA2Button
//////////////////////////////////////////

constructor TA2Button.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLockDown := false;

  AutoSize := FALSE;
  FDown := FALSE;
  FOldDown := FALSE;
  FCaptured := FALSE;
  FUpImage := TPicture.Create;
  FDownImage := TPicture.Create;
  FEnabledImage := TPicture.Create; //灰掉 静止使用
  FMouseImage := TPicture.Create; //光标

  FUpA2Image := nil;
  FDownA2Image := nil; //按下
  FEnabledA2Image := nil; //灰掉 静止使用
  FMouseA2Image := nil; //光标
end;

destructor TA2Button.Destroy;
begin
  if Assigned(FADXForm) then FADXForm.del(self);

  FDownImage.Free;
  FUpImage.Free;
  FEnabledImage.free;
  FMouseImage.free;

  if FUpA2Image <> nil then FUpA2Image.Free;
  if FDownA2Image <> nil then FDownA2Image.Free;
  if FEnabledA2Image <> nil then FEnabledA2Image.Free;
  if FMouseA2Image <> nil then FMouseA2Image.free;
  inherited destroy;
end;

procedure TA2Button.SetADXForm(Value: TA2Form);
begin
  if assigned(ADXForm) then ADXForm.Draw;
  FADXForm := Value;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.SetUpImage(Value: TPicture);
var
  temp: TA2Image;
begin
  FUpImage.Assign(Value);
  if Assigned(Value) and (not (csDesigning in ComponentState)) then
  begin
    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FUpImage.Bitmap);
      SetUpA2Image(temp);
    finally
      temp.Free;
    end;
  end;
  AutoSize := FALSE;
end;

procedure TA2Button.SetDownImage(Value: TPicture);
var
  temp: TA2Image;
begin
  FDownImage.Assign(Value);
  if Assigned(Value) and (not (csDesigning in ComponentState)) then
  begin

    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FDownImage.Bitmap);
      SetDownA2Image(temp);
    finally
      temp.Free;
    end;
  end;
  AutoSize := FALSE;
end;

procedure TA2Button.SetMouseImage(Value: TPicture);
var
  temp: TA2Image;
begin
  FMouseImage.Assign(Value);
  if Assigned(Value) and (not (csDesigning in ComponentState)) then
  begin
    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FMouseImage.Bitmap);
      SetMouseA2Image(temp);
    finally
      temp.Free;
    end;
  end;
  AutoSize := FALSE;
end;

procedure TA2Button.SetEnabledImage(Value: TPicture);
var
  temp: TA2Image;
begin
  FEnabledImage.Assign(Value);
  if Assigned(Value) and (not (csDesigning in ComponentState)) then
  begin
    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FEnabledImage.Bitmap);
      SetEnabledA2Image(temp);
    finally
      temp.Free;
    end;
  end;
  AutoSize := FALSE;
end;

procedure TA2Button.SetEnabledA2Image(Value: TA2Image);
begin
  if FEnabledA2Image <> nil then
  begin
    FEnabledA2Image.Free;
    FEnabledA2Image := nil;
  end;
  if Value = nil then
  begin

    exit;
  end;

  FEnabledA2Image := TA2Image.Create(Value.Width, Value.Height, 0, 0);
  FEnabledA2Image.Resize(Value.Width, Value.Height);
  FEnabledA2Image.DrawImage(Value, 0, 0, false);
  AutoSize := FALSE;
  Width := FEnabledA2Image.Width;
  Height := FEnabledA2Image.Height;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.SetMouseA2Image(Value: TA2Image);
begin
  if FMouseA2Image <> nil then
  begin
    FMouseA2Image.Free;
    FMouseA2Image := nil;
  end;
  if Value = nil then
  begin

    exit;
  end;
  FMouseA2Image := TA2Image.Create(Value.Width, Value.Height, 0, 0);
  FMouseA2Image.Resize(Value.Width, Value.Height);
  FMouseA2Image.DrawImage(Value, 0, 0, false);
  AutoSize := FALSE;
  Width := FMouseA2Image.Width;
  Height := FMouseA2Image.Height;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.SetUpA2Image(Value: TA2Image);
begin
  if FUpA2Image <> nil then
  begin
    FUpA2Image.Free;
    FUpA2Image := nil;
  end;
  if Value = nil then
  begin

    exit;
  end;
  FUpA2Image := TA2Image.Create(Value.Width, Value.Height, 0, 0);
  FUpA2Image.Resize(Value.Width, Value.Height);
  FUpA2Image.DrawImage(Value, 0, 0, false);
  AutoSize := FALSE;
  Width := FUpA2Image.Width;
  Height := FUpA2Image.Height;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.SetDownA2Image(Value: TA2Image);
begin
  if FDownA2Image <> nil then
  begin
    FDownA2Image.Free;
    FDownA2Image := nil;
  end;
  if Value = nil then
  begin
    exit;
  end;

  FDownA2Image := TA2Image.Create(Value.Width, Value.Height, 0, 0);
  FDownA2Image.Resize(Value.Width, Value.Height);
  FDownA2Image.DrawImage(Value, 0, 0, false);
  AutoSize := FALSE;
  Width := FDownA2Image.Width;
  Height := FDownA2Image.Height;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.Lockdown(value: boolean);
begin
  FLockDown := value;
  FDown := value;
  FCaptured := FALSE;
  if FOldDown <> FDOWN then
  begin
    FOldDown := FDown;
    paint;
  end;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.SetCaption(Value: string);
begin
  inherited Caption := Value;
  boEntered := FALSE;
  AdxPaint;
end;

function TA2Button.GetCaption: string;
begin
  Result := inherited Caption;
end;

procedure TA2Button.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  boEntered := TRUE;
  paint;
{    if Assigned(FADXForm) then
    begin
        FADXForm.FA2Hint.FVisible := FALSE;
        FADXForm.FA2Hint.setText('');
    end;}
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  boEntered := FALSE;
  paint;
{    if Assigned(FADXForm) then
    begin
        FADXForm.FA2Hint.FVisible := FALSE;
        FADXForm.FA2Hint.setText('');
    end;}
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  if FLockDown = true then exit;
  FCaptured := TRUE;
  FDown := TRUE;

  if FOldDown <> FDOWN then
  begin
    FOldDown := FDown;
    paint;
  end;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
begin
  inherited;
  if Assigned(FADXForm) then
  begin
    R := Self.ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
{        with FADXForm do
        begin
            FA2Hint.Fleft := r.Left + x;
            FA2Hint.Ftop := r.Top + y;
            FA2Hint.FVisible := true;
        end;}
  end;
end;

procedure TA2Button.WMMouseMove(var Message: TWMMouseMove);
begin
  inherited;
  if FCaptured then
  begin
    if (Message.XPos < 0) or (Message.XPos > Width) or
      (Message.YPos < 0) or (Message.YPos > Height) then FDown := FALSE
    else FDown := TRUE;
  end;
  if FOldDown <> FDOWN then
  begin
    FOldDown := FDown;
    paint;
  end;
end;

procedure TA2Button.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  if FLockDown = true then exit;
  FDown := FALSE;
  FCaptured := FALSE;
  if FOldDown <> FDOWN then
  begin
    FOldDown := FDown;
    paint;
  end;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Button.AdxPaint;
var
  R: TRect;
  Can: TCanvas;
  function _AdxPaint(atemp: tA2Image): boolean;
  begin
    result := false;
    if atemp = nil then exit;
    FADXForm.FSurface.DrawImage(atemp, R.Left, R.Top, TransParent);
    result := true;
  end;

begin
  if (csDesigning in ComponentState) or not Assigned(FADXForm) then exit;
  if not Visible then exit;
  if Assigned(Parent) then
    if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;
  R := Self.ClientRect;
  OffsetRect(R, left, top);
  if Assigned(Parent) then
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
  if Enabled = false then
  begin
    if _AdxPaint(FEnabledA2Image) = false then
      _AdxPaint(FUpA2Image);
  end
  else if (FDown) then
  begin
    if _AdxPaint(FDownA2Image) = false then
      _AdxPaint(FUpA2Image);
  end else
  begin
    if boEntered then
    begin
      if _AdxPaint(FMouseA2Image) = false then
        _AdxPaint(FUpA2Image);
    end
    else
    begin
      _AdxPaint(FUpA2Image);
    end;
  end;

  if Text <> '' then
  begin
    R := ClientRect;
    OffsetRect(R, left, top);
    if Assigned(Parent) then
      if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
    if boEntered and (FFontSelColor <> 0) then
      ATextOut(FADXForm.FSurface, R.Left, R.Top, FFontSelColor, Text)
    else
      ATextOut(FADXForm.FSurface, R.Left, R.Top, FFontColor, Text);
  end;

end;

procedure TA2Button.paint;
  function temp_Paint(atemp: TPicture): boolean;
  begin
    result := false;
    if Assigned(atemp.Graphic) = false then exit;
    Canvas.Draw(0, 0, atemp.Graphic);
    result := true;
  end;

begin
  inherited paint;
  if Enabled = false then
  begin
    if temp_Paint(FEnabledImage) = false then
      temp_Paint(FUpImage);

  end
  else if (FDown) then
  begin
    if temp_Paint(FDownImage) = false then
      temp_Paint(FUpImage);
  end else
  begin
    if boEntered then
    begin
      if temp_Paint(FMouseImage) = false then
        temp_Paint(FUpImage);
    end
    else
    begin
      temp_Paint(FUpImage);
    end;
  end;

end;

procedure TA2Button.Loaded;
var
  temp: TA2Image;
begin
  inherited Loaded;
  if Assigned(FUpImage.Graphic) then
  begin
    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FUpImage.Bitmap);
      SetUPA2Image(temp);
    finally
      temp.Free;
    end;
  end;
  if Assigned(FDownImage.Graphic) then
  begin
    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FDownImage.Bitmap);
      SetDownA2Image(temp);
    finally
      temp.Free;
    end;
  end;

  if Assigned(FEnabledImage.Graphic) then
  begin
    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FEnabledImage.Bitmap);
      SetEnabledA2Image(temp);
    finally
      temp.Free;
    end;
  end;

  if Assigned(FMouseImage.Graphic) then
  begin
    temp := TA2Image.Create(32, 32, 0, 0);
    try
      temp.LoadFromBitmap(FMouseImage.Bitmap);
      SetMouseA2Image(temp);
    finally
      temp.Free;
    end;
  end;
end;

//////////////////////////////////////////
//            TA2IEdit
//////////////////////////////////////////

constructor TA2Edit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  OldText := '';
  if not (csDesigning in ComponentState) then
  begin
    Timer := TTimer.Create(AOwner);
    Timer.Enabled := TRUE;
    Timer.Interval := 400;
    Timer.OnTimer := TimerTimer;
  end;
  FFontColor := clWhite;
  FImageBack := TA2Image.Create(32, 32, 0, 0);
end;

destructor TA2Edit.Destroy;
begin
  FImageBack.Free;
  if not (csDesigning in ComponentState) then Timer.Free;
  inherited Destroy;
end;


procedure TA2Edit.AdxPaint;
var
  i, Fx, fw, Fy: integer;
  str, tmpStr: string;
  R: TRect;
  tempimg, tempback: TA2Image;
begin // TEdit
  if not Visible then exit;
  if not Assigned(FADXForm) then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;


  str := text;

  if (passwordchar <> char(0)) and (text <> '') then
    for i := 1 to Length(text) do str[i] := passwordchar;
  fw := ATextWidth(str) + 10;

  tempimg := TA2Image.Create(fw, Height, 0, 0);
  tempback := TA2Image.Create(Width, Height, 0, 0);
  try
    tempback.Resize(Width, Height);
    ATextOut(tempimg, 0, 0, FFontColor, str);
    if boTail then //光标
    begin
      str := COPY(str, 1, SelStart);
      FX := ATextWidth(str);
      ATextOut(tempimg, fx, 0, FFontColor, '_');
      ATextOut(tempimg, fx, 0 + 1, FFontColor, '_');
    end;
    if SelLength <> 0 then
    begin
      SelStart := SelStart + SelLength;
      Sellength := 0;
    end;

    R := Self.ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);

    if fw > Width then fw := fw - width else fw := 0;
    tempimg.GetImage(tempback, fw, 0);
    FADXForm.FSurface.DrawImage(tempback, R.Left, R.Top, true);
  finally
    tempimg.Free;
    tempback.Free;
  end;

end;

procedure TA2Edit.SetFontColor(value: integer);
begin
  FFontColor := value;
end;

procedure TA2Edit.TimerTimer(Sender: TObject);
var
  fh: THandle;
begin
  fh := GetFocus;
  if Handle = fh then
  begin
    boTail := not boTail;
    if assigned(ADXForm) then ADXForm.Draw;
  end else
  begin
    FocusExit(self);
  end;
end;

procedure TA2Edit.FocusEnter(Sender: TObject);
begin
  TimerTimer(self);
  boTail := TRUE;
  if assigned(ADXForm) then ADXForm.Draw;
  if assigned(FOnEnter) then FOnEnter(Sender);
end;

procedure TA2Edit.FocusExit(Sender: TObject);
begin
  boTail := FALSE;
  if assigned(ADXForm) then ADXForm.Draw;
  if assigned(FOnExit) then FOnExit(Sender);
end;

procedure TA2Edit.TextChange(Sender: TObject);
begin
  if assigned(ADXForm) then ADXForm.Draw;
  if assigned(FOnChange) then FOnChange(Sender);
end;

procedure TA2Edit.SelfKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key = VK_LEFT) or (key = VK_RIGHT) or (key = VK_UP) or (key = VK_DOWN) then
    if assigned(ADXForm) then ADXForm.Draw;

  if assigned(FOnKeyDown) then FOnKeyDown(Sender, Key, Shift);
end;

procedure TA2Edit.Loaded;
begin
  inherited loaded;
  if not (csDesigning in ComponentState) then
  begin
    FOnEnter := OnEnter;
    FOnExit := OnExit;
    FOnChange := OnChange;
    FOnKeyDown := OnKeyDown;

    OnEnter := FocusEnter;
    OnExit := FocusExit;
    OnChange := TextChange;
    OnKeyDown := SelfKeyDown;
  end;
end;

//////////////////////////////////////////
//            TA2Memo
//////////////////////////////////////////

procedure TA2Memo.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  boEntered := TRUE;
end;

procedure TA2Memo.WndProc(var Message: TMessage);
begin

  inherited WndProc(Message);
end;

procedure TA2Memo.WMPaint(var Message: TWMPaint);
var

  DrawBounds: TRect;
begin
  inherited; //WMPaint(Message);

end;

procedure TA2Memo.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  boEntered := false;
end;

procedure TA2Memo.KeyPress(var Key: Char);
begin

  inherited KeyPress(key);
end;

procedure TA2Memo.KeyUP(var Key: Word; Shift: TShiftState);
begin

  inherited KeyUP(key, Shift);
end;

procedure TA2Memo.KeyDown(var Key: Word; Shift: TShiftState);

begin
  inherited KeyDown(key, Shift);

end;

procedure TA2Memo.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  bx, by, TextH, rcount, i: integer;
  str: string;
  fs, outstate: boolean;
  tempSelStart: integer;
begin
  inherited MouseUp(Button, Shift, x, y);

  bx := x;
  by := y;
  TextH := ATextHeight('救');
  by := round(by / texth);
  str := text;
  tempSelStart := 0;
  rcount := 0;
  fs := false;
  for i := 1 to length(str) do
  begin
    case str[i] of
      #13: ;
      #10:
        begin
          outstate := true;
        end;
    end;
    if by <= 0 then
    begin
      bx := bx - ATextWidth(str[i]);
      inc(tempSelStart);
      if bx <= 0 then Break;
    end;

    inc(rcount);
    if by > 0 then inc(tempSelStart);

    if (outstate = false) and (rcount >= FWidthtext) then
    begin
      rcount := 0;
      outstate := true;
    end;
    if outstate then
    begin
      by := by - 1;
      outstate := false;
    end;
  end;
  SelStart := tempSelStart;
  DrawItem;
end;

procedure TA2Memo.DoEnter;
begin
  inherited DoEnter;
  TimerTimer(self);
  boTail := TRUE;
  DrawItem;

end;

procedure TA2Memo.DoExit;
begin
  inherited DoExit;
  boTail := FALSE;
  DrawItem;

end;

procedure TA2Memo.Change;

begin

  DrawItem;
end;

procedure TA2Memo.TimerTimer(Sender: TObject);
var
  fh: THandle;
begin
  fh := GetFocus;
  if Handle = fh then
  begin
    boTail := not boTail;
    DrawItem;
  end else
  begin
    DOExit();
  end;
end;

constructor TA2Memo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MCanvas := TControlCanvas.Create;
  MCanvas.Control := Self;
  FWidthtext := 80;
  Font.Name := 'Arial';
  font.Size := 9;
  FBackScreen := TA2Image.Create(Width, Height, 0, 0);
  if not (csDesigning in ComponentState) then
  begin
    Timer := TTimer.Create(AOwner);
    Timer.Enabled := TRUE;
    Timer.Interval := 300;
    Timer.OnTimer := TimerTimer;
  end;

end;

destructor TA2Memo.Destroy;
begin
  MCanvas.Free;
  FBackScreen.Free;
  Timer.Enabled := false;
  Timer.Free;
  inherited Destroy;
end;

procedure TA2Memo.AdxPaint;
var
  R: TRect;
begin
  if not Assigned(FAdxForm) then exit;
  if not Visible then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;
  R := Self.ClientRect;
  OffsetRect(R, left, top);
  if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);

  FADXForm.FSurface.DrawImage(FBackScreen, R.Left, R.Top, true);

end;

procedure TA2Memo.DrawItem2;
var
  i, myY, TextH, rcount: integer;
  id, bx, by: integer;
  outstate, fs, huanhan: boolean;
  str, str1, addstr, outstr: string;

begin

  if (Width <> FBackScreen.Width)
    or (Height <> FBackScreen.Height) then
  begin
    FBackScreen.Free;
    FBackScreen := TA2Image.Create(Width, Height, 0, 0);
  end;
  FBackScreen.Clear(0);
  TextH := ATextHeight('救');
  myY := 0;
  bx := 0;
  by := 0;
  id := SelStart;
  outstate := false;
  rcount := 0;
  fs := false;
  str := text;
  if id = 0 then fs := true;
    //文字输出
  for i := 1 to length(str) do
  begin
    case str[i] of
      #13: ; //addstr := addstr + '_';
      #10:
        begin
          huanhan := true;
                    //   addstr := addstr + '_';
          outstate := true;
          outstr := addstr;
          addstr := '';
        end;
    else addstr := addstr + str[i];
    end;
    inc(rcount);
    if (outstate = false) and (rcount >= FWidthtext) then
    begin
      rcount := 0;
      outstate := true;
      outstr := addstr;
      addstr := '';
    end;

    if fs = false then
    begin
      id := id - 1;
      if id <= 0 then
      begin
        if outstate then bx := ATextWidth(outstr)
        else bx := ATextWidth(addstr);
        by := myy;
        if huanhan then
        begin
          bx := 0;
          by := by + TextH + 1;
        end;
        fs := true;
      end;
    end;
    if outstate then
    begin
      outstate := false;
      ATextOut(FBackScreen, 0, myY, ColorSysToDxColor(Font.Color), outstr);
      myY := myY + TextH + 1;
    end;
    huanhan := false;
  end;
  if addstr <> '' then
    ATextOut(FBackScreen, 0, myY, ColorSysToDxColor(Font.Color), addstr);
  if boTail and fs then
  begin

    ATextOut(FBackScreen, bx, by, ColorSysToDxColor(Font.Color), '_');
    ATextOut(FBackScreen, bx, by + 1, ColorSysToDxColor(Font.Color), '_');
  end;

end;

procedure TA2Memo.DrawItem3;
var
  i, myY, TextH: integer;
  id, bx, by, rcount: integer;
  endstate, fs: boolean;
  str, addstr, outstr: string;

begin
  if (Width <> FBackScreen.Width)
    or (Height <> FBackScreen.Height) then
  begin
    FBackScreen.Free;
    FBackScreen := TA2Image.Create(Width, Height, 0, 0);
  end;
  FBackScreen.Clear(0);
  TextH := ATextHeight('救');
  myY := 0;
  bx := 0;
  by := 0;
  id := SelStart;
  endstate := false;
  fs := false;

  if text = '' then
    fs := true
  else
  begin
    if id >= length(text) then
    begin
      if text[length(text)] = #10 then
        endstate := true;

    end;
    if id = 0 then fs := true;
  end;
    //文字输出
  for i := 0 to Lines.Count - 1 do
  begin
    str := Lines.Strings[i];
    ATextOut(FBackScreen, 0, myY, ColorSysToDxColor(Font.Color), str);
    if fs = false then
    begin

      rcount := length(str) + 2;
      id := id - rcount;
      if id <= 0 then
      begin
        id := id + rcount;
        if id < 0 then id := 0;
        str := copy(str, 1, id);
        bx := ATextWidth(str);
        by := myy;
        fs := true;
      end;
    end;
    myY := myY + TextH + 1;
  end;

  if boTail and fs then
  begin
    if endstate then
    begin
      by := by + TextH + 1;
      bx := 0;
    end;
    ATextOut(FBackScreen, bx, by, ColorSysToDxColor(Font.Color), '_');
    ATextOut(FBackScreen, bx, by + 1, ColorSysToDxColor(Font.Color), '_');
  end;

end;

procedure TA2Memo.DrawItem;
var
  i, myY, TextH, rcount: integer;
  id, bx, by: integer;
  outstate, fs, huanhan: boolean;
  str, str1, addstr, outstr: string;

begin

  if (Width <> FBackScreen.Width)
    or (Height <> FBackScreen.Height) then
  begin
    FBackScreen.Free;
    FBackScreen := TA2Image.Create(Width, Height, 0, 0);
  end;
  FBackScreen.Clear(0);
  TextH := ATextHeight('救');
  myY := 0;
  bx := 0;
  by := 0;
  id := SelStart;
  outstate := false;
  rcount := 0;
  fs := false;
  str := text;
  if id = 0 then fs := true;
    //文字输出
  for i := 1 to length(str) do
  begin
    case str[i] of
      #13: ; //addstr := addstr + '_';
      #10:
        begin
          huanhan := true;
                    //   addstr := addstr + '_';
          outstate := true;
          outstr := addstr;
          addstr := '';
        end;
    else addstr := addstr + str[i];
    end;
    inc(rcount);
    if (outstate = false) and (rcount >= FWidthtext) then
    begin
      rcount := 0;
      outstate := true;
      outstr := addstr;
      addstr := '';
    end;

    if fs = false then
    begin
      id := id - 1;
      if id <= 0 then
      begin
        if outstate then bx := ATextWidth(outstr)
        else bx := ATextWidth(addstr);
        by := myy;
        if huanhan then
        begin
          bx := 0;
          by := by + TextH + 1;
        end;
        fs := true;
      end;
    end;
    if outstate then
    begin
      outstate := false;
      ATextOut(FBackScreen, 0, myY, ColorSysToDxColor(Font.Color), outstr);
      myY := myY + TextH + 1;
    end;
    huanhan := false;
  end;
  if addstr <> '' then
    ATextOut(FBackScreen, 0, myY, ColorSysToDxColor(Font.Color), addstr);
  if boTail and fs then
  begin

    ATextOut(FBackScreen, bx, by, ColorSysToDxColor(Font.Color), '_');
    ATextOut(FBackScreen, bx, by + 1, ColorSysToDxColor(Font.Color), '_');
  end;

end;
////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////

constructor TA2ProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackScreen := TPicture.Create;
  FBACKPicture := TPicture.Create;
  FPicture := TPicture.Create;
    //  FADXForm := nil;
  FMinValue := 0;
  FMaxValue := 100;
  FValue := 0;
  Caption := '';
  Width := 100;
  Height := 20;
end;

destructor TA2ProgressBar.Destroy;
begin
  FPicture.Free;
  FBACKPicture.Free;
  FBackScreen.Free;
  inherited Destroy;
end;

procedure TA2ProgressBar.Loaded;
begin
  inherited Loaded;
end;

procedure TA2ProgressBar.paint;
var
  R: TRect;
begin
  inherited paint;
  Canvas.FillRect(ClientRect);

  if Assigned(FBackScreen) then
  begin
    R := ClientRect;
    R.Right := R.Left + FValue * Width div FMaxValue;
    Canvas.StretchDraw(R, FBackScreen.Graphic);
  end;
end;

procedure TA2ProgressBar.SetPictureback(Value: TPicture);
begin
  FbackPicture.Assign(Value);
  if FbackPicture.Graphic <> nil then
  begin
    Width := FbackPicture.Width;
    Height := FbackPicture.Height;
  end;
end;

procedure TA2ProgressBar.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
  if FPicture.Graphic <> nil then
  begin
    Width := FPicture.Width;
    Height := FPicture.Height;
  end;
end;

procedure TA2ProgressBar.setMaxValue(Value: integer);
begin
  FMaxValue := Value;
  Draw;
end;

procedure TA2ProgressBar.setMixValue(Value: integer);
begin
  FMinValue := Value;
  Draw;
end;

procedure TA2ProgressBar.setValue(Value: integer);
begin
  FValue := Value;
  Draw;
end;

procedure TA2ProgressBar.SETFADXForm(Value: TA2Form);
begin

  FADXForm := Value;
    //    if Assigned(FADXForm) then
      //      if not (csdesigning in componentstate) then
        //        if FADXForm.FComponentList.IndexOf(self) = -1 then
          //          FADXForm.FComponentList.Add(self);
end;

procedure TA2ProgressBar.Draw;
var
  Bitmap: tBitmap;
  X: INTEGER;
begin
  Bitmap := tBitmap.Create;
  try
    Bitmap.Width := FBACKPicture.Width;
    Bitmap.Height := FBACKPicture.Height;
    Bitmap.TransparentColor := 0;
    FBACKPicture.Bitmap.TransparentColor := 0;
    FPicture.Bitmap.TransparentColor := 0;
    Bitmap.Canvas.CopyRect
      (Rect(0, 0, Bitmap.Width, Bitmap.Height),
      FBACKPicture.Bitmap.Canvas,
      Rect(0, 0, FBACKPicture.Bitmap.Width, FBACKPicture.Bitmap.Height));
    X := round(FValue / (FMaxValue - FMinValue) * FPicture.Bitmap.Width);

    Bitmap.Canvas.CopyRect
      (Rect(0, 0, x, Bitmap.Height),
      FPicture.Bitmap.Canvas,
      Rect(0, 0, X, FPicture.Bitmap.Height));

    FBackScreen.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;

end;

procedure TA2ProgressBar.AdxPaint;
var
  R: TRect;
  Can: TCanvas;
  temp: TA2Image;
begin
  if (csDesigning in ComponentState) then exit;

  if not Visible then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;
  if not Assigned(FBackScreen) then exit;
  R := Self.ClientRect;
  OffsetRect(R, left, top);
  if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);

  temp := TA2Image.Create(32, 32, 0, 0);
  try
    temp.LoadFromBitmap(FBackScreen.Bitmap);
    temp.TransparentColor := 0;
    FADXForm.FSurface.DrawImage(temp, R.Left, R.Top, true);

  finally
    temp.Free;
  end;
end;

//////////////////////////////////////////
//     TA2AnimateButton : TLabel
//////////////////////////////////////////

constructor TA2AnimateButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAtzFileName := '';
  Ans2ImageLib := TA2ImageLib.Create;
  Caption := '';
  CurFrame := 0;
  boUpProcess := FALSE;
  if not (csDesigning in ComponentState) then
  begin
    Timer := TTimer.Create(AOwner);
    Timer.Enabled := TRUE;
    Timer.Interval := 80;
    Timer.OnTimer := TimerTimer;
  end;
end;

destructor TA2AnimateButton.Destroy;
begin
  Ans2ImageLib.Free;
  if not (csDesigning in ComponentState) then Timer.Free;
  inherited Destroy;
end;

procedure TA2AnimateButton.AdxPaint;
begin
  if (csDesigning in ComponentState) or not Assigned(FADXForm) then exit;
  if not Visible then exit;
  if Ans2ImageLib.count <> 0 then
    FADXForm.Surface.DrawImage(Ans2ImageLib.Images[CurFrame], Left, Top, TRUE);
end;

procedure TA2AnimateButton.paint;
begin
  inherited paint;
  if ans2ImageLib.Count <> 0 then
    A2DrawImage(Canvas, 0, 0, Ans2ImageLib[CurFrame]);
end;

procedure TA2AnimateButton.TimerTimer(Sender: TObject);
begin
  if boUpProcess then CurFrame := CurFrame + 1
  else CurFrame := CurFrame - 1;

  if CurFrame > AtzImageCount - 1 then CurFrame := AtzImagecount;
  if CurFrame < 0 then
  begin
    Timer.Enabled := FALSE;
    CurFrame := 0;
  end;
end;

procedure TA2AnimateButton.Loaded;
begin
  inherited Loaded;
  if FAtzFileName <> '' then
  begin
    Ans2ImageLib.LoadFromFile(FAtzFileName);
    if ans2Imagelib.count <> 0 then
    begin
      Width := Ans2ImageLib.Images[0].Width;
      Height := Ans2ImageLib.Images[0].Height;
    end;
  end;
end;

procedure TA2AnimateButton.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  boUpProcess := TRUE;
  Timer.Enabled := TRUE;
end;

procedure TA2AnimateButton.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  boUpProcess := FALSE;
end;

//////////////////////////////////////////
//     TA2AnimateImage : TLabel
//////////////////////////////////////////

constructor TA2AnimateImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAtzFileName := '';
  Ans2ImageLib := TA2ImageLib.Create;
  Caption := '';
  CurFrame := 0;
  if not (csDesigning in ComponentState) then
  begin
    Timer := TTimer.Create(AOwner);
    Timer.Enabled := TRUE;
    Timer.Interval := 100;
    Timer.OnTimer := TimerTimer;
  end;
end;

destructor TA2AnimateImage.Destroy;
begin
  Ans2ImageLib.Free;
  if not (csDesigning in ComponentState) then Timer.Free;
  inherited Destroy;
end;

procedure TA2AnimateImage.AdxPaint;
begin
  if (csDesigning in ComponentState) or not Assigned(FADXForm) then exit;
  if not Visible then exit;
  if Ans2ImageLib.count <> 0 then
    FADXForm.Surface.DrawImage(Ans2ImageLib.Images[CurFrame], Left, Top, TRUE);
end;

procedure TA2AnimateImage.paint;
begin
  inherited paint;
  if ans2ImageLib.Count <> 0 then A2DrawImage(Canvas, 0, 0, Ans2ImageLib[CurFrame]);
end;

procedure TA2AnimateImage.TimerTimer(Sender: TObject);
begin
  CurFrame := CurFrame + 1;
  if CurFrame > AtzImageCount - 1 then CurFrame := 0;
end;

procedure TA2AnimateImage.Loaded;
begin
  inherited Loaded;
  if FAtzFileName <> '' then
  begin
    Ans2ImageLib.LoadFromFile(FAtzFileName);
    if ans2Imagelib.count <> 0 then
    begin
      Width := Ans2ImageLib.Images[0].Width;
      Height := Ans2ImageLib.Images[0].Height;
    end;
  end;
end;

//////////////////////////////////////////
//            TA2ListBox : TListBox
//////////////////////////////////////////

function calculation4(xMax, xValue, yMax, yValue, aResult: integer): integer;
begin
  Result := 0;
  case aResult of
    1: Result := (xValue * yMax) div yValue;
    2: Result := (xMax * yValue) div yMax;
    3: Result := (xMax * yValue) div xValue;
    4: Result := (xValue * yMax) div xMax;
  end;
end;

constructor TA2ListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FboAutoSelectIndex := true;
  FboautoPro := true;

    //    application.HookMainWindow(AppKeyDownHook);
        //Width := 144;
    // Height := 200;

  FBackScreen := TA2Image.Create(Width, Height, 0, 0);

  FItemHeight := 12;
  FItemMerginX := 3;
  FItemMerginY := 3;

  ScrollBarWidth := 16;
  ScrollBarHeight := 16;
  ScrollBarTrackHeight := 16;

  FStringList := TStringList.Create;
  FItemIndex := 0;
  FViewIndex := 0;
  FMouseSelectItemIndex := -1;
  FFontColor := WinRGB(31, 31, 31);
  FFontSelColor := WinRGB(0, 0, 255);
  FEmphasis := FALSE;
  FScrollBarView := TRUE;
  FFontSelBACKColor := 0;
  FItemIndexViewState := true;
  FMouseViewState := false;

  FScrollTrackTopPos := ScrollBarHeight;
  FScrollTrackingPos := ScrollBarHeight;

  FSurface := nil; //背景
  FScrollTop := nil; //UpImage
  FScrollTrack := nil; //UpImage
  FScrollBottom := nil; //UpImage
  FScrollDTop := nil; // DownImage
  FScrollDTrack := nil; // DownImage
  FScrollDBottom := nil; // DownImage
  FScrollBackImg := nil;
end;

procedure TA2ListBox.CreateParams(var Params: TCreateParams);
type
  PSelects = ^TSelects;
  TSelects = array[Boolean] of DWORD;
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);

  Styles: array[TListBoxStyle] of DWORD =
  (0, LBS_OWNERDRAWFIXED, LBS_OWNERDRAWVARIABLE, $40, $10);
  Sorteds: array[Boolean] of DWORD = (0, LBS_SORT);
  MultiSelects: array[Boolean] of DWORD = (0, LBS_MULTIPLESEL);
  ExtendSelects: array[Boolean] of DWORD = (0, LBS_EXTENDEDSEL);
  IntegralHeights: array[Boolean] of DWORD = (LBS_NOINTEGRALHEIGHT, 0);
  MultiColumns: array[Boolean] of DWORD = (0, LBS_MULTICOLUMN);
  TabStops: array[Boolean] of DWORD = (0, LBS_USETABSTOPS);
  CSHREDRAW: array[Boolean] of DWORD = (CS_HREDRAW, 0);
var
  Selects: PSelects;
begin
  inherited CreateParams(Params);
  if Assigned(FADXForm) = false then exit;
  CreateSubClass(Params, 'LISTBOX');
  with Params do
  begin
    Selects := @ExtendSelects;
    Style := Style or (WS_HSCROLL or WS_VSCROLL or LBS_HASSTRINGS or
      LBS_NOTIFY) or Styles[lbStandard] or Sorteds[FALSE] or
      Selects^[FALSE] or IntegralHeights[FALSE] or
      MultiColumns[FALSE] or BorderStyles[bsSingle] or
      TabStops[FALSE];
    Style := Style and not WS_BORDER;
    ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    WindowClass.style := WindowClass.style and not (CSHREDRAW[UseRightToLeftAlignment] or CS_VREDRAW);
  end;
end;

destructor TA2ListBox.Destroy;
begin

    //    application.UnhookMainWindow(AppKeyDownHook);

  if FSurface <> nil then FSurface.Free; //背景
  if FScrollTop <> nil then FScrollTop.Free; //UpImage
  if FScrollTrack <> nil then FScrollTrack.Free; //UpImage
  if FScrollBottom <> nil then FScrollBottom.Free; //UpImage
  if FScrollDTop <> nil then FScrollDTop.Free; // DownImage
  if FScrollDTrack <> nil then FScrollDTrack.Free; // DownImage
  if FScrollDBottom <> nil then FScrollDBottom.Free; // DownImage
  if FScrollBackImg <> nil then FScrollBackImg.Free;

    //  FCanvas.Free;
  FStringList.Free;
  FBackScreen.Free;
  inherited destroy;

end;

procedure TA2ListBox.Loaded;
begin
  inherited loaded;
  if (csDesigning in ComponentState) then exit;
    //or not Assigned(FAdxForm)
  ViewItemCount := (Height - (FItemMerginY * 2)) div FItemHeight;

    { FItemHeight := Self.ItemHeight;
     FItemMerginX := Self.ItemMerginX;
     FItemMerginY := Self.ItemMerginY;
     FFontColor := Self.FontColor;
     FFontSelColor := Self.FontSelColor;
     FEmphasis := Self.FontEmphasis;
     FScrollBarView := Self.ScrollBarView;
     }
end;

procedure TA2ListBox.Clear;
begin
  FStringList.Clear;
  FViewIndex := 0;
  FScrollTrackingPos := ScrollBarHeight;
  DrawItem;
end;

procedure TA2ListBox.DrawScrollBar();
var
  R: TRect;
  DrawScrollState: TDrawScrollState;
  fx, fy, fw, fh: integer;

begin

  DrawScrollState := TSS_None;
    //BackImg   背
  if FScrollBackImg <> nil then
  begin
    fx := 0 + (Width - ScrollBarWidth) + (ScrollBarWidth - FScrollBackImg.Width) div 2;
    fy := 0;
    FBackScreen.DrawImage(FScrollBackImg, fx, fy, TRUE);
  end;
    //top      上
  if FScrollTop <> nil then
  begin
    fx := 0 + (Width - ScrollBarWidth) + (ScrollBarWidth - FScrollTop.Width) div 2;
    fy := 0;
    if boScrollTop then
    begin
      FBackScreen.DrawImage(FScrollTop, fx, fy, TRUE);
      DrawScrollState := TSS_TopClick;
    end else
    begin
      fx := 0 + (Width - ScrollBarWidth) + (ScrollBarWidth - FScrollDTop.Width) div 2;
      fy := 0;
      FBackScreen.DrawImage(FScrollDTop, fx, fy, TRUE);
    end;
  end;
    //bottom    下
  if FScrollBottom <> nil then
  begin

    if boScrollBottom then
    begin
      fx := 0 + (Width - ScrollBarWidth) + (ScrollBarWidth - FScrollBottom.Width) div 2;
      fy := 0 + (Height - ScrollBarHeight) + (ScrollBarHeight - FScrollBottom.Height) div 2;
      FBackScreen.DrawImage(FScrollBottom, fx, fy, TRUE);
      DrawScrollState := TSS_BottomClick;
    end else
    begin
      fx := 0 + (Width - ScrollBarWidth) + (ScrollBarWidth - FScrollDBottom.Width) div 2;
      fy := 0 + (Height - ScrollBarHeight) + (ScrollBarHeight - FScrollDBottom.Height) div 2;
      FBackScreen.DrawImage(FScrollDBottom, fx, fy, TRUE);
    end;
  end;
    //Track   滑动
  if FScrollTrack <> nil then
  begin

    if boScrollTrack then
    begin
      fx := 0 + (Width - ScrollBarWidth) + (ScrollBarWidth - FScrollTrack.Width) div 2;
      fy := 0 + FScrollTrackingPos;
      FBackScreen.DrawImage(FScrollTrack, fx, fy, TRUE);
      DrawScrollState := TSS_TrackClick;
    end else
    begin
      fx := 0 + (Width - ScrollBarWidth) + (ScrollBarWidth - FScrollDTrack.Width) div 2;
      fy := 0 + FScrollTrackingPos;
      FBackScreen.DrawImage(FScrollDTrack, fx, fy, TRUE);
    end;
  end;
  R := Rect((R.Left + Width) - ScrollBarWidth, R.Top, R.Left + Width, R.Top + Height);
  if Assigned(FOnAdxScrollDraw) then FOnAdxScrollDraw(FBackScreen, R, DrawScrollState);
  if assigned(ADXForm) then ADXForm.Draw;
end;

//Paint  通知 我画，我就画

procedure TA2ListBox.Paint;
begin
  inherited paint;
  if not (csDesigning in ComponentState) then
    A2DrawImage(Canvas, 0, 0, FBackScreen);
end;

procedure TA2ListBox.AdxPaint;
var
  R: TRect;
begin
  if not Assigned(FAdxForm) then exit;
  if not Visible then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;
  R := Self.ClientRect;
  OffsetRect(R, left, top);
  if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
  FADXForm.FSurface.DrawImage(FBackScreen, R.Left, R.Top, true);

end;

procedure TA2ListBox.ADXDrawHint(aTA2Image: TA2Image; x, y: integer);
var
  R: TRect;
begin
    {   if not Assigned(FAdxForm) then exit;
       if not Visible then exit;
       if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;
       R := Self.ClientRect;
       OffsetRect(R, left, top);
       if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);

       if FHint.FVisible then
           FHint.DrawBack(aTA2Image, R.Left + x, R.Top + y);
           }

end;

{面板 内容 发生 改变 全部重新画}

procedure TA2ListBox.DrawItem();
var
  i, xx, yy, fx, fy
    : integer;
  R: TRect;
  TmpImg: TA2Image;
  DIS: TDrawItemState;
  col: integer;
  fcol, bcol: word;
begin
  if (Width <> FBackScreen.Width)
    or (Height <> FBackScreen.Height) then
  begin
    FBackScreen.Free;
    FBackScreen := TA2Image.Create(Width, Height, 0, 0);
  end;
  FBackScreen.Clear(0);
  xx := FItemMerginX;
  yy := FItemMerginY;
    //背景
  if FSurface <> nil then FBackScreen.DrawImage(FSurface, 0, 0, TRUE);
    //滑动 背景
  if FScrollBarView then
    TmpImg := TA2Image.Create(Width - ScrollBarWidth - FItemMerginX, ItemHeight + 2, 0, 0)
  else
    TmpImg := TA2Image.Create(Width - (FItemMerginX * 2), ItemHeight + 2, 0, 0);

    //内容
  for i := FViewIndex to ViewItemCount + FViewIndex - 1 do
  begin

    if (i < 0) or (i > FStringList.Count - 1) then break;
    if i = FMouseSelectItemIndex then DIS := TIS_MouseSelect else DIS := TIS_None;
    if FStringList.Objects[i] <> nil then
    begin
      col := Integer(FStringList.Objects[i]);
      fcol := LOWORD(Col);
      bcol := HIWORD(col);
    end else
    begin
      fcol := FFontColor;
      bcol := 0;
    end;

    if i = FItemIndex then
    begin
      if FItemIndexViewState then
      begin
        if FFontSelColor <> 31 then fcol := FFontSelColor;
        TmpImg.Clear(FFontSelBACKColor);
      end else TmpImg.Clear(bcol);
      if dis = TIS_MouseSelect then
        dis := TIS_Select_and_MouseSelect
      else DIS := TIS_Select;
    end else
    begin
      TmpImg.Clear(bcol);
    end;

        //  R := Rect(0, 0, TmpImg.Width, TmpImg.Height);

    fx := 0;
    fy := 0;
    if FLayout <> tlTop then
    begin
      if FLayout = tlBottom then
        fy := ItemHeight - ATextHeight(FStringList[i])
      else
        fy := (ItemHeight - ATextHeight(FStringList[i])) div 2;
    end;

    if FEmphasis then ATextOut(TmpImg, fx + 1, fy + 1, WinRGB(3, 3, 3), FStringList[i]);
    ATextOut(TmpImg, fx, fy, fcol, FStringList[i]);
    if FMouseViewState then
      if (DIS = TIS_MouseSelect) or (DIS = TIS_Select_and_MouseSelect) then ATextOut(TmpImg, fx + 1, fy, fcol, FStringList[i]);

    if Assigned(FOnAdxDrawItem) then
      FOnAdxDrawItem(TmpImg, i, FStringList[i], R, DIS, fx, fy);

    FBackScreen.DrawImage(TmpImg, xx, yy, TRUE);

    inc(yy, FItemHeight);
  end;
  TmpImg.Free;
  if FScrollBarView then DrawScrollBar();
  if Assigned(FAdxForm) then
    AdxPaint
  else
    Paint;

  if assigned(ADXForm) then ADXForm.Draw;
end;
{}

procedure copyTA2Image(var v1, value: TA2Image);
begin
  if value = nil then exit;
  if v1 = nil then
    v1 := TA2Image.Create(value.Width, value.Height, 0, 0)
  else
    V1.Setsize(value.Width, value.Height);
  v1.DrawImage(value, 0, 0, true);
  v1.Optimize;
end;

procedure TA2ListBox.SetBackImage(value: TA2Image);
begin
  copyTA2Image(FSurface, value);
end;

procedure TA2ListBox.SetScrollTopImage(UpImage, DownImage: TA2Image);
begin
  copyTA2Image(FScrollTop, UpImage);
  copyTA2Image(FScrollDTop, DownImage);
end;

procedure TA2ListBox.SetScrollTrackImage(UpImage, DownImage: TA2Image);
begin
  copyTA2Image(FScrollTrack, UpImage);
  copyTA2Image(FScrollDTrack, DownImage);
end;

procedure TA2ListBox.SetScrollBottomImage(UpImage, DownImage: TA2Image);
begin
  copyTA2Image(FScrollBottom, UpImage);
  copyTA2Image(FScrollDBottom, DownImage);
end;

procedure TA2ListBox.SetScrollBackImage(value: TA2Image);
begin
  copyTA2Image(FScrollBackImg, value);
end;

var
  OrY: integer;
  TrackCount: integer = 0;

procedure TA2ListBox.DecItem(value: integer);
begin
  if (csDesigning in ComponentState) then exit;
  Dec(FViewIndex, value);
  if FViewIndex <= 0 then
  begin
    FViewIndex := 0;
    FScrollTrackingPos := ScrollBarHeight;
    exit;
  end;
  FScrollTrackingPos := calculation4(FStringList.Count - ViewItemCount, FViewIndex, Height - (ScrollBarHeight * 3), 0, 4);
  FScrollTrackingPos := FScrollTrackingPos + ScrollBarHeight;
  DrawItem;
end;

procedure TA2ListBox.IncItem(value: integer);
begin
  if (csDesigning in ComponentState) then exit;
  inc(FViewIndex, value);
  if FViewIndex + ViewItemCount > FStringList.Count - 1 then
  begin
    FViewIndex := FStringList.Count - ViewItemCount;
    FScrollTrackingPos := Height - (ScrollBarHeight * 2);
    exit;
  end;
  FScrollTrackingPos := calculation4(FStringList.Count - ViewItemCount, FViewIndex, Height - (ScrollBarHeight * 3), 0, 4);
  FScrollTrackingPos := FScrollTrackingPos + ScrollBarHeight;
  DrawItem;
end;

procedure TA2ListBox.IncItemIndex(value: integer);
begin
  if (csDesigning in ComponentState) then exit;
    //选择 +1
  inc(FItemIndex, value);
  upItemIndex;

  DrawItem;
end;

procedure TA2ListBox.upItemIndex();
begin
    //修正
  if FStringList.Count > 0 then
  begin

    if FItemIndex < 0 then FItemIndex := 0;
    if FItemIndex >= FStringList.Count then FItemIndex := FStringList.Count - 1;

    if FViewIndex >= FStringList.Count then FViewIndex := FStringList.Count - 1;
    if FViewIndex < 0 then FViewIndex := 0;

    if (FItemIndex < FViewIndex) then
    begin
      FViewIndex := FItemIndex;
    end;
    if (FItemIndex >= (FViewIndex + ViewItemCount)) then
    begin
      FViewIndex := FItemIndex - (ViewItemCount - 1);
    end;

  end else
  begin
    FItemIndex := -1;
  end;
  if FViewIndex + ViewItemCount > FStringList.Count - 1 then
  begin
    FViewIndex := FStringList.Count - ViewItemCount;
    if FViewIndex < 0 then FViewIndex := 0;
    if FViewIndex > (FStringList.Count - 1) then FViewIndex := FStringList.Count - 1;
    FScrollTrackingPos := Height - (ScrollBarHeight * 2);
    exit;
  end;
  if FViewIndex < 0 then FViewIndex := 0;
  if FViewIndex > (FStringList.Count - 1) then FViewIndex := FStringList.Count - 1;
  FScrollTrackingPos := calculation4(FStringList.Count - ViewItemCount, FViewIndex, Height - (ScrollBarHeight * 3), 0, 4);
  FScrollTrackingPos := FScrollTrackingPos + ScrollBarHeight;
end;

procedure TA2ListBox.DecItemIndex(value: integer);
begin
  if (csDesigning in ComponentState) then exit;
  Dec(FItemIndex, value);
  upItemIndex;

  DrawItem;
end;

procedure TA2ListBox.CMMouseEnter(var Message: TMessage);
begin
  if (csDesigning in ComponentState) then exit;
  boEntered := TRUE;
    // Windows.SetFocus(Handle);

end;

procedure TA2ListBox.CMMouseLeave(var Message: TMessage);
begin
  if (csDesigning in ComponentState) then exit;
  boEntered := false;
    { if Assigned(FADXForm) then
     begin
         FADXForm.FA2Hint.FVisible := FALSE;
         FADXForm.FA2Hint.setText('');
     end;
     }
  if FboautoPro then
    if Assigned(editset) then editset;
end;

procedure TA2ListBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
//var i, m : integer;
begin
  if (csDesigning in ComponentState) then exit;
  inherited MouseDown(Button, Shift, x, y);
  if (x > FItemMerginX)
    and (x < (Width - ScrollBarWidth - FItemMerginX))
    and (y > FItemMerginY)
    and (y < Height - FItemMerginY) then
  begin

    FItemIndex := FViewIndex + (y - FItemMerginY) div FItemHeight;

  end;

  if FStringList.Count - 1 < ViewItemCount then
  begin
    FViewIndex := 0;
    FScrollTrackingPos := ScrollBarHeight;
    DrawItem;
    exit;
  end;
    // Top Scroll Image
  if (x > Width - ScrollBarWidth) and (x < Width) and (y > 0) and (y < ScrollBarHeight) then
  begin
    boScrollTop := TRUE;
    DecItemIndex(1); //  DecItem(1)
  end;
    // Bottom Scroll Image
  if (x > Width - ScrollBarWidth) and (x < Width) and (y > Height - ScrollBarHeight) and (y < Height) then
  begin
    boScrollBottom := TRUE;
    IncItemIndex(1); //  IncItem(1);
  end;
    // Tracking
  if (x > Width - ScrollBarWidth) and (x < Width) and (y > FScrollTrackingPos) and (y < FScrollTrackingPos + ScrollBarTrackHeight) then
  begin
    boScrollTrack := TRUE;
    OrY := y - FScrollTrackingPos;
  end;
  DrawItem;

end;

procedure TA2ListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  temp: integer;
  r: TRect;
begin
  if (csDesigning in ComponentState) then exit;

  if Assigned(FADXForm) then
  begin
    R := Self.ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
{        with FADXForm do
        begin
            FA2Hint.Fleft := R.Left + x;
            FA2Hint.Ftop := R.Top + y;
            FA2Hint.FVisible := true;
        end;}
  end;

  CurXMouse := x;
  CurYMouse := y;
  if (x > FItemMerginX) and (x < (Width - ScrollBarWidth - FItemMerginX)) and (y > FItemMerginY) and (y < Height - FItemMerginY) then
  begin

    temp := FViewIndex + (y - FItemMerginY) div ItemHeight;
    if FMouseSelectItemIndex <> temp then
    begin
      FMouseSelectItemIndex := temp;
    end;
    if Assigned(FOnHint) then FOnHint(Self, FMouseSelectItemIndex);
  end;
  if boScrollTrack then
  begin
    FScrollTrackingPos := y - Ory;
    FScrollTrackTopPos := y - ScrollBarHeight;
    if FScrollTrackTopPos < ScrollBarHeight then FScrollTrackTopPos := ScrollBarHeight;
    if FScrollTrackTopPos > Height - (ScrollBarHeight * 3) then FScrollTrackTopPos := Height - (ScrollBarHeight * 2);

    if FScrollTrackingPos < ScrollBarHeight then FScrollTrackingPos := ScrollBarHeight;
    if FScrollTrackingPos > Height - (ScrollBarHeight * 2) then FScrollTrackingPos := Height - (ScrollBarHeight * 2);
    if FStringList.Count - 1 > ViewItemCount then
    begin
      FViewIndex := calculation4(FStringList.Count - ViewItemCount, 0, Height - (ScrollBarHeight * 3), FScrollTrackTopPos - ScrollBarHeight, 2);
      DrawItem;
    end;
  end;

  inherited MouseMove(Shift, x, y);
end;

procedure TA2ListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, x, y);
  boScrollTop := FALSE;
  boScrollTrack := FALSE;
  boScrollBottom := FALSE;
end;

procedure TA2ListBox.DblClick;
begin

  if (CurXMouse > FItemMerginX) and (CurXMouse < (Width - ScrollBarWidth - FItemMerginX))
    and (CurYMouse > FItemMerginY) and (CurYMouse < Height - FItemMerginY) then
  begin
        // FItemIndex := FViewIndex + (CurYMouse - FItemMerginY) div FItemHeight;
    if (FItemIndex >= 0) and (FItemIndex < FStringList.Count) then inherited DblClick;
  end;

end;

procedure TA2ListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
end;

procedure TA2ListBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited Keyup(Key, Shift);
end;

procedure TA2ListBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
end;

procedure TA2ListBox.WndProc(var Message: TMessage);
var
  akey: Word;
begin
  inherited WndProc(Message);
  case Message.Msg of
        //      WM_LBUTTONDOWN, WM_LBUTTONDBLCLK :
    WM_LBUTTONDOWN:
      begin
        if not (csDesigning in ComponentState) and not Focused then
        begin
                    //            if not (csDesigning in ComponentState) then begin
                    //               if not FboFocus then begin
          Windows.SetFocus(Handle);
                    //                  FboFocus := TRUE;
                    //               end;
          if not Focused then exit;
        end;
      end;

    WM_KEYDOWN, WM_SYSKEYDOWN:
      begin
        if not (csDesigning in ComponentState) then
        begin
          DoKeyDown(TWMKey(Message));
          aKey := TWMKey(Message).CharCode;
          case aKey of
            33: DecItemIndex(ViewItemCount);
            34: IncItemIndex(ViewItemCount);
            35: IncItemIndex(FStringList.Count);
            36: DecItemIndex(FStringList.Count);
            37: DecItemIndex(1);
            38: DecItemIndex(1);
            39: IncItemIndex(1);
            40: IncItemIndex(1);
          end;
        end;
      end;
  end;
end;

procedure TA2ListBox.OnMouseWheel(atype: integer);
begin
  if not boEntered then exit;
  if atype > 0 then
  begin
    DecItemIndex(1); //  DecItem(3)
  end else
  begin
    IncItemIndex(1); //IncItem(3)
  end;
end;

procedure TA2ListBox.WMMouseWheel(var Message: TWMMouseWheel);
begin
    // inherited;
  //  if ViewItemCount > FStringList.Count then exit;
  OnMouseWheel(Message.WheelDelta);

end;

procedure TA2ListBox.AddItem(aStr: string);
begin
  FStringList.Add(aStr);
  if FboAutoSelectIndex then
    FItemIndex := FStringList.Count;
  upItemIndex;
  DrawItem;
end;

function TA2ListBox.GetItem(Value: integer): string;
begin
  Result := '';
  if (Value < 0) or (Value > FStringList.Count - 1) then exit;
  Result := FStringList[Value];
end;

procedure TA2ListBox.setText(value: string);
var
  s: string;
begin
  FStringList.Clear;
  while value <> '' do
  begin
    FStringList.Add(CutLengthString(value, Width));
  end;
  DrawItem;
end;

procedure TA2ListBox.SETItemsColor(i: integer; fcol, bcol: word);
begin
  FStringList.Objects[i] := pointer(MakeLong(fcol, bcol));
end;

procedure TA2ListBox.SETItemIndex(Value: integer);

begin
  FItemIndex := Value;
  if fItemIndex >= ViewItemCount then
  begin
    FViewIndex := (fItemIndex + 1) - ViewItemCount;
  end else FViewIndex := 0;

  DrawItem;
end;

procedure TA2ListBox.SetItem(Value: integer; aItem: string);
begin
  if (Value < 0) or (Value > FStringList.Count - 1) then exit;
  FStringList[Value] := aItem;
  DrawItem();

end;

procedure TA2ListBox.DeleteItem(Value: integer);
begin
  FStringList.Delete(Value);
  DrawItem();

end;

function TA2ListBox.Count: integer;
begin
  Result := FStringList.Count;
end;

//////////////////////////////////////////
//            TA2ComboBox
//////////////////////////////////////////

constructor TA2ComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
  FPictureA2 := TA2Image.Create(32, 32, 0, 0);
end;

destructor TA2ComboBox.Destroy;
begin
  FPicture.Free;
  FPictureA2.Free;
  inherited destroy;
end;

procedure TA2ComboBox.setFADXForm(Value: TA2Form);
begin
  if assigned(ADXForm) then ADXForm.Draw;
  FADXForm := Value;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2ComboBox.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2ComboBox.TextChange(Sender: TObject);
begin
  if assigned(ADXForm) then ADXForm.Draw;
  if assigned(FOnChange) then FOnChange(Sender);
end;

procedure TA2ComboBox.Loaded;
begin
  inherited Loaded;
  if Assigned(FPicture.Graphic) then
    FPictureA2.LoadFromBitmap(FPicture.Bitmap);
  if not (csDesigning in ComponentState) then
  begin
    FOnChange := OnChange;
    OnChange := TextChange;
  end;
end;

procedure TA2ComboBox.AdxPaint;
var
  R: TRect;
begin
  if (csDesigning in ComponentState) or not Assigned(FADXForm) then exit;
  if not Visible then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;
  if Assigned(FPicture.Graphic) then
  begin
    R := Self.ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
    FADXForm.FSurface.DrawImage(FPictureA2, R.Left + Width - FPictureA2.Width, R.Top, TRUE);
  end;

  if Text <> '' then
  begin
    R := ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
    ATextOut(FADXForm.FSurface, R.Left + 2, R.Top + 2, WinRGB(31, 31, 31), Text);
  end;
end;
/////////////////////////

procedure TA2Hint.DrawBack(DestImage: TA2Image; x, y: integer);
begin
  if FVisible then if (timeGetTime - fshowtimetcik) > 3000 then FVisible := false;
  if FVisible = false then exit;
  y := ftop + y;
  x := Fleft + x;
    {  if (Fback.Height + y) > (DestImage.Height - 117 - 18) then
          y := DestImage.Height - 117 - Fback.Height - 18;
      if (Fback.Width + x) > (DestImage.Width) then
          x := DestImage.Width - Fback.Width - 8;}
  if (Fback.Height + y) > (DestImage.Height) then
    y := DestImage.Height - Fback.Height;
  if (Fback.Width + x) > (DestImage.Width) then
    x := DestImage.Width - Fback.Width - 8;
  case Ftype of
    hst_None: DestImage.DrawImage(Fback, x, y, true);
    hstTransparent: DestImage.DrawImageKeyColor(Fback, x, y, 31, @bubbletbl);
    hstImageOveray: DestImage.DrawImageOveray(Fback, x, y, FImageOveray);
  end;

end;

procedure TA2Hint.setText(atext: string);
begin
  FHintText.Text := StringReplace(atext, '<br>', #13#10, [rfReplaceAll]);
  Draw;
  fshowtimetcik := timeGetTime;
end;

procedure TA2Hint.setVisible;
begin
  FVisible := true;
  fshowtimetcik := timeGetTime;
end;

procedure TA2Hint.Draw;
var
  i, imgX, imgY, xx, yy: integer;
  YDrawMargin, XDrawMargin: integer;
  temp: TA2Image;
  Bitmap: TBitmap;
  r, g, b: word;
  bc, fc, lc: Tcolor;
  tempTextList: TstringList;
  function _colorstrTostr(atext: string): string;
  var
    it: integer;
    st: string;
  begin
    result := '';
    for it := 1 to length(atext) do
    begin
      case atext[it] of
        '<':
          begin
            result := result + st;
            st := '';
          end;
        '>': st := '';
      else st := st + atext[it];
      end;

    end;
    if st <> '' then result := result + st;
  end;

  procedure _GetMaxTextWHcolor(var W, H: integer; aStringList: TStringList);
  var
    xx, yy, i: integer;
  begin
    W := 0;
    H := 0;
    for i := 0 to aStringList.Count - 1 do
    begin
      xx := ATextWidth(_colorstrTostr(aStringList[i]));
      yy := ATextHeight(aStringList[i]);
      if W < xx then W := xx;
      if H < yy then H := yy;
    end;
  end;

  procedure _TA2Hint_TextOut(aTA2Image: TA2Image; ax, ay: integer; atext: string; afc: tcolor);
  var
    it: integer;
    st: string;
  begin
    tempTextList.Clear;
    st := '';
    for it := 1 to length(atext) do
    begin
      case atext[it] of
        '<':
          begin
            if st <> '' then
            begin

              ATextOut(aTA2Image, ax + 1, ay + 1, WinRGB(1, 1, 1), st);
              ATextOut(aTA2Image, ax, ay, ColorSysToDxColor(afc), st);
              ax := ax + ATextWidth(st);
            end;
            st := '';
          end;
        '>':
          begin
            try
              if UpperCase(st) = 'BR' then
              begin

              end else
                afc := (tcolor(strtoint(st)));

            except

            end;
            st := '';
          end;
      else
        st := st + atext[it];
      end;

    end;
    if st <> '' then
    begin
      ATextOut(aTA2Image, ax + 1, ay + 1, WinRGB(1, 1, 1), st);
      ATextOut(aTA2Image, ax, ay, ColorSysToDxColor(afc), st);
    end;
  end;

begin

  tempTextList := TstringList.Create;
  try

    Fback.Clear(0);
    if FHintText.Count <= 0 then exit;
    bc := FBackcolor;
    fc := FTextcolor;
    lc := Fbordercolor;

    case Ftype of
      hst_None: ;
      hstTransparent: bc := ColorDxColorToSys(31);
      hstImageOveray: ;
    end;

    YDrawMargin := 5;
    XDrawMargin := 5;
    _GetMaxTextWHcolor(imgX, imgY, FHintText);
    imgY := (imgY * FHintText.Count) + (FHintText.Count - 1);

    temp := TA2Image.Create(imgX + XDrawMargin, imgY + YDrawMargin, 0, 0);
    try

      temp.Clear(ColorSysToDxColor(bc));
            {xx := XDrawMargin div 2 + 3;
            yy := YDrawMargin div 2;
            for i := 0 to FHintText.Count - 1 do
            begin
                ATextOut(temp, xx + 1, yy + 1, WinRGB(3, 3, 3), FHintText[i]);
                inc(yy, imgY div FHintText.Count + 1);
            end;
            }
      xx := XDrawMargin div 2 + 3;
      yy := YDrawMargin div 2;
      for i := 0 to FHintText.Count - 1 do
      begin
                // ATextOut(temp, xx, yy, ColorSysToDxColor(fc), FHintText[i]);
        _TA2Hint_TextOut(temp, xx, yy, FHintText[i], fc);
        inc(yy, imgY div FHintText.Count + 1);
      end;
            //画边框
      Bitmap := tBitmap.Create;
      try
        Bitmap.Width := temp.Width + 20;
        Bitmap.Height := temp.Height + 20;
        Bitmap.PixelFormat := pf24bit;
                // Bitmap.Canvas.brush.Style := bsSolid;
        Bitmap.Canvas.Brush.Color := clBlack;
        Bitmap.canvas.Rectangle(0, 0, Bitmap.Width, Bitmap.Height);

        Bitmap.Canvas.Brush.Color := bc;
        Bitmap.Canvas.Pen.color := Fbordercolor;

                //  Bitmap.Canvas.Brush.Style := bsClear;
        Bitmap.Canvas.RoundRect(0, 0, Bitmap.Width - 1, Bitmap.Height - 1, 9, 9);
        Fback.LoadFromBitmap(Bitmap);
      finally
        Bitmap.Free;
      end;
      temp.TransparentColor := 0;
      Fback.DrawImage(temp, 10, 10, true);
      Fback.TransparentColor := 0;
    finally
      temp.Free;
    end;
  finally
    tempTextList.Free;
  end;

end;

{
procedure TA2Hint.Draw;
var
    i, imgX, imgY, xx, yy:integer;
    YDrawMargin, XDrawMargin:integer;
    temp            :TA2Image;
    Bitmap          :TBitmap;
    r, g, b         :word;
    bc, fc, lc      :Tcolor;
begin
    Fback.Clear(0);
    if FHintText.Count <= 0 then exit;
    bc := FBackcolor;
    fc := FTextcolor;
    lc := Fbordercolor;
    if FTransparent then bc := ColorDxColorToSys(31);

    YDrawMargin := 5;
    XDrawMargin := 5;
    GetMaxTextWH(imgX, imgY, FHintText);
    imgY := (imgY * FHintText.Count) + (FHintText.Count - 1);

    temp := TA2Image.Create(imgX + XDrawMargin, imgY + YDrawMargin, 0, 0);
    try

        temp.Clear(ColorSysToDxColor(bc));
        xx := XDrawMargin div 2 + 3;
        yy := YDrawMargin div 2;
        for i := 0 to FHintText.Count - 1 do
        begin
            ATextOut(temp, xx + 1, yy + 1, WinRGB(3, 3, 3), FHintText[i]);
            inc(yy, imgY div FHintText.Count + 1);
        end;
        xx := XDrawMargin div 2 + 3;
        yy := YDrawMargin div 2;
        for i := 0 to FHintText.Count - 1 do
        begin
            ATextOut(temp, xx, yy, ColorSysToDxColor(fc), FHintText[i]);
            inc(yy, imgY div FHintText.Count + 1);
        end;
        //画边框
        Bitmap := tBitmap.Create;
        try
            Bitmap.Width := temp.Width + 20;
            Bitmap.Height := temp.Height + 20;
            Bitmap.PixelFormat := pf24bit;
            // Bitmap.Canvas.brush.Style := bsSolid;
            Bitmap.Canvas.Brush.Color := clBlack;
            Bitmap.canvas.Rectangle(0, 0, Bitmap.Width, Bitmap.Height);

            Bitmap.Canvas.Brush.Color := bc;
            Bitmap.Canvas.Pen.color := Fbordercolor;

            //  Bitmap.Canvas.Brush.Style := bsClear;
            Bitmap.Canvas.RoundRect(0, 0, Bitmap.Width - 1, Bitmap.Height - 1, 9, 9);
            Fback.LoadFromBitmap(Bitmap);
        finally
            Bitmap.Free;
        end;
        temp.TransparentColor := 0;
        Fback.DrawImage(temp, 10, 10, true);
        Fback.TransparentColor := 0;
    finally
        temp.Free;
    end;
end;
}

constructor TA2Hint.Create();
begin
  inherited Create();
  Fback := TA2Image.Create(200, 200, 0, 0);
  Ftype := hst_None;
  FBackcolor := $00486368;
  FTextcolor := clWhite;
  Fbordercolor := $0047F1FA;
  FHintText := TstringList.Create;
  FImageOveray := 20;
end;

destructor TA2Hint.Destroy;
begin
  Fback.Free;
  FHintText.Free;
  inherited Destroy;
end;

{ TA2TreeNode }

function TA2TreeNode.get(aname: string): TA2TreeNode;
var
  i: integer;
  temp: TA2TreeNode;
begin
  result := nil;
  if FCaption = aname then
  begin
    result := self;
    exit;
  end;
  for i := 0 to Flist.Count - 1 do
  begin
    temp := Flist.Items[i];
    result := temp.get(aname);
    if result <> nil then exit;
  end;
end;

function TA2TreeNode.ADD(aname: string): TA2TreeNode;
var
  temp: TA2TreeNode;
begin
  result := nil;
  temp := TA2TreeNode.Create(FOwner, FADXForm);
  temp.FCaption := aname;
  temp.FParent := Self;
  temp.FLevel := FLevel + 1;
  if temp.FLevel = 0 then temp.SETOpen(true);
  Flist.Add(TEMP);
  result := temp;
end;

procedure TA2TreeNode.Clear;
var
  i: integer;
  temp: TA2TreeNode;
begin
  for i := 0 to Flist.Count - 1 do
  begin
    temp := Flist.Items[i];
    temp.Free;
  end;
  Flist.Clear;
end;

procedure TA2TreeNode.SETOpen(v: boolean);
begin
  Fopen := v;
  FNode.Visible := Fopen;
end;

constructor TA2TreeNode.Create(AOwner: TComponent; aADXForm: TA2Form);
begin
  FOwner := AOwner;
  FADXForm := aADXForm;
  FNode := TA2Label.Create(AOwner);

  FNode.OnMouseDown := onMouseDown;
  FNode.ADXForm := FADXForm;
  FNode.Parent := TWinControl(FOwner);
  FParent := nil;
  FLevel := 0;
  Flist := Tlist.Create;
  SETOpen(false);
end;

function TA2TreeNode.DEL(aname: string): boolean;
var
  i: integer;
  temp: TA2TreeNode;
begin
  result := false;
  for i := 0 to Flist.Count - 1 do
  begin
    temp := Flist.Items[i];
    if temp.FCaption = aname then
    begin
      Flist.Delete(i);
      temp.Free;
      result := true;
      exit;
    end;
    result := temp.DEL(aname);
    if result then exit;
  end;
end;

destructor TA2TreeNode.Destroy;
begin
  if TA2TreeView(FOwner).FselectTreeNode = self then
    TA2TreeView(FOwner).FselectTreeNode := nil;
  Clear;
  FNode.Free;
  Flist.Free;
  inherited;
end;

procedure TA2TreeNode.AdxPaint;
begin

end;

procedure TA2TreeNode.setTopLeft(var atop, aleft: integer);
var
  i: integer;
  temp: TA2TreeNode;
  atop1, aleft1: integer;
begin
  atop1 := atop;
  aleft1 := aleft;
  if FNode.Visible then
  begin
    if TA2TreeView(FOwner).FselectTreeNode = self then
    begin

      FNode.FFontColor := ColorSysToDxColor(TA2TreeView(FOwner).FColorSelectFont);
      FNode.FBColor := ColorSysToDxColor(TA2TreeView(FOwner).FColorSelectBack);
    end
    else
    begin
      FNode.FFontColor := ColorSysToDxColor(TA2TreeView(FOwner).FColorFont);
      FNode.FBColor := ColorSysToDxColor(TA2TreeView(FOwner).FColorBack);
    end;
    if Flist.Count > 0 then
    begin
      FNode.Caption := '+' + FCaption;
    end
    else
      FNode.Caption := FCaption;
    FNode.AutoSize := true;
    FNode.Top := atop1;
    FNode.Left := aleft1;
    atop1 := atop1 + FNode.Height;
    aleft1 := aleft1 + 10;
  end;
    //设置下面列表
  for i := 0 to Flist.Count - 1 do
  begin
    temp := Flist.Items[i];
    temp.setTopLeft(atop1, aleft1);
  end;
  atop := atop1;

end;

procedure TA2TreeNode.setADXForm(aADXForm: TA2Form);
var
  i: integer;
  temp: TA2TreeNode;
begin

  FADXForm := aADXForm;
  FNode.ADXForm := FADXForm;
  for i := 0 to Flist.Count - 1 do
  begin
    temp := Flist.Items[i];
    temp.setADXForm(aADXForm);
  end;
end;

procedure TA2TreeNode.Open();
var
  i: integer;
  temp: TA2TreeNode;
begin
  Fopen := true;
  FNode.Visible := true;
  for i := 0 to Flist.Count - 1 do
  begin
    temp := Flist.Items[i];
    temp.FNode.Visible := true;
  end;

end;

procedure TA2TreeNode.close();
var
  i: integer;
  temp: TA2TreeNode;
begin
  Fopen := false;
  FNode.Visible := false;
  for i := 0 to Flist.Count - 1 do
  begin
    temp := Flist.Items[i];
    temp.close;
  end;
end;

procedure TA2TreeNode.OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    TA2TreeView(FOwner).FselectTreeNode := self;
    if Fopen = false then
    begin
      Open;
      FNode.Visible := true;
    end else
    begin
      close;
      FNode.Visible := true;
    end;
  end;
end;

{ TA2TreeView }

procedure TA2TreeView.ADD(aindex, aname: string);
var
  temp: TA2TreeNode;
  aTop, aLeft: integer;
begin
  temp := FTreeNode.get(aindex);
  if temp = nil then exit;
  temp.ADD(aname);
  aTop := top;
  aLeft := left;
  FTreeNode.setTopLeft(atop, aleft);
end;

function TA2TreeView.AddChild(Parent: TA2TreeNode; const S: string): TA2TreeNode;
begin
  result := nil;
  if Parent = nil then
  begin
    result := FTreeNode.ADD(S);
    exit;
  end;
  result := Parent.ADD(S);
end;

procedure TA2TreeView.AdxPaint;
var
  aTop, aLeft: integer;
begin
  aTop := top;
  aLeft := left;
  FTreeNode.setTopLeft(atop, aleft);
end;

procedure TA2TreeView.Clear;
begin
  FTreeNode.Clear;
end;

constructor TA2TreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  FTreeNode := TA2TreeNode.Create(self, FADXForm);
  FTreeNode.FLevel := -1;
  FTreeNode.Fopen := true;
  FTreeNode.FNode.Visible := TRUE;
  FTreeNode.FCaption := '/';
  FTreeNode.FNode.Visible := false;
  FselectTreeNode := nil;
  FColorFont := clLime;
  FColorBack := clBlack;
  FColorSelectFont := clRed;
  FColorSelectBack := clTeal;
end;

procedure TA2TreeView.DEL(aindex, aname: string);
var
  temp: TA2TreeNode;
begin

  temp := FTreeNode.get(aindex);
  if temp = nil then exit;
  temp.DEL(aname);
end;

destructor TA2TreeView.Destroy;
begin
  FTreeNode.Free;
  inherited;
end;

function TA2TreeView.GetBufStart(Buffer: string; var Level: Integer): string;
var
  i: integer;
begin
  Level := 0;
  for i := 1 to length(Buffer) do
  begin
    if buffer[i] = #9 then
      Inc(Level)
    else
    begin
      Result := copy(Buffer, i, length(buffer));
      exit;
    end;
  end;

end;

procedure TA2TreeView.load(astringlist: tstringlist);
var
  ANode, NextNode: TA2TreeNode;
  ALevel, i, atop, aleft: Integer;
  CurrStr: string;
begin
  try
    Clear;
    ANode := nil;
    for i := 0 to astringlist.Count - 1 do
    begin
      CurrStr := GetBufStart(astringlist[i], ALevel);
      if ANode = nil then
        ANode := AddChild(nil, CurrStr)
      else if ANode.FLevel = ALevel then
        ANode := AddChild(ANode.FParent, CurrStr)
      else if ANode.FLevel = (ALevel - 1) then
        ANode := AddChild(ANode, CurrStr)
      else if ANode.FLevel > ALevel then
      begin
        NextNode := ANode.FParent;
        while NextNode.FLevel > ALevel do
          NextNode := NextNode.FParent;
        ANode := AddChild(NextNode.FParent, CurrStr);
      end;

    end;
    aTop := top;
    aLeft := left;
    FTreeNode.setTopLeft(atop, aleft);
  except
  end;
end;

procedure TA2TreeView.loadfile(afilename: string);
var
  astringlist: tstringlist;
begin
  Clear;
  if FileExists(afilename) = false then exit;
  astringlist := tstringlist.Create;
  try
    astringlist.LoadFromFile(afilename);
    load(astringlist);
  finally
    astringlist.Free;
  end;

end;

procedure TA2TreeView.setADXForm(aADXForm: TA2Form);
begin
  FADXForm := aADXForm;
  FTreeNode.setADXForm(aADXForm);
end;

{ TA2CheckBox }

procedure TA2CheckBox.AdxPaint;
var
  R: TRect;
begin
  if (csDesigning in ComponentState) then exit;
  if Assigned(FADXForm) = false then EXIT;
  if not Visible then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;

  R := Self.ClientRect;
  OffsetRect(R, left, top);
  if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);

  if Enabled = FALSE then
  begin
    if FEnabledImage = nil then EXIT;

    FADXForm.FSurface.DrawImage(FEnabledImage, R.Left, R.Top, Transparent);
  end
  else if Checked then
  begin
    if FSelectImage = nil then EXIT;
    FADXForm.FSurface.DrawImage(FSelectImage, R.Left, R.Top, Transparent);
  end
  else if Checked = FALSE then
  begin
    if FSelectNotImage = nil then exit;
    FADXForm.FSurface.DrawImage(FSelectNotImage, R.Left, R.Top, Transparent);
  end;

end;

constructor TA2CheckBox.Create(AOwner: TComponent);
begin
  inherited;
  FSelectImage := nil; //选择 图片
  FSelectNotImage := nil; //非选择 图片
  FEnabledImage := nil; //灰掉 静止使用

  FADXForm := nil;
  AutoSize := false;
  Caption := '';
end;

destructor TA2CheckBox.Destroy;
begin
  if FSelectImage <> nil then FSelectImage.Free; //选择 图片
  if FSelectNotImage <> nil then FSelectNotImage.free; //非选择 图片
  if FEnabledImage <> nil then FEnabledImage.free; //灰掉 静止使用
  if FADXForm <> nil then
  begin
        //        FADXForm.FComponentList.Remove(self);
    FADXForm := nil;
  end;
  inherited;
end;

procedure TA2CheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  Checked := not Checked;
end;

procedure TA2CheckBox.setFADXForm(Value: TA2Form);
begin
  if assigned(ADXForm) then ADXForm.Draw;
  FADXForm := Value;
  if assigned(ADXForm) then ADXForm.Draw;

end;

procedure TA2CheckBox.setEnabledImage(Value: TA2Image);
begin
  if FEnabledImage = nil then
    FEnabledImage := TA2Image.Create(Value.Width, Value.Height, 0, 0);

  FEnabledImage.Resize(Value.Width, Value.Height);
  FEnabledImage.DrawImage(Value, 0, 0, FALSE);
  Width := Value.Width;
  Height := Value.Height;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2CheckBox.setChecked(Value: boolean);
begin
  FChecked := Value;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2CheckBox.setSelectImage(Value: TA2Image);
begin
  if FSelectImage = nil then
    FSelectImage := TA2Image.Create(Value.Width, Value.Height, 0, 0);

  FSelectImage.Resize(Value.Width, Value.Height);
  FSelectImage.DrawImage(Value, 0, 0, FALSE);
  Width := Value.Width;
  Height := Value.Height;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2CheckBox.setSelectNotImage(Value: TA2Image);
begin
  if FSelectNotImage = nil then
    FSelectNotImage := TA2Image.Create(Value.Width, Value.Height, 0, 0);

  FSelectNotImage.Resize(Value.Width, Value.Height);
  FSelectNotImage.DrawImage(Value, 0, 0, FALSE);
  Width := Value.Width;
  Height := Value.Height;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2CheckBox.Loaded;
begin
  inherited;
  AutoSize := false;
  Caption := '';
end;

{ TA2Gauge }

procedure TA2Gauge._Draw;
var
  tempimgFore: TA2Image;
  x: integer;
begin
  try
    if (FCurValue > 0) and (FMaxValue > 0) then
      x := trunc((FCurValue / (FMaxValue - MinValue)) * Width)
    else x := 1;
    if x <= 0 then x := 1;
  except
    x := 1;
  end;

  tempimgFore := TA2Image.Create(x, Height, 0, 0);
  try
    FImageBack.Resize(Width, Height);
    FImageBack.Clear(ColorSysToDxColor(FBackColor));

    tempimgFore.Clear(ColorSysToDxColor(FForeColor));

    FImageBack.DrawImage(tempimgFore, 0, 0, false);
  finally
    tempimgFore.free;
  end;
  if assigned(ADXForm) then ADXForm.Draw;
end;

procedure TA2Gauge.AdxPaint;
var
  R: TRect;
begin
  if (csDesigning in ComponentState) then exit;
  if Assigned(FADXForm) = false then EXIT;
  if not Visible then exit;
  if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;
  if (FImageBack.Width <> Width) or (FImageBack.Height <> Height) then _Draw;

  R := Self.ClientRect;
  OffsetRect(R, left, top);
  if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
  FADXForm.FSurface.DrawImage(FImageBack, R.Left, R.Top, Transparent);
end;
{
var
    R               :TRect;
    tempimg         :TA2Image;
    tempimgFore     :TA2Image;
    x               :integer;
begin
    if (csDesigning in ComponentState) then exit;
    if Assigned(FADXForm) = false then EXIT;
    if not Visible then exit;
    if (Parent <> Owner) and (Parent.visible <> TRUE) then exit;

    R := Self.ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
    try
        if (FCurValue > 0) and (FMaxValue > 0) then
            x := trunc((FCurValue / (FMaxValue - MinValue)) * Width)
        else x := 1;
        if x <= 0 then x := 1;
    except
        x := 1;
    end;

    tempimgFore := TA2Image.Create(x, Height, 0, 0);
    tempimg := TA2Image.Create(Width, Height, 0, 0);
    try
        tempimg.Resize(Width, Height);
        tempimg.Clear(ColorSysToDxColor(FBackColor));
        tempimgFore.Clear(ColorSysToDxColor(FForeColor));
        tempimg.DrawImage(tempimgFore, 0, 0, false);
        FADXForm.FSurface.DrawImage(tempimg, R.Left, R.Top, true);
    finally
        tempimg.free;
        tempimgFore.free;
    end;
end;
}

procedure TA2Gauge.CMMouseEnter(var Message: TMessage);
begin
{    if Assigned(FADXForm) then
    begin
        FADXForm.FA2Hint.FVisible := FALSE;
        FADXForm.FA2Hint.setText('');
    end;}
end;

procedure TA2Gauge.CMMouseLeave(var Message: TMessage);
begin
{    if Assigned(FADXForm) then
    begin
        FADXForm.FA2Hint.FVisible := FALSE;
        FADXForm.FA2Hint.setText('');
    end;}
end;

constructor TA2Gauge.Create(AOwner: TComponent);
begin
  inherited;
  AutoSize := false;
  Caption := '';
  FImageBack := TA2Image.Create(32, 32, 0, 0); //背景
end;

destructor TA2Gauge.Destroy;
begin
  FImageBack.Free;
  inherited;
end;

procedure TA2Gauge.Loaded;
begin
  inherited;
  AutoSize := false;
  Caption := '';
  _Draw;
end;

procedure TA2Gauge.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  R: TRect;
begin
  inherited;

  if Assigned(FADXForm) then
  begin
    R := Self.ClientRect;
    OffsetRect(R, left, top);
    if Parent <> Owner then OffsetRect(R, Parent.Left, Parent.Top);
{        with FADXForm do
        begin
            FA2Hint.Fleft := r.Left + x;
            FA2Hint.Ftop := r.Top + y;
            FA2Hint.FVisible := true;
        end;}
  end;
end;

procedure TA2Gauge.SetBackColor(Value: TColor);
begin
  FBackColor := Value;
  _Draw;
end;

procedure TA2Gauge.SetForeColor(Value: TColor);
begin
  FForeColor := Value;
  _Draw;
end;

procedure TA2Gauge.SetMaxValue(Value: Integer);
begin
  FMaxValue := Value;
  _Draw;
end;

procedure TA2Gauge.SetMinValue(Value: Integer);
begin
  FMinValue := Value;
  _Draw;
end;

procedure TA2Gauge.SetProgress(Value: Integer);
begin
  FCurValue := Value;
  _Draw;
end;

end.

