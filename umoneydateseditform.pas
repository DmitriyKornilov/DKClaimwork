unit UMoneyDatesEditForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, rxcurredit, DateTimePicker, DividerBevel,

  DK_PriceUtils, DK_Dialogs,

  USQLite;

type

  { TMoneyDatesEditForm }

  TMoneyDatesEditForm = class(TForm)
    ButtonPanel: TPanel;
    CancelButton: TSpeedButton;
    DividerBevel1: TDividerBevel;
    DT2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MoneySendEdit: TCurrencyEdit;
    MoneyGetEdit: TCurrencyEdit;
    SaveButton: TSpeedButton;
    MoneySendCheckBox: TCheckBox;
    DT1: TDateTimePicker;
    MoneyGetCheckBox: TCheckBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MoneyGetCheckBoxChange(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure MoneySendCheckBoxChange(Sender: TObject);
  private
    CanFormClose: Boolean;
    MoneyValue: Int64;
    procedure DataLoad;
    procedure MoneyGetControlsEnabled;
    procedure MoneySendControlsEnabled;
  public
    LogID: Integer;
  end;

var
  MoneyDatesEditForm: TMoneyDatesEditForm;

implementation

{$R *.lfm}

{ TMoneyDatesEditForm }

procedure TMoneyDatesEditForm.CancelButtonClick(Sender: TObject);
begin
  CanFormClose:= True;
  ModalResult:= mrCancel;
end;

procedure TMoneyDatesEditForm.FormShow(Sender: TObject);
begin
  CanFormClose:= True;
  DataLoad;
end;

procedure TMoneyDatesEditForm.MoneyGetControlsEnabled;
begin
  Label3.Enabled:= MoneyGetCheckBox.Checked;
  DT2.Enabled:= Label3.Enabled;
  Label4.Enabled:= Label3.Enabled;
  MoneyGetEdit.Enabled:= Label3.Enabled;
end;

procedure TMoneyDatesEditForm.MoneySendControlsEnabled;
begin
  Label1.Enabled:= MoneySendCheckBox.Checked;
  DT1.Enabled:= Label1.Enabled;
  Label2.Enabled:= Label1.Enabled;
  MoneySendEdit.Enabled:= Label1.Enabled;
end;

procedure TMoneyDatesEditForm.MoneyGetCheckBoxChange(Sender: TObject);
begin
  MoneyGetControlsEnabled;
end;

procedure TMoneyDatesEditForm.MoneySendCheckBoxChange(Sender: TObject);
begin
  MoneySendControlsEnabled;
end;

procedure TMoneyDatesEditForm.SaveButtonClick(Sender: TObject);
var
  MoneySendValue, MoneyGetValue: Int64;
  MoneySendDate, MoneyGetDate: TDate;
  Status: Integer;
begin
  CanFormClose:= False;

  MoneySendValue:= 0;
  MoneyGetValue:= 0;
  MoneySendDate:= 0;
  MoneyGetDate:= 0;
  Status:= 0;   //не указано

  if MoneySendCheckBox.Checked then
  begin
    MoneySendValue:= Trunc(100*MoneySendEdit.Value);
    if MoneySendValue=0 then
    begin
      ShowInfo('Не указана сумма компенсации Потребителю!');
      Exit;
    end;
    MoneySendDate:= DT1.Date;
  end;
  if MoneyGetCheckBox.Checked then
  begin
    MoneyGetValue:= Trunc(100*MoneyGetEdit.Value);
    if MoneyGetValue=0 then
    begin
      ShowInfo('Не указана сумма возмещения Производителем!');
      Exit;
    end;
    MoneyGetDate:= DT1.Date;
  end;
  if (MoneySendValue=MoneyValue) and (MoneyGetValue=MoneyValue) then
    Status:= 3;  //завершено

  SQLite.PretensionMoneyUpdate(LogID, Status, MoneySendValue, MoneySendDate,
                                 MoneyGetValue, MoneyGetDate);

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TMoneyDatesEditForm.DataLoad;
var
  Status: Integer;
  MoneySendValue, MoneyGetValue: Int64;
  MoneySendDate, MoneyGetDate: TDate;
begin
  DT1.Date:= Date;
  DT2.Date:= Date;

  SQLite.PretensionInfoLoad(LogID, Status, MoneyValue);
  MoneySendEdit.Text:= PriceIntToStr(MoneyValue);
  MoneyGetEdit.Text:= PriceIntToStr(MoneyValue);

  SQLite.PretensionMoneyLoad(LogID, Status, MoneySendValue, MoneySendDate,
                             MoneyGetValue, MoneyGetDate);

  MoneySendCheckBox.Checked:= MoneySendDate>0;
  if MoneySendDate>0 then
  begin
    DT1.Date:= MoneySendDate;
    MoneySendEdit.Text:= PriceIntToStr(MoneySendValue);
  end;
  MoneyGetCheckBox.Checked:= MoneyGetDate>0;
  if MoneyGetDate>0 then
  begin
    DT2.Date:= MoneyGetDate;
    MoneyGetEdit.Text:= PriceIntToStr(MoneyGetValue);
  end;
  MoneySendControlsEnabled;
  MoneyGetControlsEnabled;
end;

end.

