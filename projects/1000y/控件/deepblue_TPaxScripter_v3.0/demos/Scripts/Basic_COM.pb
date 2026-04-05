Dim Range, WordApp = new ActiveXObject("Word.Application")
WordApp.Visible = true
WordApp.Documents.Add
Range = WordApp.Documents.Item(1).Range
Range.Text = "This is a column from a spreadsheet: "
For I = 0 to 3
  WordApp.Documents.Item(1).Paragraphs.Add
Next
Range = WordApp.Documents.Item(1).Range(WordApp.Documents.Item(1).Paragraphs.Item(3).Range.Start)
Range.Paste()

