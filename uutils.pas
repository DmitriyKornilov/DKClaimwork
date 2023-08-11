unit Uutils;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DateUtils, FileUtil,

  DK_Vector, DK_StrUtils, DK_Dialogs, DK_Const;

const
  LETTER_NOTNEED_MARK = '—';
  LETTER_NAMES: array of String = (
   { 0} 'Уведомление о неисправности от Потребителя',
   { 1} 'Уведомление о неисправности Производителю',
   { 2} 'Решение Производителя о выезде представителя',
   { 3} 'Ответ Потребителю о выезде представителя',
   { 4} 'Акт осмотра электродвигателя',
   { 5} 'Отзыв рекламации Потребителем',

   { 6} 'Запрос о ремонте двигателя от Потребителя',
   { 7} 'Запрос о ремонте двигателя Производителю',
   { 8} 'Ответ на запрос о ремонте от Производителя',
   { 9} 'Ответ на запрос о ремонте Потребителю',

   {10} 'Претензия от Потребителя',
   {11} 'Уведомление о претензии Производителю',
   {12} 'Ответ на претензию от Производителя',
   {13} 'Ответ на претензию Потребителю',

   {High} 'Указать при формировании'
  );

  LETTER_SUBJECTS: array of String = (
   { 0} 'О неисправности',
   { 1} 'О неисправности в СЛД Петроввальское',
   { 2} 'О согласовании расследования в одностороннем порядке',
   { 3} 'О выезде представителя поставщика на расследование',
   { 4} 'О выезде представителя производителя на расследование',
   { 5} 'О расследовании в СЛД Петроввальское',
   { 6} 'Об истечении срока гарантии',

   { 7} 'О гарантийном ремонте'
  );

  //Тип организации 0 - все, 1 - потребители, 2 - производители
  function OrganizationTypeGet(const ALetterType: Byte): Byte;


  //наименования таблиц и полей логов
  procedure LetterDBNamesGet(const ALetterType: Byte;
                            out ATableName, ADateField, ANumField: String);
  function LogTableNameGet(const ACategory: Byte): String;

  //статус рекламации
  function ReclamationStatusIntToStr(const AStatus: Integer): String;
  function ReclamationStatusIntToStr(const AStatuses: TIntVector): TStrVector;


  //имена писем
  function LetterFullName(const ADate: TDate; const ANum: String;
                          const ACheckFileNameBadSymbols: Boolean): String;
  function LetterFullNames(const ADates: TDateVector; const ANums: TStrVector): TStrVector;
  function LettersFullName(const ADates: TDateVector; const ANums: TStrVector): String;
  function LettersUniqueFullName(const ADates: TDateVector; const ANums: TStrVector;
                                 out AIsSeveral: Boolean): String;

  //наименования двигателей
  function MotorDateToStr(const ADate: TDate): String;
  function MotorDatesToStr(const ADates: TDateVector): TStrVector;
  function MotorFullNum(const AMotorNum: String; const AMotorDate: TDate): String;
  function MotorFullName(const AMotorName, AMotorNum: String; const AMotorDate: TDate): String;
  function MotorFullNames(const AMotorNames, AMotorNums: TStrVector;
                          const AMotorDates: TDateVector): TStrVector;
  function MotorsFullName(const AMotorNames, AMotorNums: TStrVector;
                                 const AMotorDates: TDateVector): String;
  function MotorsFullName(const AMotorNames, AMotorNums: TStrVector): String;

  procedure ReceiversDBNamesGet(const AOrganizationType: Byte;
                                out ATableName, AIDFieldName: String);

  //атрибуты документов (писем)
  function IsDocumentEmpty(const ADate: TDate; const ANum: String): Boolean;
  function IsDocumentNotNeed(const ADate: TDate; const ANum: String): Boolean;
  function IsDocumentFileExists(const ALetterType: Byte;
                                  const ALetterDate: TDate;
                                  const ALetterNum: String;
                                  const AMotorDate: TDate;
                                  const AMotorName, AMotorNum: String): Boolean;

  //файлы писем
  function MotorNameDirectoryGet(const AMotorName: String): String;
  function MotorNameDirectoryFullGet(const AMotorName: String): String;
  procedure MotorNameDirectoryCheck(const AOldMotorNameIDs, ANewMotorNameIDs: TIntVector;
                                    const AOldMotorNames, ANewMotorNames: TStrVector);

  function MotorNumDirectoryGet(const AMotorNum: String; const AMotorDate: TDate): String;
  function MotorNumDirectoryFullGet(const AMotorName, AMotorNum: String;
                                    const AMotorDate: TDate): String;
  function MotorNumDirectoryDelete(const AMotorName, AMotorNum: String;
                                    const AMotorDate: TDate): Boolean;
  procedure MotorNumDirectoryCheck(const AOldMotorName, ANewMotorName: String;
                                  const AOldMotorNum, ANewMotorNum: String;
                                  const AOldMotorDate, ANewMotorDate: TDate);

  function FileNameGet(const ALetterType: Byte;
                       const ALetterDate: TDate;
                       const ALetterNum: String): String;
  function FileNameGet(const ALetterType: Byte;
                     const ALetterDate: TDate;
                     const ALetterNum: String;
                     const AMotorDate: TDate;
                     const AMotorName, AMotorNum: String): String;
  function FileNameFullGet(const ALetterType: Byte;
                           const ALetterDate: TDate;
                           const ALetterNum: String;
                           const AMotorDate: TDate;
                           const AMotorName, AMotorNum: String): String;

  function DocumentDelete(const ALetterType: Byte;
                        const ALetterDate: TDate;
                        const ALetterNum: String;
                        const AMotorDate: TDate;
                        const AMotorName, AMotorNum: String): Boolean;
  function DocumentCopy(const ASrcFileName: String;
                        const ALetterType: Byte;
                        const ALetterDate: TDate;
                        const ALetterNum: String;
                        const AMotorDate: TDate;
                        const AMotorName, AMotorNum: String): Boolean;
  function DocumentSave(const ALetterType: Byte;
                         const ASrcFileName: String;
                         const AMotorDate: TDate;
                         const AMotorName, AMotorNum: String;
                         const AOldLetterDate: TDate;
                         const AOldLetterNum: String;
                         const ALetterDate: TDate;
                         const ALetterNum: String): Boolean;

  //текст письма из Memo
  function LetterTextFromStrings(const AStrings: TStrings): TStrVector;
  //текст письма в Memo
  procedure LetterTextToStrings(const V:TStrVector; const AStrings: TStrings);

  //тексты писем по темам
  function Letter0ReclamationToBuilder(const ALocationName, AMotorsFullName: String;
                                       const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
  function Letter1ReclamationToBuilder(const ALocationName, AMotorsFullName: String;
                                       const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
  function Letter2ReclamationToUser(const ANoticesFullName, AMotorsFullName: String;
                                    const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
  function Letter3ReclamationToUser(const ALocationName, ANoticesFullName, AMotorsFullName,
                                          AArrivalDate, ADelegateName, ADelegatePhone: String;
                                       const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
  function Letter4ReclamationToUser(const ALocationName, ANoticesFullName, AMotorsFullName,
                                        AArrivalDate, ADelegateName, ADelegatePhone: String;
                                       const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
  function Letter5ReclamationToUser(const ALocationName, ANoticesFullName, AMotorsFullName: String;
                                    const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
  function Letter6ReclamationWarranty(const ALocationName, ANoticeFullName,
                                         AMotorName, AMotorNum, AWarrantyBuildDate,
                                         AWarrantyMileage, AWarrantyUseDate: String;
                                    const AWarrantyType: Byte): TStrVector;

  function Letter7RepairToBuilder(const AMotorsFullName: String;
                                  const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
  function Letter7RepairToUser(const ANoticesFullName, AMotorsFullName: String;
                             const AIsSeveralMotors, AIsSeveralNotices, AIsSeveralAnswers: Boolean): TStrVector;

var
  ApplicationDirectoryName: String;

implementation

function LetterTextFromStrings(const AStrings: TStrings): TStrVector;
var
  i, n: Integer;
  S: String;
begin
  Result:= nil;
  if AStrings.Count=0 then Exit;

  n:= -1;
  for i:= 0 to AStrings.Count-1 do
  begin
    S:= STrim(AStrings[i]);
    if not SEmpty(S) then
    begin
      VAppend(Result, S);
      n:= i;
      break;
    end;
  end;

  for i:= n+1 to AStrings.Count-1 do
  begin
    S:= STrim(AStrings[i]);
    if SEmpty(S) then
      VAppend(Result, EmptyStr)
    else begin
      if SIsHyphenSymbol(SSymbolLast(Result[High(Result)])) then
        Result[High(Result)]:= Result[High(Result)] + S
      else
        Result[High(Result)]:= Result[High(Result)] + SYMBOL_SPACE + S
    end;
  end;
end;

procedure LetterTextToStrings(const V: TStrVector; const AStrings: TStrings);
var
  i: Integer;
begin
  if not Assigned(AStrings) then Exit;
  AStrings.Clear;
  for i:= 0 to High(V) do
  begin
    AStrings.Append(V[i]);
    if i<High(V) then
      AStrings.Append(EmptyStr);
  end;
end;

function Letter0ReclamationToBuilder(const ALocationName, AMotorsFullName: String;
                                    const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
var
  S: String;
begin
  S:= 'В связи с ';
  if AIsSeveralNotices then
    S:= S + 'поступившими уведомлениями (копии писем прилагаю) '
  else
    S:= S + 'поступившим уведомлением (копию письма прилагаю) ';
  S:= S + 'прошу Вас командировать представителя изготовителя в ';
  S:= S + ALocationName + ' на расследование ';
  if AIsSeveralMotors then
    S:= S + 'рекламационных случаев электродвигателей '
  else
    S:= S + 'рекламационного случая электродвигателя ';
  S:= S + AMotorsFullName + '.';

  Result:= VCreateStr([S]);
end;

function Letter1ReclamationToBuilder(const ALocationName, AMotorsFullName: String;
                                     const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
var
  S1, S2: String;
begin
  S1:= 'Настоящим письмом уведомляем Вас о том, что в ' + ALocationName;
  if AIsSeveralMotors then
    S1:= S1 + ' вышли из строя гарантийные электродвигатели '
  else
    S1:= S1 + ' вышел из строя гарантийный электродвигатель ';
  S1:= S1 + AMotorsFullName + '. ';
  if AIsSeveralNotices then
    S1:= S1 + 'Копии писем прилагаю. '
  else
    S1:= S1 + 'Копию письма прилагаю. ';

  if AIsSeveralMotors then
    S2:= 'Расследование рекламационных случаев '
  else
    S2:= 'Расследование рекламационного случая ';
  S2:= S2 + 'доверено Карманову А.А. в соответствии с письмом ' +
            'ООО «Русэлпром. Электрические машины» № 0215 от 09.02.2023.';
  Result:= VCreateStr([S1, S2]);
end;

function Letter2ReclamationToUser(const ANoticesFullName, AMotorsFullName: String;
                                  const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
var
  S: String;
begin
  if AIsSeveralNotices then
    S:= 'На Ваши письма №№ '
  else
    S:= 'На Ваше письмо № ';
  S:= S + ANoticesFullName;
  S:= S + ' сообщаю, что наша компания согласовывает расследование ';
  if AIsSeveralMotors then
    S:= S + 'причин неисправностей электродвигателей '
  else
    S:= S + 'причины неисправности электродвигателя ';
  S:= S + AMotorsFullName;
  S:= S + ' без представителя изготовителя/поставщика. ' +
      'Результаты расследования (акт, фото- и видеоматериалы) просим направить в наш адрес.';

  Result:= VCreateStr([S]);
end;

function Letter3ReclamationToUser(const ALocationName, ANoticesFullName, AMotorsFullName,
                                        AArrivalDate, ADelegateName, ADelegatePhone: String;
                                       const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
var
  S1, S2: String;
begin
  if AIsSeveralNotices then
    S1:= 'На Ваши письма №№ '
  else
    S1:= 'На Ваше письмо № ';
  S1:= S1 + ANoticesFullName;
  S1:= S1 + ' сообщаю, что ';
  S1:= S1 + AArrivalDate;
  S1:= S1 + ' для участия в расследовании ';
  if AIsSeveralMotors then
    S1:= S1 + 'причин неисправностей электродвигателей '
  else
    S1:= S1 + 'причины неисправности электродвигателя ';
  S1:= S1 + AMotorsFullName + ' в ' + ALocationName;
  S1:= S1 + ' прибудет наш представитель ';
  S1:= S1 + ADelegateName + ', ' + ADelegatePhone + '.';

  S2:= 'Прошу Вас организовать встречу представителя, допуск на локомотив и к ' +
       'документам, предусмотренным СТО РЖД 05.007-2019.';

  Result:= VCreateStr([S1, S2]);
end;

function Letter4ReclamationToUser(const ALocationName, ANoticesFullName, AMotorsFullName,
                                        AArrivalDate, ADelegateName, ADelegatePhone: String;
                                       const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
var
  S1, S2: String;
begin
  if AIsSeveralNotices then
    S1:= 'На Ваши письма №№ '
  else
    S1:= 'На Ваше письмо № ';
  S1:= S1 + ANoticesFullName;
  S1:= S1 + ' сообщаю, что в соответствии с решением производителя (копию письма прилагаю) ';
  S1:= S1 + AArrivalDate;
  S1:= S1 + ' для участия в расследовании ';
  if AIsSeveralMotors then
    S1:= S1 + 'причин неисправностей электродвигателей '
  else
    S1:= S1 + 'причины неисправности электродвигателя ';
  S1:= S1 + AMotorsFullName + ' в ' + ALocationName;
  S1:= S1 + ' прибудет представитель завода-изготовителя ';
  S1:= S1 + ADelegateName + ', ' + ADelegatePhone + '.';

  S2:= 'Прошу Вас организовать встречу представителя, допуск на локомотив и к ' +
       'документам, предусмотренным СТО РЖД 05.007-2019.';

  Result:= VCreateStr([S1, S2]);
end;

function Letter5ReclamationToUser(const ALocationName, ANoticesFullName, AMotorsFullName: String;
                                  const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
var
  S: String;
begin
  if AIsSeveralNotices then
    S:= 'На Ваши письма №№ '
  else
    S:= 'На Ваше письмо № ';
  S:= S + ANoticesFullName;
  S:= S + ' сообщаю, что при разборе ';
  if AIsSeveralMotors then
    S:= S + 'случаев неисправностей электродвигателей '
  else
    S:= S + 'случая неисправности электродвигателя ';
  S:= S + AMotorsFullName;
  S:= S + ' представлять интересы производителя/поставщика в ';
  S:= S + ALocationName;
  S:= S + ' доверено Карманову Алексею Александровичу, +7 (937) 534-93-22.';

  Result:= VCreateStr([S]);
end;

function Letter6ReclamationWarranty(const ALocationName, ANoticeFullName,
                                         AMotorName, AMotorNum, AWarrantyBuildDate,
                                         AWarrantyMileage, AWarrantyUseDate: String;
                                    const AWarrantyType: Byte): TStrVector;
var
  S, W: String;
begin
  S:= 'На Ваше письмо № ' + ANoticeFullName + ' сообщаю, что в соответствии c ';
  if SFind(AMotorName, 'АНЭМ225', False) then
  begin
    S:= S + 'ТУ 16-15 ВАКИ.526413.160 ТУ';
    W:= 'АНЭМ225L4УХЛ2 – 2,5 года cо дня ввода в эксплуатацию, но не более ' +
        '350 тыс. км. пробега электровоза и не более 3-х лет с даты изготовления. ';
  end
  else if SFind(AMotorName, ' 7АЖ225', False) then
  begin
    S:= S + 'ТУ 16-14 ВАКИ.526422.146 ТУ';
    W:= '7АЖ225М6У2 – 2,5 года cо дня ввода в эксплуатацию, но не более ' +
        '250 тыс. км. пробега тепловоза и не более 3-х лет с даты изготовления. ';
  end
  else begin
    S:= S + '<НОМЕР ТЕХНИЧЕСКИХ УСЛОВИЙ>';
    W:= '<СРОКИ ГАРАНТИИ>. ';
  end;

  S:= S + ', согласованными с ОАО «РЖД», установленный производителем ' +
          'гарантийный срок на электродвигатели ' + W;
  S:= S + ' Случай выхода из строя  в ' + ALocationName +
      ' электродвигателя ' + AMotorName + ' № ' + AMotorNum + ' (';
  case AWarrantyType of
  1: S:= S + 'пробег локомотива ' +  AWarrantyMileage + ' км';
  2: S:= S + 'изготовлен ' +  AWarrantyBuildDate;
  3: S:= S + 'введен в эксплуатацию ' +  AWarrantyUseDate;
  end;
  S:= S + ') не является гарантийным.';

  Result:= VCreateStr([S]);
end;


function Letter7RepairToBuilder(const AMotorsFullName: String;
                                const AIsSeveralMotors, AIsSeveralNotices: Boolean): TStrVector;
var
  S: String;
begin
  S:= 'В связи с ';
  if AIsSeveralNotices then
    S:= S + 'поступившими обращениями '
  else
    S:= S + 'поступившим обращением ';
  //S:= S + AUserNameR;
  if AIsSeveralNotices then
    S:= S + ' (копии писем прилагаю) '
  else
    S:= S + ' (копию письма прилагаю) ';
  S:= S + 'прошу Вас согласовать отправку в гарантийный ремонт  ';
  if AIsSeveralMotors then
    S:= S + 'электродвигателей '
  else
    S:= S + 'электродвигателя ';
  S:= S + AMotorsFullName + '.';

  Result:= VCreateStr([S]);
end;

function Letter7RepairToUser(const ANoticesFullName, AMotorsFullName: String;
                             const AIsSeveralMotors, AIsSeveralNotices, AIsSeveralAnswers: Boolean): TStrVector;
var
  S1, S2: String;
begin
  if AIsSeveralNotices then
    S1:= 'На Ваши письма №№ '
  else
    S1:= 'На Ваше письмо № ';
  S1:= S1 + ANoticesFullName;
  S1:= S1 + ' сообщаю, что в соответствии с решением производителя ';
  if AIsSeveralAnswers then
    S1:= S1 + '(копии писем прилагаю) '
  else
    S1:= S1 + '(копию письма прилагаю) ';
  S1:= S1 + 'наша компания согласовывает отправку в гарантийный ремонт ';
  if AIsSeveralMotors then
    S1:= S1 + 'электродвигателей '
  else
    S1:= S1 + 'электродвигателя ';
  S1:= S1 + AMotorsFullName + '. ';
  S1:= S1 + 'Отгрузку ';
  if AIsSeveralMotors then
    S1:= S1 + 'электродвигателей '
  else
    S1:= S1 + 'электродвигателя ';
  S1:= S1 +'необходимо произвести через транспортную компанию ООО «Желдорэкспедиция» ' +
       'за счет грузополучателя. Прошу Вас обратить внимание на выполнение условий ' +
       'хранения и транспортировки гарантийного товара.';
  S2:= 'Заводом-изготовителем будет проведено комплексное обследование и в случае ' +
       'подтверждения причины неисправности, указанной в акте осмотра – гарантийный ремонт.';

  Result:= VCreateStr([S1, S2]);
end;

function OrganizationTypeGet(const ALetterType: Byte): Byte;
begin
  Result:= 0;
  if ALetterType in [1, 7, 11] then  //Уведомление производителю
    Result:= 2 //производители
  else if ALetterType in [3, 9, 13] then   //Ответ потребителю
    Result:= 1; //потребители
end;

procedure LetterDBNamesGet(const ALetterType: Byte;
                          out ATableName, ADateField, ANumField: String);
var
  Prefix: String;
begin
  if {(ALetterType>=0) and} (ALetterType<=5) then
    ATableName:= LogTableNameGet(1)
  else if (ALetterType>=6) and (ALetterType<=9) then
    ATableName:= LogTableNameGet(2)
  else if (ALetterType>=10) and (ALetterType<=13) then
    ATableName:= LogTableNameGet(3);

  if ALetterType in [0, 6, 10] then
    Prefix:= 'NoticeFromUser'
  else if ALetterType in [1, 7, 11] then
    Prefix:= 'NoticeToBuilder'
  else if ALetterType in [2, 8, 12] then
    Prefix:= 'AnswerFromBuilder'
  else if ALetterType in [3, 9, 13] then
    Prefix:= 'AnswerToUser'
  else if ALetterType = 4 then
    Prefix:= 'Report'
  else if ALetterType = 5 then
    Prefix:= 'Cancel';

  ANumField:= Prefix + 'Num';
  ADateField:= Prefix + 'Date';
end;

function LogTableNameGet(const ACategory: Byte): String;
begin
  case ACategory of
  1: Result:= 'LOGRECLAMATION';
  2: Result:= 'LOGREPAIR';
  3: Result:= 'LOGPRETENSION';
  end;
end;

function MotorDateToStr(const ADate: TDate): String;
begin
  Result:= EmptyStr;
  if ADate>0 then
    Result:= FormatDateTime('dd.mm.yyyy', ADate);
end;

function MotorDatesToStr(const ADates: TDateVector): TStrVector;
var
  i: Integer;
begin
  VDim(Result{%H-}, Length(ADates));
  for i:= 0 to High(Result) do
    Result[i]:= MotorDateToStr(ADates[i]);
end;

function ReclamationStatusIntToStr(const AStatus: Integer): String;
begin
  Result:= EmptyStr;
  case AStatus of
  0: Result:= EmptyStr;
  1: Result:= 'В работе';
  2: Result:= 'Принята';
  3: Result:= 'Отклонена';
  4: Result:= 'Отозвана';
  end;
end;

function ReclamationStatusIntToStr(const AStatuses: TIntVector): TStrVector;
var
  i: Integer;
begin
  VDim(Result{%H-}, Length(AStatuses));
  for i:= 0 to High(Result) do
    Result[i]:= ReclamationStatusIntToStr(AStatuses[i]);
end;

function LetterFullName(const ADate: TDate; const ANum: String;
                        const ACheckFileNameBadSymbols: Boolean): String;
var
  S: String;
begin
  Result:= EmptyStr;
  if ACheckFileNameBadSymbols then
    S:= SFileNameCheck(ANum, SYMBOL_HYPHEN)
  else
    S:= ANum;
  if (ADate>0) and (not SEmpty(S)) then
    Result:= S + ' от ' + FormatDateTime('dd.mm.yyyy', ADate)
  else if not SEmpty(S) then
    Result:= S;
end;

function LetterFullNames(const ADates: TDateVector; const ANums: TStrVector): TStrVector;
var
  i: Integer;
begin
  Result:= nil;
  if Length(ADates) <> Length(ANums) then Exit;
  VDim(Result, Length(ADates));
  for i:= 0 to High(Result) do
    Result[i]:= LetterFullName(ADates[i], ANums[i], False {no check bad symbols});
end;

function LettersFullName(const ADates: TDateVector; const ANums: TStrVector): String;
var
  i, j: Integer;
  S: String;
  VDates: TDateVector;
  VNums: TStrVector;
begin
  Result:= EmptyStr;
  if Length(ADates) <> Length(ANums) then Exit;
  if VIsNil(ADates) or VIsNil(ANums) then Exit;
  VDates:= VUniqueDate(ADates);
  VDim(VNums{%H-}, Length(VDates));
  for i:= 0 to High(ADates) do
  begin
    S:= ANums[i];
    j:= VIndexOfDate(VDates, ADates[i]);
    if SEmpty(VNums[j]) then
      VNums[j]:= S
    else
      VNums[j]:= VNums[j] + ', ' + S;
  end;
  Result:= LetterFullName(VDates[0], VNums[0], False {no check bad symbols});
  for i:= 1 to High(VNums) do
    Result:= Result + ', ' + LetterFullName(VDates[i], VNums[i], False {no check bad symbols});
end;

function LettersUniqueFullName(const ADates: TDateVector;
  const ANums: TStrVector; out AIsSeveral: Boolean): String;
var
  i, n: Integer;
  Dates: TDateVector;
  Nums: TStrVector;
begin
  Result:= EmptyStr;
  AIsSeveral:= False;
  if Length(ADates) <> Length(ANums) then Exit;

  Dates:= nil;
  Nums:= nil;
  for i:= 0 to High(ANums) do
  begin
    n:= VIndexOf(Nums, ANums[i]);
    if n=-1 then
    begin
      VAppend(Nums, ANums[i]);
      VAppend(Dates, ADates[i]);
    end
    else if Dates[n]<>ADates[i] then
    begin
      VAppend(Nums, ANums[i]);
      VAppend(Dates, ADates[i]);
    end;
  end;

  AIsSeveral:= Length(Nums)>1;
  Result:= LettersFullName(Dates, Nums);
end;

function MotorFullNum(const AMotorNum: String; const AMotorDate: TDate): String;
begin
  Result:= AMotorNum + ' (' + FormatDateTime('mm.yy', AMotorDate) + ')';
end;

function MotorFullName(const AMotorName, AMotorNum: String; const AMotorDate: TDate): String;
begin
  Result:= AMotorName + ' № ' + MotorFullNum(AMotorNum, AMotorDate);
end;

function MotorFullNames(const AMotorNames, AMotorNums: TStrVector;
                        const AMotorDates: TDateVector): TStrVector;
var
  i: Integer;
begin
  VDim(Result{%H-}, Length(AMotorNames));
  for i:= 0 to High(Result) do
    Result[i]:= MotorFullName(AMotorNames[i], AMotorNums[i], AMotorDates[i]);
end;

function MotorsFullName(const AMotorNames, AMotorNums: TStrVector;
                               const AMotorDates: TDateVector): String;
var
  i, j: Integer;
  S: String;
  VNames, VNums: TStrVector;
begin
  Result:= EmptyStr;
  VNames:= VUnique(AMotorNames, False);
  VNames:= VSort(VNames);
  VDim(VNums{%H-}, Length(VNames));
  for i:= 0 to High(AMotorNames) do
  begin
    S:= MotorFullNum(AMotorNums[i], AMotorDates[i]);
    j:= VIndexOf(VNames, AMotorNames[i]);
    if SEmpty(VNums[j]) then
      VNums[j]:= S
    else
      VNums[j]:= VNums[j] + ', ' + S;
  end;
  Result:= VNames[0] + ' № ' + VNums[0];
  for i:= 1 to High(VNames) do
    Result:= Result + ', ' + VNames[i] + ' № ' + VNums[i];
end;

function MotorsFullName(const AMotorNames, AMotorNums: TStrVector): String;
var
  i, j: Integer;
  S: String;
  VNames, VNums: TStrVector;
begin
  Result:= EmptyStr;
  if Length(AMotorNames) <> Length(AMotorNums) then Exit;
  if VIsNil(AMotorNames) or VIsNil(AMotorNums) then Exit;
  VNames:= VUnique(AMotorNames, False);
  VNames:= VSort(VNames);
  VDim(VNums{%H-}, Length(VNames));
  for i:= 0 to High(AMotorNames) do
  begin
    S:= AMotorNums[i];
    j:= VIndexOf(VNames, AMotorNames[i]);
    if SEmpty(VNums[j]) then
      VNums[j]:= S
    else
      VNums[j]:= VNums[j] + ', ' + S;
  end;
  Result:= VNames[0] + ' № ' + VNums[0];
  for i:= 1 to High(VNames) do
    Result:= Result + ', ' + VNames[i] + ' № ' + VNums[i];
end;

procedure ReceiversDBNamesGet(const AOrganizationType: Byte;
                               out ATableName, AIDFieldName: String);
begin
  if AOrganizationType=1 then  //1 - потребители
  begin
    ATableName:= 'USERRECEIVERS ';
    AIDFieldName:= 'UserID ';
  end
  else begin //2 - производители
    ATableName:= 'BUILDERRECEIVERS ';
    AIDFieldName:= 'BuilderID ';
  end;
end;








function IsDocumentEmpty(const ADate: TDate; const ANum: String): Boolean;
begin
  Result:= SEmpty(ANum) and (ADate=0);
end;

function IsDocumentNotNeed(const ADate: TDate; const ANum: String): Boolean;
begin
  Result:= SSame(ANum, LETTER_NOTNEED_MARK) and (ADate=0);
end;

function IsDocumentFileExists(const ALetterType: Byte;
                                  const ALetterDate: TDate;
                                  const ALetterNum: String;
                                  const AMotorDate: TDate;
                                  const AMotorName, AMotorNum: String): Boolean;
var
  DocName: String;
begin
  Result:= False;
  if IsDocumentEmpty(ALetterDate, ALetterNum) or
     IsDocumentNotNeed(ALetterDate, ALetterNum) then Exit;
  DocName:= FileNameFullGet(ALetterType, ALetterDate, ALetterNum,
                            AMotorDate, AMotorName, AMotorNum);
  Result:= FileExists(DocName);
end;

function MotorNameDirectoryGet(const AMotorName: String): String;
begin
  Result:= AMotorName;
end;

function MotorNameDirectoryFullGet(const AMotorName: String): String;
begin
  Result:= ApplicationDirectoryName + 'files' +
           DirectorySeparator +
           MotorNameDirectoryGet(AMotorName);
end;

procedure MotorNameDirectoryCheck(const AOldMotorNameIDs, ANewMotorNameIDs: TIntVector;
                              const AOldMotorNames, ANewMotorNames: TStrVector);
var
  S: String;
  i, n: Integer;
begin
  for i:= 0 to High(AOldMotorNameIDs) do
  begin
    n:= VIndexOf(ANewMotorNameIDs, AOldMotorNameIDs[i]);
    if (n>=0) and (not SSame(ANewMotorNames[n], AOldMotorNames[i])) then
    begin
      S:= MotorNameDirectoryFullGet(AOldMotorNames[i]);
      if DirectoryExists(S) then
          RenameFile(S, MotorNameDirectoryFullGet(ANewMotorNames[n]));
    end;
  end;
end;

function MotorNumDirectoryGet(const AMotorNum: String; const AMotorDate: TDate): String;
begin
  Result:= AMotorNum + ' (' + FormatDateTime('mm.yy', AMotorDate) + ')';
end;

function MotorNumDirectoryFullGet(const AMotorName, AMotorNum: String;
                                  const AMotorDate: TDate): String;
begin
  Result:= MotorNameDirectoryFullGet(AMotorName) +
           DirectorySeparator +
           MotorNumDirectoryGet(AMotorNum, AMotorDate);
end;

function MotorNumDirectoryDelete(const AMotorName, AMotorNum: String;
                                 const AMotorDate: TDate): Boolean;
var
  DirName: String;
begin
  Result:= False;
  DirName:= MotorNumDirectoryFullGet(AMotorName, AMotorNum, AMotorDate);
  if DirectoryExists(DirName) then
    Result:= DeleteDirectory(DirName, False);
end;

procedure MotorNumDirectoryCheck(const AOldMotorName, ANewMotorName: String;
                                  const AOldMotorNum, ANewMotorNum: String;
                                  const AOldMotorDate, ANewMotorDate: TDate);
var
  OldDirName, NewDirName:  String;
begin
  if SSame(AOldMotorName, ANewMotorName) and
     SSame(AOldMotorNum, ANewMotorNum) and
     SameDate(AOldMotorDate, ANewMotorDate) then Exit;
  OldDirName:= MotorNumDirectoryFullGet(AOldMotorName, AOldMotorNum, AOldMotorDate);
  if not DirectoryExists(OldDirName) then Exit;
  NewDirName:= MotorNumDirectoryFullGet(ANewMotorName, ANewMotorNum, ANewMotorDate);
  RenameFile(OldDirName, NewDirName);
end;

function FileNameGet(const ALetterType: Byte;
                     const ALetterDate: TDate;
                     const ALetterNum: String): String;
var
  S: String;
begin
  S:= LetterFullName(ALetterDate, ALetterNum, True {check bad symbols});
  if ALetterType = 4 then
    Result:= 'Акт №' + S + ' осмотра электродвигателя'
  else if ALetterType in [0, 2, 5, 6, 8, 12, 10] then
    Result:= 'Вх. №' + S + ' - ' + LETTER_NAMES[ALetterType]
  else if ALetterType in [1, 3, 7, 9, 11, 13] then
    Result:= 'Исх. №' + S + ' - ' + LETTER_NAMES[ALetterType];
end;

function FileNameGet(const ALetterType: Byte;
                     const ALetterDate: TDate;
                     const ALetterNum: String;
                     const AMotorDate: TDate;
                     const AMotorName, AMotorNum: String): String;
var
  S: String;
begin
  S:= MotorFullName(AMotorName, AMotorNum, AMotorDate);
  Result:= FileNameGet(ALetterType, ALetterDate, ALetterNum) + SYMBOL_SPACE + S;
end;

function FileNameFullGet(const ALetterType: Byte;
                           const ALetterDate: TDate;
                           const ALetterNum: String;
                           const AMotorDate: TDate;
                           const AMotorName, AMotorNum: String): String;
begin
  Result:= MotorNumDirectoryFullGet(AMotorName, AMotorNum, AMotorDate) +
           DirectorySeparator +
           FileNameGet(ALetterType, ALetterDate, ALetterNum,
                       AMotorDate, AMotorName, AMotorNum) + '.pdf';
end;

function DocumentDelete(const ALetterType: Byte;
                        const ALetterDate: TDate;
                        const ALetterNum: String;
                        const AMotorDate: TDate;
                        const AMotorName, AMotorNum: String): Boolean;
var
  FileName: String;
begin
  Result:= False;
  FileName:= FileNameFullGet(ALetterType, ALetterDate, ALetterNum,
                             AMotorDate, AMotorName, AMotorNum);
  if FileExists(FileName) then
    Result:= DeleteFile(FileName);
end;

function DocumentCopy(const ASrcFileName: String;
                        const ALetterType: Byte;
                        const ALetterDate: TDate;
                        const ALetterNum: String;
                        const AMotorDate: TDate;
                        const AMotorName, AMotorNum: String): Boolean;
var
  DestFileName: String;
begin
  DestFileName:= FileNameFullGet(ALetterType, ALetterDate, ALetterNum,
                                   AMotorDate, AMotorName, AMotorNum);
  Result:= CopyFile(ASrcFileName, DestFileName,
               [cffOverwriteFile, cffCreateDestDirectory, cffPreserveTime]);
end;

function DocumentSave(const ALetterType: Byte;
                         const ASrcFileName: String;
                         const AMotorDate: TDate;
                         const AMotorName, AMotorNum: String;
                         const AOldLetterDate: TDate;
                         const AOldLetterNum: String;
                         const ALetterDate: TDate;
                         const ALetterNum: String): Boolean;
var
  IsEmptyFile: Boolean;
begin
  Result:= False;
  IsEmptyFile:= False;

  if SEmpty(ASrcFileName) then
    if Confirm('Не указан файл письма! Продолжить без файла?') then
      IsEmptyFile:= True;

  if not IsEmptyFile then
  begin
    if not FileExists(ASrcFileName) then
    begin
      ShowInfo('Указанный файл письма не найден!');
      Exit;
    end;
    //удаляем старый файл
    DocumentDelete(ALetterType, AOldLetterDate, AOldLetterNum,
                   AMotorDate, AMotorName, AMotorNum);

    //копируем новый файл
    Result:= DocumentCopy(ASrcFileName, ALetterType, ALetterDate, ALetterNum,
                          AMotorDate, AMotorName, AMotorNum);
  end;
end;

end.

