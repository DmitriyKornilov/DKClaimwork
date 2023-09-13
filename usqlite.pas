unit USQLite;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls,

  DK_SQLite3, DK_SQLUtils, DK_Vector, DK_Matrix, DK_StrUtils, DK_DateUtils,

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

    //электродвигатели
    procedure MotorsAllLoad(const AMotorNumLike: String;  //список всех электродвигателей
                            out AMotorIDs: TIntVector;
                            out AMotorNames, AMotorNums: TStrVector;
                            out AMotorDates: TDateVector);
    procedure MotorsForReclamationLoad(const AIsWithNoticeLoad: Boolean;  //список электродвигателей для уведомления о рекламации
                            const AMotorNumLike: String;
                            const ABusyMotorIDs: TIntVector;
                            out AMotorIDs: TIntVector;
                            out AMotorNames, AMotorNums: TStrVector;
                            out AMotorDates: TDateVector);
    procedure MotorsForPretensionLoad(const AMotorNumLike: String;  //список электродвигателей для претензии
                            const ABusyRecLogIDs: TIntVector;
                            out ARecLogIDs, AMotorIDs: TIntVector;
                            out ARecNoticeNums, AMotorNames, AMotorNums: TStrVector;
                            out ARecNoticeDates, AMotorDates: TDateVector);
    procedure MotorsForRepairLoad(const AMotorNumLike: String;  //список электродвигателей для запроса ремонта
                            const ABusyRecLogIDs: TIntVector;
                            out ARecLogIDs, AMotorIDs: TIntVector;
                            out ARecNoticeNums, AMotorNames, AMotorNums: TStrVector;
                            out ARecNoticeDates, AMotorDates: TDateVector);

    procedure MotorsEmptyLetterLoad(const ALetterType: Byte; //список электродвигателей с пустым письмом
                            const AMotorNumLike: String;
                            const ABusyLogIDs: TIntVector;
                            const AUserID: Integer;
                            out ALogIDs, AMotorIDs: TIntVector;
                            out AMotorNames, AMotorNums: TStrVector;
                            out AMotorDates: TDateVector;
                            out ANoticeNums: TStrVector;
                            out ANoticeDates: TDateVector;
                            const ALocationID: Integer = 0);
    procedure MotorsInLetterLoad(const ALetterType: Byte;
                                  const ALetterNum: String;
                                  const ALetterDate: TDate;
                                  out ALogIDs, AMotorIDs: TIntVector;
                                  out AMotorNames, AMotorNums: TStrVector;
                                  out AMotorDates: TDateVector;
                                  out ANoticeNums: TStrVector;
                                  out ANoticeDates: TDateVector);
     procedure MotorsInPretensionLetterLoad(const ALetterType: Byte;
                                  const ALetterNum: String;
                                  const ALetterDate: TDate;
                                  out APretensionIDs: TIntVector;
                                  out ANoticeNums: TStrVector;
                                  out ANoticeDates: TDateVector;
                                  out AMoneyValues: TInt64Vector;
                                  out AMotorNames, AMotorNums: TStrMatrix;
                                  out AMotorDates: TDateMatrix);
    procedure MotorsEmptyPretensionLetterLoad(const ALetterType: Byte;
                                  const AMotorNumLike: String;
                                  const ABusyPretensionIDs: TIntVector;
                                  const AUserID: Integer;
                                  out APretensionIDs: TIntVector;
                                  out ANoticeNums: TStrVector;
                                  out ANoticeDates: TDateVector;
                                  out AMoneyValues: TInt64Vector;
                                  out AMotorNames, AMotorNums: TStrMatrix;
                                  out AMotorDates: TDateMatrix);



    //писок электродвигателей
    function MotorLastWritedLogID: Integer;
    procedure MotorLoad(const AMotorID: Integer;
                         out AMotorNameID: Integer;
                         out AMotorName, AMotorNum: String;
                         out AMotorDate: TDate);
    procedure MotorAdd(const AMotorNameID: Integer;
                       const AMotorNum: String;
                       const AMotorDate: TDate);
    procedure MotorUpdate(const AMotorID, AMotorNameID: Integer;
                           const AMotorNum: String;
                           const AMotorDate: TDate);
    procedure MotorDelete(const AMotorID: Integer);
    function MotorFind(const AMotorSearchNameID: Integer;
                       const AMotorSearchNum: String;
                       const AMotorSearchDate: TDate;
                       out AMotorID: Integer;
                       out AMotorName, AMotorNum: String;
                       out AMotorDate: TDate): Boolean;

    //рекламации
    procedure ReclamationListLoad(const AMotorNumLike: String;
                const ABeginDate, AEndDate: TDate;
                const AViewIndex: Integer;
                out AReclamationIDs: TIntVector;
                out AUserNames, AUserTitles: TStrVector;
                out ALocationNames, ALocationTitles: TStrVector;
                out ANoticeDates: TDateVector; out ANoticeNums: TStrVector;
                out AToBuilderDates: TDateMatrix; out AToBuilderNums: TStrMatrix;
                out AFromBuilderDates: TDateMatrix; out AFromBuilderNums: TStrMatrix;
                out AToUserDates: TDateMatrix; out AToUserNums: TStrMatrix;
                out ACancelDates: TDateMatrix; out ACancelNums: TStrMatrix;
                out AReportDates: TDateMatrix; out AReportNums: TStrMatrix;
                out ALogIDs, AMileages, AStatuses: TIntMatrix;
                out ANotes, AMotorNames, AMotorNums: TStrMatrix;
                out AMotorDates: TDateMatrix);
    procedure ReclamationInfoLoad(const AReclamationID: Integer;
                                  out AUserID, ALocationID: Integer;
                                  out ANoticeNum: String;
                                  out ANoticeDate: TDate);
    procedure ReclamationMotorsLoad(const AReclamationID: Integer;
                                  out AMotorIDs: TIntVector;
                                  out AMotorNames, AMotorNums: TStrVector;
                                  out AMotorDates: TDateVector);
    function ReclamationMaxID: Integer;

    procedure ReclamationNoticeDelete(const AReclamationID: Integer);
    procedure ReclamationNoticeAdd(const AMotorIDs: TIntVector;
                                      const AUserID, ALocationID: Integer;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate);
    procedure ReclamationNoticeUpdate(const AReclamationID: Integer;
                                      const AUserID, ALocationID: Integer;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate;
                                      const AAddMotorIDs, ADelMotorIDs: TIntVector);
    procedure ReclamationAnswerToUserDelete(const ALogID: Integer);
    function ReclamationStatusLoad(const ALogID: Integer): Integer;
    function ReclamationLocationIDLoad(const AReclamationID: Integer): Integer;

    procedure ReclamationCancelNotNeed(const ALogIDs, ADelLogIDs: TIntVector);
    procedure ReclamationCancelUpdate(const ALogIDs, ADelLogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate);
    procedure ReclamationCancelDelete(const ALogID: Integer);

    procedure ReclamationReportNotNeed(const ALogIDs, ADelLogIDs: TIntVector; const AStatus: Integer);
    procedure ReclamationReportUpdate(const ALogIDs, ADelLogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
    procedure ReclamationReportDelete(const ALogID: Integer);

    procedure MotorsReturn(const ALogIDs, AMotorIDs: TIntVector;   //возврат двигателя на этапе расследования рекламации
                           const AUserID: Integer;
                           const ALetterNum: String;
                           const ALetterDate: TDate);

    //ремонты
    procedure RepairListLoad(const AMotorNumLike: String;
                const ABeginDate, AEndDate: TDate;
                const AViewIndex, AMileageIndex: Integer;
                out ARepairIDs: TIntVector;
                out AUserNames, AUserTitles: TStrVector;
                out ANoticeDates: TDateVector; out ANoticeNums: TStrVector;
                out AToBuilderDates: TDateMatrix; out AToBuilderNums: TStrMatrix;
                out AFromBuilderDates: TDateMatrix; out AFromBuilderNums: TStrMatrix;
                out AToUserDates: TDateMatrix; out AToUserNums: TStrMatrix;
                out ARepairBeginDates, ARepairEndDates: TDateMatrix;
                out AReclamationIDs, ALogIDs, AMileages, AStatuses: TIntMatrix;
                out ANotes, AMotorNames, AMotorNums: TStrMatrix;
                out AMotorDates: TDateMatrix);
    procedure RepairInfoLoad(const ARepairID: Integer;
                             out AUserID: Integer;
                             out ANoticeNum: String;
                             out ANoticeDate: TDate);
    procedure RepairMotorsLoad(const ARepairID: Integer;
                               out ARecLogIDs, AMotorIDs: TIntVector;
                               out ARecNoticeNums, AMotorNames, AMotorNums: TStrVector;
                               out ARecNoticeDates, AMotorDates: TDateVector);
    function RepairMaxID: Integer;
    procedure RepairNoticeAdd(const ARecLogIDs, AMotorIDs: TIntVector;
                              const AUserID: Integer;
                              const ANoticeNum: String;
                              const ANoticeDate: TDate);
    procedure RepairNoticeDelete(const ARepairID: Integer);
    procedure RepairNoticeUpdate(const ARepairID: Integer;
                                  const AUserID: Integer;
                                  const ANoticeNum: String;
                                  const ANoticeDate: TDate;
                                  const AAddRecLogIDs, AAddMotorIDs, ADelRecLogIDs: TIntVector);
    procedure RepairDatesLoad(const ALogID: Integer; out ABeginDate, AEndDate: TDate);
    procedure RepairDatesUpdate(const ALogID, AStatus: Integer; const ABeginDate, AEndDate: TDate);
    procedure RepairDatesDelete(const ALogID: Integer);
    function RepairStatusLoad(const ALogID: Integer): Integer;
    procedure RepairAnswerToUserDelete(const ALogID: Integer);
    procedure RepairAnswersToUserUpdate(const ALogIDs, ADelLogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
    procedure RepairAnswerNotNeed(const ALogIDs, ADelLogIDs: TIntVector; const AStatus: Integer);

    //претензии
    procedure PretensionListLoad(const AMotorNumLike: String;
                const ABeginDate, AEndDate: TDate;
                const AViewIndex, AMileageIndex: Integer;
                out APretensionIDs, AStatuses: TIntVector;
                out AUserNames, AUserTitles, ANotes: TStrVector;
                out ANoticeDates: TDateVector; out ANoticeNums: TStrVector;
                out AMoneyValues, ASendValues, AGetValues: TInt64Vector;
                out ASendDates, AGetDates: TDateVector;
                out AToBuilderDates: TDateVector; out AToBuilderNums: TStrVector;
                out AFromBuilderDates: TDateVector; out AFromBuilderNums: TStrVector;
                out AToUserDates: TDateVector; out AToUserNums: TStrVector;
                out AReclamationIDs, ALogIDs, AMileages: TIntMatrix;
                out AMotorNames, AMotorNums: TStrMatrix;
                out AMotorDates: TDateMatrix);
    function PretensionMaxID: Integer;
    procedure PretensionInfoLoad(const APretensionID: Integer;
                                 out AUserID: Integer;
                                 out AMoneyValue: Int64;
                                 out ANoticeNum: String;
                                 out ANoticeDate: TDate);
    procedure PretensionMotorsLoad(const APretensionID: Integer;
                               out ARecLogIDs, AMotorIDs: TIntVector;
                               out ARecNoticeNums, AMotorNames, AMotorNums: TStrVector;
                               out ARecNoticeDates, AMotorDates: TDateVector);
    procedure PretensionNoticeAdd(const ARecLogIDs, AMotorIDs: TIntVector;
                              const AUserID: Integer;
                              const AMoneyValue: Int64;
                              const ANoticeNum: String;
                              const ANoticeDate: TDate);
    procedure PretensionNoticeDelete(const APretensionID: Integer);
    procedure PretensionNoticeUpdate(const APretensionID: Integer;
                                     const AUserID: Integer;
                                     const AMoneyValue: Int64;
                                     const ANoticeNum: String;
                                     const ANoticeDate: TDate;
                                     const AAddRecLogIDs, AAddMotorIDs, ADelRecLogIDs: TIntVector);
    procedure PretensionMoneyDatesLoad(const APretensionID: Integer;
                                     out ASendValue, AGetValue: Int64;
                                     out ASendDate, AGetDate: TDate);
    procedure PretensionMoneyDatesUpdate(const APretensionID, AStatus: Integer;
                                   const ASendValue, AGetValue: Int64;
                                   const ASendDate, AGetDate: TDate);
    procedure PretensionMoneyDatesDelete(const APretensionID: Integer);
    function PretensionStatusByLogIDLoad(const ALogID: Integer): Integer;
    function PretensionStatusLoad(const APretensionID: Integer): Integer;
    procedure PretensionLetterLoad(const APretensionID: Integer;
                                   const ALetterType: Byte;
                                   out ALetterNum: String;
                                   out ALetterDate: TDate);

    procedure PretensionLetterCustomUpdate(const APretensionIDs: TIntVector; //no commit
                                           const ALetterType: Byte;
                                           const ALetterNum: String;
                                           const ALetterDate: TDate;
                                           const AStatus: Integer = -1);
    procedure PretensionLetterDelete(const APretensionID: Integer; const ALetterType: Byte);
    procedure PretensionLetterNotNeed(const APretensionIDs, ADelPretensionIDs: TIntVector; const ALetterType: Byte);
    procedure PretensionLetterUpdate(const APretensionIDs, ADelPretensionIDs: TIntVector;
                                     const ALetterType: Byte;
                                     const ALetterNum: String;
                                     const ALetterDate: TDate);

    procedure PretensionAnswerToUserDelete(const APretensionID: Integer);
    procedure PretensionAnswerToUserNotNeed(const APretensionIDs, ADelPretensionIDs: TIntVector;
                                            const AStatus: Integer);
    procedure PretensionAnswersToUserUpdate(const APretensionIDs, ADelPretensionIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);


    //уведомления от Потребителя и ответы Производителя для формирования стандартных писем
    procedure NoticeAndAnswersLoad(const ALetterType: Byte;
                            const ALogIDs: TIntVector;
                            out AMotorNames, AMotorNums: TStrVector;
                            out AMotorDates: TDateVector;
                            out ANoticeNums: TStrVector;
                            out ANoticeDates: TDateVector;
                            out AAnswerNums: TStrVector;
                            out AAnswerDates: TDateVector);

    //приложения
    function AttachmentNameLoad(const ACategory: Byte; const AAttachmentID: Integer): String;
    procedure AttachmentDelete(const ACategory: Byte; const AAttachmentID: Integer);
    function AttachmentFind(const ACategory: Byte;
                            const AAttachmentID: Integer;
                            const AAttachmentName: String): Boolean;
    procedure AttachmentListLoad(const ACategory: Byte; const ALogID: Integer;
                                 out AAttachmentIDs: TIntVector;
                                 out AAttachmentNames, AAttachmentExtensions: TStrVector);
    procedure AttachmentAdd(const ACategory: Byte; const ALogID: Integer;
                            const AAttachmentName, AAttachmentExtension: String);
    procedure AttachmentUpdate(const ACategory: Byte; const AAttachmentID: Integer;
                            const AAttachmentName, AAttachmentExtension: String);


    //списки файлов
    function FileNamesLoad(const ACategory: Byte; const AReclamationID: Integer): TStrVector;
    function AllFileNamesLoad(const AReclamationID: Integer): TStrVector;         //все письма, каксающиеся AReclamationID
    function ReclamationFileNamesLoad(const AReclamationID: Integer): TStrVector; //письма (документы) по рекламации
    function RepairFileNamesLoad(const ARepairID: Integer): TStrVector;           //письма (документы) по ремонту
    function PretensionFileNamesLoad(const APretensionID: Integer): TStrVector;   //письма (документы) по претензии

    //письма общие
    procedure LetterLoad(const ALogID: Integer; const ALetterType: Byte;
                         out ALetterNum: String;
                         out ALetterDate: TDate);
    procedure LetterDelete(const ALogID: Integer; const ALetterType: Byte);
    procedure LettersUpdate(const ALogIDs, ADelLogIDs: TIntVector;
                           const ALetterType: Byte;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer = -1);
    procedure LettersNotNeed(const ALogIDs, ADelLogIDs: TIntVector; const ALetterType: Byte);
    function LetterUserIDLoad(const ALetterType: Byte; const AID: Integer): Integer;

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
    function NoteLoad(const ALogID: Integer; const ACategory: Byte): String;
    procedure NoteUpdate(const ALogID: Integer; const ACategory: Byte; const ANote: String);
    procedure NoteDelete(const ALogID: Integer; const ACategory: Byte);

    function PretensionNoteLoad(const APretensionID: Integer): String;
    procedure PretensionNoteUpdate(const APretensionID: Integer; const ANote: String);
    procedure PretensionNoteDelete(const APretensionID: Integer);

    //пробеги
    function MileageLoad(const ALogID: Integer): Integer;
    procedure MileageUpdate(const ALogID: Integer; const AMileage: Integer);
    procedure MileageDelete(const ALogID: Integer);

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
  Result:= LastWritedInt32ID('MOTORS');
end;

procedure TSQLite.MotorLoad(const AMotorID: Integer;
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
    'FROM MOTORS t1 ' +
    'INNER JOIN MOTORNAMES t2 ON (t1.MotorNameID = t2.MotorNameID) ' +
    'WHERE ' +
        't1.MotorID = :MotorID'
  );
  QParamInt('MotorID', AMotorID);
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
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'INSERT INTO ' +
        'MOTORS ' +
        '(MotorNameID, MotorNum, MotorDate) ' +
      'VALUES ' +
        '(:MotorNameID, :MotorNum, :MotorDate) '
    );
    QParamInt('MotorNameID', AMotorNameID);
    QParamStr('MotorNum', AMotorNum);
    QParamDT('MotorDate', AMotorDate);
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.MotorUpdate(const AMotorID, AMotorNameID: Integer;
                           const AMotorNum: String;
                           const AMotorDate: TDate);
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'MOTORS ' +
      'SET ' +
        'MotorNameID = :MotorNameID, MotorNum = :MotorNum, MotorDate = :MotorDate ' +
      'WHERE ' +
        'MotorID = :MotorID'
    );
    QParamInt('MotorID', AMotorID);
    QParamInt('MotorNameID', AMotorNameID);
    QParamStr('MotorNum', AMotorNum);
    QParamDT('MotorDate', AMotorDate);
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.MotorDelete(const AMotorID: Integer);
begin
  Delete('MOTORS', 'MotorID', AMotorID);
