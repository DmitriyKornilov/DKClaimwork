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
    MoneyGetNotNeedCheckBox: TCheckBox;
    MoneySendEdit: TCurrencyEdit;
    MoneyGetEdit: TCurrencyEdit;
    SaveButton: TSpeedButton;
    MoneySendCheckBox: TCheckBox;
    DT1: TDateTimePicker;
    MoneyGetCheckBox: TCheckBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MoneyGetCheckBoxChange(Sender: TObject);
    procedure MoneyGetNotNeedCheckBoxChange(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure MoneySendCheckBoxChange(Sender: TObject);
  private
    CanFormClose: Boolean;
    MoneyValue: Int64;
    procedure DataLoad;
    procedure MoneyGetControlsEnabled;
    procedure MoneySendControlsEnabled;
  public
    PretensionID: Integer;
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

procedure TMoneyDatesEditForm.MoneyGetNotNeedCheckBoxChange(Sender: TObject);
begin
  if not MoneyGetNotNeedCheckBox.Checked then
    MoneyGetCheckBox.Checked:= False;
  MoneyGetCheckBox.Enabled:= not MoneyGetNotNeedCheckBox.Checked;
end;

procedure TMoneyDatesEditForm.MoneySendCheckBoxChange(Sender: TObject);
begin
  MoneySendControlsEnabled;
end;

procedure TMoneyDatesEditForm.SaveButtonClick(Sender: TObject);
var
  SendValue, GetValue: Int64;
  SendDate, GetDate: TDate;
  Status: Integer;
begin
  CanFormClose:= False;

  SendValue:= 0;
  GetValue:= 0;
  SendDate:= 0;
  GetDate:= 0;
  Status:= 2;   //возмещение

  if MoneySendCheckBox.Checked then
  begin
    SendValue:= Trunc(100*MoneySendEdit.Value);
    if SendValue=0 then
    begin
      ShowInfo('Не указана сумма компенсации Потребителю!');
      Exit;
    end;
    SendDate:= DT1.Date;
  end;

  if MoneyGetCheckBox.Checked then
  begin
    GetValue:= Trunc(100*MoneyGetEdit.Value);
    if GetValue=0 then
    begin
      ShowInfo('Не указана сумма возмещения Производителем!');
      Exit;
    end;
    GetDate:= DT1.Date;
  end;

  if (MoneyGetNotNeedCheckBox.Checked and (SendValue=MoneyValue)) or
     ((SendValue=MoneyValue) and (GetValue=MoneyValue)) then
    Status:= 3;  //завершено

  SQLite.PretensionMoneyDatesUpdate(PretensionID, Status,
                                    SendValue, GetValue, SendDate, GetDate);

  CanFormClose:= True;
  ModalResult:= mrOK;
end;

procedure TMoneyDatesEditForm.DataLoad;
var
  S: String;
  i: Integer;
  SendValue, GetValue: Int64;
  SendDate, GetDate: TDate;
begin
  DT1.Date:= Date;
  DT2.Date:= Date;

  SQLite.PretensionInfoLoad(PretensionID, i, MoneyValue, S, SendDate{tmp});
  MoneySendEdit.Text:= PriceIntToStr(MoneyValue);
  MoneyGetEdit.Text:= PriceIntToStr(MoneyValue);

  SQLite.PretensionMoneyDatesLoad(PretensionID, SendValue, GetValue, SendDate, GetDate);

  MoneySendCheckBox.Checked:= SendDate>0;
  if SendDate>0 then
  begin
    DT1.Date:= SendDate;
    MoneySendEdit.Text:= PriceIntToStr(SendValue);
  end;
  MoneyGetCheckBox.Checked:= GetDate>0;
  if GetDate>0 then
  begin
    DT2.Date:= GetDate;
    MoneyGetEdit.Text:= PriceIntToStr(GetValue);
  end;
  MoneySendControlsEnabled;
  MoneyGetControlsEnabled;
end;

end.

