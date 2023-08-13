unit USheets;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, fpspreadsheetgrid,

  DK_SheetTables, DK_Vector, DK_Fonts,

  Uutils;

const
  FONT_LIKE_DEFAULT = flArial;
  FONT_SIZE_DEFAULT = 8;

type

  { TLogTable }

  TLogTable = class(TSheetTable)
  public
    constructor Create(const AGrid: TsWorksheetGrid; const AOnSelect: TSheetSelectEvent);
    procedure Update(const AMotorNames, AMotorNums, AMotorDates,
                           AReclamationLocations, AReclamationUsers,
                           AReclamationNoticeFromUserStrs,
                           AReclamationNoticeToBuilderStrs,
                           AReclamationAnswerFromBuilderStrs,
                           AReclamationAnswerToUserStrs,
                           AReclamationCancelStrs,
                           AReclamationReportStrs,
                           AReclamationNotes, AReclamationStatuses,
                           ARepairUsers,
                           ARepairNoticeFromUserStrs,
                           ARepairNoticeToBuilderStrs,
                           ARepairAnswerFromBuilderStrs,
                           ARepairAnswerToUserStrs,
                           ARepairBeginDatesStrs,
                           ARepairEndDatesStrs,
                           ARepairNotes, ARepairStatuses,
                           APretensionUsers,
                           APretensionNoticeFromUserStrs, APretensionMoneyValueStrs,
                           APretensionNoticeToBuilderStrs,
                           APretensionAnswerFromBuilderStrs,
                           APretensionAnswerToUserStrs,
                           APretensionMoneySendDatesStrs, APretensionMoneySendValuesStrs,
                           APretensionMoneyGetDatesStrs, APretensionMoneyGetValuesStrs,
                           APretensionNotes, APretensionStatuses: TStrVector);
  end;

implementation

{ TLogTable }

constructor TLogTable.Create(const AGrid: TsWorksheetGrid; const AOnSelect: TSheetSelectEvent);
const
  MAIN_COLUMN_WIDTH = 110;
  NOTE_COLUMN_WIDTH = 180;
  STATUS_COLUMN_WIDTH = 95;
