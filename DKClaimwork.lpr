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
  UNoticeEditForm, UNoteEditForm, rxnew, ULetterEditForm, ULetterStandardForm,
  URepairDatesEditForm, ULetterCustomForm, UAboutForm, UMoneyDatesEditForm
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

