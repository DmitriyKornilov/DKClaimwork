unit USQLite;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls,

  DK_SQLite3, DK_SQLUtils, DK_Vector, DK_StrUtils, DK_DateUtils,

  UUtils;

type

  { TSQLite }

  TSQLite = class (TSQLite3)
  public
    //справочники
    procedure MotorIDsAndNamesLoad(out AIDs: TIntVector; out ANames: TStrVector);
    procedure MotorIDsAndNamesLoad(AComboBox: TComboBox;
                                   out AIDs: TIntVector;
                                   const AKeyValueNotZero: Boolean = True);
    procedure LocationIDsAndNamesLoad(AComboBox: TComboBox;
                                   out AIDs: TIntVector;
                                   const AKeyValueNotZero: Boolean = True);
    procedure UserIDsAndNamesLoad(AComboBox: TComboBox;
                                   out AIDs: TIntVector;
                                   const AKeyValueNotZero: Boolean = True);
    function LocationNameLoad(const ALocationID: Integer): String;
    function LocationTitleLoad(const ALocationID: Integer): String;
    function UserNameILoad(const AUserID: Integer): String;
    function UserNameRLoad(const AUserID: Integer): String;
    function UserTitleLoad(const AUserID: Integer): String;

    //список двигателей в работе
    function MotorLastWritedLogID: Integer;
    procedure MotorLoad(const ALogID: Integer;
                         out AMotorNameID: Integer;
                         out AMotorName, AMotorNum: String;
                         out AMotorDate: TDate);

    procedure MotorAdd(const AMotorNameID: Integer;
                       const AMotorNum: String;
                       const AMotorDate: TDate);
    procedure MotorUpdate(const ALogID, AMotorNameID: Integer;
                           const AMotorNum: String;
                           const AMotorDate: TDate);
    procedure MotorDelete(const ALogID: Integer);
    function MotorFind(const AMotorSearchNameID: Integer;
                       const AMotorSearchNum: String;
                       const AMotorSearchDate: TDate;
                       out ALogID: Integer;
                       out AMotorName, AMotorNum: String;
                       out AMotorDate: TDate): Boolean;

    //рекламации
    procedure ReclamationInfoLoad(const ALogID: Integer; out AUserID, ALocationID: Integer);
    procedure ReclamationNoticeDelete(const ALogID: Integer);
    procedure ReclamationNoticeUpdate(const ALogIDs: TIntVector;
                                      const AUserID, ALocationID: Integer;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate);
    function ReclamationStatusLoad(const ALogID: Integer): Integer;


    //ремонты
    procedure RepairInfoLoad(const ALogID: Integer; out AUserID: Integer);
    procedure RepairNoticeDelete(const ALogID: Integer);
    procedure RepairNoticeUpdate(const ALogIDs: TIntVector;
                                  const AUserID: Integer;
                                  const ANoticeNum: String;
                                  const ANoticeDate: TDate);
    procedure RepairDatesLoad(const ALogID: Integer; out ABeginDate, AEndDate: TDate);
    procedure RepairDatesUpdate(const ALogID, AStatus: Integer; const ABeginDate, AEndDate: TDate);
    procedure RepairDatesDelete(const ALogID: Integer);
    function RepairStatusLoad(const ALogID: Integer): Integer;


    //претензии
    procedure PretensionInfoLoad(const ALogID: Integer; out AUserID: Integer; out AMoneyValue: Int64);
    procedure PretensionNoticeDelete(const ALogID: Integer);
    procedure PretensionNoticeUpdate(const ALogIDs: TIntVector;
                                     const AUserID: Integer;
                                     const AMoneyValue: Int64;
                                     const ANoticeNum: String;
                                     const ANoticeDate: TDate);
    procedure PretensionMoneyLoad(const ALogID: Integer; out AStatus: Integer;
                                 out AMoneySendValue: Int64; out AMoneySendDate: TDate;
                                 out AMoneyGetValue: Int64; out AMoneyGetDate: TDate);
    procedure PretensionMoneyUpdate(const ALogID, AStatus: Integer;
                                   const AMoneySendValue: Int64; const AMoneySendDate: TDate;
                                   const AMoneyGetValue: Int64; const AMoneyGetDate: TDate);
    procedure PretensionMoneyDelete(const ALogID: Integer);
    function PretensionStatusLoad(const ALogID: Integer): Integer;

    //двигатели и письма для ответа
    procedure MotorsWithoutNoticeLoad(const AThisLogID: Integer;
                                      const ALetterType: Byte;
                                      const ANeedOtherMotors: Boolean;
                                      out ALogIDs: TIntVector;
                                      out AMotorNames, AMotorNums: TStrVector;
                                      out AMotorDates: TDateVector);

    procedure MotorNoticeAnswerLoad(const ALogID, ALocationID, AUserID: Integer;
                                    const ALetterType: Byte;
                                    const AOldLetterNum: String;
                                    const AOldLetterDate: TDate;
                                    out ALogIDs: TIntVector;
                                    out AMotorNames, AMotorNums: TStrVector;
                                    out AMotorDates: TDateVector;
                                    out ANoticeNums: TStrVector;
                                    out ANoticeDates: TDateVector;
                                    out AAnswerNums: TStrVector;
                                    out AAnswerDates: TDateVector;
                                    out ALocationTitles, AUserTitles: TStrVector;
                                    out AMoneyValues: TInt64Vector);
    procedure MotorNoticeAnswerLoad(const ALogID: Integer;
                                    const ALetterType: Byte;
                                    out AMotorName, AMotorNum: String;
                                    out AMotorDate: TDate;
                                    out ANoticeNum: String;
                                    out ANoticeDate: TDate;
                                    out AAnswerNum: String;
                                    out AAnswerDate: TDate;
                                    out ALocationTitle, AUserTitle: String);

    //письма по рекламациям
    procedure ReclamationCancelNotNeed(const ALogIDs: TIntVector);
    procedure ReclamationCancelUpdate(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate);
    procedure ReclamationCancelDelete(const ALogID: Integer);

    procedure ReclamationReportNotNeed(const ALogIDs: TIntVector; const AStatus: Integer);
    procedure ReclamationReportUpdate(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
    procedure ReclamationReportDelete(const ALogID: Integer);

    //возврат двигателя на этапе расследования рекламации
    procedure MotorsReturn(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate);
    //ответ по ремонту
    procedure RepairAnswersToUserUpdate(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
    //ответ на претензию
    procedure PretensionAnswersToUserUpdate(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);

    //письма общие
    procedure LetterLoad(const ALogID: Integer; const ALetterType: Byte;
                         out ALetterNum: String;
                         out ALetterDate: TDate);
    procedure LetterDelete(const ALogID: Integer; const ALetterType: Byte);
    procedure LettersUpdate(const ALogIDs: TIntVector;
                           const ALetterType: Byte;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer = -1);
    procedure LettersNotNeed(const ALogIDs: TIntVector; const ALetterType: Byte);




    //изображения
    procedure ImageListLoad(out AImageIDs: TIntVector; out AImageNames: TStrVector);
    procedure ImageUpdate(const AImageID: Integer; const AFileName: String);
    function ImageLoad(const AImageID: Integer;
                       out ASourceFileExtension: String;
                       var AStream: TMemoryStream): Boolean;
    //отправители
    function SenderLastWritedID: Integer;
    procedure SenderAdd(const ASenderName, ASenderPost: String);
    procedure SenderUpdate(const ASenderID: Integer; const ASenderName, ASenderPost: String);
    procedure SenderLoad(const ASenderID: Integer; out ASenderName, ASenderPost: String);
    procedure SenderDelete(const ASenderID: Integer);
    procedure SenderListLoad(out ASenderIDs: TIntVector;
                             out ASenderNames, ASenderPosts: TStrVector);
    procedure SenderSignUpdate(const ASenderID: Integer; const AFileName: String);
    function SenderSignLoad(const ASenderID: Integer;
                            out ASourceFileExtension: String;
                             var AStream: TMemoryStream): Boolean;
    //получатели
    procedure OrganizationListLoad(const AOrganizationType: Byte;
                                   out AOrganizationIDs: TIntVector;
                                   out AOrganizationNames, AOrganizationTitles:  TStrVector);
    procedure ReceiverListLoad(const AOrganizationType: Byte;
                               const AOrganizationID: Integer;
                               out AReceiverIDs:  TIntVector;
                               out AReceiverNames, AReceiverPosts, AReceiverAppeals:  TStrVector);
    procedure ReceiverAdd(const AOrganizationType: Byte; const AOrganizationID: Integer;
                          const AReceiverName, AReceiverPost, AReceiverAppeal: String);
    procedure ReceiverUpdate(const AOrganizationType: Byte; const AReceiverID: Integer;
                          const AReceiverName, AReceiverPost, AReceiverAppeal: String);
    procedure ReceiverDelete(const AOrganizationType: Byte; const AReceiverID: Integer);
    function ReceiverLastWritedID(const AOrganizationType: Byte): Integer;

    //исполнители
    procedure PerformerListLoad(out APerformerIDs: TIntVector;
                                out APerformerNames, APerformerPhones, APerformerMails: TStrVector);
    //представители
    procedure DelegateListLoad(const ADelegateType: Byte;
                                out ADelegateIDs: TIntVector;
                                out ADelegateNameIs, ADelegateNameRs,
                                    ADelegatePhones, ADelegatePassports: TStrVector);

    //примечания
    procedure NoteLoad(const ALogID: Integer; const ACategory: Byte; out ANote: String);
    procedure NoteUpdate(const ALogID: Integer; const ACategory: Byte; const ANote: String);
    procedure NoteDelete(const ALogID: Integer; const ACategory: Byte);

    //весь список
    procedure DataLoad(const AMotorNumLike: String;
                       const AOrderIndex, AViewIndex: Integer;
                       const ABeginDate, AEndDate: TDate;
                       out ALogIDs: TIntVector;
                       out AMotorNames: TStrVector;
                       out AMotorNums: TStrVector;
                       out AMotorDates: TDateVector;
                       out AReclamationUserNames: TStrVector;
                       out AReclamationUserTitles: TStrVector;
                       out AReclamationLocationNames: TStrVector;
                       out AReclamationLocationTitles: TStrVector;
                       out AReclamationNoticeFromUserDates: TDateVector;
                       out AReclamationNoticeFromUserNums: TStrVector;
                       out AReclamationNoticeToBuilderDates: TDateVector;
                       out AReclamationNoticeToBuilderNums: TStrVector;
                       out AReclamationAnswerFromBuilderDates: TDateVector;
                       out AReclamationAnswerFromBuilderNums: TStrVector;
                       out AReclamationAnswerToUserDates: TDateVector;
                       out AReclamationAnswerToUserNums: TStrVector;
                       out AReclamationCancelDates: TDateVector;
                       out AReclamationCancelNums: TStrVector;
                       out AReclamationReportDates: TDateVector;
                       out AReclamationReportNums: TStrVector;
                       out AReclamationNotes: TStrVector;
                       out AReclamationStatuses: TIntVector;
                       out ARepairUserNames: TStrVector;
                       out ARepairUserTitles: TStrVector;
                       out ARepairNoticeFromUserDates: TDateVector;
                       out ARepairNoticeFromUserNums: TStrVector;
                       out ARepairNoticeToBuilderDates: TDateVector;
                       out ARepairNoticeToBuilderNums: TStrVector;
                       out ARepairAnswerFromBuilderDates: TDateVector;
                       out ARepairAnswerFromBuilderNums: TStrVector;
                       out ARepairAnswerToUserDates: TDateVector;
                       out ARepairAnswerToUserNums: TStrVector;
                       out ARepairBeginDates: TDateVector;
                       out ARepairEndDates: TDateVector;
                       out ARepairNotes: TStrVector;
                       out ARepairStatuses: TIntVector;
                       out APretensionUserNames: TStrVector;
                       out APretensionUserTitles: TStrVector;
                       out APretensionNoticeFromUserDates: TDateVector;
                       out APretensionNoticeFromUserNums: TStrVector;
                       out APretensionMoneyValues: TInt64Vector;
                       out APretensionNoticeToBuilderDates: TDateVector;
                       out APretensionNoticeToBuilderNums: TStrVector;
                       out APretensionAnswerFromBuilderDates: TDateVector;
                       out APretensionAnswerFromBuilderNums: TStrVector;
                       out APretensionAnswerToUserDates: TDateVector;
                       out APretensionAnswerToUserNums: TStrVector;
                       out APretensionMoneySendDates: TDateVector;
                       out APretensionMoneySendValues: TInt64Vector;
                       out APretensionMoneyGetDates: TDateVector;
                       out APretensionMoneyGetValues: TInt64Vector;
                       out APretensionNotes: TStrVector;
                       out APretensionStatuses: TIntVector
                       );
  end;

var
  SQLite: TSQLite;

implementation

{ TSQLite }

procedure TSQLite.MotorIDsAndNamesLoad(out AIDs: TIntVector; out ANames: TStrVector);
begin
  KeyPickList('MOTORNAMES', 'MotorNameID', 'MotorName', AIDs, ANames, True{ID>0});
end;

procedure TSQLite.MotorIDsAndNamesLoad(AComboBox: TComboBox;
                                   out AIDs: TIntVector;
                                   const AKeyValueNotZero: Boolean = True);
begin
  LoadIDsAndNames(AComboBox, AIDs,
                  'MOTORNAMES', 'MotorNameID', 'MotorName', 'MotorNameID',
                  AKeyValueNotZero, 'ВСЕ НАИМЕНОВАНИЯ');
end;

procedure TSQLite.LocationIDsAndNamesLoad(AComboBox: TComboBox;
                                   out AIDs: TIntVector;
                                   const AKeyValueNotZero: Boolean = True);
begin
  LoadIDsAndNames(AComboBox, AIDs,
                  'LOCATIONS', 'LocationID', 'LocationName', 'LocationName',
                  AKeyValueNotZero, 'ВСЕ НАИМЕНОВАНИЯ');
end;

procedure TSQLite.UserIDsAndNamesLoad(AComboBox: TComboBox;
                                   out AIDs: TIntVector;
                                   const AKeyValueNotZero: Boolean = True);
begin
  LoadIDsAndNames(AComboBox, AIDs,
                  'USERS', 'UserID', 'UserNameI', 'UserNameI',
                  AKeyValueNotZero, 'ВСЕ НАИМЕНОВАНИЯ');
end;

function TSQLite.MotorLastWritedLogID: Integer;
begin
  Result:= LastWritedInt32ID('LOGMOTORS');
end;

procedure TSQLite.MotorLoad(const ALogID: Integer;
                         out AMotorNameID: Integer;
                         out AMotorName, AMotorNum: String;
                         out AMotorDate: TDate);
begin
  AMotorNameID:= 0;
  AMotorName:= EmptyStr;
  AMotorNum:= EmptyStr;
  AMotorDate:= 0;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't1.MotorNameID, t1.MotorNum, t1.MotorDate, t2.MotorName ' +
    'FROM LOGMOTORS t1 ' +
    'INNER JOIN MOTORNAMES t2 ON (t1.MotorNameID = t2.MotorNameID) ' +
    'WHERE ' +
        't1.LogID = :LogID'
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AMotorNameID:= QFieldInt('MotorNameID');
    AMotorNum:= QFieldStr('MotorNum');
    AMotorDate:= QFieldDT('MotorDate');
    AMotorName:= QFieldStr('MotorName');
  end;
  QClose;
end;

procedure TSQLite.MotorAdd(const AMotorNameID: Integer;
                       const AMotorNum: String;
                       const AMotorDate: TDate);
var
  LogID: Integer;
  i: Byte;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'INSERT INTO ' +
        'LOGMOTORS ' +
        '(MotorNameID, MotorNum, MotorDate) ' +
      'VALUES ' +
        '(:MotorNameID, :MotorNum, :MotorDate) '
    );
    QParamInt('MotorNameID', AMotorNameID);
    QParamStr('MotorNum', AMotorNum);
    QParamDT('MotorDate', AMotorDate);
    QExec;

    LogID:= MotorLastWritedLogID;
    for i:= 1 to 3 do
    begin
      QSetSQL(
        'INSERT INTO ' + SqlEsc(LogTableNameGet(i)) +
          '(LogID) ' +
        'VALUES ' +
          '(:LogID) '
      );
      QParamInt('LogID', LogID);
      QExec;
    end;

    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.MotorUpdate(const ALogID, AMotorNameID: Integer;
                           const AMotorNum: String;
                           const AMotorDate: TDate);
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGMOTORS ' +
      'SET ' +
        'MotorNameID = :MotorNameID, MotorNum = :MotorNum, MotorDate = :MotorDate ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamInt('LogID', ALogID);
    QParamInt('MotorNameID', AMotorNameID);
    QParamStr('MotorNum', AMotorNum);
    QParamDT('MotorDate', AMotorDate);
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.MotorDelete(const ALogID: Integer);
begin
  Delete('LOGMOTORS', 'LogID', ALogID);
end;

function TSQLite.MotorFind(const AMotorSearchNameID: Integer;
                       const AMotorSearchNum: String;
                       const AMotorSearchDate: TDate;
                       out ALogID: Integer;
                       out AMotorName, AMotorNum: String;
                       out AMotorDate: TDate): Boolean;
begin
  Result:= False;
  ALogID:= 0;
  AMotorName:= EmptyStr;
  AMotorNum:= EmptyStr;
  AMotorDate:= 0;
  QSetSQL(
    'SELECT ' +
      't1.LogID, t1.MotorNameID, t1.MotorNum, t1.MotorDate, t2.MotorName ' +
    'FROM ' +
      'LOGMOTORS t1 ' +
    'INNER JOIN MOTORNAMES t2 ON (t1.MotorNameID=t2.MotorNameID) ' +
    'WHERE' +
      '(t1.MotorNameID=:MotorNameID) AND (UPPER(MotorNum)=:MotorNum) AND ' +
      '(t1.MotorDate BETWEEN :BD AND :ED)'
  );
  QParamInt('MotorNameID', AMotorSearchNameID);
  QParamStr('MotorNum', SUpper(AMotorSearchNum));
  QParamDT('BD', FirstDayInYear(AMotorSearchDate));
  QParamDT('ED', LastDayInYear(AMotorSearchDate));
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    Result:= True;
    ALogID:= QFieldInt('LogID');
    AMotorName:= QFieldStr('MotorName');
    AMotorNum:= QFieldStr('MotorNum');
    AMotorDate:= QFieldDT('MotorDate');
  end;
  QClose;
end;

function TSQLite.LocationNameLoad(const ALocationID: Integer): String;
begin
  Result:= ValueStrInt32ID('LOCATIONS', 'LocationName', 'LocationID', ALocationID);
end;

function TSQLite.LocationTitleLoad(const ALocationID: Integer): String;
begin
  Result:= ValueStrInt32ID('LOCATIONS', 'LocationTitle', 'LocationID', ALocationID);
end;

function TSQLite.UserNameILoad(const AUserID: Integer): String;
begin
  Result:= ValueStrInt32ID('USERS', 'UserNameI', 'UserID', AUserID);
end;

function TSQLite.UserNameRLoad(const AUserID: Integer): String;
begin
  Result:= ValueStrInt32ID('USERS', 'UserNameR', 'UserID', AUserID);
end;

function TSQLite.UserTitleLoad(const AUserID: Integer): String;
begin
  Result:= ValueStrInt32ID('USERS', 'UserTitle', 'UserID', AUserID);
end;

procedure TSQLite.ReclamationInfoLoad(const ALogID: Integer;
                                      out AUserID, ALocationID: Integer);
begin
  AUserID:= 0;
  ALocationID:= 0;

  QSetSQL(
    'SELECT ' +
      'UserID, LocationID ' +
    'FROM ' +
      'LOGRECLAMATION ' +
    'WHERE ' +
      'LogID = :LogID'
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AUserID:= QFieldInt('UserID');
    ALocationID:= QFieldInt('LocationID');
  end;
  QClose;
end;

procedure TSQLite.ReclamationNoticeUpdate(const ALogIDs: TIntVector;
                                      const AUserID, ALocationID: Integer;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate);
var
  i: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGRECLAMATION ' +
      'SET ' +
        'UserID = :UserID, LocationID = :LocationID, Status = 1, ' +  {1 - расследование}
        'NoticeFromUserDate = :NoticeDate, NoticeFromUserNum = :NoticeNum ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamInt('LocationID', ALocationID);
    QParamInt('UserID', AUserID);
    QParamStr('NoticeNum', ANoticeNum);
    QParamDT('NoticeDate', ANoticeDate);
    for i:= 0 to High(ALogIDs) do
    begin
      QParamInt('LogID', ALogIDs[i]);
      QExec;
    end;
    QCommit;
  except
    QRollback;
  end;
end;

function TSQLite.ReclamationStatusLoad(const ALogID: Integer): Integer;
begin
  Result:= ValueInt32Int32ID('LOGRECLAMATION', 'Status', 'LogID', ALogID);
end;

procedure TSQLite.ReclamationNoticeDelete(const ALogID: Integer);
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGRECLAMATION ' +
      'SET ' +
        'UserID = 0, LocationID = 0, Status = 0, ' +
        'NoticeFromUserDate = NULL, NoticeFromUserNum = NULL ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamInt('LogID', ALogID);
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.RepairInfoLoad(const ALogID: Integer; out AUserID: Integer);
begin
  AUserID:= 0;

  QSetSQL(
    'SELECT ' +
      'UserID ' +
    'FROM ' +
      'LOGREPAIR ' +
    'WHERE ' +
      'LogID = :LogID'
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AUserID:= QFieldInt('UserID');
  end;
  QClose;
end;

procedure TSQLite.RepairNoticeUpdate(const ALogIDs: TIntVector;
                                  const AUserID: Integer;
                                  const ANoticeNum: String;
                                  const ANoticeDate: TDate);
var
  i: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGREPAIR ' +
      'SET ' +
        'UserID = :UserID, Status = 1, ' +   {1 - согласование}
        'NoticeFromUserDate = :NoticeDate, NoticeFromUserNum = :NoticeNum ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamInt('UserID', AUserID);
    QParamStr('NoticeNum', ANoticeNum);
    QParamDT('NoticeDate', ANoticeDate);
    for i:= 0 to High(ALogIDs) do
    begin
      QParamInt('LogID', ALogIDs[i]);
      QExec;
    end;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.RepairNoticeDelete(const ALogID: Integer);
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGREPAIR ' +
      'SET ' +
        'UserID = 0, Status = 0, ' +  {0 - не указано}
        'NoticeFromUserDate = NULL, NoticeFromUserNum = NULL ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamInt('LogID', ALogID);
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.RepairDatesLoad(const ALogID: Integer;  out ABeginDate, AEndDate: TDate);
begin
  ABeginDate:= 0;
  AEndDate:= 0;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'BeginDate, EndDate ' +
    'FROM ' +
      'LOGREPAIR ' +
    'WHERE ' +
        'LogID = :LogID'
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    ABeginDate:= QFieldDT('BeginDate');
    AEndDate:= QFieldDT('EndDate');
  end;
  QClose;
end;

procedure TSQLite.RepairDatesUpdate(const ALogID, AStatus: Integer; const ABeginDate, AEndDate: TDate);
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGREPAIR ' +
      'SET ' +
        'Status = :Status, ' +
        'BeginDate = :BeginDate, ' +
        'EndDate = :EndDate ' +
      'WHERE ' +
          'LogID = :LogID'
    );
    QParamInt('LogID', ALogID);
    QParamInt('Status', AStatus);
    QParamDT('BeginDate', ABeginDate, ABeginDate>0);
    QParamDT('EndDate', AEndDate, AEndDate>0);
    QExec;
    QCommit;
  except
    QRollback;
  end;


  //S:=
  //  'UPDATE ' +
  //    'LOGREPAIR ' +
  //  'SET ' +
  //    'Status = :Status, ';
  //if ABeginDate = 0 then
  //  S:= S + 'BeginDate = NULL, '
  //else
  //  S:= S + 'BeginDate = :BeginDate, ';
  //if AEndDate = 0 then
  //  S:= S + 'EndDate = NULL '
  //else
  //  S:= S + 'EndDate = :EndDate ';
  //S:= S +
  //  'WHERE ' +
  //      'LogID = :LogID';
  //
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(S);
  //  QParamInt('LogID', ALogID);
  //  QParamInt('Status', AStatus);
  //  if ABeginDate>0 then
  //    QParamDT('BeginDate', ABeginDate);
  //  if AEndDate>0 then
  //    QParamDT('EndDate', AEndDate);
  //  QExec;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.RepairDatesDelete(const ALogID: Integer);
var
  UserID, Status: Integer;
begin
  RepairInfoLoad(ALogID, UserID);
  Status:= 2*Ord(UserID>0); {если задан потребитель, то 2 - согласовано, если не задан - то 0 - не указано}
  RepairDatesUpdate(ALogID, Status, 0, 0);
end;

function TSQLite.RepairStatusLoad(const ALogID: Integer): Integer;
begin
  Result:= ValueInt32Int32ID('LOGREPAIR', 'Status', 'LogID', ALogID);
end;

procedure TSQLite.PretensionInfoLoad(const ALogID: Integer;
                   out AUserID: Integer; out AMoneyValue: Int64);
begin
  AUserID:= 0;
  AMoneyValue:= 0;

  QSetSQL(
    'SELECT ' +
      'UserID, MoneyValue ' +
    'FROM ' +
      'LOGPRETENSION ' +
    'WHERE ' +
      'LogID = :LogID'
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AUserID:= QFieldInt('UserID');
    AMoneyValue:= QFieldInt64('MoneyValue');
  end;
  QClose;
end;

procedure TSQLite.PretensionNoticeDelete(const ALogID: Integer);
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGPRETENSION ' +
      'SET ' +
        'UserID = 0, MoneyValue = NULL, Status = 0, ' +  {0 - не указано}
        'NoticeFromUserDate = NULL, NoticeFromUserNum = NULL ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamInt('LogID', ALogID);
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.PretensionNoticeUpdate(const ALogIDs: TIntVector;
                                      const AUserID: Integer;
                                      const AMoneyValue: Int64;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate);
var
  i: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGPRETENSION ' +
      'SET ' +
        'UserID = :UserID, MoneyValue = :MoneyValue, Status = 1, ' +   {1 - в работе}
        'NoticeFromUserDate = :NoticeDate, NoticeFromUserNum = :NoticeNum ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamInt64('MoneyValue', AMoneyValue);
    QParamInt('UserID', AUserID);
    QParamStr('NoticeNum', ANoticeNum);
    QParamDT('NoticeDate', ANoticeDate);
    for i:= 0 to High(ALogIDs) do
    begin
      QParamInt('LogID', ALogIDs[i]);
      QExec;
    end;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.PretensionMoneyLoad(const ALogID: Integer; out AStatus: Integer;
                                         out AMoneySendValue: Int64; out AMoneySendDate: TDate;
                                         out AMoneyGetValue: Int64; out AMoneyGetDate: TDate);
begin
  AMoneySendValue:= 0;
  AMoneySendDate:= 0;
  AMoneyGetValue:= 0;
  AMoneyGetDate:= 0;
  AStatus:= 0;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'MoneySendDate, MoneySendValue, MoneyGetDate, MoneyGetValue, Status ' +
    'FROM ' +
      'LOGPRETENSION ' +
    'WHERE ' +
        'LogID = :LogID'
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AStatus:= QFieldInt('Status');
    AMoneySendDate:= QFieldDT('MoneySendDate');
    AMoneySendValue:= QFieldInt64('MoneySendValue');
    AMoneyGetDate:= QFieldDT('MoneyGetDate');
    AMoneyGetValue:= QFieldInt64('MoneyGetValue');
  end;
  QClose;
end;

procedure TSQLite.PretensionMoneyUpdate(const ALogID, AStatus: Integer;
             const AMoneySendValue: Int64; const AMoneySendDate: TDate;
             const AMoneyGetValue: Int64; const AMoneyGetDate: TDate);
var
  S: String;
begin
  S:=
    'UPDATE ' +
      'LOGPRETENSION ' +
    'SET ' +
    'MoneySendDate  = :MoneySendDate, ' +
    'MoneySendValue = :MoneySendValue, ' +
    'MoneyGetDate   = :MoneyGetDate, ' +
    'MoneyGetValue  = :MoneyGetValue ';
  if AStatus>0 then
    S:= S +
      ', Status = :Status ';
  S:= S +
    'WHERE ' +
        'LogID = :LogID';

  QSetQuery(FQuery);
  try
    QSetSQL(S);
    QParamInt('LogID', ALogID);
    QParamDT('MoneySendDate', AMoneySendDate, AMoneySendDate>0);
    QParamInt64('MoneySendValue', AMoneySendValue, AMoneySendValue>0);
    QParamDT('MoneyGetDate', AMoneyGetDate, AMoneyGetDate>0);
    QParamInt64('MoneyGetValue', AMoneyGetValue, AMoneyGetValue>0);
    if AStatus>0 then
      QParamInt('Status', AStatus);
    QExec;
    QCommit;
  except
    QRollback;
  end;
  //S:=
  //  'UPDATE ' +
  //    'LOGPRETENSION ' +
  //  'SET ';
  //if AStatus>0 then
  //  S:= S +
  //    'Status = :Status, ';
  //
  //if AMoneySendDate = 0 then
  //  S:= S + 'MoneySendDate = NULL, '
  //else
  //  S:= S + 'MoneySendDate = :MoneySendDate, ';
  //if AMoneySendValue = 0 then
  //  S:= S + 'MoneySendValue = NULL, '
  //else
  //  S:= S + 'MoneySendValue = :MoneySendValue, ';
  //
  //if AMoneyGetDate = 0 then
  //  S:= S + 'MoneyGetDate = NULL, '
  //else
  //  S:= S + 'MoneyGetDate = :MoneyGetDate, ';
  //if AMoneyGetValue = 0 then
  //  S:= S + 'MoneyGetValue = NULL '
  //else
  //  S:= S + 'MoneyGetValue = :MoneyGetValue ';
  //
  //S:= S +
  //  'WHERE ' +
  //      'LogID = :LogID';
  //
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(S);
  //  QParamInt('LogID', ALogID);
  //  if AStatus>0 then
  //    QParamInt('Status', AStatus);
  //  if AMoneySendDate>0 then
  //    QParamDT('MoneySendDate', AMoneySendDate);
  //  if AMoneySendValue > 0 then
  //    QParamInt64('MoneySendValue', AMoneySendValue);
  //  if AMoneyGetDate>0 then
  //    QParamDT('MoneyGetDate', AMoneyGetDate);
  //  if AMoneyGetValue > 0 then
  //    QParamInt64('MoneyGetValue', AMoneyGetValue);
  //  QExec;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.PretensionMoneyDelete(const ALogID: Integer);
var
  UserID, Status: Integer;
  MoneyValue: Int64;
begin
  PretensionInfoLoad(ALogID, UserID, MoneyValue);
  Status:= Ord(UserID>0);
  PretensionMoneyUpdate(ALogID, Status, 0, 0, 0, 0);
end;

function TSQLite.PretensionStatusLoad(const ALogID: Integer): Integer;
begin
  Result:= ValueInt32Int32ID('LOGPRETENSION', 'Status', 'LogID', ALogID);
end;

procedure TSQLite.MotorsWithoutNoticeLoad(const AThisLogID: Integer;
                                      const ALetterType: Byte;
                                      const ANeedOtherMotors: Boolean;
                                      out ALogIDs: TIntVector;
                                      out AMotorNames, AMotorNums: TStrVector;
                                      out AMotorDates: TDateVector);
var
  S, TableName: String;
  FieldDate, FieldNum: String;
  MotorNameID: Integer;
  MotorName, MotorNum, LetterNum: String;
  MotorDate, LetterDate: TDate;
  IsNoticeNotEmpty: Boolean;
begin
  ALogIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

  MotorLoad(AThisLogID, MotorNameID, MotorName, MotorNum, MotorDate);
  VAppend(ALogIDs, AThisLogID);
  VAppend(AMotorNames, MotorName);
  VAppend(AMotorNums, MotorNum);
  VAppend(AMotorDates, MotorDate);

  if not ANeedOtherMotors then Exit;

  LetterDBNamesGet(ALetterType, TableName, FieldDate, FieldNum);
  FieldDate:= SqlEsc(FieldDate);
  FieldNum:= SqlEsc(FieldNum);

  LetterLoad(AThisLogID, ALetterType, LetterNum, LetterDate);

  IsNoticeNotEmpty:= not IsDocumentEmpty(LetterDate, LetterNum);

  S:= 'SELECT ' +
      't1.LogID, t1.MotorNum, t1.MotorDate, t2.MotorName, ' +
      't3.' + FieldDate + ', t3.' + FieldNum +
    'FROM LOGMOTORS t1 ' +
    'INNER JOIN MOTORNAMES t2 ON (t1.MotorNameID=t2.MotorNameID) ' +
    'INNER JOIN '+ SqlEsc(TableName) + ' t3 ON (t1.LogID=t3.LogID) ' +
    'WHERE ' +
        '(t1.LogID>0) AND (t1.LogID <> :LogID) ';
  if IsNoticeNotEmpty then
    S:= S + 'AND (' +
        '((t3.' + FieldDate + ' = :DateValue) AND (t3.' + FieldNum  + ' = :NumValue)) ' +
        ' OR ' +
        '((t3.' + FieldDate + ' IS NULL) AND (t3.' + FieldNum  + ' IS NULL))' +
        ')'
  else
    S:= S + ' AND ((t3.' + FieldDate + ' IS NULL) AND (t3.' + FieldNum  + ' IS NULL))';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamInt('LogID', AThisLogID);
  if IsNoticeNotEmpty then
  begin
    QParamDT('DateValue', LetterDate);
    QParamStr('NumValue', LetterNum);
  end;
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ALogIDs, QFieldInt('LogID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.MotorNoticeAnswerLoad(const ALogID, ALocationID, AUserID: Integer;
                                    const ALetterType: Byte;
                                    const AOldLetterNum: String;
                                    const AOldLetterDate: TDate;
                                    out ALogIDs: TIntVector;
                                    out AMotorNames, AMotorNums: TStrVector;
                                    out AMotorDates: TDateVector;
                                    out ANoticeNums: TStrVector;
                                    out ANoticeDates: TDateVector;
                                    out AAnswerNums: TStrVector;
                                    out AAnswerDates: TDateVector;
                                    out ALocationTitles, AUserTitles: TStrVector;
                                    out AMoneyValues: TInt64Vector);
var
  TableName: String;
  ThisDateField, ThisNumField: String;
  NoticeDateField, NoticeNumField: String;
  AnswerDateField, AnswerNumField: String;
  S: String;
  NoticeLetterType, AnswerLetterType: Byte;
  NeedAnswers, NeedLocation, NeedMoney: Boolean;
  IsLetterNotEmpty: Boolean;
begin
  ALogIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  ANoticeNums:= nil;
  ANoticeDates:= nil;
  AAnswerNums:= nil;
  AAnswerDates:= nil;
  ALocationTitles:= nil;
  AUserTitles:= nil;
  AMoneyValues:= nil;

  IsLetterNotEmpty:= not IsDocumentEmpty(AOldLetterDate, AOldLetterNum);

  NeedMoney:= ALetterType in [11,13];
  NeedLocation:= ALocationID>0;
  NeedAnswers:= ALetterType in [3,9,13];
  NoticeLetterType:= NoticeLetterTypeGet(ALetterType);
  if NeedAnswers then {3,9,13 - ответы потребителю}
    AnswerLetterType:= ALetterType - 1
  else
    AnswerLetterType:= 0; // 0 - ответы не нужны


  LetterDBNamesGet(ALetterType, TableName, ThisDateField, ThisNumField);
  LetterDBNamesGet(NoticeLetterType, TableName, NoticeDateField, NoticeNumField);
  if NeedAnswers then
    LetterDBNamesGet(AnswerLetterType, TableName, AnswerDateField, AnswerNumField);

  S:=
    'SELECT ' +
      't1.LogID, t1.MotorNum, t1.MotorDate, t2.MotorName, t4.UserTitle, ' +
      't3.' + SqlEsc(NoticeDateField) + ', t3.' + SqlEsc(NoticeNumField);
  if NeedAnswers then
    S:= S + ', ' +
      't3.' + SqlEsc(AnswerDateField) + ', t3.' + SqlEsc(AnswerNumField);
  if NeedMoney then
    S:= S + ', ' +
      't3.MoneyValue ';
  if NeedLocation then
    S:= S + ', ' +
       't5.LocationTitle ';
  S:= S +
    'FROM LOGMOTORS t1 ' +
    'INNER JOIN MOTORNAMES t2 ON (t1.MotorNameID=t2.MotorNameID) ' +
    'INNER JOIN '+ SqlEsc(TableName) + ' t3 ON (t1.LogID=t3.LogID) ' +
    'INNER JOIN USERS t4 ON (t3.UserID=t4.UserID) ';
  if NeedLocation then
    S:= S +
      'INNER JOIN LOCATIONS t5 ON (t3.LocationID=t5.LocationID) ';
  S:= S +
    'WHERE ' +
        '(t1.LogID>0) AND (t1.LogID <> :LogID) AND (t3.UserID = :UserID) AND ' +
        '((t3.' + SqlEsc(NoticeDateField) + ' IS NOT NULL) AND (t3.' + SqlEsc(NoticeNumField)  + ' IS NOT NULL)) ';
  if IsLetterNotEmpty then
    S:= S + ' AND (' +
        '((t3.' + SqlEsc(ThisDateField) + ' = :DateValue) AND (t3.' + SqlEsc(ThisNumField)  + ' = :NumValue)) ' +
        ' OR ' +
        '((t3.' + SqlEsc(ThisDateField) + ' IS NULL) AND (t3.' + SqlEsc(ThisNumField)  + ' IS NULL))' +
        ')'
  else
    S:= S + ' AND ((t3.' + SqlEsc(ThisDateField) + ' IS NULL) AND (t3.' + SqlEsc(ThisNumField)  + ' IS NULL))';



  if NeedAnswers then
    S:= S +
        ' AND (t3.' + SqlEsc(AnswerNumField)  + ' IS NOT NULL) ' ; // AnswerDateField может быть NULL, если ответ не требуется

  if NeedLocation then
    S:= S + ' AND (t3.LocationID = :LocationID) ';

  S:= S + 'ORDER BY t3.' + SqlEsc(NoticeDateField) + ', t3.' + SqlEsc(NoticeNumField);

  QSetQuery(FQuery);
  QSetSQL(S);

  QParamInt('UserID', AUserID);
  QParamInt('LogID', ALogID);
  if ALocationID>0 then
    QParamInt('LocationID', ALocationID);
  if IsLetterNotEmpty then
  begin
    QParamDT('DateValue', AOldLetterDate);
    QParamStr('NumValue', AOldLetterNum);
  end;
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ALogIDs, QFieldInt('LogID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      VAppend(AUserTitles, QFieldStr('UserTitle'));
      if NeedLocation then
        VAppend(ALocationTitles, QFieldStr('LocationTitle'))
      else
        VAppend(ALocationTitles, EmptyStr);
      VAppend(ANoticeNums, QFieldStr(NoticeNumField));
      VAppend(ANoticeDates, QFieldDT(NoticeDateField));
      if NeedAnswers then
      begin
        VAppend(AAnswerNums, QFieldStr(AnswerNumField));
        VAppend(AAnswerDates, QFieldDT(AnswerDateField));
      end
      else begin
        VAppend(AAnswerNums, EmptyStr);
        VAppend(AAnswerDates, 0);
      end;
      if NeedMoney then
        VAppend(AMoneyValues, QFieldInt64('MoneyValue'))
      else
        VAppend(AMoneyValues, 0);
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.MotorNoticeAnswerLoad(const ALogID: Integer;
                                    const ALetterType: Byte;
                                    out AMotorName, AMotorNum: String;
                                    out AMotorDate: TDate;
                                    out ANoticeNum: String;
                                    out ANoticeDate: TDate;
                                    out AAnswerNum: String;
                                    out AAnswerDate: TDate;
                                    out ALocationTitle, AUserTitle: String);
var
  TableName: String;
  ThisDateField, ThisNumField: String;
  NoticeDateField, NoticeNumField: String;
  AnswerDateField, AnswerNumField: String;
  S: String;
  NoticeLetterType, AnswerLetterType: Byte;
  NeedAnswer, NeedLocation: Boolean;
begin
  AMotorName:= EmptyStr;
  AMotorNum:= EmptyStr;
  AMotorDate:= 0;
  ANoticeNum:= EmptyStr;
  ANoticeDate:= 0;
  AAnswerNum:= EmptyStr;
  AAnswerDate:= 0;
  ALocationTitle:= EmptyStr;
  AUserTitle:= EmptyStr;

  NeedAnswer:= ALetterType in [3,9,13];
  NoticeLetterType:= NoticeLetterTypeGet(ALetterType);
  if NeedAnswer then {3,9,13 - ответы потребителю}
    AnswerLetterType:= ALetterType - 1
  else   {1,7,11 - уведомления производителю}
    AnswerLetterType:= 0; // 0 - ответы не нужны

  LetterDBNamesGet(ALetterType, TableName, ThisDateField, ThisNumField);
  LetterDBNamesGet(NoticeLetterType, TableName, NoticeDateField, NoticeNumField);
  if NeedAnswer then
    LetterDBNamesGet(AnswerLetterType, TableName, AnswerDateField, AnswerNumField);

  NeedLocation:= ALetterType in [1,2,3,4];

  S:=
    'SELECT ' +
      't1.MotorNum, t1.MotorDate, t2.MotorName, t4.UserTitle, ' +
      't3.' + SqlEsc(NoticeDateField) + ', t3.' + SqlEsc(NoticeNumField);
  if NeedAnswer then
    S:= S + ', ' +
      't3.' + SqlEsc(AnswerDateField) + ', t3.' + SqlEsc(AnswerNumField);
  if NeedLocation then
    S:= S + ', ' +
       't5.LocationTitle ';
  S:= S +
    'FROM LOGMOTORS t1 ' +
    'INNER JOIN MOTORNAMES t2 ON (t1.MotorNameID=t2.MotorNameID) ' +
    'INNER JOIN '+ SqlEsc(TableName) + ' t3 ON (t1.LogID=t3.LogID) ' +
    'INNER JOIN USERS t4 ON (t3.UserID=t4.UserID) ';
  if NeedLocation then
    S:= S +
      'INNER JOIN LOCATIONS t5 ON (t3.LocationID=t5.LocationID) ';
  S:= S +
    'WHERE ' +
        '(t1.LogID = :LogID) ';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AMotorName:= QFieldStr('MotorName');
    AMotorNum:= QFieldStr('MotorNum');
    AMotorDate:= QFieldDT('MotorDate');
    AUserTitle:= QFieldStr('UserTitle');
    if NeedLocation then
      ALocationTitle:= QFieldStr('LocationTitle');
    ANoticeNum:= QFieldStr(NoticeNumField);
    ANoticeDate:= QFieldDT(NoticeDateField);
    if NeedAnswer then
    begin
      AAnswerNum:= QFieldStr(AnswerNumField);
      AAnswerDate:= QFieldDT(AnswerDateField);
    end;
  end;
  QClose;
end;

procedure TSQLite.LetterLoad(const ALogID: Integer; const ALetterType: Byte;
                             out ALetterNum: String;
                             out ALetterDate: TDate);
var
  TableName, DateField, NumField: String;
begin
  ALetterNum:= EmptyStr;
  ALetterDate:= 0;

  LetterDBNamesGet(ALetterType, TableName, DateField, NumField);
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      SqlEsc(DateField) + ', ' + SqlEsc(NumField) + ' ' +
    'FROM ' +
      SqlEsc(TableName) +
    'WHERE ' +
        'LogID = :LogID'
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    ALetterNum:= QFieldStr(NumField);
    ALetterDate:= QFieldDT(DateField);
  end;
  QClose;
end;


procedure TSQLite.LetterDelete(const ALogID: Integer; const ALetterType: Byte);
//var
//  TableName, DateField, NumField: String;
begin
  LettersUpdate(VCreateInt([ALogID]), ALetterType, EmptyStr, 0);
  //LetterDBNamesGet(ALetterType, TableName, DateField, NumField);
  //
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      SqlEsc(TableName) +
  //    'SET ' +
  //      SqlEsc(NumField)  + ' = NULL, ' +
  //      SqlEsc(DateField) + ' = NULL ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamInt('LogID', ALogID);
  //  QExec;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.LettersUpdate(const ALogIDs: TIntVector;
                           const ALetterType: Byte;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer = -1);
var
  TableName, DateField, NumField, S: String;
  i: Integer;
begin
  LetterDBNamesGet(ALetterType, TableName, DateField, NumField);
  S:=
    'UPDATE ' +
      SqlEsc(TableName) +
    'SET ' +
      SqlEsc(NumField)  + ' = :NumValue, ' +
      SqlEsc(DateField) + ' = :DateValue ';
  if AStatus>=0 then
    S:= S + ', Status = :Status ';
  S:= S +
    'WHERE ' +
        'LogID = :LogID';
  QSetQuery(FQuery);
  try
    QSetSQL(S);
    QParamStr('NumValue', ALetterNum, not SEmpty(ALetterNum));
    QParamDT('DateValue', ALetterDate, ALetterDate>0);
    if AStatus>=0 then
      QParamInt('Status', AStatus);
    for i:= 0 to High(ALogIDs) do
    begin
      QParamInt('LogID', ALogIDs[i]);
      QExec;
    end;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.LettersNotNeed(const ALogIDs: TIntVector; const ALetterType: Byte);
//var
//  i: Integer;
//  TableName, DateField, NumField: String;
begin
  LettersUpdate(ALogIDs, ALetterType, LETTER_NOTNEED_MARK, 0);

  //LetterDBNamesGet(ALetterType, TableName, DateField, NumField);
  //
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      SqlEsc(TableName) +
  //    'SET ' +
  //      SqlEsc(NumField)  + ' = :NumValue, ' +
  //      SqlEsc(DateField) + ' = NULL ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamStr('NumValue', LETTER_NOTNEED_MARK);
  //  for i:= 0 to High(ALogIDs) do
  //  begin
  //    QParamInt('LogID', ALogIDs[i]);
  //    QExec;
  //  end;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.ReclamationCancelNotNeed(const ALogIDs: TIntVector);
//var
//  i: Integer;
begin
  LettersUpdate(ALogIDs, 5 {отзыв рекл}, LETTER_NOTNEED_MARK, 0, 1{в работе});

  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      'LOGRECLAMATION ' +
  //    'SET ' +
  //      'Status = 1, ' +   {1 - в работе}
  //      'CancelNum = :NumValue, ' +
  //      'CancelDate = NULL ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamStr('NumValue', LETTER_NOTNEED_MARK);
  //  for i:= 0 to High(ALogIDs) do
  //  begin
  //    QParamInt('LogID', ALogIDs[i]);
  //    QExec;
  //  end;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.ReclamationCancelUpdate(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate);
//var
//  i: Integer;
begin
  LettersUpdate(ALogIDs, 5 {отзыв рекл}, ALetterNum, ALetterDate, 4{отозвана});
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      'LOGRECLAMATION ' +
  //    'SET ' +
  //      'Status = 4, '  + {4 - отозвана}
  //      'CancelNum = :NumValue, ' +
  //      'CancelDate = :DateValue ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamStr('NumValue', ALetterNum);
  //  QParamDT('DateValue', ALetterDate);
  //  for i:= 0 to High(ALogIDs) do
  //  begin
  //    QParamInt('LogID', ALogIDs[i]);
  //    QExec;
  //  end;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.ReclamationCancelDelete(const ALogID: Integer);
var
  LetterNum: String;
  LetterDate: TDate;
  Status: Integer;
begin
  Status:= 0 {не указана};
  LetterLoad(ALogID, 0 {уведомл. о неиспр.}, LetterNum, LetterDate);
  if not IsDocumentEmpty(LetterDate, LetterNum) then
    Status:= 1 {в работе};

  LettersUpdate(VCreateInt([ALogID]), 5 {отзыв рекл}, EmptyStr, 0, Status);

  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      'LOGRECLAMATION ' +
  //    'SET ' +
  //      'Status = :Status, ' +
  //      'CancelNum = NULL, ' +
  //      'CancelDate = NULL ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamInt('LogID', ALogID);
  //  QParamInt('Status', Status);
  //  QExec;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.ReclamationReportNotNeed(const ALogIDs: TIntVector; const AStatus: Integer);
//var
//  i: Integer;
begin
  LettersUpdate(ALogIDs, 4 {акт осмотра}, LETTER_NOTNEED_MARK, 0, AStatus);
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      'LOGRECLAMATION ' +
  //    'SET ' +
  //      'Status = :Status, ' +
  //      'ReportNum = :NumValue, ' +
  //      'ReportDate = NULL ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamInt('Status', AStatus);
  //  QParamStr('NumValue', LETTER_NOTNEED_MARK);
  //  for i:= 0 to High(ALogIDs) do
  //  begin
  //    QParamInt('LogID', ALogIDs[i]);
  //    QExec;
  //  end;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.ReclamationReportUpdate(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
//var
//  i: Integer;
begin
  LettersUpdate(ALogIDs, 4 {акт осмотра}, ALetterNum, ALetterDate, AStatus);
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      'LOGRECLAMATION ' +
  //    'SET ' +
  //      'Status = :Status, ' +
  //      'ReportNum = :NumValue, ' +
  //      'ReportDate = :DateValue ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamInt('Status', AStatus);
  //  QParamStr('NumValue', ALetterNum);
  //  QParamDT('DateValue', ALetterDate);
  //  for i:= 0 to High(ALogIDs) do
  //  begin
  //    QParamInt('LogID', ALogIDs[i]);
  //    QExec;
  //  end;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.ReclamationReportDelete(const ALogID: Integer);
var
  LetterNum: String;
  LetterDate: TDate;
  Status: Integer;
begin
  Status:= 0 {не указана};
  LetterLoad(ALogID, 5 {отзыв рекл.}, LetterNum, LetterDate);
  if not IsDocumentEmpty(LetterDate, LetterNum) then
    Status:= 4 {отозвана}
  else begin
    LetterLoad(ALogID, 0 {уведомл. о неиспр.}, LetterNum, LetterDate);
    if not IsDocumentEmpty(LetterDate, LetterNum) then
      Status:= 1 {в работе}
  end;

  LettersUpdate(VCreateInt([ALogID]), 4 {акт осмотра}, EmptyStr, 0, Status);

  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      'LOGRECLAMATION ' +
  //    'SET ' +
  //      'Status = :Status, ' +
  //      'ReportNum = NULL, ' +
  //      'ReportDate = NULL ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamInt('LogID', ALogID);
  //  QParamInt('Status', Status);
  //  QExec;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.MotorsReturn(const ALogIDs: TIntVector;
  const ALetterNum: String; const ALetterDate: TDate);
var
  i, UserID, LocationID: Integer;
begin
  //получаем UserID - он у всех одинаковый
  ReclamationInfoLoad(ALogIDs[0], UserID, LocationID);

  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'LOGRECLAMATION ' +
      'SET ' +
        'Status = 2, ' +  {2 - принята}
        'AnswerToUserNum = :NumValue, ' +
        'AnswerToUserDate = :DateValue ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamStr('NumValue', ALetterNum);
    QParamDT('DateValue', ALetterDate);
    for i:= 0 to High(ALogIDs) do
    begin
      QParamInt('LogID', ALogIDs[i]);
      QExec;
    end;

    QSetSQL(
      'UPDATE ' +
        'LOGREPAIR ' +
      'SET ' +
        'UserID = :UserID, ' +
        'Status = 2, ' +  {2 - в пути}
        'NoticeFromUserDate = NULL, ' +
        'NoticeFromUserNum = :NumValue, ' +
        'NoticeToBuilderDate = NULL, ' +
        'NoticeToBuilderNum = :NumValue, ' +
        'AnswerFromBuilderDate = NULL, ' +
        'AnswerFromBuilderNum = :NumValue, ' +
        'AnswerToUserDate = NULL, ' +
        'AnswerToUserNum = :NumValue, ' +
        'Note = :Note ' +
      'WHERE ' +
        'LogID = :LogID'
    );
    QParamInt('UserID', UserID);
    QParamStr('NumValue', LETTER_NOTNEED_MARK);
    QParamStr('Note', 'Производителем принято решение о возврате на этапе расследования');
    for i:= 0 to High(ALogIDs) do
    begin
      QParamInt('LogID', ALogIDs[i]);
      QExec;
    end;

    QCommit;
  except
    QRollback;
  end;

end;

procedure TSQLite.RepairAnswersToUserUpdate(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
//var
//  i: Integer;
begin
  LettersUpdate(ALogIDs, 9 {ответ потреб. по ремонту}, ALetterNum, ALetterDate, AStatus);
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      'LOGREPAIR ' +
  //    'SET ' +
  //      'Status = :Status, ' +
  //      'AnswerToUserNum = :NumValue, ' +
  //      'AnswerToUserDate = :DateValue ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamInt('Status', AStatus);
  //  QParamStr('NumValue', ALetterNum);
  //  QParamDT('DateValue', ALetterDate);
  //  for i:= 0 to High(ALogIDs) do
  //  begin
  //    QParamInt('LogID', ALogIDs[i]);
  //    QExec;
  //  end;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.PretensionAnswersToUserUpdate(const ALogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
//var
//  i: Integer;
begin
  LettersUpdate(ALogIDs, 13 {ответ потреб. по претензии}, ALetterNum, ALetterDate, AStatus);
  //QSetQuery(FQuery);
  //try
  //  QSetSQL(
  //    'UPDATE ' +
  //      'LOGPRETENSION ' +
  //    'SET ' +
  //      'Status = :Status, ' +
  //      'AnswerToUserNum = :NumValue, ' +
  //      'AnswerToUserDate = :DateValue ' +
  //    'WHERE ' +
  //      'LogID = :LogID'
  //  );
  //  QParamInt('Status', AStatus);
  //  QParamStr('NumValue', ALetterNum);
  //  QParamDT('DateValue', ALetterDate);
  //  for i:= 0 to High(ALogIDs) do
  //  begin
  //    QParamInt('LogID', ALogIDs[i]);
  //    QExec;
  //  end;
  //  QCommit;
  //except
  //  QRollback;
  //end;
end;

procedure TSQLite.ImageListLoad(out AImageIDs: TIntVector; out AImageNames: TStrVector);
begin
  AImageIDs:= nil;
  AImageNames:= nil;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'ImageID, ImageName ' +
    'FROM ' +
      'EJDMIMAGES'
  );
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(AImageIDs, QFieldInt('ImageID'));
      VAppend(AImageNames, QFieldStr('ImageName'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.ImageUpdate(const AImageID: Integer; const AFileName: String);
begin
  QSetQuery(FQuery);
  QSetSQL(
    'UPDATE '+
      'EJDMIMAGES ' +
    'SET ' +
      'ImageValue = :ImageValue, ImageExt = :ImageExt ' +
    'WHERE ' +
      'ImageID = :ImageID'
  );
  QParamInt('ImageID', AImageID);
  QParamFile('ImageValue', AFileName);
  QParamStr('ImageExt', ExtractFileExt(AFileName));
  try
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

function TSQLite.ImageLoad(const AImageID: Integer;
                       out ASourceFileExtension: String;
                       var AStream: TMemoryStream): Boolean;
begin
  Result:= False;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'ImageValue, ImageExt ' +
    'FROM ' +
      'EJDMIMAGES ' +
    'WHERE ' +
      '(ImageID = :ImageID) AND (ImageValue IS NOT NULL)');
  QParamInt('ImageID', AImageID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    Result:= QFieldFile('ImageValue', AStream);
    ASourceFileExtension:= QFieldStr('ImageExt');
  end;
  if not Result then
  begin
    ASourceFileExtension:= EmptyStr;
    AStream:= nil;
  end;
  QClose;
end;

function TSQLite.SenderLastWritedID: Integer;
begin
  Result:= LastWritedInt32ID('EJDMSENDERS');
end;

procedure TSQLite.SenderAdd(const ASenderName, ASenderPost: String);
begin
  QSetQuery(FQuery);
  QSetSQL(
    'INSERT INTO '+
      'EJDMSENDERS ' +
      '(SenderName, SenderPost) ' +
    'VALUES ' +
      '(:SenderName, :SenderPost)'
  );
  QParamStr('SenderName', ASenderName);
  QParamStr('SenderPost', ASenderPost);
  try
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.SenderUpdate(const ASenderID: Integer;
                               const ASenderName, ASenderPost: String);
begin
  QSetQuery(FQuery);
  QSetSQL(
    'UPDATE '+
      'EJDMSENDERS ' +
    'SET ' +
      'SenderName = :SenderName, SenderPost = :SenderPost ' +
    'WHERE ' +
      'SenderID = :SenderID'
  );
  QParamInt('SenderID', ASenderID);
  QParamStr('SenderName', ASenderName);
  QParamStr('SenderPost', ASenderPost);
  try
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.SenderLoad(const ASenderID: Integer;
                             out ASenderName, ASenderPost: String);
begin
  ASenderName:= EmptyStr;
  ASenderPost:= EmptyStr;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'SenderName, SenderPost ' +
    'FROM ' +
      'EJDMSENDERS ' +
    'WHERE ' +
      'SenderID = :SenderID ');
  QParamInt('SenderID', ASenderID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    ASenderName:= QFieldStr('SenderName');
    ASenderPost:= QFieldStr('SenderPost');
  end;
  QClose;
end;

procedure TSQLite.SenderDelete(const ASenderID: Integer);
begin
  Delete('EJDMSENDERS', 'SenderID', ASenderID);
end;

procedure TSQLite.SenderListLoad(out ASenderIDs: TIntVector;
                                 out ASenderNames, ASenderPosts: TStrVector);
begin
  ASenderIDs:= nil;
  ASenderNames:= nil;
  ASenderPosts:= nil;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'SenderID, SenderName, SenderPost ' +
    'FROM ' +
      'EJDMSENDERS'
  );
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ASenderIDs, QFieldInt('SenderID'));
      VAppend(ASenderNames, QFieldStr('SenderName'));
      VAppend(ASenderPosts, QFieldStr('SenderPost'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.SenderSignUpdate(const ASenderID: Integer; const AFileName: String);
begin
  QSetQuery(FQuery);
  QSetSQL(
    'UPDATE '+
      'EJDMSENDERS ' +
    'SET ' +
      'SenderSign = :SenderSign, SenderExt = :SenderExt ' +
    'WHERE ' +
      'SenderID = :SenderID'
  );
  QParamInt('SenderID', ASenderID);
  QParamFile('SenderSign', AFileName);
  QParamStr('SenderExt', ExtractFileExt(AFileName));
  try
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

function TSQLite.SenderSignLoad(const ASenderID: Integer;
                                out ASourceFileExtension: String;
                                var AStream: TMemoryStream): Boolean;
begin
  Result:= False;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'SenderSign, SenderExt ' +
    'FROM ' +
      'EJDMSENDERS ' +
    'WHERE (SenderID = :SenderID) AND (SenderSign IS NOT NULL)');
  QParamInt('SenderID', ASenderID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    Result:= QFieldFile('SenderSign', AStream);
    ASourceFileExtension:= QFieldStr('SenderExt');
  end;
  if not Result then
  begin
    ASourceFileExtension:= EmptyStr;
    AStream:= nil;
  end;
  QClose;
end;

procedure TSQLite.OrganizationListLoad(const AOrganizationType: Byte;
                                   out AOrganizationIDs: TIntVector;
                                   out AOrganizationNames, AOrganizationTitles:  TStrVector);
var
  S: String;
begin
  AOrganizationIDs:= nil;
  AOrganizationNames:= nil;
  AOrganizationTitles:= nil;

  if AOrganizationType=1 then  //потребители
  begin
    S:=
    'SELECT ' +
      'UserID AS OrgID, UserNameI AS OrgName, UserTitle AS OrgTitle ' +
    'FROM ' +
      'USERS ' +
    'WHERE ' +
      'UserID > 0 ';
  end
  else begin //2 - производители
    S:=
    'SELECT ' +
      'BuilderID AS OrgID, BuilderName AS OrgName, BuilderTitle AS OrgTitle ' +
    'FROM ' +
      'BUILDERS '  +
    'WHERE ' +
      'BuilderID > 0 ';
  end;
  S:= S + 'ORDER BY OrgName';

  QSetQuery(FQuery);
  QSetSQL(S);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(AOrganizationIDs, QFieldInt('OrgID'));
      VAppend(AOrganizationNames, QFieldStr('OrgName'));
      VAppend(AOrganizationTitles, QFieldStr('OrgTitle'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.ReceiverListLoad(const AOrganizationType: Byte;
               const AOrganizationID: Integer;
               out AReceiverIDs:  TIntVector;
               out AReceiverNames, AReceiverPosts, AReceiverAppeals:  TStrVector);
var
  TableName, IDFieldName: String;
begin
  AReceiverIDs:= nil;
  AReceiverNames:= nil;
  AReceiverPosts:= nil;
  AReceiverAppeals:= nil;

  ReceiversDBNamesGet(AOrganizationType, TableName, IDFieldName);

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'ReceiverID, ReceiverName, ReceiverPost, ReceiverAppeal ' +
    'FROM ' +
       TableName +
    'WHERE ' +
       IDFieldName + ' = :OrganizationID ' +
    'ORDER BY ' +
      'ReceiverName'
  );
  QParamInt('OrganizationID', AOrganizationID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(AReceiverIDs, QFieldInt('ReceiverID'));
      VAppend(AReceiverNames, QFieldStr('ReceiverName'));
      VAppend(AReceiverPosts, QFieldStr('ReceiverPost'));
      VAppend(AReceiverAppeals, QFieldStr('ReceiverAppeal'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.ReceiverAdd(const AOrganizationType: Byte;
                    const AOrganizationID: Integer;
                    const AReceiverName, AReceiverPost, AReceiverAppeal: String);
var
  TableName, IDFieldName: String;
begin
  ReceiversDBNamesGet(AOrganizationType, TableName, IDFieldName);

  QSetQuery(FQuery);
  QSetSQL(
    'INSERT INTO ' +
      TableName +
      '(' + IDFieldName + ', ReceiverName, ReceiverPost, ReceiverAppeal) ' +
    'VALUES ' +
        '(:OrganizationID, :ReceiverName, :ReceiverPost, :ReceiverAppeal)'
  );
  QParamInt('OrganizationID', AOrganizationID);
  QParamStr('ReceiverName', AReceiverName);
  QParamStr('ReceiverPost', AReceiverPost);
  QParamStr('ReceiverAppeal', AReceiverAppeal);
  try
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.ReceiverUpdate(const AOrganizationType: Byte;
                const AReceiverID: Integer;
                const AReceiverName, AReceiverPost, AReceiverAppeal: String);
var
  TableName, IDFieldName: String;
begin
  ReceiversDBNamesGet(AOrganizationType, TableName, IDFieldName);

  QSetQuery(FQuery);
  QSetSQL(
    'UPDATE ' +
      TableName +
    'SET ' +
      'ReceiverName = :ReceiverName, ' +
      'ReceiverPost = :ReceiverPost, ' +
      'ReceiverAppeal = :ReceiverAppeal ' +
    'WHERE ' +
      'ReceiverID = :ReceiverID'
  );
  QParamInt('ReceiverID', AReceiverID);
  QParamStr('ReceiverName', AReceiverName);
  QParamStr('ReceiverPost', AReceiverPost);
  QParamStr('ReceiverAppeal', AReceiverAppeal);
  try
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.ReceiverDelete(const AOrganizationType: Byte;  const AReceiverID: Integer);
var
  TableName, IDFieldName: String;
begin
  ReceiversDBNamesGet(AOrganizationType, TableName, IDFieldName);
  Delete(TableName, 'ReceiverID', AReceiverID);
end;

function TSQLite.ReceiverLastWritedID(const AOrganizationType: Byte): Integer;
var
  TableName, IDFieldName: String;
begin
  ReceiversDBNamesGet(AOrganizationType, TableName, IDFieldName);
  Result:= LastWritedInt32ID(TableName);
end;

procedure TSQLite.PerformerListLoad(out APerformerIDs: TIntVector;
           out APerformerNames, APerformerPhones, APerformerMails: TStrVector);
begin
  APerformerIDs:= nil;
  APerformerNames:= nil;
  APerformerPhones:= nil;
  APerformerMails:= nil;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'PerformerID, PerformerName, PerformerPhone, PerformerMail ' +
    'FROM ' +
      'EJDMPERFORMERS ' +
    'WHERE ' +
      'PerformerID > 0 ' +
    'ORDER BY PerformerName'
  );
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(APerformerIDs, QFieldInt('PerformerID'));
      VAppend(APerformerNames, QFieldStr('PerformerName'));
      VAppend(APerformerPhones, QFieldStr('PerformerPhone'));
      VAppend(APerformerMails, QFieldStr('PerformerMail'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.DelegateListLoad(const ADelegateType: Byte;
                                out ADelegateIDs: TIntVector;
                                out ADelegateNameIs, ADelegateNameRs,
                                    ADelegatePhones, ADelegatePassports: TStrVector);
var
  TableName: String;
begin
  ADelegateIDs:= nil;
  ADelegateNameIs:= nil;
  ADelegateNameRs:= nil;
  ADelegatePhones:= nil;
  ADelegatePassports:= nil;

  if ADelegateType=0 then Exit;
  if ADelegateType=1 then
    TableName:= 'EJDMDELEGATES '
  else if ADelegateType=2 then
    TableName:= 'BUILDERDELEGATES ';

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'DelegateID, DelegateNameI, DelegatePhone, DelegateNameR, DelegatePassport ' +
    'FROM ' +
      TableName +
    'WHERE ' +
      'DelegateID > 0 ' +
    'ORDER BY DelegateNameI'
  );
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ADelegateIDs, QFieldInt('DelegateID'));
      VAppend(ADelegateNameIs, QFieldStr('DelegateNameI'));
      VAppend(ADelegateNameRs, QFieldStr('DelegateNameR'));
      VAppend(ADelegatePhones, QFieldStr('DelegatePhone'));
      VAppend(ADelegatePassports, QFieldStr('DelegatePassport'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.NoteLoad(const ALogID: Integer; const ACategory: Byte; out ANote: String);
var
  TableName: String;
begin
  TableName:= LogTableNameGet(ACategory);
  ANote:= ValueStrInt32ID(TableName, 'Note', 'LogID', ALogID);
end;

procedure TSQLite.NoteUpdate(const ALogID: Integer; const ACategory: Byte; const ANote: String);
var
  TableName: String;
begin
  TableName:= LogTableNameGet(ACategory);
  UpdateInt32ID(TableName, 'Note', 'LogID', ALogID, ANote);
end;

procedure TSQLite.NoteDelete(const ALogID: Integer; const ACategory: Byte);
begin
  NoteUpdate(ALogID, ACategory, EmptyStr);
end;


procedure TSQLite.DataLoad(const AMotorNumLike: String;
                       const AOrderIndex, AViewIndex: Integer;
                       const ABeginDate, AEndDate: TDate;
                       out ALogIDs: TIntVector;
                       out AMotorNames: TStrVector;
                       out AMotorNums: TStrVector;
                       out AMotorDates: TDateVector;
                       out AReclamationUserNames: TStrVector;
                       out AReclamationUserTitles: TStrVector;
                       out AReclamationLocationNames: TStrVector;
                       out AReclamationLocationTitles: TStrVector;
                       out AReclamationNoticeFromUserDates: TDateVector;
                       out AReclamationNoticeFromUserNums: TStrVector;
                       out AReclamationNoticeToBuilderDates: TDateVector;
                       out AReclamationNoticeToBuilderNums: TStrVector;
                       out AReclamationAnswerFromBuilderDates: TDateVector;
                       out AReclamationAnswerFromBuilderNums: TStrVector;
                       out AReclamationAnswerToUserDates: TDateVector;
                       out AReclamationAnswerToUserNums: TStrVector;
                       out AReclamationCancelDates: TDateVector;
                       out AReclamationCancelNums: TStrVector;
                       out AReclamationReportDates: TDateVector;
                       out AReclamationReportNums: TStrVector;
                       out AReclamationNotes: TStrVector;
                       out AReclamationStatuses: TIntVector;
                       out ARepairUserNames: TStrVector;
                       out ARepairUserTitles: TStrVector;
                       out ARepairNoticeFromUserDates: TDateVector;
                       out ARepairNoticeFromUserNums: TStrVector;
                       out ARepairNoticeToBuilderDates: TDateVector;
                       out ARepairNoticeToBuilderNums: TStrVector;
                       out ARepairAnswerFromBuilderDates: TDateVector;
                       out ARepairAnswerFromBuilderNums: TStrVector;
                       out ARepairAnswerToUserDates: TDateVector;
                       out ARepairAnswerToUserNums: TStrVector;
                       out ARepairBeginDates: TDateVector;
                       out ARepairEndDates: TDateVector;
                       out ARepairNotes: TStrVector;
                       out ARepairStatuses: TIntVector;
                       out APretensionUserNames: TStrVector;
                       out APretensionUserTitles: TStrVector;
                       out APretensionNoticeFromUserDates: TDateVector;
                       out APretensionNoticeFromUserNums: TStrVector;
                       out APretensionMoneyValues: TInt64Vector;
                       out APretensionNoticeToBuilderDates: TDateVector;
                       out APretensionNoticeToBuilderNums: TStrVector;
                       out APretensionAnswerFromBuilderDates: TDateVector;
                       out APretensionAnswerFromBuilderNums: TStrVector;
                       out APretensionAnswerToUserDates: TDateVector;
                       out APretensionAnswerToUserNums: TStrVector;
                       out APretensionMoneySendDates: TDateVector;
                       out APretensionMoneySendValues: TInt64Vector;
                       out APretensionMoneyGetDates: TDateVector;
                       out APretensionMoneyGetValues: TInt64Vector;
                       out APretensionNotes: TStrVector;
                       out APretensionStatuses: TIntVector
                       );
var
  S: String;
begin
  ALogIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

  AReclamationUserNames:= nil;
  AReclamationUserTitles:= nil;
  AReclamationLocationNames:= nil;
  AReclamationLocationTitles:= nil;
  AReclamationNoticeFromUserDates:= nil;
  AReclamationNoticeFromUserNums:= nil;
  AReclamationNoticeToBuilderDates:= nil;
  AReclamationNoticeToBuilderNums:= nil;
  AReclamationAnswerFromBuilderDates:= nil;
  AReclamationAnswerFromBuilderNums:= nil;
  AReclamationAnswerToUserDates:= nil;
  AReclamationAnswerToUserNums:= nil;
  AReclamationCancelDates:= nil;
  AReclamationCancelNums:= nil;
  AReclamationReportDates:= nil;
  AReclamationReportNums:= nil;
  AReclamationNotes:= nil;
  AReclamationStatuses:= nil;

  ARepairUserNames:= nil;
  ARepairUserTitles:= nil;
  ARepairNoticeFromUserDates:= nil;
  ARepairNoticeFromUserNums:= nil;
  ARepairNoticeToBuilderDates:= nil;
  ARepairNoticeToBuilderNums:= nil;
  ARepairAnswerFromBuilderDates:= nil;
  ARepairAnswerFromBuilderNums:= nil;
  ARepairAnswerToUserDates:= nil;
  ARepairAnswerToUserNums:= nil;
  ARepairBeginDates:= nil;
  ARepairEndDates:= nil;
  ARepairNotes:= nil;
  ARepairStatuses:= nil;

  APretensionUserNames:= nil;
  APretensionUserTitles:= nil;
  APretensionNoticeFromUserDates:= nil;
  APretensionNoticeFromUserNums:= nil;
  APretensionMoneyValues:= nil;
  APretensionNoticeToBuilderDates:= nil;
  APretensionNoticeToBuilderNums:= nil;
  APretensionAnswerFromBuilderDates:= nil;
  APretensionAnswerFromBuilderNums:= nil;
  APretensionAnswerToUserDates:= nil;
  APretensionAnswerToUserNums:= nil;
  APretensionMoneySendDates:= nil;
  APretensionMoneySendValues:= nil;
  APretensionMoneyGetDates:= nil;
  APretensionMoneyGetValues:= nil;
  APretensionNotes:= nil;
  APretensionStatuses:= nil;

  S:=
    'SELECT ' +
      't0.LogID, t0.MotorNum, t0.MotorDate, ' +

      't1.NoticeFromUserDate    AS ReclamationNoticeFromUserDate, '  +
      't1.NoticeFromUserNum     AS ReclamationNoticeFromUserNum, ' +
      't1.NoticeToBuilderDate   AS ReclamationNoticeToBuilderDate, ' +
      't1.NoticeToBuilderNum    AS ReclamationNoticeToBuilderNum, ' +
      't1.AnswerFromBuilderDate AS ReclamationAnswerFromBuilderDate, '+
      't1.AnswerFromBuilderNum  AS ReclamationAnswerFromBuilderNum, ' +
      't1.AnswerToUserDate      AS ReclamationAnswerToUserDate, ' +
      't1.AnswerToUserNum       AS ReclamationAnswerToUserNum, ' +
      't1.Note                  AS ReclamationNote, ' +
      't1.Status                AS ReclamationStatus, ' +
      't1.CancelDate, t1.CancelNum, t1.ReportDate, t1.ReportNum, ' +

      't2.NoticeFromUserDate    AS RepairNoticeFromUserDate, '  +
      't2.NoticeFromUserNum     AS RepairNoticeFromUserNum, ' +
      't2.NoticeToBuilderDate   AS RepairNoticeToBuilderDate, ' +
      't2.NoticeToBuilderNum    AS RepairNoticeToBuilderNum, ' +
      't2.AnswerFromBuilderDate AS RepairAnswerFromBuilderDate, '+
      't2.AnswerFromBuilderNum  AS RepairAnswerFromBuilderNum, ' +
      't2.AnswerToUserDate      AS RepairAnswerToUserDate, ' +
      't2.AnswerToUserNum       AS RepairAnswerToUserNum, ' +
      't2.Note                  AS RepairNote, ' +
      't2.Status                AS RepairStatus, ' +
      't2.BeginDate, t2.EndDate, ' +

      't3.NoticeFromUserDate    AS PretensionNoticeFromUserDate, '  +
      't3.NoticeFromUserNum     AS PretensionNoticeFromUserNum, ' +
      't3.NoticeToBuilderDate   AS PretensionNoticeToBuilderDate, ' +
      't3.NoticeToBuilderNum    AS PretensionNoticeToBuilderNum, ' +
      't3.AnswerFromBuilderDate AS PretensionAnswerFromBuilderDate, '+
      't3.AnswerFromBuilderNum  AS PretensionAnswerFromBuilderNum, ' +
      't3.AnswerToUserDate      AS PretensionAnswerToUserDate, ' +
      't3.AnswerToUserNum       AS PretensionAnswerToUserNum, ' +
      't3.Note                  AS PretensionNote, ' +
      't3.Status                AS PretensionStatus, ' +
      't3.MoneyValue, t3.MoneySendDate, t3.MoneySendValue, t3.MoneyGetDate, t3.MoneyGetValue,  ' +

      't4.MotorName, ' +
      't5.LocationName, t5.LocationTitle, ' +
      't6.UserNameI AS ReclamationUserName, t6.UserTitle AS ReclamationUserTitle, '  +
      't7.UserNameI AS RepairUserName, t7.UserTitle AS RepairUserTitle, '  +
      't8.UserNameI AS PretensionUserName, t8.UserTitle AS PretensionUserTitle '  +
    'FROM ' +
      'LOGMOTORS t0 ' +
    'INNER JOIN LOGRECLAMATION t1 ON (t0.LogID=t1.LogID) ' +
    'INNER JOIN LOGREPAIR t2 ON (t0.LogID=t2.LogID) ' +
    'INNER JOIN LOGPRETENSION t3 ON (t0.LogID=t3.LogID) ' +
    'INNER JOIN MOTORNAMES t4 ON (t0.MotorNameID=t4.MotorNameID) ' +
    'INNER JOIN LOCATIONS t5 ON (t1.LocationID=t5.LocationID) ' +
    'INNER JOIN USERS t6 ON (t1.UserID=t6.UserID) ' +
    'INNER JOIN USERS t7 ON (t2.UserID=t7.UserID) ' +
    'INNER JOIN USERS t8 ON (t3.UserID=t8.UserID) ' +
    'WHERE ' +
      '(t0.LogID>0) ';

  if not SEmpty(AMotorNumLike) then
    S:= S + ' AND (UPPER(t0.MotorNum) LIKE :NumberLike) '   //отбор только по номеру двигателя
  else begin
    case AViewIndex of
    0: S:= S + ' AND (t1.Status < 2) ';                        //в процессе рекламационной работы
    1: S:= S + ' AND ((t1.Status = 2) AND (t2.Status < 2)) ';  //ожидающие согласования ремонта
    2: S:= S + ' AND (t2.Status = 2) ';                        //на этапе транспортировки в ремонт
    3: S:= S + ' AND (t2.Status = 3) ';                        //в процессе гарантийного ремонта
    4: S:= S + ' AND ((t3.Status > 0) AND (t3.Status < 3)) ';  //с незавершенной претензионной работой
    5: S:= S + ' AND (' +                                      //все электродвигатели за период
                     '(t1.NoticeFromUserDate IS NULL) OR ' +
                     '(t1.NoticeFromUserDate BETWEEN :BD AND :ED) OR ' +
                     '(t2.NoticeFromUserDate BETWEEN :BD AND :ED) OR ' +
                     '(t3.NoticeFromUserDate BETWEEN :BD AND :ED) OR ' +
                     '(t1.AnswerToUserDate BETWEEN :BD AND :ED) OR ' +
                     '(t2.AnswerToUserDate BETWEEN :BD AND :ED) OR ' +
                     '(t3.AnswerToUserDate BETWEEN :BD AND :ED) OR ' +
                     '(t3.MoneySendDate BETWEEN :BD AND :ED) OR ' +
                     '(t3.MoneyGetDate  BETWEEN :BD AND :ED) OR ' +
                     '(t2.BeginDate BETWEEN :BD AND :ED) OR ' +
                     '(t2.EndDate   BETWEEN :BD AND :ED)' +
                     ') ';
    end;
  end;

  S:= S + 'ORDER BY ';
  case AOrderIndex of
  0: S:= S + 't1.NoticeFromUserDate, t1.NoticeFromUserNum';
  1: S:= S + 't2.NoticeFromUserDate, t2.NoticeFromUserNum';
  2: S:= S + 't3.NoticeFromUserDate, t3.NoticeFromUserNum';
  3: S:= S + 't6.UserTitle';
  4: S:= S + 't4.MotorName, t0.MotorNum, t0.MotorDate';
  5: S:= S + 't0.MotorDate, t0.MotorNum';
  end;

  QSetQuery(FQuery);
  QSetSQL(S);
  if not SEmpty(AMotorNumLike) then
    QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  //else if AViewIndex=5 then
  //begin
    QParamDT('BD', ABeginDate);
    QParamDT('ED', AEndDate);
  //end;

  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ALogIDs, QFieldInt('LogID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));

      VAppend(AReclamationUserNames, QFieldStr('ReclamationUserName'));
      VAppend(AReclamationUserTitles, QFieldStr('ReclamationUserTitle'));
      VAppend(AReclamationLocationNames, QFieldStr('LocationName'));
      VAppend(AReclamationLocationTitles, QFieldStr('LocationTitle'));
      VAppend(AReclamationNoticeFromUserDates, QFieldDT('ReclamationNoticeFromUserDate'));
      VAppend(AReclamationNoticeFromUserNums, QFieldStr('ReclamationNoticeFromUserNum'));
      VAppend(AReclamationNoticeToBuilderDates, QFieldDT('ReclamationNoticeToBuilderDate'));
      VAppend(AReclamationNoticeToBuilderNums, QFieldStr('ReclamationNoticeToBuilderNum'));
      VAppend(AReclamationAnswerFromBuilderDates, QFieldDT('ReclamationAnswerFromBuilderDate'));
      VAppend(AReclamationAnswerFromBuilderNums, QFieldStr('ReclamationAnswerFromBuilderNum'));
      VAppend(AReclamationAnswerToUserDates, QFieldDT('ReclamationAnswerToUserDate'));
      VAppend(AReclamationAnswerToUserNums, QFieldStr('ReclamationAnswerToUserNum'));
      VAppend(AReclamationCancelDates, QFieldDT('CancelDate'));
      VAppend(AReclamationCancelNums, QFieldStr('CancelNum'));
      VAppend(AReclamationReportDates, QFieldDT('ReportDate'));
      VAppend(AReclamationReportNums, QFieldStr('ReportNum'));
      VAppend(AReclamationNotes, QFieldStr('ReclamationNote'));
      VAppend(AReclamationStatuses, QFieldInt('ReclamationStatus'));

      VAppend(ARepairUserNames, QFieldStr('RepairUserName'));
      VAppend(ARepairUserTitles, QFieldStr('RepairUserTitle'));
      VAppend(ARepairNoticeFromUserDates, QFieldDT('RepairNoticeFromUserDate'));
      VAppend(ARepairNoticeFromUserNums, QFieldStr('RepairNoticeFromUserNum'));
      VAppend(ARepairNoticeToBuilderDates, QFieldDT('RepairNoticeToBuilderDate'));
      VAppend(ARepairNoticeToBuilderNums, QFieldStr('RepairNoticeToBuilderNum'));
      VAppend(ARepairAnswerFromBuilderDates, QFieldDT('RepairAnswerFromBuilderDate'));
      VAppend(ARepairAnswerFromBuilderNums, QFieldStr('RepairAnswerFromBuilderNum'));
      VAppend(ARepairAnswerToUserDates, QFieldDT('RepairAnswerToUserDate'));
      VAppend(ARepairAnswerToUserNums, QFieldStr('RepairAnswerToUserNum'));
      VAppend(ARepairBeginDates, QFieldDT('BeginDate'));
      VAppend(ARepairEndDates, QFieldDT('EndDate'));
      VAppend(ARepairNotes, QFieldStr('RepairNote'));
      VAppend(ARepairStatuses, QFieldInt('RepairStatus'));

      VAppend(APretensionUserNames, QFieldStr('PretensionUserName'));
      VAppend(APretensionUserTitles, QFieldStr('PretensionUserTitle'));
      VAppend(APretensionNoticeFromUserDates, QFieldDT('PretensionNoticeFromUserDate'));
      VAppend(APretensionNoticeFromUserNums, QFieldStr('PretensionNoticeFromUserNum'));
      VAppend(APretensionMoneyValues, QFieldInt64('MoneyValue'));
      VAppend(APretensionNoticeToBuilderDates, QFieldDT('PretensionNoticeToBuilderDate'));
      VAppend(APretensionNoticeToBuilderNums, QFieldStr('PretensionNoticeToBuilderNum'));
      VAppend(APretensionAnswerFromBuilderDates, QFieldDT('PretensionAnswerFromBuilderDate'));
      VAppend(APretensionAnswerFromBuilderNums, QFieldStr('PretensionAnswerFromBuilderNum'));
      VAppend(APretensionAnswerToUserDates, QFieldDT('PretensionAnswerToUserDate'));
      VAppend(APretensionAnswerToUserNums, QFieldStr('PretensionAnswerToUserNum'));
      VAppend(APretensionMoneySendDates, QFieldDT('MoneySendDate'));
      VAppend(APretensionMoneySendValues, QFieldInt64('MoneySendValue'));
      VAppend(APretensionMoneyGetDates, QFieldDT('MoneyGetDate'));
      VAppend(APretensionMoneyGetValues, QFieldInt64('MoneyGetValue'));
      VAppend(APretensionNotes, QFieldStr('PretensionNote'));
      VAppend(APretensionStatuses, QFieldInt('PretensionStatus'));

      QNext;
    end;
  end;
  QClose;
end;

end.