begin
  inherited Create(AGrid);
  OnSelect:= AOnSelect;
  SetFontsName(FontLikeToName(FONT_LIKE_DEFAULT));
  SetFontsSize(FONT_SIZE_DEFAULT);
  HeaderFont.Style:= [fsBold];

  //общие данные
  AddColumn('№ п/п', 30);
  AddColumn('Наименование двигателя', 150);
  AddColumn('Номер двигателя', 70);
  AddColumn('Дата изготовления', 70);
  AddColumn('Предприятие', 140);
  AddColumn('Потребитель1', 100);
  //рекламации
  AddColumn(LETTER_NAMES[0], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[1], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[2], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[3], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[4], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[5], MAIN_COLUMN_WIDTH);
  AddColumn('Примечание по ходу расследования', NOTE_COLUMN_WIDTH, haLeft);
  AddColumn('Статус1', STATUS_COLUMN_WIDTH);
  //гарантийный ремонт
  AddColumn('Потребитель2', 100);
  AddColumn(LETTER_NAMES[6], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[7], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[8], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[9], MAIN_COLUMN_WIDTH);
  AddColumn('Дата прибытия в ремонт', 70);
  AddColumn('Дата отправки из ремонта', 70);
  AddColumn('Примечание по ходу ремонта', NOTE_COLUMN_WIDTH, haLeft);
  AddColumn('Статус2', STATUS_COLUMN_WIDTH);
  //возмещение затрат
  AddColumn('Потребитель3', 100);
  AddColumn(LETTER_NAMES[10], MAIN_COLUMN_WIDTH);
  AddColumn('Сумма к возмещению', 80);
  AddColumn(LETTER_NAMES[11], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[12], MAIN_COLUMN_WIDTH);
  AddColumn(LETTER_NAMES[13], MAIN_COLUMN_WIDTH);
  AddColumn('Дата возмещения Потребителю', 70);
  AddColumn('Сумма возмещения Потребителю', 80);
  AddColumn('Дата возмещения Производителем', 70);
  AddColumn('Сумма возмещения Производителем', 80);
  AddColumn('Примечание по возмещению затрат', NOTE_COLUMN_WIDTH, haLeft);
  AddColumn('Статус3', STATUS_COLUMN_WIDTH);

  //общие данные
  AddToHeader(1, 1, 2, 1, '№ п/п');
  AddToHeader(1, 2, 1, 4,  'Электродвигатель');
  AddToHeader(2, 2, 'Наименование');
  AddToHeader(2, 3, 'Номер');
  AddToHeader(2, 4, 'Дата');
  AddToHeader(1, 5, 2, 5, 'Предприятие');
  AddToHeader(1, 6, 2, 6, 'Отправитель уведомления о неисправности');
  //рекламации
  AddToHeader(1, 7, 2, 7,    LETTER_NAMES[0]);
  AddToHeader(1, 8, 2, 8,    LETTER_NAMES[1]);
  AddToHeader(1, 9, 2, 9,    LETTER_NAMES[2]);
  AddToHeader(1, 10, 2, 10,  LETTER_NAMES[3]);
  AddToHeader(1, 11, 2, 11,  LETTER_NAMES[4]);
  AddToHeader(1, 12, 2, 12,  LETTER_NAMES[5]);
  AddToHeader(1, 13, 2, 13, 'Примечание по ходу расследования');
  AddToHeader(1, 14, 2, 14, 'Статус рекламации');
  //гарантийный ремонт
  AddToHeader(1, 15, 2, 15, 'Отправитель запроса на согласование ремонта');
  AddToHeader(1, 16, 2, 16,    LETTER_NAMES[6]);
  AddToHeader(1, 17, 2, 17,    LETTER_NAMES[7]);
  AddToHeader(1, 18, 2, 18,    LETTER_NAMES[8]);
  AddToHeader(1, 19, 2, 19,    LETTER_NAMES[9]);
  AddToHeader(1, 20, 2, 20, 'Дата прибытия в ремонт');
  AddToHeader(1, 21, 2, 21, 'Дата отправки из ремонта');
  AddToHeader(1, 22, 2, 22, 'Примечание по ходу ремонта');
  AddToHeader(1, 23, 2, 23, 'Статус ремонта');
  //возмещение затрат
  AddToHeader(1, 24, 2, 24, 'Отправитель претензии');
  AddToHeader(1, 25, 2, 25, LETTER_NAMES[10]);
  AddToHeader(1, 26, 2, 26, 'Сумма к возмещению');
  AddToHeader(1, 27, 2, 27, LETTER_NAMES[11]);
  AddToHeader(1, 28, 2, 28, LETTER_NAMES[12]);
  AddToHeader(1, 29, 2, 29, LETTER_NAMES[13]);
  AddToHeader(1, 30, 1, 31, 'Компенсировано Потребителю');
  AddToHeader(2, 30, 'Дата');
  AddToHeader(2, 31, 'Сумма');
  AddToHeader(1, 32, 1, 33, 'Возмещено Производителем');
  AddToHeader(2, 32, 'Дата');
  AddToHeader(2, 33, 'Сумма');
  AddToHeader(1, 34, 2, 34, 'Примечание по возмещению затрат');
  AddToHeader(1, 35, 2, 35, 'Статус претензионной работы');
end;

