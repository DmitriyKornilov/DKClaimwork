program DKClaimwork;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UMainForm, ULetters, USheets, Uutils, lazcontrols, datetimectrls,
  USQLite, UMotorEditForm, USenderEditForm, UReceiverEditForm, UImageEditForm,
  UNoteEditForm, rxnew, ULetterEditForm, ULetterStandardForm,
  URepairDatesEditForm, ULetterCustomForm, UAboutForm, UMoneyDatesEditForm,
  UStatisticForm, UMotorListForm, UReclamationForm, URepairForm,
  UPretensionForm, UReclamationEditForm, UMileageEditForm, URepairEditForm,
  UPretensionEditForm, UPretensionLetterForm, UPretensionLetterStandardForm,
  UAttachmentEditForm, UAttachmentForm
  { you can add units after this }
  , DK_Const, SysUtils;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  DefaultFormatSettings:= DefaultFormatSettingsRus;
  {$IFDEF WINDOWS}
  Application.{%H-}UpdateFormatSettings:= False;
  {$ENDIF}
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

