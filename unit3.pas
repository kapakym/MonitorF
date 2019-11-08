unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, Forms, Controls, Graphics, Dialogs, DBCtrls,
  DBGrids, Grids, StdCtrls, ExtCtrls, TAGraph, TASeries, unit4;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button2: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    DBGrid1: TDBGrid;
    SQLQuery1: TSQLQuery;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private

  public

  end;

var
  Form4: TForm4;
  jk : longint;


implementation
uses Unit1;
{$R *.lfm}

{ TForm4 }

procedure TForm4.Button1Click(Sender: TObject);
begin
  SQLQuery1.Close;
  SQLQuery1.Clear;
  SQLQuery1.SQL.Add('SELECT * FROM '+Form2.Edit4.Text+';');
  SQLQuery1.Open;
  Form1.SQLTransaction1.Commit;
end;

procedure TForm4.Button2Click(Sender: TObject);

begin
  StringGrid1.Clear;
  Chart1LineSeries1.Clear;
  if Form1.MySQL57Connection1.Connected then
  begin
    SQLQuery1.Close;
    SQLQuery1.Clear;
    SQLQuery1.SQL.Clear;
    SQLQuery1.SQL.Add('SELECT *, COUNT(filename) FROM '+Form2.Edit4.Text+' GROUP BY filename ORDER BY COUNT(filename) DESC;');
    SQLQuery1.Open;
    while not SQLQuery1.EOF do
    begin
       StringGrid1.RowCount:=StringGrid1.RowCount+1;
       StringGrid1.Cells[0, StringGrid1.RowCount-1] := SQLQuery1.FieldValues['filename'];
       StringGrid1.Cells[1, StringGrid1.RowCount-1] := IntToStr(SQLQuery1.FieldValues['COUNT(filename)']);
       SQLQuery1.Next;
    end;
    SQLQuery1.Close;
    SQLQuery1.Clear;
    SQLQuery1.SQL.Clear;
    SQLQuery1.SQL.Add('SELECT *, COUNT(datetime) FROM '+Form2.Edit4.Text+' GROUP BY DATE_FORMAT(datetime,'+#39+'%Y-%m-%d %H'+#39+' ) ORDER BY datetime DESC;');
    SQLQuery1.Open;
    jk :=0;
    while not SQLQuery1.EOF do
    begin
     //  StringGrid1.RowCount:=StringGrid1.RowCount+1;
     //  StringGrid1.Cells[0, StringGrid1.RowCount-1] := SQLQuery1.FieldValues['filename'];
     //  StringGrid1.Cells[1, StringGrid1.RowCount-1] := IntToStr(SQLQuery1.FieldValues['COUNT(filename)']);
       Chart1LineSeries1.AddXY(jk,SQLQuery1.FieldValues['COUNT(datetime)']);
       jk:=jk+1;
       SQLQuery1.Next;
    end;
  end else
  begin
    ShowMessage('ОШИБКА: Отсутсвует соедениение с базой данных!');
    Form1.EventLog1.Error('<ОШИБКА> Отсутсвует соедениение с базой данных!');
  end;

end;



end.