end;

function TSQLite.MotorFind(const AMotorSearchNameID: Integer;
                       const AMotorSearchNum: String;
                       const AMotorSearchDate: TDate;
                       out AMotorID: Integer;
                       out AMotorName, AMotorNum: String;
                       out AMotorDate: TDate): Boolean;
begin
  Result:= False;
  AMotorID:= 0;
  AMotorName:= EmptyStr;
  AMotorNum:= EmptyStr;
  AMotorDate:= 0;
  QSetSQL(
    'SELECT ' +
      't1.MotorID, t1.MotorNameID, t1.MotorNum, t1.MotorDate, t2.MotorName ' +
    'FROM ' +
      'MOTORS t1 ' +
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
    AMotorID:= QFieldInt('MotorID');
    AMotorName:= QFieldStr('MotorName');
    AMotorNum:= QFieldStr('MotorNum');
    AMotorDate:= QFieldDT('MotorDate');
  end;
  QClose;
end;

procedure TSQLite.ReclamationListLoad(const AMotorNumLike: String;
                const ABeginDate, AEndDate: TDate;
                const AViewIndex: Integer;
                out AReclamationIDs: TIntVector;
                out AUserNames, AUserTitles: TStrVector;
                out ALocationNames, ALocationTitles: TStrVector;
                out ANoticeDates: TDateVector; out ANoticeNums: TStrVector;
                out AToBuilderDates: TDateMatrix; out AToBuilderNums: TStrMatrix;
                out AFromBuilderDates: TDateMatrix; out AFromBuilderNums: TStrMatrix;
                out AToUserDates: TDateMatrix; out AToUserNums: TStrMatrix;
                out ACancelDates: TDateMatrix; out ACancelNums: TStrMatrix;
                out AReportDates: TDateMatrix; out AReportNums: TStrMatrix;
                out ALogIDs, AMileages, AStatuses: TIntMatrix;
                out ANotes, AMotorNames, AMotorNums: TStrMatrix;
                out AMotorDates: TDateMatrix);
var
  S: String;
  OldID, NewID, n: Integer;
begin
  AReclamationIDs:= nil;
  AUserNames:= nil;
  AUserTitles:= nil;
  ALocationNames:= nil;
  ALocationTitles:= nil;
  ANoticeDates:= nil;
  ANoticeNums:= nil;
  AToBuilderDates:= nil;
  AToBuilderNums:= nil;
  AFromBuilderDates:= nil;
  AFromBuilderNums:= nil;
  AToUserDates:= nil;
  AToUserNums:= nil;
  ACancelDates:= nil;
  ACancelNums:= nil;
  AReportDates:= nil;
  AReportNums:= nil;
  ALogIDs:= nil;
  AMileages:= nil;
  AStatuses:= nil;
  ANotes:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

  S:=
    'SELECT ' +
      't1.*, '+
      't2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum, ' +
      't5.LocationName, t5.LocationTitle, ' +
      't6.UserNameI, t6.UserTitle ' +
    'FROM ' +
      'RECLAMATIONMOTORS t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'INNER JOIN RECLAMATIONS t4 ON (t1.ReclamationID=t4.ReclamationID) ' +
    'INNER JOIN LOCATIONS t5 ON (t4.LocationID=t5.LocationID) ' +
    'INNER JOIN USERS t6 ON (t4.UserID=t6.UserID) ' +
    'WHERE ' +
      '(t1.ReclamationID>0) ';

  if not SEmpty(AMotorNumLike) then
    S:= S + 'AND (UPPER(t2.MotorNum) LIKE :NumberLike) '   //отбор только по номеру двигателя
  else begin
    if (AViewIndex<>1) and  //расслед
       (ABeginDate>0) and (AEndDate>0) then
      S:= S + 'AND (t4.NoticeFromUserDate BETWEEN :BD AND :ED) ';
    if AViewIndex>0 then
      S:= S + ' AND (t1.Status = :Status) ';
  end;
  S:= S +
    'ORDER BY t4.NoticeFromUserDate, t4.NoticeFromUserNum';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  QParamDT('BD', ABeginDate);
  QParamDT('ED', AEndDate);
  QParamInt('Status', AViewIndex);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    OldID:= 0;
    while not QEOF do
    begin
      NewID:= QFieldInt('ReclamationID');
      if NewID<>OldID then
      begin
        VAppend(AReclamationIDs, NewID);
        VAppend(AUserNames, QFieldStr('UserNameI'));
        VAppend(AUserTitles, QFieldStr('UserTitle'));
        VAppend(ALocationNames, QFieldStr('LocationName'));
        VAppend(ALocationTitles, QFieldStr('LocationTitle'));
        VAppend(ANoticeDates, QFieldDT('NoticeFromUserDate'));
        VAppend(ANoticeNums, QFieldStr('NoticeFromUserNum'));

        MAppend(AToBuilderDates, VCreateDate([QFieldDT('NoticeToBuilderDate')]));
        MAppend(AToBuilderNums, VCreateStr([QFieldStr('NoticeToBuilderNum')]));
        MAppend(AFromBuilderDates, VCreateDate([QFieldDT('AnswerFromBuilderDate')]));
        MAppend(AFromBuilderNums, VCreateStr([QFieldStr('AnswerFromBuilderNum')]));
        MAppend(AToUserDates, VCreateDate([QFieldDT('AnswerToUserDate')]));
        MAppend(AToUserNums, VCreateStr([QFieldStr('AnswerToUserNum')]));
        MAppend(ACancelDates, VCreateDate([QFieldDT('CancelDate')]));
        MAppend(ACancelNums, VCreateStr([QFieldStr('CancelNum')]));
        MAppend(AReportDates, VCreateDate([QFieldDT('ReportDate')]));
        MAppend(AReportNums, VCreateStr([QFieldStr('ReportNum')]));
        MAppend(AMileages, VCreateInt([QFieldInt('Mileage')]));
        MAppend(ANotes, VCreateStr([QFieldStr('Note')]));
        MAppend(AStatuses, VCreateInt([QFieldInt('Status')]));
        MAppend(ALogIDs, VCreateInt([QFieldInt('LogID')]));
        MAppend(AMotorNames, VCreateStr([QFieldStr('MotorName')]));
        MAppend(AMotorNums, VCreateStr([QFieldStr('MotorNum')]));
        MAppend(AMotorDates, VCreateDate([QFieldDT('MotorDate')]));
        OldID:= NewID;
      end
      else begin
        n:= High(AReclamationIDs);
        VAppend(AToBuilderDates[n], QFieldDT('NoticeToBuilderDate'));
        VAppend(AToBuilderNums[n], QFieldStr('NoticeToBuilderNum'));
        VAppend(AFromBuilderDates[n], QFieldDT('AnswerFromBuilderDate'));
        VAppend(AFromBuilderNums[n], QFieldStr('AnswerFromBuilderNum'));
        VAppend(AToUserDates[n], QFieldDT('AnswerToUserDate'));
        VAppend(AToUserNums[n], QFieldStr('AnswerToUserNum'));
        VAppend(ACancelDates[n], QFieldDT('CancelDate'));
        VAppend(ACancelNums[n], QFieldStr('CancelNum'));
        VAppend(AReportDates[n], QFieldDT('ReportDate'));
        VAppend(AReportNums[n], QFieldStr('ReportNum'));
        VAppend(AMileages[n], QFieldInt('Mileage'));
        VAppend(ANotes[n], QFieldStr('Note'));
        VAppend(AStatuses[n], QFieldInt('Status'));
        VAppend(ALogIDs[n], QFieldInt('LogID'));
        VAppend(AMotorNames[n], QFieldStr('MotorName'));
        VAppend(AMotorNums[n], QFieldStr('MotorNum'));
        VAppend(AMotorDates[n], QFieldDT('MotorDate'));
      end;
      QNext;
    end;
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

procedure TSQLite.MotorsAllLoad(const AMotorNumLike: String;
                            out AMotorIDs: TIntVector;
                            out AMotorNames, AMotorNums: TStrVector;
                            out AMotorDates: TDateVector);
var
  S: String;
begin
  AMotorIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

  S:=
    'SELECT ' +
      't1.MotorID, t1.MotorNum, t1.MotorDate, t2.MotorName ' +
    'FROM ' +
      'MOTORS t1 ' +
      'INNER JOIN MOTORNAMES t2 ON (t1.MotorNameID=t2.MotorNameID) ';

  if not SEmpty(AMotorNumLike) then
    S:= S + 'WHERE (UPPER(t1.MotorNum) LIKE :NumberLike) ';

  S:= S + 'ORDER BY t1.MotorNum, t1.MotorDate, t2.MotorName ';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.MotorsForReclamationLoad(const AIsWithNoticeLoad: Boolean;
                            const AMotorNumLike: String;
                            const ABusyMotorIDs: TIntVector;
                            out AMotorIDs: TIntVector;
                            out AMotorNames, AMotorNums: TStrVector;
                            out AMotorDates: TDateVector);
var
  S: String;
begin
  AMotorIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

  S:=
    'SELECT ' +
      't1.MotorID, t1.MotorNum, t1.MotorDate, t2.MotorName, t3.LogID ' +
    'FROM ' +
      'MOTORS t1 ' +
      'INNER JOIN MOTORNAMES t2 ON (t1.MotorNameID=t2.MotorNameID) ' +
      'LEFT OUTER JOIN RECLAMATIONMOTORS t3 ON (t1.MotorID=t3.MotorID) '+
      'LEFT OUTER JOIN RECLAMATIONS t4 ON (t3.ReclamationID=t4.ReclamationID) ' +
    'WHERE ' +
      '(t1.MotorID>0) ';

  //один и тот же мотор может словить рекламацию не один раз
  if not AIsWithNoticeLoad then
    S:= S + 'AND (t3.LogID IS NULL) ';

  if not VIsNil(ABusyMotorIDs) then
    S:= S + 'AND' + SqlNOTIN('t1','MotorID', Length(ABusyMotorIDs));

  if not SEmpty(AMotorNumLike) then
    S:= S + 'AND (UPPER(t1.MotorNum) LIKE :NumberLike) ';

  S:= S + ' ORDER BY t1.MotorNum, t1.MotorDate, t2.MotorName ';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  if not VIsNil(ABusyMotorIDs) then QParamsInt(ABusyMotorIDs);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.MotorsForRepairLoad(const AMotorNumLike: String;  //список электродвигателей для запроса ремонта
                            const ABusyRecLogIDs: TIntVector;
                            out ARecLogIDs, AMotorIDs: TIntVector;
                            out ARecNoticeNums, AMotorNames, AMotorNums: TStrVector;
                            out ARecNoticeDates, AMotorDates: TDateVector);
var
  S: String;
begin
  ARecLogIDs:= nil;
  AMotorIDs:= nil;
  ARecNoticeNums:= nil;
  ARecNoticeDates:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

  S:=
    'SELECT ' +
      't1.LogID, t1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum ' +
    'FROM ' +
      'RECLAMATIONMOTORS t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'INNER JOIN RECLAMATIONS t4 ON (t1.ReclamationID=t4.ReclamationID) ' +
      'LEFT OUTER JOIN REPAIRMOTORS t5 ON (t1.LogID=t5.RecLogID) ' +
    'WHERE ' +
      '(t5.RecLogID IS NULL) ';


  if not VIsNil(ABusyRecLogIDs) then
    S:= S + 'AND' + SqlNOTIN('t1','LogID', Length(ABusyRecLogIDs));

  if not SEmpty(AMotorNumLike) then
    S:= S + 'AND (UPPER(t2.MotorNum) LIKE :NumberLike) ';

  S:= S + ' ORDER BY t2.MotorNum, t2.MotorDate, t3.MotorName, t4.NoticeFromUserDate, t4.NoticeFromUserNum ';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  if not VIsNil(ABusyRecLogIDs) then QParamsInt(ABusyRecLogIDs);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ARecLogIDs, QFieldInt('LogID'));
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      VAppend(ARecNoticeNums, QFieldStr('NoticeFromUserNum'));
      VAppend(ARecNoticeDates, QFieldDT('NoticeFromUserDate'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.MotorsForPretensionLoad(const AMotorNumLike: String;
                            const ABusyRecLogIDs: TIntVector;
                            out ARecLogIDs, AMotorIDs: TIntVector;
                            out ARecNoticeNums, AMotorNames, AMotorNums: TStrVector;
                            out ARecNoticeDates, AMotorDates: TDateVector);
var
  S: String;
begin
  ARecLogIDs:= nil;
  AMotorIDs:= nil;
  ARecNoticeNums:= nil;
  ARecNoticeDates:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

  S:=
    'SELECT ' +
      't1.LogID, t1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum ' +
    'FROM ' +
      'RECLAMATIONMOTORS t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'LEFT OUTER JOIN RECLAMATIONS t4 ON (t1.ReclamationID=t4.ReclamationID) ' +
      'LEFT OUTER JOIN PRETENSIONMOTORS t5 ON (t1.LogID=t5.RecLogID) ' +
    'WHERE ' +
      '(t5.RecLogID IS NULL) ';


  if not VIsNil(ABusyRecLogIDs) then
    S:= S + 'AND' + SqlNOTIN('t1','LogID', Length(ABusyRecLogIDs));

  if not SEmpty(AMotorNumLike) then
    S:= S + 'AND (UPPER(t2.MotorNum) LIKE :NumberLike) ';

  S:= S + ' ORDER BY t2.MotorNum, t2.MotorDate, t3.MotorName, t4.NoticeFromUserDate, t4.NoticeFromUserNum ';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  if not VIsNil(ABusyRecLogIDs) then QParamsInt(ABusyRecLogIDs);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ARecLogIDs, QFieldInt('LogID'));
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      VAppend(ARecNoticeNums, QFieldStr('NoticeFromUserNum'));
      VAppend(ARecNoticeDates, QFieldDT('NoticeFromUserDate'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.MotorsEmptyLetterLoad(const ALetterType: Byte; //список электродвигателей с пустым письмом
                            const AMotorNumLike: String;
                            const ABusyLogIDs: TIntVector;
                            const AUserID: Integer;
                            out ALogIDs, AMotorIDs: TIntVector;
                            out AMotorNames, AMotorNums: TStrVector;
                            out AMotorDates: TDateVector;
                            out ANoticeNums: TStrVector;
                            out ANoticeDates: TDateVector;
                            const ALocationID: Integer = 0);
var
  S, LogNoticeTableName, LogMotorsTableName: String;
  DateField, NumField, IDField: String;
  Category: Byte;
begin
  ALogIDs:= nil;
  AMotorIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  ANoticeNums:= nil;
  ANoticeDates:= nil;

  Category:= CategoryFromLetterType(ALetterType);
  LogNoticeTableName:= SqlEsc(LogNoticeTableNameGet(Category));
  IDField:= SqlEsc(LogNoticeIDFieldNameGet(Category));

  LetterDBNamesGet(ALetterType, LogMotorsTableName, DateField, NumField);
  LogMotorsTableName:= SqlEsc(LogMotorsTableName);
  DateField:= SqlEsc(DateField);
  NumField:= SqlEsc(NumField);

  S:=
    'SELECT ' +
      't1.LogID, t1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum ' +
    'FROM ' +
      LogMotorsTableName + ' t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'INNER JOIN '+LogNoticeTableName+' t4 ON (t1.'+IDField+'=t4.'+IDField+') ' +
    'WHERE ' +
      '(t4.UserID = :UserID) AND ' +
      '((t1.'+DateField+' IS NULL) AND (t1.'+NumField+' IS NULL)) ';

  if ALetterType in [2,3,4,8,9] then
  begin
    LetterDBNamesGet(ALetterType-1, LogMotorsTableName, DateField, NumField);
    S:= S +
      ' AND (t1.'+NumField+' IS NOT NULL) '; //DateField может NULL, если NumField=NOT_NEED_MARK
  end;

  if ALocationID>0 then
    S:= S + 'AND (t4.LocationID = :LocationID) ';

  if not VIsNil(ABusyLogIDs) then
    S:= S + 'AND' + SqlNOTIN('t1','LogID', Length(ABusyLogIDs));

  if not SEmpty(AMotorNumLike) then
    S:= S + 'AND (UPPER(t2.MotorNum) LIKE :NumberLike) ';

  S:= S + ' ORDER BY t2.MotorNum, t2.MotorDate, t3.MotorName ';


  QSetQuery(FQuery);
  QSetSQL(S);
  QParamInt('UserID', AUserID);
  QParamInt('LocationID', ALocationID);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  if not VIsNil(ABusyLogIDs) then QParamsInt(ABusyLogIDs);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ANoticeNums, QFieldStr('NoticeFromUserNum'));
      VAppend(ANoticeDates, QFieldDT('NoticeFromUserDate'));
      VAppend(ALogIDs, QFieldInt('LogID'));
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.MotorsInLetterLoad(const ALetterType: Byte;
                                  const ALetterNum: String;
                                  const ALetterDate: TDate;
                                  out ALogIDs, AMotorIDs: TIntVector;
                                  out AMotorNames, AMotorNums: TStrVector;
                                  out AMotorDates: TDateVector;
                                  out ANoticeNums: TStrVector;
                                  out ANoticeDates: TDateVector);
var
  LogMotorTableName, LogNoticeTableName, DateField, NumField, IDFieldName: String;
  Category: Byte;
begin
  ALogIDs:= nil;
  AMotorIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  ANoticeNums:= nil;
  ANoticeDates:= nil;

  LetterDBNamesGet(ALetterType, LogMotorTableName, DateField, NumField);
  LogMotorTableName:= SqlEsc(LogMotorTableName);
  DateField:= SqlEsc(DateField);
  NumField:= SqlEsc(NumField);
  Category:= CategoryFromLetterType(ALetterType);
  LogNoticeTableName:= SqlEsc(LogNoticeTableNameGet(Category));
  IDFieldName:=  SqlEsc(LogNoticeIDFieldNameGet(Category));

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't1.LogID, t1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum ' +
    'FROM ' +
      LogMotorTableName +' t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'INNER JOIN '+ LogNoticeTableName+ ' t4 ON (t1.'+ IDFieldName + '=t4.' + IDFieldName + ') ' +
    'WHERE ' +
      '(t1.' + DateField + ' = :DateValue) AND (t1.' + NumField + ' = :NumValue) ' +
    'ORDER BY t2.MotorNum, t2.MotorDate, t3.MotorName'
  );
  QParamDT('DateValue', ALetterDate);
  QParamStr('NumValue', ALetterNum);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ANoticeNums, QFieldStr('NoticeFromUserNum'));
      VAppend(ANoticeDates, QFieldDT('NoticeFromUserDate'));
      VAppend(ALogIDs, QFieldInt('LogID'));
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      QNext;
    end;
  end;
  QClose;
