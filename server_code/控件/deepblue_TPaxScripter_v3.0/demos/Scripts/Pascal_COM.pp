var
  WordApp, Range: Variant;
  I: Integer;

WordApp := ActiveXObject.Create("Word.Application");
WordApp.Visible := true;
WordApp.Documents.Add;
Range := WordApp.Documents.Item[1].Range;
Range.Text := 'This is a column from a spreadsheet: ';
for I:= 0 to 3 do
  WordApp.Documents.Item[1].Paragraphs.Add();
Range := WordApp.Documents.Item[1].Range[WordApp.Documents.Item[1].Paragraphs.Item[3].Range.Start];
Range.Paste;
.

