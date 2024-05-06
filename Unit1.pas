unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    XPManifest1: TXPManifest;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  myFile : TextFile;
  text, a : string;
  p, i: integer;
begin
if opendialog1.Execute then
  begin
    memo1.Lines.Clear;
    AssignFile(myFile, opendialog1.FileName);
    Reset(myFile);
    while not Eof(myFile) do
      begin
       ReadLn(myFile, a);
       text:=text+a+#13+#10;
      end;
    CloseFile(myFile);

    p:=pos('ick_Han', text);
    delete(text, 1, p+14);
    p:=pos('__Vectors_End', text);
    delete(text, p-2, length(text));

    p:=pos('DCD', text);
    delete(text, 1, p-17);

    text:=StringReplace(text, 'DCD', '', [rfReplaceAll, rfIgnoreCase]);
    text:=StringReplace(text, ';', '//', [rfReplaceAll, rfIgnoreCase]);
    text:=StringReplace(text, 'andler', 'andler,', [rfReplaceAll, rfIgnoreCase]);
    text:=StringReplace(text, ' 0', ' 0,', [rfReplaceAll, rfIgnoreCase]);

    memo2.Text:= text;

    for i:=0 to memo2.Lines.Count do
      begin
        p:=pos('ler,',memo2.Lines.Strings[i]);
        if p<>0 then
          begin
            memo1.lines.Add('void __attribute__ ((weak, alias ("Default_Handler")))');
            a:=Copy(memo2.Lines.Strings[i], 1, p+2);
            a:=StringReplace(a, ' ', '', [rfReplaceAll, rfIgnoreCase]);
            memo1.Lines.Add(a+'(void);');
            memo1.Lines.Add('');
          end;
        end;
    end;
end;

end.
