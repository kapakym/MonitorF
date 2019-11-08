{%BuildWorkingDir E:\WorkProjects\Lazarus\MonitorF}
unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Grids,
  ComCtrls, StdCtrls, PopupNotifier, Menus, AsyncProcess, ActnList, CheckLst,
  FileCtrl, RDCWDirMonitor, ServiceManager, sqldb, sqldblib, db, mysql57conn,
  Types, unit4, IniFiles, eventlog, Unit2, Unit3, FileUtil, TAGraph, TASeries,
  ShellApi, process ;


type

  TMyDirScan = class(TDirMonitor) // Модифицируем класс
    private
    public
      DirControl : string;      // Храним путь который используется для мониторинга
      DirDatabase : string;     // Храним путь который пойдет в базу данных
  end;

  // Создаем свой таймер в отдельном потоке

  { MyTimer }

  MyTimer = class(TThread)
    private
    protected
    procedure Execute; override;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    CheckListBox1: TCheckListBox;
    CheckListBox2: TCheckListBox;
    DataSource1: TDataSource;
    DirMonitor1: TDirMonitor;
    EventLog1: TEventLog;
    FileListBox1: TFileListBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    IdleTimer1: TIdleTimer;
    ImageList1: TImageList;
    ImageList2: TImageList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MySQL57Connection1: TMySQL57Connection;
    ProgressBar1: TProgressBar;

    SelectDirectoryDialog1: TSelectDirectoryDialog;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    Timer2: TTimer;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    TrayIcon1: TTrayIcon;

    procedure Button1Click(Sender: TObject);
    procedure ControlBar1Click(Sender: TObject);
    procedure CoolBar1Change(Sender: TObject);
    procedure DirMonitor1Change(sender: TObject; fAction: TAction;
      FileName: string);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure PopupNotifier1Close(Sender: TObject; var CloseAction: TCloseAction
      );
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure ZConnection1AfterConnect(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  today, starttd, ArcDate : TDateTime;
    MyList : TList;
    nact1, nint, nactold, nstop : Int64;
      TimeZip : Cardinal;
       launch : boolean;

implementation

{$R *.lfm}

{ MyTimer }

procedure MyTimer.Execute;
begin

end;

{ TForm1 }




procedure TForm1.CoolBar1Change(Sender: TObject);
begin

end;

procedure TForm1.ControlBar1Click(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);

  Var
  ArcName, output : AnsiString;
  i : Integer;
  intFileAge: LongInt;
  Result, OldDate : TDateTime;
  Dindex : integer;
  Aprocess : TProcess;
begin
  if Form1.MySQL57Connection1.Connected then
  begin
   SQLQuery2.Close;
   SQLQuery2.Clear;
   SQLQuery2.SQL.Clear;
   SQLQuery2.SQL.Add('SELECT * FROM '+Form2.Edit4.Text+' WHERE datetime > '+#39+FormatDateTime('yyyy-mm-dd hh:mm:ss',ArcDate) +#39+' GROUP BY filename;');

   SQLQuery2.Open;
   //if not SQLQuery2.RecordCount>0 then ShowMessage(IntToStr(SQLQuery2.RecordCount));
   while not SQLQuery2.EOF do
   begin
    ArcName:=ExtractFileName(SQLQuery2.FieldValues['filename']);
      if FileExists(SQLQuery2.FieldValues['filename']) then
      begin
      CreateDir(Form2.Edit6.Text+'\'+ArcName); // Создаем папку для хранения копий изменненных файлов
      FileListBox1.Directory:=Form2.Edit6.Text+'\'+ArcName;
      FileListBox1.UpdateFileList;
      Form3.Memo1.Lines.Add(IntToStr(FileListBox1.Count));
      ArcName:=Form2.Edit9.Text+' '+Form2.Edit8.Text+' '+Form2.Edit6.Text+'\'+ArcName+'\'+ArcName +'_'+FormatDateTime('yyyy-mm-dd_hh-mm-ss', today)+'.zip '+SQLQuery2.FieldValues['filename'];
      Form3.Memo1.Lines.Add(ArcName);
      // Добавление очередной архивной копии файла в хранилище
      Aprocess := TProcess.Create(nil);
      Aprocess.CommandLine:=ArcName;
      Aprocess.Options:=[poWaitOnExit, poNoConsole];
//      Aprocess.p;
      Aprocess.Execute;
      Aprocess.Free;
      //RunCommand(ArcName,output);
      Form3.Memo1.Lines.Add(output);
         // Удаление более старой копии файла
      if FileListBox1.Count > (StrToInt(Form2.Edit10.Text)-1) then
      begin
        OldDate:=Now;
        for i:=0 to FileListBox1.Count-1 do
        begin
          intFileAge := FileAge(FileListBox1.Directory+'\'+FileListBox1.Items.Strings[i]);
          Result := FileDateToDateTime(intFileAge);
          if OldDate>Result then
          begin
            OldDate:=Result;
            Dindex:=i;
          end;
        end;
        Form3.Memo1.Lines.Add('Удаление файла: '+ FileListBox1.Directory+'\'+FileListBox1.Items.Strings[Dindex]+' '+FormatDateTime('YY-MM-DD hh:mm:ss',OldDate));
        DeleteFile(FileListBox1.Directory+'\'+FileListBox1.Items.Strings[Dindex]);
      end;
    end;
    SQLQuery2.Next;
   end;



  end else
  begin
    ShowMessage('ОШИБКА: Отсутсвует соедениение с базой данных!');
    Form1.EventLog1.Error('<ОШИБКА> Отсутсвует соедениение с базой данных!');
  end;
  ArcDate:=Now;
end;

function FileSize(fileName : wideString) : Int64;
 var
   sr : TSearchRec;
 begin
   if FindFirst(fileName, faAnyFile, sr ) = 0 then
      result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
   else
      result := -1;

   FindClose(sr) ;
 end;

function MakeMemSize(Size: int64): String;
const
  kb=1024;
  mb=kb*kb;
  gb=mb*kb;
begin
  case Size of
    0..kb-1:Result:=IntToStr(size)+' Байт';
    kb..mb-1:Result:=Format('%.2f КБ',[Size/kb]);
    mb..gb-1:Result:=Format('%.2f МБ',[Size/mb]);
  else
    Result:=Format('%.2f ГБ',[Size/gb]);
  end;
end;

procedure TForm1.DirMonitor1Change(sender: TObject; fAction: TAction; FileName: string);
var
  MyRect : TRect;

  myFile : TFileStream;
  size : int64;
  i, myAction : integer;


begin
  // Обработчик изменений файловой системы
  Timer1.Enabled:=true;
  nstop:=0;
  nact1:=nact1+1;
  StatusBar1.Panels[0].Text:='Запущено потоков: '+IntToStr(nact1);
  // Добавляем поддержку кирилицы в пути к контролируемой папке
 // if  SelectDirectoryDialog1.FileName[Length(SelectDirectoryDialog1.FileName)] <> '\' then
  FileName:=(Sender as TMyDirScan).DirDatabase+FileName;// else FileName:=SelectDirectoryDialog1.FileName+FileName;

  // Фильтр
  for i:=0 to CheckListBox2.Count-1 do
  begin
      if ExtractFilePath(FileName) = CheckListBox2.Items[i] then Exit;
      if ExtractFilePath(FileName)+'\' = CheckListBox2.Items[i] then Exit;
  end;

  size:=FileSize(FileName);  // Вычисление размера файла
  StringGrid1.RowCount:=StringGrid1.RowCount+1;
  today:=Now;


  // Текущее время
  StringGrid1.Cells[0,StringGrid1.RowCount-1]:=DateToStr(today)+' '+TimeToStr(today);

  case fAction of
       faADDED :
         begin
           StringGrid1.Cells[1,StringGrid1.RowCount-1]:='Создание';
           StringGrid1.Cells[2,StringGrid1.RowCount-1]:=FileName;
           StringGrid1.Cells[3,StringGrid1.RowCount-1]:=MakeMemSize(size);
         end;
       faMODIFIED :
         begin
           StringGrid1.Cells[1,StringGrid1.RowCount-1]:='Изменение';
           StringGrid1.Cells[2,StringGrid1.RowCount-1]:=FileName;
           StringGrid1.Cells[3,StringGrid1.RowCount-1]:=MakeMemSize(size);;
         end;

       faREMOVED :
         begin
           StringGrid1.Cells[1,StringGrid1.RowCount-1]:='Удаление';
           StringGrid1.Cells[2,StringGrid1.RowCount-1]:=FileName;
           StringGrid1.Cells[3,StringGrid1.RowCount-1]:=MakeMemSize(size);
         end;
       faRENAMED_NEW_NAME :
         begin
           StringGrid1.Cells[1,StringGrid1.RowCount-1]:='Переименование';
           StringGrid1.Cells[2,StringGrid1.RowCount-1]:=FileName;
           StringGrid1.Cells[3,StringGrid1.RowCount-1]:=MakeMemSize(size);;
         end;
       faRENAMED_OLD_NAME :
         begin
           StringGrid1.Cells[1,StringGrid1.RowCount-1]:='Переименование';
           StringGrid1.Cells[2,StringGrid1.RowCount-1]:=FileName;
           StringGrid1.Cells[3,StringGrid1.RowCount-1]:=MakeMemSize(size);;
         end;
  end;
  if MySQL57Connection1.Connected then
  begin
    case StringGrid1.Cells[1,StringGrid1.RowCount-1] of
        'Удаление':  myAction:=1;
        'Изменение': myAction:=2;
        'Переименование': myAction:=3;
        'Создание': myAction:=4;
   end;
   if myAction>1 then
   begin
    Form1.SQLQuery1.Active:=false;
    SQLQuery1.SQL.Add('INSERT INTO '+Form2.Edit3.Text+'.'+Form2.Edit4.Text);
    SQLQuery1.SQL.Add('(datetime, action, filename, filesize)');
    FileName :=StringReplace(FileName,'\','\\\',[rfReplaceAll, rfIgnoreCase]);
    SQLQuery1.SQL.Add('VALUES ('+#39+FormatDateTime('yyyy-mm-dd hh:mm:ss', today )+#39+', '+#39+intToStr(myAction)+#39+
    ', '+#39+FileName+#39+', '+#39+IntToStr(size)+#39+');');
    Form1.SQLQuery1.ExecSQL;
    Form1.SQLQuery1.SQL.Clear;
    SQLTransaction1.Commit;
   end;
  end;

end;

procedure TForm1.FormActivate(Sender: TObject);
Var
  myINI : TIniFile;
  pp : Real;
begin
  //ArcDate:=now;
  if launch=False then
  begin
    EventLog1.LogType:=ltFile;
    EventLog1.FileName:='monitorF.log';
    EventLog1.Active:=true;
    if FileExists(ExtractFilePath(ParamStr(0))+'monitor.ini') then
    begin
      myINI := TIniFile.Create(ExtractFilePath(ParamStr(0))+'monitor.ini');
     Form2.Edit1.Text:=myINI.ReadString('Database','hostname', 'localhost');
     Form2.Edit2.Text:=myINI.ReadString('Database','username', 'root');
     Form2.MaskEdit1.Text:=myINI.ReadString('Database','password', 'rootroot');
     Form2.Edit3.Text:=myINI.ReadString('Database','basename', 'monitor');
     Form2.Edit4.Text:=myINI.ReadString('Database','tablename', 'tab_1');
     Form2.Edit5.Text:=IntToStr(myINI.ReadInteger('Database','port', 3306));
     Form2.Edit6.Text:=myINI.ReadString('warehouse','path', 'C:\warehouse');
     Form2.Edit8.Text:=myINI.ReadString('warehouse','paramzip', 'u -ssw -mx1 -r0');
     Form2.Edit9.Text:=myINI.ReadString('warehouse','cmdzip', '7z.exe');
     Form2.Edit7.Text:=FloatToStr(myINI.ReadFloat('warehouse','timeatak', 1000));
     Form2.TrackBar1.Position:=myINI.ReadInteger('warehouse','patak', 1);
     Form2.Edit10.Text:= IntToStr(myINI.ReadInteger('warehouse','level',2));
     Form2.CheckBox1.Checked:=myINI.ReadBool('warehouse','allzip',false);
     case Form2.TrackBar1.Position of
       1 : pp:=0.9;
       2 : pp:=0.95;
       3 : pp:=0.99;
     end;
     TimeZip := -1*trunc(StrToInt(Form2.Edit7.Text)*ln(pp));
     ProgressBar1.Min:=0;
     ProgressBar1.Max:=TimeZip;
     myINI.Free;
    end
    else
    begin
      ShowMessage('Конфигурационный файл не найден!');
      EventLog1.Error('<ОШИБКА> Конфигурационный файл не найден!');
      Form2.Button2.Enabled:=false;
      Form2.ShowModal;
      Form2.Button2.Enabled:=true;
    end;
      launch:=true;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  nact1:=0;
  nstop:=0;
  nint:=0;
  nactold:=0;
  DragAcceptFiles(Handle, true);
  starttd:=now;
end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of String);
var
  i, j : integer;
  FileName : String;
begin
  for i:=0 to Length(FileNames) -1 do
  begin
     FileName := FileNames[i];
     if DirectoryExists(FileName) then
     begin
       if  FileName[Length(FileName)] <> '\' then FileName:=FileName+'\';
       if CheckListBox1.Items.IndexOf(FileName)=-1 then
        CheckListBox1.AddItem(FileName,nil);

     end;
  end;


end;

procedure TForm1.FormResize(Sender: TObject);
begin
  CheckListBox1.Width:=Width div 2;
  GroupBox1.Width:=Width div 2;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  if Form1.WindowState = wsMinimized then begin
      form1.WindowState := wsNormal;
      form1.Hide;
      Form1.ShowInTaskBar := stNever;
      end;

end;

procedure TForm1.GroupBox2Click(Sender: TObject);
begin

end;

procedure TForm1.IdleTimer1Timer(Sender: TObject);
Var
  pp:Real;
begin
 if TimeZip<0 then
 begin
   case Form2.TrackBar1.Position of
         1 : pp:=0.9;
         2 : pp:=0.95;
         3 : pp:=0.99;
    end;
    TimeZip := -1*trunc(StrToInt(Form2.Edit7.Text)*ln(pp));
    Button1Click(self);
 end;

 TimeZip:=TimeZip-1;
 ProgressBar1.Position:=TimeZip;
 StatusBar1.Panels[0].Text:='Резервирование данных через: '+IntToStr(TimeZip)+' c';
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Form2.ShowModal;
End;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  try
    MySQL57Connection1.Connected:=true;
    Form4.ShowModal;
  except
    ShowMessage('ОШИБКА: Отсутствует подключение к базе данных!');
    EventLog1.Error('<ОШИБКА> Отсутствует подключение к базе данных!');
  end;

end;



procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  //SelectDirectoryDialog1.Execute;
  //EventLog1.Log('Выбор папки');
 // DirMonitor1.Directory:=ExtractShortPathNameUTF8(SelectDirectoryDialog1.FileName);
  //StatusBar1.Panels[0].Text:='Папка: '+SelectDirectoryDialog1.FileName;

end;

procedure TForm1.MenuItem5Click(Sender: TObject);
var
  CD : TMyDirScan;
  i:integer;
  t : TButton;
  ArcName : String;
  output : AnsiString;
begin
  // Запуск монитора
  Timer1.Enabled:=true;
 // Timer2.Enabled:=true;
  IdleTimer1.Enabled:=true;
  ArcDate:=Now;
  IdleTimer1.Enabled:=true;
  MySQL57Connection1.HostName:=Form2.Edit1.Text;
  MySQL57Connection1.UserName:=Form2.Edit2.Text;
  MySQL57Connection1.Password:=Form2.MaskEdit1.Text;
  try
    MySQL57Connection1.Connected:=true;
  except;
    ShowMessage('Соединение с базой данных не установлено!');
    EventLog1.Error('<ОШИБКА> Соединение с базой данных не установлено!');
  end;
  CheckListBox1.Enabled:=false;
  MyList := TList.Create;

  for i:= 0 to CheckListBox1.Count-1 do
  begin
    // Запуск монитора согласно списка
    EventLog1.Log('Запуск монитора в директории: '+CheckListBox1.Items[i]);
    ArcName:=StringReplace(CheckListBox1.Items[i],'\','',[rfReplaceAll, rfIgnoreCase]);
    ArcName:=StringReplace(ArcName,':','',[rfReplaceAll, rfIgnoreCase]);
    if Form2.CheckBox1.Checked then
    begin
      ArcName:=Form2.Edit9.Text+' '+Form2.Edit8.Text+' '+Form2.Edit6.Text+'\'+ArcName +' '+CheckListBox1.Items[i];
      RunCommand(ArcName,output);
    end;
    //SysUtils.ExecuteProcess(ArcName,'');
    //ShowMessage(Form2.Edit9.Text+' '+Form2.Edit8.Text+' '+Form2.Edit6.Text+'\'+ArcName +' '+CheckListBox1.Items[i]);
    Form3.Memo1.Lines.Add(output);
    CD := TMyDirScan.Create(nil);
    CD.Directory:=ExtractShortPathNameUTF8(CheckListBox1.Items[i]);
    CD.DirDatabase:=CheckListBox1.Items[i];
    CD.OnChange:=@DirMonitor1Change;
    CD.FilterAction:=[faADDED,  faMODIFIED, faREMOVED, faRENAMED_NEW_NAME, faRENAMED_OLD_NAME] ;
    CD.FilterNotification:=[nfATTRIBUTES, nfCREATION, nfDIR_NAME, nfFILE_NAME, nfLAST_ACCESS, nfLAST_WRITE, nfSECURITY, nfSIZE];
    CD.WatchSubtree:=true;
    CD.Name:='dir'+IntToStr(i);
    CD.Active:= true;
    MyList.Add(CD);
    StatusBar1.Panels[0].Text:='Запущено потоков: '+IntToStr(i+1);
  end;
  ToolButton1.Enabled:=false;
  ToolButton3.Enabled:=true;
  MenuItem5.Enabled:=false;
  MenuItem6.Enabled:=true;;
  ToolButton10.Enabled:=false;
  ToolButton11.Enabled:=false;
  ToolButton12.Enabled:=false;
  ToolButton13.Enabled:=false;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
Var
  i : integer;
begin
  Timer1.Enabled:=false;
  Timer2.Enabled:=false;
  IdleTimer1.Enabled:=false;
  Chart1LineSeries1.Clear;
  for i:=0 to MyList.Count-1 do
  begin
     StatusBar1.Panels[0].Text:='Остановка потоков: '+IntToStr(i+1);
   //  MyList.Items[i]
     TMyDirScan(MyList.Items[i]).Active := false;
     MyList.Delete(i);
  end;
  ToolButton1.Enabled:=true;
  ToolButton3.Enabled:=false;
  MenuItem5.Enabled:=true;
  MenuItem6.Enabled:=false;
  ToolButton10.Enabled:=true;
  ToolButton11.Enabled:=true;
  ToolButton12.Enabled:=true;
  ToolButton13.Enabled:=true;

  EventLog1.Log('Монитор остановлен');
  SQLQuery1.Close;
  SQLTransaction1.Commit;
  CheckListBox1.Enabled:=true;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
 // DirMonitor1.Active:=false;
  Close;
end;

procedure TForm1.PopupNotifier1Close(Sender: TObject;
  var CloseAction: TCloseAction);
begin

end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
//  InflateRect(Rect,1,1);
   if aRow>0 then
   begin
   case StringGrid1.Cells[aCol,aRow] of
        'Удаление':
        begin
          StringGrid1.Canvas.Brush.Color:=clRed;
          StringGrid1.Canvas.FillRect(aRect);
          StringGrid1.Canvas.Font.Color:=clYellow;
          StringGrid1.Canvas.TextOut(aRect.Left,aRect.Top,StringGrid1.Cells[Acol,Arow]);
        end;
        'Изменение':
        begin
          StringGrid1.Canvas.Brush.Color:=clGreen;
          StringGrid1.Canvas.FillRect(aRect);
          StringGrid1.Canvas.Font.Color:=clYellow;
          StringGrid1.Canvas.TextOut(aRect.Left,aRect.Top,StringGrid1.Cells[Acol,Arow]);
        end;
        'Переименование':
        begin
          StringGrid1.Canvas.Brush.Color:=clBlack;
          StringGrid1.Canvas.FillRect(aRect);
          StringGrid1.Canvas.Font.Color:=clYellow;
          StringGrid1.Canvas.TextOut(aRect.Left,aRect.Top,StringGrid1.Cells[Acol,Arow]);
        end;
        'Создание':
        begin
          StringGrid1.Canvas.Brush.Color:=clBlue;
          StringGrid1.Canvas.FillRect(aRect);
          StringGrid1.Canvas.Font.Color:=clYellow;
          StringGrid1.Canvas.TextOut(aRect.Left,aRect.Top,StringGrid1.Cells[Acol,Arow]);
        end; else

          StringGrid1.Canvas.Brush.Color:=clWhite;
          StringGrid1.Canvas.FillRect(aRect);
          StringGrid1.Canvas.Font.Color:=clBlack;
          StringGrid1.Canvas.TextOut(aRect.Left,aRect.Top,StringGrid1.Cells[Acol,Arow]);
   end;

   end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Chart1LineSeries1.AddXY(nint,nact1);
 // DebugLn(nact);
  if nact1=nactold then
  begin
    nact1:=0;
  end;
  nstop:=nstop+1;
  if nstop>6 then Timer1.Enabled:=false;
    nactold:=nact1;
   nint:=nint+1;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
Var
  ArcName, output : AnsiString;
  i : Integer;
  intFileAge: LongInt;
  Result, OldDate : TDateTime;
  Dindex : integer;
  Aprocess : TProcess;
begin
  if Form1.MySQL57Connection1.Connected then
  begin
   SQLQuery2.Close;
   SQLQuery2.Clear;
   SQLQuery2.SQL.Clear;
   SQLQuery2.SQL.Add('SELECT * FROM '+Form2.Edit4.Text+' WHERE datetime > '+#39+FormatDateTime('yyyy-mm-dd hh:mm:ss',ArcDate) +#39+' GROUP BY filename;');

   SQLQuery2.Open;
   //if not SQLQuery2.RecordCount>0 then ShowMessage(IntToStr(SQLQuery2.RecordCount));
   while not SQLQuery2.EOF do
   begin
    ArcName:=ExtractFileName(SQLQuery2.FieldValues['filename']);
      if FileExists(SQLQuery2.FieldValues['filename']) then
      begin
      CreateDir(Form2.Edit6.Text+'\'+ArcName); // Создаем папку для хранения копий изменненных файлов
      FileListBox1.Directory:=Form2.Edit6.Text+'\'+ArcName;
      FileListBox1.UpdateFileList;
      Form3.Memo1.Lines.Add(IntToStr(FileListBox1.Count));
      ArcName:=Form2.Edit9.Text+' '+Form2.Edit8.Text+' '+Form2.Edit6.Text+'\'+ArcName+'\'+ArcName +'_'+FormatDateTime('yyyy-mm-dd_hh-mm-ss', today)+'.zip '+SQLQuery2.FieldValues['filename'];
      Form3.Memo1.Lines.Add(ArcName);
      // Добавление очередной архивной копии файла в хранилище
      Aprocess := TProcess.Create(nil);
      Aprocess.CommandLine:=ArcName;
      Aprocess.Options:=[poWaitOnExit, poNoConsole];
//      Aprocess.p;
      Aprocess.Execute;
      Aprocess.Free;
      //RunCommand(ArcName,output);
      Form3.Memo1.Lines.Add(output);
         // Удаление более старой копии файла
      if FileListBox1.Count > (StrToInt(Form2.Edit10.Text)-1) then
      begin
        OldDate:=Now;
        for i:=0 to FileListBox1.Count-1 do
        begin
          intFileAge := FileAge(FileListBox1.Directory+'\'+FileListBox1.Items.Strings[i]);
          Result := FileDateToDateTime(intFileAge);
          if OldDate>Result then
          begin
            OldDate:=Result;
            Dindex:=i;
          end;
        end;
        Form3.Memo1.Lines.Add('Удаление файла: '+ FileListBox1.Directory+'\'+FileListBox1.Items.Strings[Dindex]+' '+FormatDateTime('YY-MM-DD hh:mm:ss',OldDate));
        DeleteFile(FileListBox1.Directory+'\'+FileListBox1.Items.Strings[Dindex]);
      end;
    end;
    SQLQuery2.Next;
   end;



  end else
  begin
    ShowMessage('ОШИБКА: Отсутсвует соедениение с базой данных!');
    Form1.EventLog1.Error('<ОШИБКА> Отсутсвует соедениение с базой данных!');
  end;
  ArcDate:=Now;
end;

procedure TForm1.ToolButton10Click(Sender: TObject);
begin
  // Добавление папки для мониторинга
  SelectDirectoryDialog1.Execute;
  EventLog1.Log('Добавление папки: '+SelectDirectoryDialog1.FileName);
  if  SelectDirectoryDialog1.FileName[Length(SelectDirectoryDialog1.FileName)] <> '\' then SelectDirectoryDialog1.FileName:=SelectDirectoryDialog1.FileName+'\';
  CheckListBox1.AddItem(SelectDirectoryDialog1.FileName,nil);
end;

procedure TForm1.ToolButton11Click(Sender: TObject);
var
  i : Integer;
begin
  i:=0;
  while i<CheckListBox1.Count do
   begin
     if CheckListBox1.Checked[i] then CheckListBox1.Items.Delete(i) else inc(i);
   end;

end;

procedure TForm1.ToolButton12Click(Sender: TObject);
begin
  CheckListBox1.CheckAll(cbChecked);
end;

procedure TForm1.ToolButton13Click(Sender: TObject);
begin
  CheckListBox1.CheckAll(cbUnchecked);
end;

procedure TForm1.ToolButton14Click(Sender: TObject);
begin
  SelectDirectoryDialog1.Execute;
  EventLog1.Log('Добавление папки в фильтр: '+SelectDirectoryDialog1.FileName);

  if  SelectDirectoryDialog1.FileName[Length(SelectDirectoryDialog1.FileName)] <> '\' then SelectDirectoryDialog1.FileName:=SelectDirectoryDialog1.FileName+'\';
  CheckListBox2.AddItem(SelectDirectoryDialog1.FileName,nil);
end;

procedure TForm1.ToolButton15Click(Sender: TObject);
var
i : Integer;
begin
i:=0;
while i<CheckListBox2.Count do
 begin
   if CheckListBox2.Checked[i] then CheckListBox2.Items.Delete(i) else inc(i);
 end;
end;

procedure TForm1.ToolButton16Click(Sender: TObject);
begin
  CheckListBox2.CheckAll(cbChecked);
end;

procedure TForm1.ToolButton17Click(Sender: TObject);
begin
  CheckListBox2.CheckAll(cbUnchecked);
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  MenuItem5Click(self);
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  MenuItem4Click(self);
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  MenuItem6Click(self);

end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.ToolButton7Click(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
  MenuItem3Click(self);

end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
  Form1.Show;
end;

procedure TForm1.ZConnection1AfterConnect(Sender: TObject);
begin

end;





end.

