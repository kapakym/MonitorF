unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MaskEdit,
  ComCtrls, IniFiles;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MaskEdit1: TMaskEdit;
    OpenDialog1: TOpenDialog;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation
Uses unit1;

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  //Создание новой таблицы в базе данных
  try
     Form1.MySQL57Connection1.Open;
     Button2.Enabled:=true;
     Close;
   except
    Button2.Enabled:=false;
    ShowMessage('ОШИБКА: Не удалось подключится к базе данных!');
    Form1.EventLog1.Error('<ОШИБКА> Не удалось подключится к базе данных!');
   end;
  if Form1.MySQL57Connection1.Connected=true then
  begin
    try
      Form1.SQLQuery1.Active:=false;
      Form1.SQLQuery1.SQL.Add('CREATE TABLE '+Edit4.Caption+' (');
      Form1.SQLQuery1.SQL.Add('datetime DATETIME NULL,');
      Form1.SQLQuery1.SQL.Add('action INT NULL,');
      Form1.SQLQuery1.SQL.Add('filename VARCHAR(5000) NULL,');
      Form1.SQLQuery1.SQL.Add('filesize INT NULL) COLLATE='+#39+'utf8_general_ci'+#39+';');
      Form1.SQLQuery1.ExecSQL;
      Form1.SQLQuery1.SQL.Clear;
      ShowMessage('Таблица создана');
    except
     ShowMessage('ОШИБКА: SQL запрос не выполнен!!!');
      Form1.EventLog1.Error('<ОШИБКА> SQL запрос не выполнен!!!');

    end;

  end;


end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  Form1.SelectDirectoryDialog1.Execute;
  Edit6.Text:=Form1.SelectDirectoryDialog1.FileName;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  //Создание новой таблицы в базе данных
  try
     Form1.MySQL57Connection1.Open;
     Button2.Enabled:=true;
     Close;
   except
    Button2.Enabled:=false;
    ShowMessage('ОШИБКА: Не удалось подключится к базе данных!');
    Form1.EventLog1.Error('<ОШИБКА> Не удалось подключится к базе данных!');
   end;
  if Form1.MySQL57Connection1.Connected=true then
  begin
    try
      Form1.SQLQuery1.Active:=false;
      Form1.SQLQuery1.SQL.Add('CREATE DATABASE '+Edit3.Text+';');

      Form1.SQLQuery1.ExecSQL;
      Form1.SQLQuery1.SQL.Clear;
      ShowMessage('База данных создана');
    except
     ShowMessage('ОШИБКА: SQL запрос не выполнен!!!');
      Form1.EventLog1.Error('<ОШИБКА> SQL запрос не выполнен!!!');

    end;

  end;
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
   Form1.SelectDirectoryDialog1.Execute;
  Edit9.Text:=Form1.SelectDirectoryDialog1.FileName;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

end;

procedure TForm2.GroupBox1Click(Sender: TObject);
begin

end;

procedure TForm2.TrackBar1Change(Sender: TObject);
begin
  case TrackBar1.Position of
    1 : Label11.Caption:='Низкая';
    2 : Label11.Caption:='Средняя';
    3 : Label11.Caption:='Высокая';
  end;
end;


procedure TForm2.Button1Click(Sender: TObject);
var
  myINI : TIniFile;
  Tim,pp : Real;
begin
   // Сохраняем настройки в ini файл
   myINI := TIniFile.Create(ExtractFilePath(ParamStr(0))+'monitor.ini');
   myINI.WriteString('Database','hostname', Form2.Edit1.Text);
   myINI.WriteString('Database','username', Form2.Edit2.Text);
   myINI.WriteString('Database','password', Form2.MaskEdit1.Text);
   myINI.WriteString('Database','basename', Form2.Edit3.Text);
   myINI.WriteString('Database','tablename', Form2.Edit4.Text);
   myINI.WriteInteger('Database','port', StrToInt(Form2.Edit5.Text));
   myINI.WriteString('warehouse','path', Form2.Edit6.Text);
   myINI.WriteString('warehouse','paramzip', Form2.Edit8.Text);
   myINI.WriteString('warehouse','cmdzip', Form2.Edit9.Text);
   myINI.WriteFloat('warehouse','timeatak', StrToFloat(Form2.Edit7.Text));
   myINI.WriteInteger('warehouse','patak', Form2.TrackBar1.Position);
   myINI.WriteInteger('warehouse','level',StrToInt(Edit10.Text));
   myINI.WriteBool('warehouse','allzip',CheckBox1.Checked);
   myINI.Free;
   Form1.MySQL57Connection1.Connected:=false;
   Form1.MySQL57Connection1.HostName:=Form2.Edit1.Text;
   Form1.MySQL57Connection1.UserName:=Form2.Edit2.Text;
   Form1.MySQL57Connection1.Password:=Form2.MaskEdit1.Text;
   Form1.MySQL57Connection1.DatabaseName:=Form2.Edit3.Text;
   Form1.MySQL57Connection1.Port:=StrToInt(Form2.Edit5.Text);
   case TrackBar1.Position of
     1 : pp:=0.9;
     2 : pp:=0.95;
     3 : pp:=0.99;
   end;
   TimeZip := -1*trunc(StrToInt(Edit7.Text)*ln(pp));
   Form1.ProgressBar1.Min:=0;
   Form1.ProgressBar1.Max:=TimeZip;
   //ShowMessage(FloatToStr(Tim));
   try
     Form1.MySQL57Connection1.Open;
     Button2.Enabled:=true;
     Close;
   except
    Button2.Enabled:=false;
    ShowMessage('ОШИБКА: Не удалось подключится к базе данных!');
    Form1.EventLog1.Error('<ОШИБКА> Не удалось подключится к базе данных!');
   end;

end;

end.