end;


procedure TSQLite.MotorsEmptyPretensionLetterLoad(const ALetterType: Byte;
                                  const AMotorNumLike: String;
                                  const ABusyPretensionIDs: TIntVector;
                                  const AUserID: Integer;
                                  out APretensionIDs: TIntVector;
                                  out ANoticeNums: TStrVector;
                                  out ANoticeDates: TDateVector;
                                  out AMoneyValues: TInt64Vector;
                                  out AMotorNames, AMotorNums: TStrMatrix;
                                  out AMotorDates: TDateMatrix);
var
  S, DateField, NumField: String;
  OldID, NewID, n: Integer;
begin
  APretensionIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  ANoticeNums:= nil;
  ANoticeDates:= nil;
  AMoneyValues:= nil;

  LetterDBNamesGet(ALetterType, S, DateField, NumField);
  DateField:= SqlEsc(DateField);
  NumField:= SqlEsc(NumField);



  S:=
    'SELECT DISTINCT ' +
      't1.PretensionID ' +
    'FROM ' +
      'PRETENSIONMOTORS t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'INNER JOIN PRETENSIONS t4 ON (t1.PretensionID=t4.PretensionID) ' +
    'WHERE ' +
      '(t4.UserID = :UserID) AND ' +
      '((t4.'+DateField+' IS NULL) AND (t4.'+NumField+' IS NULL)) ';

  if ALetterType = 12 then
    S:= S + ' AND (t4.NoticeToBuilderNum IS NOT NULL) ' //DateField может NULL, если NumField=NOT_NEED_MARK
  else if ALetterType = 13 then
    S:= S + ' AND (t4.AnswerFromBuilderNum IS NOT NULL) '; //DateField может NULL, если NumField=NOT_NEED_MARK

  if not VIsNil(ABusyPretensionIDs) then
    S:= S + 'AND' + SqlNOTIN('t1','PretensionID', Length(ABusyPretensionIDs));

  if not SEmpty(AMotorNumLike) then
    S:= S + 'AND (UPPER(t2.MotorNum) LIKE :NumberLike) ';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamInt('UserID', AUserID);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  if not VIsNil(ABusyPretensionIDs) then QParamsInt(ABusyPretensionIDs);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(APretensionIDs, QFieldInt('PretensionID'));
      QNext;
    end;
  end;
  QClose;

  if VIsNil(APretensionIDs) then Exit;

  S:=
    'SELECT ' +
      't1.PretensionID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum, t4.MoneyValue ' +
    'FROM ' +
      'PRETENSIONMOTORS t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'INNER JOIN PRETENSIONS t4 ON (t1.PretensionID=t4.PretensionID) ' +
    'WHERE ' +
      SqlIN('t1','PretensionID', Length(APretensionIDs)) +
    'ORDER BY ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum, t2.MotorNum, t2.MotorDate, t3.MotorName ';


  QSetQuery(FQuery);
  QSetSQL(S);
  QParamsInt(APretensionIDs);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    OldID:= 0;
    APretensionIDs:= nil;
    while not QEOF do
    begin
      NewID:= QFieldInt('PretensionID');
      if NewID<>OldID then
      begin
        VAppend(APretensionIDs, NewID);
        VAppend(ANoticeNums, QFieldStr('NoticeFromUserNum'));
        VAppend(ANoticeDates, QFieldDT('NoticeFromUserDate'));
        VAppend(AMoneyValues, QFieldInt64('MoneyValue'));
        MAppend(AMotorNames, VCreateStr([QFieldStr('MotorName')]));
        MAppend(AMotorNums, VCreateStr([QFieldStr('MotorNum')]));
        MAppend(AMotorDates, VCreateDate([QFieldDT('MotorDate')]));
        OldID:= NewID;
      end
      else begin
        n:= High(AMotorNames);
        VAppend(AMotorNames[n], QFieldStr('MotorName'));
        VAppend(AMotorNums[n], QFieldStr('MotorNum'));
        VAppend(AMotorDates[n], QFieldDT('MotorDate'));
      end;
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.MotorsInPretensionLetterLoad(const ALetterType: Byte;
                                  const ALetterNum: String;
                                  const ALetterDate: TDate;
                                  out APretensionIDs: TIntVector;
                                  out ANoticeNums: TStrVector;
                                  out ANoticeDates: TDateVector;
                                  out AMoneyValues: TInt64Vector;
                                  out AMotorNames, AMotorNums: TStrMatrix;
                                  out AMotorDates: TDateMatrix);