procedure TLogTable.Update(const AMotorNames, AMotorNums, AMotorDates,
                           AReclamationLocations, AReclamationUsers,
                           AReclamationNoticeFromUserStrs,
                           AReclamationNoticeToBuilderStrs,
                           AReclamationAnswerFromBuilderStrs,
                           AReclamationAnswerToUserStrs,
                           AReclamationCancelStrs,
                           AReclamationReportStrs,
                           AReclamationNotes, AReclamationStatuses,
                           ARepairUsers,
                           ARepairNoticeFromUserStrs,
                           ARepairNoticeToBuilderStrs,
                           ARepairAnswerFromBuilderStrs,
                           ARepairAnswerToUserStrs,
                           ARepairBeginDatesStrs,
                           ARepairEndDatesStrs,
                           ARepairNotes, ARepairStatuses,
                           APretensionUsers,
                           APretensionNoticeFromUserStrs, APretensionMoneyValueStrs,
                           APretensionNoticeToBuilderStrs,
                           APretensionAnswerFromBuilderStrs,
                           APretensionAnswerToUserStrs,
                           APretensionMoneySendDatesStrs, APretensionMoneySendValuesStrs,
                           APretensionMoneyGetDatesStrs, APretensionMoneyGetValuesStrs,
                           APretensionNotes, APretensionStatuses: TStrVector
                           );
begin
  //общие данные
  SetColumnOrder('№ п/п');
  SetColumnString('Наименование двигателя', AMotorNames);
  SetColumnString('Номер двигателя', AMotorNums);
  SetColumnString('Дата изготовления', AMotorDates);
  SetColumnString('Предприятие', AReclamationLocations);
  SetColumnString('Потребитель1', AReclamationUsers);
  //рекламации
  SetColumnString(LETTER_NAMES[0], AReclamationNoticeFromUserStrs);
  SetColumnString(LETTER_NAMES[1], AReclamationNoticeToBuilderStrs);
  SetColumnString(LETTER_NAMES[2], AReclamationAnswerFromBuilderStrs);
  SetColumnString(LETTER_NAMES[3], AReclamationAnswerToUserStrs);
  SetColumnString(LETTER_NAMES[4], AReclamationReportStrs);
  SetColumnString(LETTER_NAMES[5], AReclamationCancelStrs);
  SetColumnString('Примечание по ходу расследования', AReclamationNotes);
  SetColumnString('Статус1', AReclamationStatuses);
  //гарантийный ремонт
  SetColumnString('Потребитель2', ARepairUsers);
  SetColumnString(LETTER_NAMES[6], ARepairNoticeFromUserStrs);
  SetColumnString(LETTER_NAMES[7], ARepairNoticeToBuilderStrs);
  SetColumnString(LETTER_NAMES[8], ARepairAnswerFromBuilderStrs);
  SetColumnString(LETTER_NAMES[9], ARepairAnswerToUserStrs);
  SetColumnString('Дата прибытия в ремонт', ARepairBeginDatesStrs);
  SetColumnString('Дата отправки из ремонта', ARepairEndDatesStrs);
  SetColumnString('Примечание по ходу ремонта', ARepairNotes);
  SetColumnString('Статус2', ARepairStatuses);
  //возмещение затрат
  SetColumnString('Потребитель3', APretensionUsers);
  SetColumnString(LETTER_NAMES[10], APretensionNoticeFromUserStrs);
  SetColumnString('Сумма к возмещению', APretensionMoneyValueStrs);
  SetColumnString(LETTER_NAMES[11], APretensionNoticeToBuilderStrs);
  SetColumnString(LETTER_NAMES[12], APretensionAnswerFromBuilderStrs);
  SetColumnString(LETTER_NAMES[13], APretensionAnswerToUserStrs);
  SetColumnString('Дата возмещения Потребителю', APretensionMoneySendDatesStrs);
  SetColumnString('Сумма возмещения Потребителю', APretensionMoneySendValuesStrs);
  SetColumnString('Дата возмещения Производителем', APretensionMoneyGetDatesStrs);
  SetColumnString('Сумма возмещения Производителем', APretensionMoneyGetValuesStrs);
  SetColumnString('Примечание по возмещению затрат', APretensionNotes);
  SetColumnString('Статус3', APretensionStatuses);

  Draw;
end;

end.

