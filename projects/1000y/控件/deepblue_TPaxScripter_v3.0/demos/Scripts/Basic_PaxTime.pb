Imports SysUtils, ExtCtrls, Forms

Dim Form = New TForm(NULL)
Form.Caption = "PAX Time"
Form.Canvas.Font.Height = 50
Form.Height = 100
Form.Width = 400

Dim Timer = New TTimer(Form)
Timer.Interval = 100
Timer.OnTimer = AddressOf ShowTime

Form.Show

DoNotDestroy Form

Sub ShowTime(Sender)
  Form.Canvas.TextOut 10, 10, DateTimeToStr(Now())
End Sub