var
  S, DateField, NumField: String;
  OldID, NewID, n: Integer;
begin
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  APretensionIDs:= nil;
  ANoticeNums:= nil;
  ANoticeDates:= nil;
  AMoneyValues:= nil;

  LetterDBNamesGet(ALetterType, S, DateField, NumField);
  DateField:= SqlEsc(DateField);
  NumField:= SqlEsc(NumField);

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't1.PretensionID, t1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum, t4.MoneyValue ' +
    'FROM ' +
      'PRETENSIONMOTORS t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'INNER JOIN PRETENSIONS t4 ON (t1.PretensionID=t4.PretensionID) ' +
    'WHERE ' +
      '(t4.'+DateField+' = :DateValue) AND (t4.'+NumField+' = :NumValue) ' +
    'ORDER BY t4.NoticeFromUserDate, t4.NoticeFromUserNum, t2.MotorNum, t2.MotorDate, t3.MotorName '
  );
  QParamDT('DateValue', ALetterDate);
  QParamStr('NumValue', ALetterNum);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    OldID:= 0;
    while not QEOF do
    begin
      NewID:= QFieldInt('PretensionID');
      if NewID<>OldID then
      begin
        VAppend(APretensionIDs, NewID);
        VAppend(ANoticeNums, QFieldStr('NoticeFromUserNum'));
        VAppend(ANoticeDates, QFieldDT('NoticeFromUserDate'));
        VAppend(AMoneyValues, QFieldInt64('MoneyValue'));
        MAppend(AMotorNames, VCreateStr([QFieldStr('MotorName')]));
        MAppend(AMotorNums, VCreateStr([QFieldStr('MotorNum')]));
        MAppend(AMotorDates, VCreateDate([QFieldDT('MotorDate')]));
        OldID:= NewID;
      end
      else begin
        n:= High(APretensionIDs);
        VAppend(AMotorNames[n], QFieldStr('MotorName'));
        VAppend(AMotorNums[n], QFieldStr('MotorNum'));
        VAppend(AMotorDates[n], QFieldDT('MotorDate'));
      end;
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.ReclamationInfoLoad(const AReclamationID: Integer;
                                  out AUserID, ALocationID: Integer;
                                  out ANoticeNum: String;
                                  out ANoticeDate: TDate);
begin
  AUserID:= 0;
  ALocationID:= 0;
  ANoticeNum:= EmptyStr;
  ANoticeDate:= 0;
  if AReclamationID<=0 then Exit;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'UserID, LocationID, NoticeFromUserDate, NoticeFromUserNum ' +
    'FROM ' +
      'RECLAMATIONS ' +
    'WHERE ' +
      'ReclamationID = :ReclamationID'
  );
  QParamInt('ReclamationID', AReclamationID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AUserID:= QFieldInt('UserID');
    ALocationID:= QFieldInt('LocationID');
    ANoticeNum:= QFieldStr('NoticeFromUserNum');
    ANoticeDate:= QFieldDT('NoticeFromUserDate');
  end;
  QClose;
end;

procedure TSQLite.ReclamationMotorsLoad(const AReclamationID: Integer;
                                  out AMotorIDs: TIntVector;
                                  out AMotorNames, AMotorNums: TStrVector;
                                  out AMotorDates: TDateVector);
begin
  AMotorIDs:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  if AReclamationID<=0 then Exit;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName ' +
    'FROM ' +
      'RECLAMATIONMOTORS t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'WHERE ' +
      't1.ReclamationID = :ReclamationID ' +
    'ORDER BY t2.MotorNum, t2.MotorDate, t3.MotorName'
  );
  QParamInt('ReclamationID', AReclamationID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      QNext;
    end;
  end;
  QClose;
end;

function TSQLite.ReclamationMaxID: Integer;
begin
  Result:= MaxInt32ID('RECLAMATIONS');
end;

procedure TSQLite.ReclamationNoticeUpdate(const AReclamationID: Integer;
                                      const AUserID, ALocationID: Integer;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate;
                                      const AAddMotorIDs, ADelMotorIDs: TIntVector);
var
  i: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'RECLAMATIONS ' +
      'SET ' +
        'UserID = :UserID, LocationID = :LocationID, ' +
        'NoticeFromUserDate = :NoticeFromUserDate, NoticeFromUserNum = :NoticeFromUserNum ' +
      'WHERE ' +
        'ReclamationID = :ReclamationID'
    );
    QParamInt('ReclamationID', AReclamationID);
    QParamInt('LocationID', ALocationID);
    QParamInt('UserID', AUserID);
    QParamStr('NoticeFromUserNum', ANoticeNum);
    QParamDT('NoticeFromUserDate', ANoticeDate);
    QExec;

    if not VIsNil(AAddMotorIDs) then
    begin
      QSetSQL(
        'INSERT INTO ' +
          'RECLAMATIONMOTORS ' +
          '(ReclamationID, MotorID, Status) ' +
        'VALUES ' +
          '(:ReclamationID, :MotorID, 1) '
      );
      QParamInt('ReclamationID', AReclamationID);
      for i:= 0 to High(AAddMotorIDs) do
      begin
        QParamInt('MotorID', AAddMotorIDs[i]);
        QExec;
      end;
    end;

    if not VIsNil(ADelMotorIDs) then
    begin
      QSetSQL(
        'DELETE FROM ' +
          'RECLAMATIONMOTORS ' +
        'WHERE ' +
          '(ReclamationID = :ReclamationID) AND ' + SqlIN('','MotorID', Length(ADelMotorIDs))
      );
      QParamInt('ReclamationID', AReclamationID);
      QParamsInt(ADelMotorIDs);
      QExec;
    end;

    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.ReclamationAnswerToUserDelete(const ALogID: Integer);
begin
  LettersUpdate(VCreateInt([ALogID]), nil, 3 {ответ на рекл}, EmptyStr, 0, 1{в работе});
end;

function TSQLite.ReclamationStatusLoad(const ALogID: Integer): Integer;
begin
  Result:= ValueInt32Int32ID('RECLAMATIONMOTORS', 'Status', 'LogID', ALogID);
end;

function TSQLite.ReclamationLocationIDLoad(const AReclamationID: Integer): Integer;
begin
  Result:= ValueInt32Int32ID('RECLAMATIONS', 'LocationID', 'ReclamationID', AReclamationID);
end;

procedure TSQLite.ReclamationNoticeDelete(const AReclamationID: Integer);
var
  i, j: Integer;
  RepairIDs, PretensionIDs: TIntVector;

  function GetIDs(const ATableName, AIDFieldName: String): TIntVector;
  begin
    Result:= nil;
    QSetQuery(FQuery);
    QSetSQL(
      'SELECT DISTINCT ' +
        't1.' + SqlEsc(AIDFieldName) +
      'FROM ' +
        SqlEsc(ATableName) + ' t1 ' +
      'INNER JOIN RECLAMATIONMOTORS t2 ON (t1.RecLogID=t2.LogID) ' +
      'WHERE ' +
        't2.ReclamationID = :ReclamationID '
    );
    QParamInt('ReclamationID', AReclamationID);
    QOpen;
    if not QIsEmpty then
    begin
      QFirst;
      while not QEOF do
      begin
        VAppend(Result, QFieldInt(AIDFieldName));
        QNext;
      end;
    end;
    QClose;
  end;

begin
  //получаем список RepairID из REPAIRMOTORS с этими ReclamationID
  RepairIDs:= GetIDs('REPAIRMOTORS', 'RepairID');
  //получаем список PretensionID из PRETENSIONMOTORS с этими ReclamationID
  PretensionIDs:= GetIDs('PRETENSIONMOTORS', 'PretensionID');
  try
    //удаляем данные по рекламации
    Delete('RECLAMATIONS', 'ReclamationID', AReclamationID, False {no commit});
    //удаляем оставшиеся пустыми записи из REPAIRS
    for i:= 0 to High(RepairIDs) do
    begin
      j:= ValueInt32Int32ID('REPAIRMOTORS', 'LogID', 'RepairID', RepairIDs[i]);
      if j=0 then
        Delete('REPAIRS', 'RepairID', RepairIDs[i], False {no commit});
    end;
    //удаляем оставшиеся пустыми записи из PRETENSIONS
    for i:= 0 to High(PretensionIDs) do
    begin
      j:= ValueInt32Int32ID('PRETENSIONMOTORS', 'LogID', 'PretensionID', PretensionIDs[i]);
      if j=0 then
        Delete('PRETENSIONS', 'PretensionID', PretensionIDs[i], False {no commit});
    end;

    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.ReclamationNoticeAdd(const AMotorIDs: TIntVector;
                                      const AUserID, ALocationID: Integer;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate);
var
  i, ReclamationID: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'INSERT INTO ' +
        'RECLAMATIONS ' +
        '(UserID, LocationID, NoticeFromUserDate, NoticeFromUserNum) ' +
      'VALUES ' +
        '(:UserID, :LocationID, :NoticeFromUserDate, :NoticeFromUserNum) '
    );
    QParamInt('LocationID', ALocationID);
    QParamInt('UserID', AUserID);
    QParamStr('NoticeFromUserNum', ANoticeNum);
    QParamDT('NoticeFromUserDate', ANoticeDate);
    QExec;
    ReclamationID:= ReclamationMaxID;

    QSetQuery(FQuery);
    QSetSQL(
      'INSERT INTO ' +
        'RECLAMATIONMOTORS ' +
        '(ReclamationID, MotorID, Status) ' +
      'VALUES ' +
        '(:ReclamationID, :MotorID, 1) '
    );
    QParamInt('ReclamationID', ReclamationID);
    for i:= 0 to High(AMotorIDs) do
    begin
      QParamInt('MotorID', AMotorIDs[i]);
      QExec;
    end;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.RepairNoticeDelete(const ARepairID: Integer);
begin
  Delete('REPAIRS', 'RepairID', ARepairID);
end;

procedure TSQLite.RepairNoticeUpdate(const ARepairID: Integer;
                                      const AUserID: Integer;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate;
                                      const AAddRecLogIDs, AAddMotorIDs, ADelRecLogIDs: TIntVector);
var
  i: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'REPAIRS ' +
      'SET ' +
        'UserID = :UserID, ' +
        'NoticeFromUserDate = :NoticeFromUserDate, NoticeFromUserNum = :NoticeFromUserNum ' +
      'WHERE ' +
        'RepairID = :RepairID'
    );
    QParamInt('RepairID', ARepairID);
    QParamInt('UserID', AUserID);
    QParamStr('NoticeFromUserNum', ANoticeNum);
    QParamDT('NoticeFromUserDate', ANoticeDate);
    QExec;

    if not VIsNil(AAddRecLogIDs) then
    begin
      QSetSQL(
        'INSERT INTO ' +
          'REPAIRMOTORS ' +
          '(RepairID, MotorID, RecLogID, Status) ' +
        'VALUES ' +
          '(:RepairID, :MotorID, :RecLogID, 1) '
      );
      QParamInt('RepairID', ARepairID);
      for i:= 0 to High(AAddRecLogIDs) do
      begin
        QParamInt('RecLogID', AAddRecLogIDs[i]);
        QParamInt('MotorID', AAddMotorIDs[i]);
        QExec;
      end;
    end;

    if not VIsNil(ADelRecLogIDs) then
    begin
      QSetSQL(
        'DELETE FROM ' +
          'REPAIRMOTORS ' +
        'WHERE ' +
          '(RepairID = :RepairID) AND ' + SqlIN('','RecLogID', Length(ADelRecLogIDs))
      );
      QParamInt('RepairID', ARepairID);
      QParamsInt(ADelRecLogIDs);
      QExec;
    end;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.RepairAnswerToUserDelete(const ALogID: Integer);
begin
  LettersUpdate(VCreateInt([ALogID]), nil, 9 {ответ за запр ремонта}, EmptyStr, 0, 1{в работе});
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
      'REPAIRMOTORS ' +
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
        'REPAIRMOTORS ' +
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
end;

procedure TSQLite.RepairDatesDelete(const ALogID: Integer);
begin
  RepairDatesUpdate(ALogID, 2 {согласовано}, 0, 0);
end;

function TSQLite.RepairStatusLoad(const ALogID: Integer): Integer;
begin
  Result:= ValueInt32Int32ID('REPAIRMOTORS', 'Status', 'LogID', ALogID);
end;

procedure TSQLite.PretensionInfoLoad(const APretensionID: Integer;
                                 out AUserID: Integer;
                                 out AMoneyValue: Int64;
                                 out ANoticeNum: String;
                                 out ANoticeDate: TDate);
begin
  AUserID:= 0;
  AMoneyValue:= 0;
  ANoticeNum:= EmptyStr;
  ANoticeDate:= 0;
  if APretensionID<=0 then Exit;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'UserID, MoneyValue, NoticeFromUserDate, NoticeFromUserNum ' +
    'FROM ' +
      'PRETENSIONS ' +
    'WHERE ' +
      'PretensionID = :PretensionID'
  );
  QParamInt('PretensionID', APretensionID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AUserID:= QFieldInt('UserID');
    AMoneyValue:= QFieldInt64('MoneyValue');
    ANoticeNum:= QFieldStr('NoticeFromUserNum');
    ANoticeDate:= QFieldDT('NoticeFromUserDate');
  end;
  QClose;
end;

procedure TSQLite.PretensionMotorsLoad(const APretensionID: Integer;
                               out ARecLogIDs, AMotorIDs: TIntVector;
                               out ARecNoticeNums, AMotorNames, AMotorNums: TStrVector;
                               out ARecNoticeDates, AMotorDates: TDateVector);
begin
  ARecLogIDs:= nil;
  AMotorIDs:= nil;
  ARecNoticeNums:= nil;
  ARecNoticeDates:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  if APretensionID<=0 then Exit;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't1.RecLogID, t1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't5.NoticeFromUserDate, t5.NoticeFromUserNum ' +
    'FROM ' +
      'PRETENSIONMOTORS t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'INNER JOIN RECLAMATIONMOTORS t4 ON (t1.RecLogID=t4.LogID) ' +
    'INNER JOIN RECLAMATIONS t5 ON (t4.ReclamationID=t5.ReclamationID) ' +
    'WHERE ' +
      't1.PretensionID = :PretensionID ' +
    'ORDER BY t2.MotorNum, t2.MotorDate, t3.MotorName'
  );
  QParamInt('PretensionID', APretensionID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ARecLogIDs, QFieldInt('RecLogID'));
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      VAppend(ARecNoticeNums, QFieldStr('NoticeFromUserNum'));
      VAppend(ARecNoticeDates, QFieldDT('NoticeFromUserDate'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.PretensionNoticeAdd(const ARecLogIDs, AMotorIDs: TIntVector;
                              const AUserID: Integer;
                              const AMoneyValue: Int64;
                              const ANoticeNum: String;
                              const ANoticeDate: TDate);
var
  i, PretensionID: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'INSERT INTO ' +
        'PRETENSIONS ' +
        '(UserID, MoneyValue, Status, ' +
        'NoticeFromUserDate, NoticeFromUserNum) ' +
      'VALUES ' +
        '(:UserID, :MoneyValue, 1, ' +  {1 - согласование}
        ':NoticeFromUserDate, :NoticeFromUserNum) '
    );
    QParamInt('UserID', AUserID);
    QParamInt64('MoneyValue', AMoneyValue);
    QParamStr('NoticeFromUserNum', ANoticeNum);
    QParamDT('NoticeFromUserDate', ANoticeDate);
    QExec;
    PretensionID:= PretensionMaxID;

    QSetQuery(FQuery);
    QSetSQL(
      'INSERT INTO ' +
        'PRETENSIONMOTORS ' +
        '(PretensionID, MotorID, RecLogID) ' +
      'VALUES ' +
        '(:PretensionID, :MotorID, :RecLogID) '
    );
    QParamInt('PretensionID', PretensionID);
    for i:= 0 to High(AMotorIDs) do
    begin
      QParamInt('RecLogID', ARecLogIDs[i]);
      QParamInt('MotorID', AMotorIDs[i]);
      QExec;
    end;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.PretensionNoticeDelete(const APretensionID: Integer);
begin
  Delete('PRETENSIONS', 'PretensionID', APretensionID);
end;

procedure TSQLite.PretensionNoticeUpdate(const APretensionID: Integer;
                                      const AUserID: Integer;
                                      const AMoneyValue: Int64;
                                      const ANoticeNum: String;
                                      const ANoticeDate: TDate;
                                      const AAddRecLogIDs, AAddMotorIDs, ADelRecLogIDs: TIntVector);
var
  i: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        'PRETENSIONS ' +
      'SET ' +
        'UserID = :UserID, MoneyValue = :MoneyValue, ' +
        'NoticeFromUserDate = :NoticeFromUserDate, NoticeFromUserNum = :NoticeFromUserNum ' +
      'WHERE ' +
        'PretensionID = :PretensionID'
    );
    QParamInt('PretensionID', APretensionID);
    QParamInt('UserID', AUserID);
    QParamInt64('MoneyValue', AMoneyValue);
    QParamStr('NoticeFromUserNum', ANoticeNum);
    QParamDT('NoticeFromUserDate', ANoticeDate);
    QExec;

    if not VIsNil(AAddRecLogIDs) then
    begin
      QSetSQL(
        'INSERT INTO ' +
          'PRETENSIONMOTORS ' +
          '(PretensionID, MotorID, RecLogID) ' +
        'VALUES ' +
          '(:PretensionID, :MotorID, :RecLogID) '
      );
      QParamInt('PretensionID', APretensionID);
      for i:= 0 to High(AAddRecLogIDs) do
      begin
        QParamInt('RecLogID', AAddRecLogIDs[i]);
        QParamInt('MotorID', AAddMotorIDs[i]);
        QExec;
      end;
    end;

    if not VIsNil(ADelRecLogIDs) then
    begin
      QSetSQL(
        'DELETE FROM ' +
          'PRETENSIONMOTORS ' +
        'WHERE ' +
          '(PretensionID = :PretensionID) AND ' + SqlIN('','RecLogID', Length(ADelRecLogIDs))
      );
      QParamInt('PretensionID', APretensionID);
      QParamsInt(ADelRecLogIDs);
      QExec;
    end;

    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.PretensionMoneyDatesLoad(const APretensionID: Integer;
                                     out ASendValue, AGetValue: Int64;
                                     out ASendDate, AGetDate: TDate);
begin
  ASendValue:= 0;
  ASendDate:= 0;
  AGetValue:= 0;
  AGetDate:= 0;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'MoneySendDate, MoneySendValue, MoneyGetDate, MoneyGetValue ' +
    'FROM ' +
      'PRETENSIONS ' +
    'WHERE ' +
        'PretensionID = :PretensionID'
  );
  QParamInt('PretensionID', APretensionID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    ASendDate:= QFieldDT('MoneySendDate');
    ASendValue:= QFieldInt64('MoneySendValue');
    AGetDate:= QFieldDT('MoneyGetDate');
    AGetValue:= QFieldInt64('MoneyGetValue');
  end;
  QClose;
end;

procedure TSQLite.PretensionMoneyDatesUpdate(const APretensionID, AStatus: Integer;
                                   const ASendValue, AGetValue: Int64;
                                   const ASendDate, AGetDate: TDate);
var
  S: String;
begin
  S:=
    'UPDATE ' +
      'PRETENSIONS ' +
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
        'PretensionID = :PretensionID';

  QSetQuery(FQuery);
  try
    QSetSQL(S);
    QParamInt('PretensionID', APretensionID);
    QParamDT('MoneySendDate', ASendDate, ASendDate>0);
    QParamInt64('MoneySendValue', ASendValue, ASendValue>0);
    QParamDT('MoneyGetDate', AGetDate, AGetDate>0);
    QParamInt64('MoneyGetValue', AGetValue, AGetValue>0);
    QParamInt('Status', AStatus);
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.PretensionMoneyDatesDelete(const APretensionID: Integer);
begin
  PretensionMoneyDatesUpdate(APretensionID, 2{согласовано}, 0, 0, 0, 0);
end;

function TSQLite.PretensionStatusByLogIDLoad(const ALogID: Integer): Integer;
begin
  Result:= 0;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't2.Status ' +
    'FROM ' +
      'PRETENSIONMOTORS t1 ' +
      'INNER JOIN PRETENSIONS t2 ON (t1.PretensionID=t2.PretensionID) ' +
    'WHERE ' +
      't1.LogID = :LogID '
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    Result:= QFieldInt('Status');
  end;
  QClose;
end;

function TSQLite.PretensionStatusLoad(const APretensionID: Integer): Integer;
begin
  Result:= ValueInt32Int32ID('PRETENSIONS', 'Status', 'PretensionID', APretensionID);
end;

procedure TSQLite.PretensionLetterLoad(const APretensionID: Integer;
                                   const ALetterType: Byte;
                                   out ALetterNum: String;
                                   out ALetterDate: TDate);
var
  S, DateField, NumField: String;
begin
  ALetterNum:= EmptyStr;
  ALetterDate:= 0;

  LetterDBNamesGet(ALetterType, S, DateField, NumField);
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      SqlEsc(DateField) + ', ' + SqlEsc(NumField) + ' ' +
    'FROM ' +
      'PRETENSIONS ' +
    'WHERE ' +
        'PretensionID = :PretensionID'
  );
  QParamInt('PretensionID', APretensionID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    ALetterNum:= QFieldStr(NumField);
    ALetterDate:= QFieldDT(DateField);
  end;
  QClose;
end;

procedure TSQLite.PretensionLetterCustomUpdate(const APretensionIDs: TIntVector;
                                               const ALetterType: Byte;
                                               const ALetterNum: String;
                                               const ALetterDate: TDate;
                                               const AStatus: Integer = -1);
var
  S, DateField, NumField: String;
begin
  if VIsNil(APretensionIDs) then Exit;

  LetterDBNamesGet(ALetterType, S, DateField, NumField);
  DateField:= SqlEsc(DateField);
  NumField:= SqlEsc(NumField);

  S:=
    'UPDATE ' +
      'PRETENSIONS ' +
    'SET ' +
      DateField + ' = :DateValue, '+ NumField+ ' = :NumValue ';
  if AStatus>=0 then
    S:= S +
      ', Status = :Status ';
  S:= S +
    'WHERE ' +
      SqlIN('','PretensionID', Length(APretensionIDs));

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamsInt(APretensionIDs);
  QParamStr('NumValue', ALetterNum, not SEmpty(ALetterNum));
  QParamDT('DateValue', ALetterDate, ALetterDate>0);
  QParamInt('Status', AStatus);
  QExec;
end;

procedure TSQLite.PretensionLetterDelete(const APretensionID: Integer; const ALetterType: Byte);
begin
  PretensionLetterUpdate(VCreateInt([APretensionID]), nil, ALetterType, EmptyStr, 0);
end;

procedure TSQLite.PretensionLetterNotNeed(const APretensionIDs, ADelPretensionIDs: TIntVector;
                                               const ALetterType: Byte);
begin
  PretensionLetterUpdate(APretensionIDs, ADelPretensionIDs, ALetterType, LETTER_NOTNEED_MARK, 0);
end;

procedure TSQLite.PretensionLetterUpdate(const APretensionIDs, ADelPretensionIDs: TIntVector;
                                     const ALetterType: Byte;
                                     const ALetterNum: String;
                                     const ALetterDate: TDate);
begin
  try
    PretensionLetterCustomUpdate(APretensionIDs, ALetterType, ALetterNum, ALetterDate);
    PretensionLetterCustomUpdate(ADelPretensionIDs, ALetterType, EmptyStr, 0);
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.PretensionAnswerToUserNotNeed(const APretensionIDs, ADelPretensionIDs: TIntVector; const AStatus: Integer);
begin
  PretensionAnswersToUserUpdate(APretensionIDs, ADelPretensionIDs, LETTER_NOTNEED_MARK, 0, AStatus);
end;

procedure TSQLite.PretensionAnswerToUserDelete(const APretensionID: Integer);
begin
  PretensionAnswersToUserUpdate(VCreateInt([APretensionID]), nil, EmptyStr, 0, 1);
end;

procedure TSQLite.NoticeAndAnswersLoad(const ALetterType: Byte;
                            const ALogIDs: TIntVector;
                            out AMotorNames, AMotorNums: TStrVector;
                            out AMotorDates: TDateVector;
                            out ANoticeNums: TStrVector;
                            out ANoticeDates: TDateVector;
                            out AAnswerNums: TStrVector;
                            out AAnswerDates: TDateVector);
var
  S, LogNoticeTableName, LogMotorsTableName: String;
  NoticeDateField, NoticeNumField, AnswerDateField, AnswerNumField, IDField: String;
  Category, LetterType: Byte;
  NeedAnswers: Boolean;
begin
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  ANoticeNums:= nil;
  ANoticeDates:= nil;
  AAnswerNums:= nil;
  AAnswerDates:= nil;

  Category:= CategoryFromLetterType(ALetterType);
  LogNoticeTableName:= SqlEsc(LogNoticeTableNameGet(Category));
  IDField:= SqlEsc(LogNoticeIDFieldNameGet(Category));

  NeedAnswers:= ALetterType in [3,9,13];

  LetterType:= NoticeLetterTypeGet(ALetterType);
  LetterDBNamesGet(LetterType, LogMotorsTableName, NoticeDateField, NoticeNumField);

  if NeedAnswers then
  begin
    LetterType:= ALetterType-1;
    LetterDBNamesGet(LetterType, LogMotorsTableName, AnswerDateField, AnswerNumField);
  end;

  LogMotorsTableName:= SqlEsc(LogMotorsTableName);

  S:=
    'SELECT ' +
      't1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.' + SqlEsc(NoticeDateField) + ', t4.' + SqlEsc(NoticeNumField) + ' ';
  if NeedAnswers then
    S:= S +
      ', t1.' + SqlEsc(AnswerDateField) + ', t1.' + SqlEsc(AnswerNumField) + ' ';
  S:= S +
    'FROM ' +
      LogMotorsTableName + ' t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'INNER JOIN '+LogNoticeTableName+' t4 ON (t1.'+IDField+'=t4.'+IDField+') ' +
    'WHERE ' +
      SqlIN('t1','LogID', Length(ALogIDs)) +
    'ORDER BY '+
      't2.MotorNum, t2.MotorDate, t3.MotorName ';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamsInt(ALogIDs);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      VAppend(ANoticeNums, QFieldStr(NoticeNumField));
      VAppend(ANoticeDates, QFieldDT(NoticeDateField));
      if NeedAnswers then
      begin
        VAppend(AAnswerNums, QFieldStr(AnswerNumField));
        VAppend(AAnswerDates, QFieldDT(AnswerDateField));
      end;
      QNext;
    end;
  end;
  QClose;
end;

function TSQLite.AttachmentNameLoad(const ACategory: Byte; const AAttachmentID: Integer): String;
var
  TableName: String;
begin
  TableName:= AttachmentTableNameGet(ACategory);
  Result:= ValueStrInt32ID(TableName, 'AttachmentName', 'ID', AAttachmentID);
end;

procedure TSQLite.AttachmentDelete(const ACategory: Byte;  const AAttachmentID: Integer);
var
  TableName: String;
begin
  TableName:= AttachmentTableNameGet(ACategory);
  Delete(TableName, 'ID', AAttachmentID);
end;

function TSQLite.AttachmentFind(const ACategory: Byte;
                                const AAttachmentID: Integer;
                                const AAttachmentName: String): Boolean;
var
  TableName: String;
begin
  TableName:= AttachmentTableNameGet(ACategory);
  Result:= IsValueInTableNotMatchInt32ID(TableName,
    'AttachmentName', AAttachmentName, 'ID', AAttachmentID, False);
end;

procedure TSQLite.AttachmentListLoad(const ACategory: Byte; const ALogID: Integer;
                                 out AAttachmentIDs: TIntVector;
                                 out AAttachmentNames, AAttachmentExtensions: TStrVector);
var
  TableName: String;
begin
  AAttachmentIDs:= nil;
  AAttachmentNames:= nil;
  AAttachmentExtensions:= nil;

  TableName:= SqlEsc(AttachmentTableNameGet(ACategory));

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'ID, AttachmentName, AttachmentExtension ' +
    'FROM ' +
      TableName +
    'WHERE ' +
      'LogID = :LogID'
  );
  QParamInt('LogID', ALogID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(AAttachmentIDs, QFieldInt('ID'));
      VAppend(AAttachmentNames, QFieldStr('AttachmentName'));
      VAppend(AAttachmentExtensions, QFieldStr('AttachmentExtension'));
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.AttachmentAdd(const ACategory: Byte; const ALogID: Integer;
                                const AAttachmentName, AAttachmentExtension: String);
var
  TableName: String;
begin
  TableName:= AttachmentTableNameGet(ACategory);

  QSetQuery(FQuery);
  try
    QSetSQL(
      'INSERT INTO ' +
        SqlEsc(TableName) +
        '(LogID, AttachmentName, AttachmentExtension) ' +
      'VALUES ' +
        '(:LogID, :AttachmentName, :AttachmentExtension) '
    );
    QParamInt('LogID', ALogID);
    QParamStr('AttachmentName', AAttachmentName);
    QParamStr('AttachmentExtension', AAttachmentExtension);
    QExec;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.AttachmentUpdate(const ACategory: Byte; const AAttachmentID: Integer;
                            const AAttachmentName, AAttachmentExtension: String);
var
  TableName: String;
begin
  TableName:= AttachmentTableNameGet(ACategory);

  QSetQuery(FQuery);
  try
    QSetSQL(
      'UPDATE ' +
        SqlEsc(TableName) +
      'SET ' +
        'AttachmentName = :AttachmentName, AttachmentExtension = :AttachmentExtension ' +
      'WHERE ' +
        'ID = :AttachmentID '
    );
    QParamInt('AttachmentID', AAttachmentID);
    QParamStr('AttachmentName', AAttachmentName);
    QParamStr('AttachmentExtension', AAttachmentExtension);
    QExec;
    QCommit;
  except
    QRollback;
  end;
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
begin
  LettersUpdate(VCreateInt([ALogID]), nil, ALetterType, EmptyStr, 0);
end;

procedure TSQLite.LettersUpdate(const ALogIDs, ADelLogIDs: TIntVector;
                           const ALetterType: Byte;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer = -1);
var
  TableName, DateField, NumField, S: String;
begin
  if VIsNil(ALogIDs) then Exit;

  LetterDBNamesGet(ALetterType, TableName, DateField, NumField);
  QSetQuery(FQuery);
  try
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
        SqlIN('','LogID', Length(ALogIDs));
    QSetSQL(S);
    QParamStr('NumValue', ALetterNum, not SEmpty(ALetterNum));
    QParamDT('DateValue', ALetterDate, ALetterDate>0);
    QParamInt('Status', AStatus);
    QParamsInt(ALogIDs);
    QExec;

    if not VIsNil(ADelLogIDs) then
    begin
      S:=
        'UPDATE ' +
          SqlEsc(TableName) +
        'SET ' +
          SqlEsc(NumField)  + ' = NULL, ' +
          SqlEsc(DateField) + ' = NULL, ' +
          'Status = 1 ';
      S:= S +
        'WHERE ' +
          SqlIN('','LogID', Length(ADelLogIDs));
      QSetSQL(S);
      QParamsInt(ADelLogIDs);
      QExec;
    end;

    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.LettersNotNeed(const ALogIDs, ADelLogIDs: TIntVector; const ALetterType: Byte);
begin
  LettersUpdate(ALogIDs, ADelLogIDs, ALetterType, LETTER_NOTNEED_MARK, 0);
end;

function TSQLite.LetterUserIDLoad(const ALetterType: Byte; const AID: Integer): Integer;
var
  Category: Byte;
  TableName, IDFieldName: String;
begin
  Category:= CategoryFromLetterType(ALetterType);
  TableName:= LogNoticeTableNameGet(Category);
  IDFieldName:= LogNoticeIDFieldNameGet(Category);
  Result:= ValueInt32Int32ID(TableName, 'UserID', IDFieldName, AID);
end;

procedure TSQLite.ReclamationCancelNotNeed(const ALogIDs, ADelLogIDs: TIntVector);
begin
  LettersUpdate(ALogIDs, ADelLogIDs, 5 {отзыв рекл}, LETTER_NOTNEED_MARK, 0, 1{в работе});
end;

procedure TSQLite.ReclamationCancelUpdate(const ALogIDs, ADelLogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate);
begin
  LettersUpdate(ALogIDs, ADelLogIDs, 5 {отзыв рекл}, ALetterNum, ALetterDate, 4{отозвана});
end;

procedure TSQLite.ReclamationCancelDelete(const ALogID: Integer);
begin
  LettersUpdate(VCreateInt([ALogID]), nil, 5 {отзыв рекл}, EmptyStr, 0, 1{в работе});
end;

procedure TSQLite.ReclamationReportNotNeed(const ALogIDs, ADelLogIDs: TIntVector; const AStatus: Integer);
begin
  LettersUpdate(ALogIDs, ADelLogIDs, 4 {акт осмотра}, LETTER_NOTNEED_MARK, 0, AStatus);
end;

procedure TSQLite.ReclamationReportUpdate(const ALogIDs, ADelLogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
begin
  LettersUpdate(ALogIDs, ADelLogIDs, 4 {акт осмотра}, ALetterNum, ALetterDate, AStatus);
end;

procedure TSQLite.ReclamationReportDelete(const ALogID: Integer);
var
  LetterNum: String;
  LetterDate: TDate;
  Status: Integer;
begin
  LetterLoad(ALogID, 5 {отзыв рекл.}, LetterNum, LetterDate);
  if not IsDocumentEmpty(LetterDate, LetterNum) then
    Status:= 4 {отозвана}
  else
    Status:= 1 {в работе};

  LettersUpdate(VCreateInt([ALogID]), nil, 4 {акт осмотра}, EmptyStr, 0, Status);
end;

function TSQLite.FileNamesLoad(const ACategory: Byte; const AReclamationID: Integer): TStrVector;
var
  i: Integer;
  LetterType1, LeterType2: Byte;
  NoticeTableName, MotorTableName, IDFieldName, S: String;
  LetterDate, MotorDate: TDate;
  FileName, LetterNum, MotorName, MotorNum, DateField, NumField: String;
begin
  Result:= nil;

  LetterTypesFromCategory(ACategory, LetterType1, LeterType2);
  NoticeTableName:= SqlEsc(LogNoticeTableNameGet(ACategory));
  MotorTableName:= SqlEsc(LogMotorTableNameGet(ACategory));
  IDFieldName:= SqlEsc(LogNoticeIDFieldNameGet(ACategory));

  S:=
    'SELECT ' +
      't1.*, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum ' +
    'FROM ' +
      MotorTableName + ' t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'INNER JOIN '+ NoticeTableName + ' t4 ON (t1.' + IDFieldName + '=t4.' + IDFieldName + ') ';
  if ACategory>1 then
    S:= S +
      'INNER JOIN RECLAMATIONMOTORS t5 ON (t1.RecLogID=t5.LogID) ';
  S:= S + 'WHERE ';
  if ACategory>1 then
    S:= S + '(t5.ReclamationID = :ReclamationID) '
  else
    S:= S + '(t1.ReclamationID = :ReclamationID) ';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamInt('ReclamationID', AReclamationID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      MotorDate:= QFieldDT('MotorDate');
      MotorName:= QFieldStr('MotorName');
      MotorNum:= QFieldStr('MotorNum');

      for i:= LetterType1 to LeterType2 do
      begin
        LetterFieldNamesGet(i, DateField, NumField);
        LetterDate:= QFieldDT(DateField);
        LetterNum:= QFieldStr(NumField);
        if IsDocumentExists(LetterDate, LetterNum) then
        begin
          FileName:= FileNameFullGet(i, LetterDate, LetterNum,
                                     MotorDate, MotorName, MotorNum);
          VAppend(Result, FileName);
        end;
      end;
      QNext;
    end;
  end;
  QClose;
end;

function TSQLite.ReclamationFileNamesLoad(const AReclamationID: Integer): TStrVector;
begin
  Result:= FileNamesLoad(1, AReclamationID);
end;

function TSQLite.RepairFileNamesLoad(const ARepairID: Integer): TStrVector;
var
  i: Integer;
  LetterDate, MotorDate: TDate;
  FileName, LetterNum, MotorName, MotorNum, DateField, NumField: String;
begin
  Result:= nil;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't1.*, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum ' +
    'FROM ' +
      'REPAIRMOTORS t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'INNER JOIN REPAIRS t4 ON (t1.RepairID=t4.RepairID) ' +
    'WHERE ' +
      '(t1.RepairID = :RepairID) '
  );
  QParamInt('RepairID', ARepairID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      MotorDate:= QFieldDT('MotorDate');
      MotorName:= QFieldStr('MotorName');
      MotorNum:= QFieldStr('MotorNum');

      for i:= 6 to 9 do
      begin
        LetterFieldNamesGet(i, DateField, NumField);
        LetterDate:= QFieldDT(DateField);
        LetterNum:= QFieldStr(NumField);
        if IsDocumentExists(LetterDate, LetterNum) then
        begin
          FileName:= FileNameFullGet(i, LetterDate, LetterNum,
                                     MotorDate, MotorName, MotorNum);
          VAppend(Result, FileName);
        end;
      end;
      QNext;
    end;
  end;
  QClose;
end;

function TSQLite.PretensionFileNamesLoad(const APretensionID: Integer): TStrVector;
var
  i: Integer;
  LetterDate, MotorDate: TDate;
  FileName, LetterNum, MotorName, MotorNum, DateField, NumField: String;
begin
  Result:= nil;
  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't4.*, t2.MotorNum, t2.MotorDate, t3.MotorName ' +
     // 't4.NoticeFromUserDate, t4.NoticeFromUserNum ' +
    'FROM ' +
      'PRETENSIONMOTORS t1 ' +
      'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
      'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
      'INNER JOIN PRETENSIONS t4 ON (t1.PretensionID=t4.PretensionID) ' +
    'WHERE ' +
      '(t1.PretensionID = :PretensionID) '
  );
  QParamInt('PretensionID', APretensionID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      MotorDate:= QFieldDT('MotorDate');
      MotorName:= QFieldStr('MotorName');
      MotorNum:= QFieldStr('MotorNum');

      for i:= 10 to 13 do
      begin
        LetterFieldNamesGet(i, DateField, NumField);
        LetterDate:= QFieldDT(DateField);
        LetterNum:= QFieldStr(NumField);
        if IsDocumentExists(LetterDate, LetterNum) then
        begin
          FileName:= FileNameFullGet(i, LetterDate, LetterNum,
                                     MotorDate, MotorName, MotorNum);
          VAppend(Result, FileName);
        end;
      end;
      QNext;
    end;
  end;
  QClose;
end;

function TSQLite.AllFileNamesLoad(const AReclamationID: Integer): TStrVector;
var
  i: Integer;
begin
  Result:= nil;
  for i:= 1 to 3 do
    Result:= VAdd(Result, FileNamesLoad(i, AReclamationID));
end;

procedure TSQLite.MotorsReturn(const ALogIDs, AMotorIDs: TIntVector;   //возврат двигателя на этапе расследования рекламации
                           const AUserID: Integer;
                           const ALetterNum: String;
                           const ALetterDate: TDate);
var
  i, j: Integer;
  RepairIDs: TIntVector;
begin
  QSetQuery(FQuery);
  try
    //1. Получаем список RepairID, для которых в REPAIRMOTORS есть записи соот рекламационным моторам ALogIDs
    RepairIDs:= nil;
    QSetSQL(
      'SELECT ' +
        'RepairID ' +
      'FROM ' +
        'REPAIRMOTORS ' +
      'WHERE ' +
        SqlIN('','RecLogID', Length(ALogIDs))
    );
    QParamsInt(ALogIDs);
    QOpen;
    if not QIsEmpty then
    begin
      QFirst;
      while not QEOF do
      begin
        VAppend(RepairIDs, QFieldInt('RepairID'));
        QNext;
      end;
    end;
    QClose;
    if not VIsNil(RepairIDs) then
    begin
      //2. Удаляем из ремонтной таблицы моторов записи с RecLogID соотв этим  ALogIDs
      QSetSQL(
        'DELETE FROM ' +
          'REPAIRMOTORS ' +
        'WHERE ' +
          SqlIN('','RecLogID', Length(ALogIDs))
      );
      QParamsInt(ALogIDs);
      QExec;
      //3.Удаляем оставшиеся пустыми записи из REPAIRS
      for i:= 0 to High(RepairIDs) do
      begin
        j:= ValueInt32Int32ID('REPAIRMOTORS', 'LogID', 'RepairID', RepairIDs[i]);
        if j=0 then
          Delete('REPAIRS', 'RepairID', RepairIDs[i], False {no commit});
      end;
    end;
    //4. Записываем ответ потребителю по рекламации и меняем статус на принята
    QSetSQL(
      'UPDATE ' +
        'RECLAMATIONMOTORS ' +
      'SET ' +
        'Status = 2, ' +  {2 - принята}
        'AnswerToUserNum = :NumValue, ' +
        'AnswerToUserDate = :DateValue ' +
      'WHERE ' +
        SqlIN('','LogID', Length(ALogIDs))
    );
    QParamStr('NumValue', ALetterNum);
    QParamDT('DateValue', ALetterDate);
    QParamsInt(ALogIDs);
    QExec;
    //5. Записываем в REPAIRS один новый запрос с LETTER_NOTNEED_MARK на все эти моторы
    QSetSQL(
      'INSERT INTO ' +
        'REPAIRS ' +
        '(UserID, NoticeFromUserDate, NoticeFromUserNum) ' +
      'VALUES ' +
        '(:UserID, 0, :NoticeFromUserNum) '
    );
    QParamInt('UserID', AUserID);
    QParamStr('NoticeFromUserNum', LETTER_NOTNEED_MARK);
    QExec;
    //6. Получаем записанный RepairID
    j:= RepairMaxID;
    //7. записываем моторы в REPAIRMOTORS
    QSetSQL(
      'INSERT INTO ' +
        'REPAIRMOTORS ' +
        '(RepairID, RecLogID, MotorID, Note, Status, ' +
        ' NoticeToBuilderNum, AnswerFromBuilderNum, AnswerToUserNum) ' +
      'VALUES ' +
        '(:RepairID, :RecLogID, :MotorID, :Note, 2, ' +  {2 - в пути}
        ' :NumValue, :NumValue, :NumValue) '
    );
    QParamInt('RepairID', j);
    QParamStr('NumValue', LETTER_NOTNEED_MARK);
    QParamStr('Note', 'Производителем принято решение о возврате на этапе расследования');
    for i:= 0 to High(ALogIDs) do
    begin
      QParamInt('RecLogID', ALogIDs[i]);
      QParamInt('MotorID', AMotorIDs[i]);
      QExec;
    end;

    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.RepairListLoad(const AMotorNumLike: String;
                const ABeginDate, AEndDate: TDate;
                const AViewIndex, AMileageIndex: Integer;
                out ARepairIDs: TIntVector;
                out AUserNames, AUserTitles: TStrVector;
                out ANoticeDates: TDateVector; out ANoticeNums: TStrVector;
                out AToBuilderDates: TDateMatrix; out AToBuilderNums: TStrMatrix;
                out AFromBuilderDates: TDateMatrix; out AFromBuilderNums: TStrMatrix;
                out AToUserDates: TDateMatrix; out AToUserNums: TStrMatrix;
                out ARepairBeginDates, ARepairEndDates: TDateMatrix;
                out AReclamationIDs, ALogIDs, AMileages, AStatuses: TIntMatrix;
                out ANotes, AMotorNames, AMotorNums: TStrMatrix;
                out AMotorDates: TDateMatrix);
var
  S: String;
  OldID, NewID, n: Integer;
begin
  ARepairIDs:= nil;
  AUserNames:= nil;
  AUserTitles:= nil;
  ANoticeDates:= nil;
  ANoticeNums:= nil;
  AToBuilderDates:= nil;
  AToBuilderNums:= nil;
  AFromBuilderDates:= nil;
  AFromBuilderNums:= nil;
  AToUserDates:= nil;
  AToUserNums:= nil;
  ARepairBeginDates:= nil;
  ARepairEndDates:= nil;
  AReclamationIDs:= nil;
  ALogIDs:= nil;
  AMileages:= nil;
  AStatuses:= nil;
  ANotes:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

  S:=
    'SELECT ' +
      't1.*, '+
      't2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum, ' +
      't5.ReclamationID, t5.Mileage, ' +
      't6.UserNameI, t6.UserTitle ' +
    'FROM ' +
      'REPAIRMOTORS t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'INNER JOIN REPAIRS t4 ON (t1.RepairID=t4.RepairID) ' +
    'INNER JOIN RECLAMATIONMOTORS t5 ON (t1.RecLogID=t5.LogID) ' +
    'INNER JOIN USERS t6 ON (t4.UserID=t6.UserID) ' +
    'INNER JOIN RECLAMATIONS t7 ON (t5.ReclamationID=t7.ReclamationID) ' +
    'WHERE ' +
      '(t1.RepairID>0) ';

  if not SEmpty(AMotorNumLike) then
    S:= S + 'AND (UPPER(t2.MotorNum) LIKE :NumberLike) '   //отбор только по номеру двигателя
  else begin
    if (AViewIndex in [0,4,5]) and //все, отремонтированные, с отказом
       (ABeginDate>0) and (AEndDate>0) then
      //запросы о ремонте за период + рекламации за период, если принято решение о возврате
      S:= S + 'AND ((t4.NoticeFromUserDate BETWEEN :BD AND :ED) OR ( (t7.NoticeFromUserDate BETWEEN :BD AND :ED) AND (t4.NoticeFromUserDate=0) ) ) ';

    if AViewIndex>0 then
      S:= S + ' AND (t1.Status = :Status) ';
    if AMileageIndex>0 then
    begin
      case AMileageIndex of
      1: S:= S + ' AND (t5.Mileage < 175000) ';
      2: S:= S + ' AND (t5.Mileage >= 175000) ';
      end;
    end;
  end;
  S:= S +
    'ORDER BY t4.NoticeFromUserDate, t4.NoticeFromUserNum';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  QParamDT('BD', ABeginDate);
  QParamDT('ED', AEndDate);
  QParamInt('Status', AViewIndex);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    OldID:= 0;
    while not QEOF do
    begin
      NewID:= QFieldInt('RepairID');
      if NewID<>OldID then
      begin
        VAppend(ARepairIDs, NewID);
        VAppend(AUserNames, QFieldStr('UserNameI'));
        VAppend(AUserTitles, QFieldStr('UserTitle'));
        VAppend(ANoticeDates, QFieldDT('NoticeFromUserDate'));
        VAppend(ANoticeNums, QFieldStr('NoticeFromUserNum'));

        MAppend(AToBuilderDates, VCreateDate([QFieldDT('NoticeToBuilderDate')]));
        MAppend(AToBuilderNums, VCreateStr([QFieldStr('NoticeToBuilderNum')]));
        MAppend(AFromBuilderDates, VCreateDate([QFieldDT('AnswerFromBuilderDate')]));
        MAppend(AFromBuilderNums, VCreateStr([QFieldStr('AnswerFromBuilderNum')]));
        MAppend(AToUserDates, VCreateDate([QFieldDT('AnswerToUserDate')]));
        MAppend(AToUserNums, VCreateStr([QFieldStr('AnswerToUserNum')]));
        MAppend(ARepairBeginDates, VCreateDate([QFieldDT('BeginDate')]));
        MAppend(ARepairEndDates, VCreateDate([QFieldDT('EndDate')]));
        MAppend(ANotes, VCreateStr([QFieldStr('Note')]));
        MAppend(AMileages, VCreateInt([QFieldInt('Mileage')]));
        MAppend(AStatuses, VCreateInt([QFieldInt('Status')]));
        MAppend(AReclamationIDs, VCreateInt([QFieldInt('ReclamationID')]));
        MAppend(ALogIDs, VCreateInt([QFieldInt('LogID')]));
        MAppend(AMotorNames, VCreateStr([QFieldStr('MotorName')]));
        MAppend(AMotorNums, VCreateStr([QFieldStr('MotorNum')]));
        MAppend(AMotorDates, VCreateDate([QFieldDT('MotorDate')]));
        OldID:= NewID;
      end
      else begin
        n:= High(ARepairIDs);
        VAppend(AToBuilderDates[n], QFieldDT('NoticeToBuilderDate'));
        VAppend(AToBuilderNums[n], QFieldStr('NoticeToBuilderNum'));
        VAppend(AFromBuilderDates[n], QFieldDT('AnswerFromBuilderDate'));
        VAppend(AFromBuilderNums[n], QFieldStr('AnswerFromBuilderNum'));
        VAppend(AToUserDates[n], QFieldDT('AnswerToUserDate'));
        VAppend(AToUserNums[n], QFieldStr('AnswerToUserNum'));
        VAppend(ARepairBeginDates[n], QFieldDT('BeginDate'));
        VAppend(ARepairEndDates[n], QFieldDT('EndDate'));
        VAppend(ANotes[n], QFieldStr('Note'));
        VAppend(AMileages[n], QFieldInt('Mileage'));
        VAppend(AStatuses[n], QFieldInt('Status'));
        VAppend(AReclamationIDs[n], QFieldInt('ReclamationID'));
        VAppend(ALogIDs[n], QFieldInt('LogID'));
        VAppend(AMotorNames[n], QFieldStr('MotorName'));
        VAppend(AMotorNums[n], QFieldStr('MotorNum'));
        VAppend(AMotorDates[n], QFieldDT('MotorDate'));
      end;
      QNext;
    end;
  end;
  QClose;
end;

procedure TSQLite.RepairInfoLoad(const ARepairID: Integer;
                             out AUserID: Integer;
                             out ANoticeNum: String;
                             out ANoticeDate: TDate);
begin
  AUserID:= 0;
  ANoticeNum:= EmptyStr;
  ANoticeDate:= 0;
  if ARepairID<=0 then Exit;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      'UserID, NoticeFromUserDate, NoticeFromUserNum ' +
    'FROM ' +
      'REPAIRS ' +
    'WHERE ' +
      'RepairID = :RepairID'
  );
  QParamInt('RepairID', ARepairID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    AUserID:= QFieldInt('UserID');
    ANoticeNum:= QFieldStr('NoticeFromUserNum');
    ANoticeDate:= QFieldDT('NoticeFromUserDate');
  end;
  QClose;
end;

procedure TSQLite.RepairMotorsLoad(const ARepairID: Integer;
                               out ARecLogIDs, AMotorIDs: TIntVector;
                               out ARecNoticeNums, AMotorNames, AMotorNums: TStrVector;
                               out ARecNoticeDates, AMotorDates: TDateVector);
begin
  ARecLogIDs:= nil;
  AMotorIDs:= nil;
  ARecNoticeNums:= nil;
  ARecNoticeDates:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;
  if ARepairID<=0 then Exit;

  QSetQuery(FQuery);
  QSetSQL(
    'SELECT ' +
      't1.RecLogID, t1.MotorID, t2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't5.NoticeFromUserDate, t5.NoticeFromUserNum ' +
    'FROM ' +
      'REPAIRMOTORS t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'INNER JOIN RECLAMATIONMOTORS t4 ON (t1.RecLogID=t4.LogID) ' +
    'INNER JOIN RECLAMATIONS t5 ON (t4.ReclamationID=t5.ReclamationID) ' +
    'WHERE ' +
      't1.RepairID = :RepairID ' +
    'ORDER BY t2.MotorNum, t2.MotorDate, t3.MotorName'
  );
  QParamInt('RepairID', ARepairID);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(ARecLogIDs, QFieldInt('RecLogID'));
      VAppend(AMotorIDs, QFieldInt('MotorID'));
      VAppend(AMotorNames, QFieldStr('MotorName'));
      VAppend(AMotorNums, QFieldStr('MotorNum'));
      VAppend(AMotorDates, QFieldDT('MotorDate'));
      VAppend(ARecNoticeNums, QFieldStr('NoticeFromUserNum'));
      VAppend(ARecNoticeDates, QFieldDT('NoticeFromUserDate'));
      QNext;
    end;
  end;
  QClose;
end;

function TSQLite.RepairMaxID: Integer;
begin
  Result:= MaxInt32ID('REPAIRS');
end;

procedure TSQLite.RepairNoticeAdd(const ARecLogIDs, AMotorIDs: TIntVector;
                              const AUserID: Integer;
                              const ANoticeNum: String;
                              const ANoticeDate: TDate);
var
  i, RepairID: Integer;
begin
  QSetQuery(FQuery);
  try
    QSetSQL(
      'INSERT INTO ' +
        'REPAIRS ' +
        '(UserID, NoticeFromUserDate, NoticeFromUserNum) ' +
      'VALUES ' +
        '(:UserID, :NoticeFromUserDate, :NoticeFromUserNum) '
    );
    QParamInt('UserID', AUserID);
    QParamStr('NoticeFromUserNum', ANoticeNum);
    QParamDT('NoticeFromUserDate', ANoticeDate);
    QExec;
    RepairID:= RepairMaxID;

    QSetQuery(FQuery);
    QSetSQL(
      'INSERT INTO ' +
        'REPAIRMOTORS ' +
        '(RepairID, MotorID, RecLogID, Status) ' +
      'VALUES ' +
        '(:RepairID, :MotorID, :RecLogID, 1) '
    );
    QParamInt('RepairID', RepairID);
    for i:= 0 to High(AMotorIDs) do
    begin
      QParamInt('RecLogID', ARecLogIDs[i]);
      QParamInt('MotorID', AMotorIDs[i]);
      QExec;
    end;
    QCommit;
  except
    QRollback;
  end;
end;

procedure TSQLite.RepairAnswersToUserUpdate(const ALogIDs, ADelLogIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
begin
  LettersUpdate(ALogIDs, ADelLogIDs, 9 {ответ потреб. по ремонту}, ALetterNum, ALetterDate, AStatus);
end;

procedure TSQLite.RepairAnswerNotNeed(const ALogIDs, ADelLogIDs: TIntVector; const AStatus: Integer);
begin
  LettersUpdate(ALogIDs, ADelLogIDs, 9 {ответ потреб. по ремонту}, LETTER_NOTNEED_MARK, 0, AStatus);
end;

procedure TSQLite.PretensionListLoad(const AMotorNumLike: String;
                const ABeginDate, AEndDate: TDate;
                const AViewIndex, AMileageIndex: Integer;
                out APretensionIDs, AStatuses: TIntVector;
                out AUserNames, AUserTitles, ANotes: TStrVector;
                out ANoticeDates: TDateVector; out ANoticeNums: TStrVector;
                out AMoneyValues, ASendValues, AGetValues: TInt64Vector;
                out ASendDates, AGetDates: TDateVector;
                out AToBuilderDates: TDateVector; out AToBuilderNums: TStrVector;
                out AFromBuilderDates: TDateVector; out AFromBuilderNums: TStrVector;
                out AToUserDates: TDateVector; out AToUserNums: TStrVector;
                out AReclamationIDs, ALogIDs, AMileages: TIntMatrix;
                out AMotorNames, AMotorNums: TStrMatrix;
                out AMotorDates: TDateMatrix);
var
  S: String;
  OldID, NewID, n: Integer;
begin
  APretensionIDs:= nil;
  AStatuses:= nil;
  AUserNames:= nil;
  AUserTitles:= nil;
  ANotes:= nil;
  ANoticeDates:= nil;
  ANoticeNums:= nil;
  AMoneyValues:= nil;
  ASendValues:= nil;
  AGetValues:= nil;
  ASendDates:= nil;
  AGetDates:= nil;
  AToBuilderDates:= nil;
  AToBuilderNums:= nil;
  AFromBuilderDates:= nil;
  AFromBuilderNums:= nil;
  AToUserDates:= nil;
  AToUserNums:= nil;
  AReclamationIDs:= nil;
  ALogIDs:= nil;
  AMileages:= nil;
  AMotorNames:= nil;
  AMotorNums:= nil;
  AMotorDates:= nil;

   S:=
    'SELECT DISTINCT ' +
      't1.PretensionID ' +
    'FROM ' +
      'PRETENSIONMOTORS t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'INNER JOIN PRETENSIONS t4 ON (t1.PretensionID=t4.PretensionID) ' +
    'INNER JOIN RECLAMATIONMOTORS t5 ON (t1.RecLogID=t5.LogID) ' +
    'INNER JOIN USERS t6 ON (t4.UserID=t6.UserID) ' +
    'WHERE ' +
      '(t1.PretensionID>0) ';

  if not SEmpty(AMotorNumLike) then
    S:= S + 'AND (UPPER(t2.MotorNum) LIKE :NumberLike) '   //отбор только по номеру двигателя
  else begin
    if (AViewIndex in [0,3,4]) and //все, завершено, отказано
       (ABeginDate>0) and (AEndDate>0) then
      S:= S + 'AND (t4.NoticeFromUserDate BETWEEN :BD AND :ED) ';
    if AViewIndex>0 then
      S:= S + ' AND (t4.Status = :Status) ';
    if AMileageIndex>0 then
    begin
      case AMileageIndex of
      1: S:= S + ' AND (t5.Mileage < 175000) ';
      2: S:= S + ' AND (t5.Mileage >= 175000) ';
      end;
    end;
  end;
  S:= S +
    'ORDER BY t4.NoticeFromUserDate, t4.NoticeFromUserNum';

  QSetQuery(FQuery);
  QSetSQL(S);
  QParamStr('NumberLike', SUpper(AMotorNumLike)+'%');
  QParamDT('BD', ABeginDate);
  QParamDT('ED', AEndDate);
  QParamInt('Status', AViewIndex);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    while not QEOF do
    begin
      VAppend(APretensionIDs, QFieldInt('PretensionID'));
      QNext;
    end;
  end;
  QClose;

  if VIsNil(APretensionIDs) then Exit;

  S:=
    'SELECT ' +
      't1.*, '+
      't2.MotorNum, t2.MotorDate, t3.MotorName, ' +
      't4.*, ' +
      't5.ReclamationID, t5.Mileage, ' +
      't6.UserNameI, t6.UserTitle ' +
    'FROM ' +
      'PRETENSIONMOTORS t1 ' +
    'INNER JOIN MOTORS t2 ON (t1.MotorID=t2.MotorID) ' +
    'INNER JOIN MOTORNAMES t3 ON (t2.MotorNameID=t3.MotorNameID) ' +
    'INNER JOIN PRETENSIONS t4 ON (t1.PretensionID=t4.PretensionID) ' +
    'INNER JOIN RECLAMATIONMOTORS t5 ON (t1.RecLogID=t5.LogID) ' +
    'INNER JOIN USERS t6 ON (t4.UserID=t6.UserID) ' +
    'WHERE ' +
      SqlIN('t1','PretensionID', Length(APretensionIDs)) +
    'ORDER BY ' +
      't4.NoticeFromUserDate, t4.NoticeFromUserNum, t2.MotorNum, t2.MotorDate, t3.MotorName ';

  QSetSQL(S);
  QParamsInt(APretensionIDs);
  QOpen;
  if not QIsEmpty then
  begin
    QFirst;
    OldID:= 0;
    APretensionIDs:= nil;
    while not QEOF do
    begin
      NewID:= QFieldInt('PretensionID');
      if NewID<>OldID then
      begin
        VAppend(APretensionIDs, NewID);
        VAppend(AUserNames, QFieldStr('UserNameI'));
        VAppend(AUserTitles, QFieldStr('UserTitle'));
        VAppend(ANoticeDates, QFieldDT('NoticeFromUserDate'));
        VAppend(ANoticeNums, QFieldStr('NoticeFromUserNum'));
        VAppend(AToBuilderDates, QFieldDT('NoticeToBuilderDate'));
        VAppend(AToBuilderNums, QFieldStr('NoticeToBuilderNum'));
        VAppend(AFromBuilderDates, QFieldDT('AnswerFromBuilderDate'));
        VAppend(AFromBuilderNums, QFieldStr('AnswerFromBuilderNum'));
        VAppend(AToUserDates, QFieldDT('AnswerToUserDate'));
        VAppend(AToUserNums, QFieldStr('AnswerToUserNum'));
        VAppend(AStatuses, QFieldInt('Status'));
        VAppend(ANotes, QFieldStr('Note'));
        VAppend(AMoneyValues, QFieldInt64('MoneyValue'));
        VAppend(ASendValues, QFieldInt64('MoneySendValue'));
        VAppend(AGetValues, QFieldInt64('MoneyGetValue'));
        VAppend(ASendDates, QFieldDT('MoneySendDate'));
        VAppend(AGetDates, QFieldDT('MoneyGetDate'));

        MAppend(AReclamationIDs, VCreateInt([QFieldInt('ReclamationID')]));
        MAppend(ALogIDs, VCreateInt([QFieldInt('LogID')]));
        MAppend(AMileages, VCreateInt([QFieldInt('Mileage')]));
        MAppend(AMotorNames, VCreateStr([QFieldStr('MotorName')]));
        MAppend(AMotorNums, VCreateStr([QFieldStr('MotorNum')]));
        MAppend(AMotorDates, VCreateDate([QFieldDT('MotorDate')]));
        OldID:= NewID;
      end
      else begin
        n:= High(AMotorNames);
        VAppend(AReclamationIDs[n], QFieldInt('ReclamationID'));
        VAppend(ALogIDs[n], QFieldInt('LogID'));
        VAppend(AMileages[n], QFieldInt('Mileage'));
        VAppend(AMotorNames[n], QFieldStr('MotorName'));
        VAppend(AMotorNums[n], QFieldStr('MotorNum'));
        VAppend(AMotorDates[n], QFieldDT('MotorDate'));
      end;
      QNext;
    end;
  end;
  QClose;
end;

function TSQLite.PretensionMaxID: Integer;
begin
  Result:= MaxInt32ID('PRETENSIONS');
end;

procedure TSQLite.PretensionAnswersToUserUpdate(const APretensionIDs, ADelPretensionIDs: TIntVector;
                           const ALetterNum: String;
                           const ALetterDate: TDate;
                           const AStatus: Integer);
begin
  try
    PretensionLetterCustomUpdate(APretensionIDs, 13, ALetterNum, ALetterDate, AStatus);
    PretensionLetterCustomUpdate(ADelPretensionIDs, 13, EmptyStr, 0, 1);
    QCommit;
  except
    QRollback;
  end;
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

function TSQLite.NoteLoad(const ALogID: Integer; const ACategory: Byte): String;
var
  TableName: String;
begin
  TableName:= LogMotorTableNameGet(ACategory);
  Result:= ValueStrInt32ID(TableName, 'Note', 'LogID', ALogID);
end;

procedure TSQLite.NoteUpdate(const ALogID: Integer; const ACategory: Byte; const ANote: String);
var
  TableName: String;
begin
  TableName:= LogMotorTableNameGet(ACategory);
  UpdateInt32ID(TableName, 'Note', 'LogID', ALogID, ANote);
end;

procedure TSQLite.NoteDelete(const ALogID: Integer; const ACategory: Byte);
begin
  NoteUpdate(ALogID, ACategory, EmptyStr);
end;

function TSQLite.PretensionNoteLoad(const APretensionID: Integer): String;
begin
  Result:= ValueStrInt32ID('PRETENSIONS', 'Note', 'PretensionID', APretensionID);
end;

procedure TSQLite.PretensionNoteUpdate(const APretensionID: Integer; const ANote: String);
begin
  UpdateInt32ID('PRETENSIONS', 'Note', 'PretensionID', APretensionID, ANote);
end;

procedure TSQLite.PretensionNoteDelete(const APretensionID: Integer);
begin
  PretensionNoteUpdate(APretensionID, EmptyStr);
end;

function TSQLite.MileageLoad(const ALogID: Integer): Integer;
begin
  Result:= ValueInt32Int32ID('RECLAMATIONMOTORS', 'Mileage', 'LogID', ALogID);
end;

procedure TSQLite.MileageUpdate(const ALogID: Integer; const AMileage: Integer);
begin
  UpdateInt32ID('RECLAMATIONMOTORS', 'Mileage', 'LogID', ALogID, AMileage);
end;

procedure TSQLite.MileageDelete(const ALogID: Integer);
begin
  MileageUpdate(ALogID, -1);
end;

end.

