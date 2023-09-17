unit USheets;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Controls, fpspreadsheetgrid,

  DK_SheetTables, DK_Vector, DK_Matrix, DK_Fonts, DK_SheetWriter, DK_Const,
  DK_SheetExporter,

  Uutils;

const
  FONT_LIKE_DEFAULT = flArial;
  FONT_SIZE_DEFAULT = 8;

  USER_COLUMN_WIDTH = 100;
  LETTER_COLUMN_WIDTH = 110;
  NOTE_COLUMN_WIDTH = 180;
  STATUS_COLUMN_WIDTH = 110;

type

  { TSheetCustom }

  TSheetCustom = class (TObject)
  const
    HEADER_ROWS_COUNT = 1;
  private
    FWriter: TSheetWriter;
    FFontName: String;
    FFontSize: Single;
    FZoomPercents: Integer;

    FMainCol1, FMainCol2: Integer;    //начало/конец диапазона столбцов основного уведомления, в котором будем выделять все строки
    FMainColIndex: Integer;
    FFullSelectColIndexes: TIntVector;
    FSelCols1, FSelCols2: TIntVector; //начало/конец диапазонов столбцов для выделения
    FSelectedColIndex: Integer;       //индекс выделенного диапазона столбцов
    FSelRows1, FSelRows2: TIntVector; //начало/конец диапазона строк основного уведомления, в котором будем выделять все строки
    FSelectedNoticeIndex: Integer;    //индекс основного уведомления (диапазона строк)
    FSelectedMotorIndex: Integer;     //индекс двигателя внутри диапазона уведомления

    FUsers: TStrVector;      //отправитель уведомления (потребитель)
    FNotices: TStrVector;    //уведомление от потребителя
    FMotors: TStrMatrix;

    FOnSelect: TSheetSelectEvent;


    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      {%H-}Shift: TShiftState; X, Y: Integer);

    function GetIsSelected: Boolean;
    procedure SelectCell(ARow, ACol: Integer);
    procedure SelectedIndexesClear;

    procedure SetBackground(const ANoticeIndex: Integer; const AIsSelected: Boolean);

    function IsLineExists(const ANoticeIndex: Integer): Boolean;

    function ColumnWidths: TIntVector; virtual;
    procedure DrawHeader; virtual;
    procedure DrawLine(const ANoticeIndex: Integer); virtual;

    procedure DrawMileage(const ARow, ACol, AMileage: Integer);
    procedure DrawDate(const ARow1, ACol1, ARow2, ACol2: Integer; const ADate: TDate);
    procedure DrawMoney(const ARow1, ACol1, ARow2, ACol2: Integer; const AMoney: Int64);
  public
    constructor Create(const AWorksheet: TsWorksheet; const AGrid: TsWorksheetGrid = nil);
    destructor  Destroy; override;

    procedure Update(const AUsers, ANotices: TStrVector; const AMotors: TStrMatrix);

    procedure Draw;
    property Zoom: Integer read FZoomPercents write FZoomPercents;

    function IsFullSelectColIndex(const AColIndex: Integer): Boolean;
    property MainColIndex: Integer read FMainColIndex;

    procedure Select(const ANoticeIndex, AMotorIndex, AColIndex: Integer);
    procedure Unselect;
    property SelectedColIndex: Integer read FSelectedColIndex;
    property SelectedNoticeIndex: Integer read FSelectedNoticeIndex;
    property SelectedMotorIndex: Integer read FSelectedMotorIndex;

    procedure Save(const ADoneMessage: String);

    property IsSelected: Boolean read GetIsSelected;
    property OnSelect: TSheetSelectEvent read FOnSelect write FOnSelect;
  end;

  { TSheetReclamation }

  TSheetReclamation = class (TSheetCustom)
  private
    FLocations: TStrVector;
    FMileages: TIntMatrix;
    FCancels: TStrMatrix;
    FReports: TStrMatrix;
    FStatuses: TStrMatrix;
    FNotes: TStrMatrix;
    FToBuilders: TStrMatrix;
    FFromBuilders: TStrMatrix;
    FToUsers: TStrMatrix;
    function ColumnWidths: TIntVector; override;
    procedure DrawHeader; override;
    procedure DrawLine(const ANoticeIndex: Integer); override;
  public
    procedure Update(const ALocations, AUsers, ANotices: TStrVector;
                     const AToBuilders, AFromBuilders, AToUsers,
                           ANotes, AStatuses, AMotors, AReports, ACancels: TStrMatrix;
                     const AMileages: TIntMatrix);
  end;

  { TSheetRepair }

  TSheetRepair = class (TSheetCustom)
  private
    FBeginDates: TDateMatrix;
    FEndDates: TDateMatrix;
    FStatuses: TStrMatrix;
    FNotes: TStrMatrix;
    FToBuilders: TStrMatrix;
    FFromBuilders: TStrMatrix;
    FToUsers: TStrMatrix;
    FMileages: TIntMatrix;
    function ColumnWidths: TIntVector; override;
    procedure DrawHeader; override;
    procedure DrawLine(const ANoticeIndex: Integer); override;
  public
    procedure Update(const AUsers, ANotices: TStrVector;
                     const AToBuilders, AFromBuilders, AToUsers,
                           ANotes, AStatuses, AMotors: TStrMatrix;
                     const ABeginDates, AEndDates: TDateMatrix;
                     const AMileages: TIntMatrix);
  end;

  { TSheetPretension }

  TSheetPretension = class (TSheetCustom)
  private
    FMoneyValues: TInt64Vector;
    FSendValues: TInt64Vector;
    FSendDates: TDateVector;
    FGetValues: TInt64Vector;
    FGetInvDates: TDateVector;
    FGetDates: TDateVector;
    FStatuses: TStrVector;
    FNotes: TStrVector;
    FToBuilders: TStrVector;
    FFromBuilders: TStrVector;
    FToUsers: TStrVector;
    FMileages: TIntMatrix;
    function ColumnWidths: TIntVector; override;
    procedure DrawHeader; override;
    procedure DrawLine(const ANoticeIndex: Integer); override;
  public
    procedure Update(const AUsers, ANotices,
                           AToBuilders, AFromBuilders, AToUsers, ANotes, AStatuses: TStrVector;
                     const AMotors: TStrMatrix;
                     const AMoneyValues, ASendValues, AGetValues: TInt64Vector;
                     const ASendDates, AGetInvDates, AGetDates: TDateVector;
                     const AMileages: TIntMatrix);
  end;




implementation

{ TSheetPretension }

function TSheetPretension.ColumnWidths: TIntVector;
var
  V1, V2: TIntVector;
begin
  V1:= inherited ColumnWidths;
  V2:= VCreateInt([
    {03} 80,                  // пробег
    {04} 80,                  // сумма
    {05} USER_COLUMN_WIDTH,   // отправитель уведомления (потребитель)
    {06} LETTER_COLUMN_WIDTH, // письмо от потребителя
    {07} LETTER_COLUMN_WIDTH, // письмо производителю
    {08} LETTER_COLUMN_WIDTH, // ответ от производителя
    {09} LETTER_COLUMN_WIDTH, // ответ потребителю
    {10} 100,                 // дата компенсации потребителю
    {11} 100,                 // сумма компенсации потребителю
    {12} 100,                 // дата выставления счета производителю
    {13} 110,                 // дата возмещения производителем
    {14} 110,                 // сумма возмещения производителем
    {15} NOTE_COLUMN_WIDTH,   // примечание
    {16} STATUS_COLUMN_WIDTH  // статус
  ]);
  Result:= VAdd(V1, V2);

  {indexes                0  1  2  3  4   5          }
  FSelCols1:= VCreateInt([4, 7, 8, 9, 10, 15, 1]);
  FSelCols2:= VCreateInt([6, 7, 8, 9, 14, 15, 2]);
  FMainCol1:= 4;
  FMainCol2:= 6;
  FMainColIndex:= 0;
  FFullSelectColIndexes:= VCreateInt([FMainColIndex, 1, 2, 3, 4, 5]);
end;

procedure TSheetPretension.DrawHeader;
begin
  inherited DrawHeader;
  FWriter.WriteText(1,  3, 'Пробег локомотива, км', cbtOuter, True, True);
  FWriter.WriteText(1,  4, 'Сумма к возмещению', cbtOuter, True, True);
  FWriter.WriteText(1,  5, 'Потребитель', cbtOuter, True, True);
  FWriter.WriteText(1,  6, LETTER_NAMES[10], cbtOuter, True, True);
  FWriter.WriteText(1,  7, LETTER_NAMES[11], cbtOuter, True, True);
  FWriter.WriteText(1,  8, LETTER_NAMES[12], cbtOuter, True, True);
  FWriter.WriteText(1,  9, LETTER_NAMES[13], cbtOuter, True, True);
  FWriter.WriteText(1, 10, 'Дата компенсации Потребителю', cbtOuter, True, True);
  FWriter.WriteText(1, 11, 'Сумма компенсации Потребителю', cbtOuter, True, True);
  FWriter.WriteText(1, 12, 'Дата выставления счета Производителю', cbtOuter, True, True);
  FWriter.WriteText(1, 13, 'Дата возмещения Производителем', cbtOuter, True, True);
  FWriter.WriteText(1, 14, 'Сумма возмещения Производителем', cbtOuter, True, True);
  FWriter.WriteText(1, 15, 'Примечание по претензии', cbtOuter, True, True);
  FWriter.WriteText(1, 16, 'Статус претензионной работы', cbtOuter, True, True);
end;

procedure TSheetPretension.DrawLine(const ANoticeIndex: Integer);
var
  i, j, R1, R2: Integer;
begin
  if not IsLineExists(ANoticeIndex) then Exit;

  inherited DrawLine(ANoticeIndex);

  i:= ANoticeIndex;
  R1:= FSelRows1[i];
  R2:= FSelRows2[i];

  FWriter.SetFont(FFontName, FFontSize, [], clBlack);
  FWriter.SetAlignment(haCenter, vaCenter);

  SetBackground(ANoticeIndex, FSelectedColIndex=FMainColIndex);
  FWriter.WriteNumber(R1, 4, R2, 4, FMoneyValues[i]/100, cbtOuter, '#,##0.00');
  FWriter.WriteText(R1, 5, R2, 5, FUsers[i], cbtOuter, True, True);
  FWriter.WriteText(R1, 6, R2, 6, FNotices[i], cbtOuter, True, True);

  SetBackground(ANoticeIndex, FSelectedColIndex=1);
  FWriter.WriteText(R1, 7, R2, 7, FToBuilders[i], cbtOuter, True, True);
  SetBackground(ANoticeIndex, FSelectedColIndex=2);
  FWriter.WriteText(R1, 8, R2, 8, FFromBuilders[i], cbtOuter, True, True);
  SetBackground(ANoticeIndex, FSelectedColIndex=3);
  FWriter.WriteText(R1, 9, R2, 9, FToUsers[i], cbtOuter, True, True);

  SetBackground(ANoticeIndex, FSelectedColIndex=4);
  DrawDate(R1, 10, R2, 10, FSendDates[i]);
  DrawMoney(R1, 11, R2, 11, FSendValues[i]);
  DrawDate(R1, 12, R2, 12, FGetInvDates[i]);
  DrawDate(R1, 13, R2, 13, FGetDates[i]);
  DrawMoney(R1, 14, R2, 14, FGetValues[i]);

  SetBackground(ANoticeIndex, FSelectedColIndex=5);
  FWriter.SetAlignment(haLeft, vaCenter);
  FWriter.WriteText(R1, 15, R2, 15, FNotes[i], cbtOuter, True, True);

  FWriter.SetBackgroundClear;
  FWriter.SetAlignment(haCenter, vaCenter);
  FWriter.WriteText(R1, 16, R2, 16, FStatuses[i], cbtOuter);
  for j:= 0 to High(FMotors[i]) do
  begin
    R1:= FSelRows1[i] + j;
    DrawMileage(R1, 3, FMileages[i,j]);
  end;
end;

procedure TSheetPretension.Update(const AUsers, ANotices,
                           AToBuilders, AFromBuilders, AToUsers, ANotes, AStatuses: TStrVector;
                     const AMotors: TStrMatrix;
                     const AMoneyValues, ASendValues, AGetValues: TInt64Vector;
                     const ASendDates, AGetInvDates, AGetDates: TDateVector;
                     const AMileages: TIntMatrix);
begin
  inherited Update(AUsers, ANotices, AMotors);

  FMoneyValues:= AMoneyValues;
  FSendValues:= ASendValues;
  FGetValues:= AGetValues;
  FGetInvDates:= AGetInvDates;
  FSendDates:= ASendDates;
  FGetDates:= AGetDates;
  FNotes:= ANotes;
  FStatuses:= AStatuses;
  FToBuilders:= AToBuilders;
  FFromBuilders:= AFromBuilders;
  FToUsers:= AToUsers;
  FMileages:= AMileages;
end;

{ TSheetRepair }

function TSheetRepair.ColumnWidths: TIntVector;
var
  V1, V2: TIntVector;
begin
  V1:= inherited ColumnWidths;
  V2:= VCreateInt([
    {03} 80,   // пробег
    {04} USER_COLUMN_WIDTH,   // отправитель запроса (потребитель)
    {05} LETTER_COLUMN_WIDTH, // письмо от потребителя
    {06} LETTER_COLUMN_WIDTH, // письмо производителю
    {07} LETTER_COLUMN_WIDTH, // ответ от производителя
    {08} LETTER_COLUMN_WIDTH, // ответ потребителю
    {09} 80,                  // дата прибытия в ремонт
    {10} 80,                  // дата убытия в ремонт
    {11} NOTE_COLUMN_WIDTH,   // примечание
    {12} STATUS_COLUMN_WIDTH  // статус
  ]);
  Result:= VAdd(V1, V2);

  {indexes                0  1  2  3  4   5     }
  FSelCols1:= VCreateInt([4, 6, 7, 8, 9,  11, 1]);
  FSelCols2:= VCreateInt([5, 6, 7, 8, 10, 11, 2]);
  FMainCol1:= 4;
  FMainCol2:= 5;
  FMainColIndex:= 0;
  FFullSelectColIndexes:= VCreateInt([FMainColIndex]);
end;

procedure TSheetRepair.DrawHeader;
begin
  inherited DrawHeader;
  FWriter.WriteText(1,  3, 'Пробег локомотива, км', cbtOuter, True, True);
  FWriter.WriteText(1,  4, 'Потребитель', cbtOuter, True, True);
  FWriter.WriteText(1,  5, LETTER_NAMES[6], cbtOuter, True, True);
  FWriter.WriteText(1,  6, LETTER_NAMES[7], cbtOuter, True, True);
  FWriter.WriteText(1,  7, LETTER_NAMES[8], cbtOuter, True, True);
  FWriter.WriteText(1,  8, LETTER_NAMES[9], cbtOuter, True, True);
  FWriter.WriteText(1,  9, 'Дата прибытия в ремонт', cbtOuter, True, True);
  FWriter.WriteText(1, 10, 'Дата отправки из ремонта', cbtOuter, True, True);
  FWriter.WriteText(1, 11, 'Примечание по ходу ремонта', cbtOuter, True, True);
  FWriter.WriteText(1, 12, 'Статус ремонта', cbtOuter, True, True);
end;

procedure TSheetRepair.DrawLine(const ANoticeIndex: Integer);
var
  i, j, R1, R2: Integer;
begin
  if not IsLineExists(ANoticeIndex) then Exit;

  inherited DrawLine(ANoticeIndex);

  i:= ANoticeIndex;
  R1:= FSelRows1[i];
  R2:= FSelRows2[i];

  FWriter.SetFont(FFontName, FFontSize, [], clBlack);
  FWriter.SetAlignment(haCenter, vaCenter);

  SetBackground(ANoticeIndex, FSelectedColIndex=FMainColIndex);
  FWriter.WriteText(R1, 4, R2, 4, FUsers[i], cbtOuter, True, True);
  FWriter.WriteText(R1, 5, R2, 5, FNotices[i], cbtOuter, True, True);

  for j:= 0 to High(FMotors[i]) do
  begin
    R1:= FSelRows1[i] + j;
    FWriter.SetAlignment(haCenter, vaCenter);
    FWriter.SetBackgroundClear;
    DrawMileage(R1, 3, FMileages[i,j]);
    SetBackground(ANoticeIndex, (FSelectedColIndex=1) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 6, FToBuilders[i,j], cbtOuter, True, True);
    SetBackground(ANoticeIndex, (FSelectedColIndex=2) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 7, FFromBuilders[i,j], cbtOuter, True, True);
    SetBackground(ANoticeIndex, (FSelectedColIndex=3) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 8, FToUsers[i,j], cbtOuter, True, True);
    SetBackground(ANoticeIndex, (FSelectedColIndex=4) and (FSelectedMotorIndex=j));
    DrawDate(R1, 9, R1, 9, FBeginDates[i,j]);
    DrawDate(R1, 10, R1, 10, FEndDates[i,j]);
    FWriter.SetBackgroundClear;
    FWriter.WriteText(R1, 12, FStatuses[i,j], cbtOuter);
    FWriter.SetAlignment(haLeft, vaCenter);
    SetBackground(ANoticeIndex, (FSelectedColIndex=5) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 11, FNotes[i,j], cbtOuter, True, True);
  end;
end;

procedure TSheetRepair.Update(const AUsers, ANotices: TStrVector;
                     const AToBuilders, AFromBuilders, AToUsers,
                           ANotes, AStatuses, AMotors: TStrMatrix;
                     const ABeginDates, AEndDates: TDateMatrix;
                     const AMileages: TIntMatrix);
begin
  inherited Update(AUsers, ANotices, AMotors);

  FBeginDates:= ABeginDates;
  FEndDates:= AEndDates;
  FNotes:= ANotes;
  FStatuses:= AStatuses;
  FToBuilders:= AToBuilders;
  FFromBuilders:= AFromBuilders;
  FToUsers:= AToUsers;
  FMileages:= AMileages;
end;

{ TSheetReclamation }

function TSheetReclamation.ColumnWidths: TIntVector;
var
  V1, V2: TIntVector;
begin
  V1:= inherited ColumnWidths;
  V2:= VCreateInt([
    {03} 80,   // пробег
    {04} 140,  // депо
    {05} USER_COLUMN_WIDTH,   // отправитель уведомления (потребитель)
    {06} LETTER_COLUMN_WIDTH, // письмо от потребителя
    {07} LETTER_COLUMN_WIDTH, // письмо производителю
    {08} LETTER_COLUMN_WIDTH, // ответ от производителя
    {09} LETTER_COLUMN_WIDTH, // ответ потребителю
    {10} LETTER_COLUMN_WIDTH, // акт осмотра двигателя
    {11} LETTER_COLUMN_WIDTH, // отзыв рекламации потребителем
    {12} NOTE_COLUMN_WIDTH,   // примечание
    {13} STATUS_COLUMN_WIDTH  // статус
  ]);
  Result:= VAdd(V1, V2);

  {indexes                0  1  2  3  4  5   6   7       }
  FSelCols1:= VCreateInt([3, 4, 7, 8, 9, 10, 11, 12, 1]);
  FSelCols2:= VCreateInt([3, 6, 7, 8, 9, 10, 11, 12, 2]);
  FMainCol1:= 4;
  FMainCol2:= 6;
  FMainColIndex:= 1;
  FFullSelectColIndexes:= VCreateInt([FMainColIndex]);
end;

procedure TSheetReclamation.DrawHeader;
begin
  inherited DrawHeader;
  FWriter.WriteText(1,  3, 'Пробег локомотива, км', cbtOuter, True, True);
  FWriter.WriteText(1,  4, 'Предприятие', cbtOuter, True, True);
  FWriter.WriteText(1,  5, 'Потребитель', cbtOuter, True, True);
  FWriter.WriteText(1,  6, LETTER_NAMES[0], cbtOuter, True, True);
  FWriter.WriteText(1,  7, LETTER_NAMES[1], cbtOuter, True, True);
  FWriter.WriteText(1,  8, LETTER_NAMES[2], cbtOuter, True, True);
  FWriter.WriteText(1,  9, LETTER_NAMES[3], cbtOuter, True, True);
  FWriter.WriteText(1, 10, LETTER_NAMES[4], cbtOuter, True, True);
  FWriter.WriteText(1, 11, LETTER_NAMES[5], cbtOuter, True, True);
  FWriter.WriteText(1, 12, 'Примечание по ходу расследования', cbtOuter, True, True);
  FWriter.WriteText(1, 13, 'Статус рекламации', cbtOuter, True, True);
end;

procedure TSheetReclamation.DrawLine(const ANoticeIndex: Integer);
var
  i, j, R1, R2: Integer;
begin
  if not IsLineExists(ANoticeIndex) then Exit;

  inherited DrawLine(ANoticeIndex);

  i:= ANoticeIndex;
  R1:= FSelRows1[i];
  R2:= FSelRows2[i];

  FWriter.SetFont(FFontName, FFontSize, [], clBlack);
  FWriter.SetAlignment(haCenter, vaCenter);

  SetBackground(ANoticeIndex, FSelectedColIndex=FMainColIndex);
  FWriter.WriteText(R1, 4, R2, 4, FLocations[i], cbtOuter, True, True);
  FWriter.WriteText(R1, 5, R2, 5, FUsers[i], cbtOuter, True, True);
  FWriter.WriteText(R1, 6, R2, 6, FNotices[i], cbtOuter, True, True);

  for j:= 0 to High(FMotors[i]) do
  begin
    R1:= FSelRows1[i] + j;
    FWriter.SetAlignment(haCenter, vaCenter);
    SetBackground(ANoticeIndex, (FSelectedColIndex=0) and (FSelectedMotorIndex=j));
    DrawMileage(R1, 3, FMileages[i,j]);
    SetBackground(ANoticeIndex, (FSelectedColIndex=2) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 7, FToBuilders[i,j], cbtOuter, True, True);
    SetBackground(ANoticeIndex, (FSelectedColIndex=3) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 8, FFromBuilders[i,j], cbtOuter, True, True);
    SetBackground(ANoticeIndex, (FSelectedColIndex=4) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 9, FToUsers[i,j], cbtOuter, True, True);
    SetBackground(ANoticeIndex, (FSelectedColIndex=5) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 10, FReports[i,j], cbtOuter, True, True);
    SetBackground(ANoticeIndex, (FSelectedColIndex=6) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 11, FCancels[i,j], cbtOuter, True, True);
    FWriter.SetBackgroundClear;
    FWriter.WriteText(R1, 13, FStatuses[i,j], cbtOuter);
    FWriter.SetAlignment(haLeft, vaCenter);
    SetBackground(ANoticeIndex, (FSelectedColIndex=7) and (FSelectedMotorIndex=j));
    FWriter.WriteText(R1, 12, FNotes[i,j], cbtOuter, True, True);
  end;
end;

procedure TSheetReclamation.Update(const ALocations, AUsers, ANotices: TStrVector;
                     const AToBuilders, AFromBuilders, AToUsers,
                           ANotes, AStatuses, AMotors, AReports, ACancels: TStrMatrix;
                     const AMileages: TIntMatrix);
begin
  inherited Update(AUsers, ANotices, AMotors);

  FLocations:= ALocations;
  FMileages:= AMileages;
  FReports:= AReports;
  FCancels:= ACancels;
  FNotes:= ANotes;
  FStatuses:= AStatuses;
  FToBuilders:= AToBuilders;
  FFromBuilders:= AFromBuilders;
  FToUsers:= AToUsers;
end;

{ TSheetCustom }

procedure TSheetCustom.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  R,C: Integer;
begin
  if Button=mbLeft then
  begin
    (Sender as TsWorksheetGrid).MouseToCell(X,Y,C,R);
    SelectCell(R, C);
  end
  else if Button=mbRight then
    Unselect;
end;

function TSheetCustom.GetIsSelected: Boolean;
begin
  Result:= (FSelectedMotorIndex>=0) and
           (FSelectedNoticeIndex>=0) and
           (FSelectedColIndex>=0);
end;

procedure TSheetCustom.SelectedIndexesClear;
begin
  FSelectedMotorIndex:= -1;
  FSelectedNoticeIndex:= -1;
  FSelectedColIndex:= -1;
end;

procedure TSheetCustom.Unselect;
var
  i: Integer;
begin
  i:= FSelectedNoticeIndex;
  SelectedIndexesClear;
  if i>=0 then
    DrawLine(i);
  if Assigned(FOnSelect) then FOnSelect;
end;

procedure TSheetCustom.Save(const ADoneMessage: String);
var
  Exporter: TGridExporter;
  i,j,k: Integer;
begin
  if IsSelected then
  begin
    k:= FSelectedColIndex;
    i:= FSelectedNoticeIndex;
    j:= FSelectedMotorIndex;
    Unselect;
  end;

  Exporter:= TGridExporter.Create(FWriter.Grid);
  try
    Exporter.PageSettings(spoLandscape);
    Exporter.Save(ADoneMessage);
  finally
    FreeAndNil(Exporter);
  end;
  Select(i,j,k);
end;

procedure TSheetCustom.Select(const ANoticeIndex, AMotorIndex, AColIndex: Integer);
var
  n: Integer;
begin
  if (ANoticeIndex<0) or (AMotorIndex<0) or (AColIndex<0) then Exit;

  if (ANoticeIndex>High(FNotices)) or (AMotorIndex>High(FMotors[ANoticeIndex])) then Exit;

  FSelectedNoticeIndex:= ANoticeIndex;
  FSelectedMotorIndex:=  AMotorIndex;
  FSelectedColIndex:= AColIndex;

  if FWriter.HasGrid then
  begin
    n:= FSelRows1[FSelectedNoticeIndex] + FSelectedMotorIndex;
    if n<FWriter.Grid.RowCount then
      FWriter.Grid.Row:= n;
  end;
  DrawLine(FSelectedNoticeIndex);

  if Assigned(FOnSelect) then FOnSelect;
end;

procedure TSheetCustom.SelectCell(ARow, ACol: Integer);
var
  NewSelectedColIndex: Integer;
  NewSelectedNoticeIndex: Integer;
  NewSelectedMotorIndex: Integer;
  NeedChangeSelection: Boolean;
begin
  NewSelectedColIndex:= VIndexOf(FSelCols1, FSelCols2, ACol);
  if NewSelectedColIndex<0 then Exit;
  NewSelectedNoticeIndex:= VIndexOf(FSelRows1, FSelRows2, ARow);
  if NewSelectedNoticeIndex<0 then Exit;

  NewSelectedMotorIndex:= ARow - FSelRows1[NewSelectedNoticeIndex];

  NeedChangeSelection:= (NewSelectedColIndex<>FSelectedColIndex) or
                        (NewSelectedNoticeIndex<>FSelectedNoticeIndex);
  if not ((ACol>=FMainCol1) and (ACol<=FMainCol2)) then
    NeedChangeSelection:= NeedChangeSelection or (NewSelectedMotorIndex<>FSelectedMotorIndex);

  if not NeedChangeSelection then Exit;

  Unselect;
  Select(NewSelectedNoticeIndex, NewSelectedMotorIndex, NewSelectedColIndex);
end;

procedure TSheetCustom.SetBackground(const ANoticeIndex: Integer; const AIsSelected: Boolean);
begin
  if (ANoticeIndex=FSelectedNoticeIndex) and AIsSelected then
    FWriter.SetBackground(DefaultSelectionBGColor)
  else
    FWriter.SetBackgroundClear;
end;

function TSheetCustom.ColumnWidths: TIntVector;
begin
  Result:= VCreateInt([
    {01} 50,  // № п/п
    {02} 250  // Электродвигатель
  ]);
  FMainCol1:= 0;
  FMainCol2:= 0;
  FMainColIndex:= -1;
  FFullSelectColIndexes:= nil;
  FSelCols1:= nil;
  FSelCols2:= nil;
  SelectedIndexesClear;
end;

procedure TSheetCustom.DrawHeader;
begin
  FWriter.SetBackgroundClear;
  FWriter.SetFont(FFontName, FFontSize, [fsBold], clBlack);
  FWriter.SetAlignment(haCenter, vaCenter);
  FWriter.WriteText(1, 1, '№ п/п', cbtOuter, True, True);
  FWriter.WriteText(1, 2, 'Электродвигатель', cbtOuter, True, True);
end;

function TSheetCustom.IsLineExists(const ANoticeIndex: Integer): Boolean;
begin
  Result:= (not MIsNil(FMotors)) and (not VIsNil(FMotors[ANoticeIndex]));
end;

procedure TSheetCustom.DrawLine(const ANoticeIndex: Integer);
var
  i, j, R: Integer;
begin
  if not IsLineExists(ANoticeIndex) then Exit;
  i:= ANoticeIndex;
  for j:= 0 to High(FMotors[i]) do
  begin
    if VIsNil(FMotors[i]) then continue;
    R:= FSelRows1[ANoticeIndex] + j;
    FWriter.SetFont(FFontName, FFontSize, [], clBlack);
    SetBackground(ANoticeIndex, IsFullSelectColIndex(FSelectedColIndex) or (FSelectedMotorIndex=j));
    FWriter.SetAlignment(haCenter, vaCenter);
    FWriter.WriteNumber(R, 1, R-HEADER_ROWS_COUNT, cbtOuter);
    SetBackground(ANoticeIndex, IsFullSelectColIndex(FSelectedColIndex) or (FSelectedMotorIndex=j));
    FWriter.SetAlignment(haLeft, vaCenter);
    FWriter.WriteText(R, 2, FMotors[i,j], cbtOuter, True, True);
  end;
end;

procedure TSheetCustom.DrawMileage(const ARow, ACol, AMileage: Integer);
begin
  if AMileage>=0 then
    FWriter.WriteNumber(ARow, ACol, AMileage, cbtOuter, '#,##0')
  else
    FWriter.WriteText(ARow, ACol, EmptyStr, cbtOuter);
end;

procedure TSheetCustom.DrawDate(const ARow1, ACol1, ARow2, ACol2: Integer; const ADate: TDate);
begin
  if ADate>0 then
    FWriter.WriteDate(ARow1, ACol1, ARow2, ACol2, ADate, cbtOuter)
  else
    FWriter.WriteText(ARow1, ACol1, ARow2, ACol2, EmptyStr, cbtOuter);
end;

procedure TSheetCustom.DrawMoney(const ARow1, ACol1, ARow2, ACol2: Integer; const AMoney: Int64);
begin
  if AMoney>0 then
    FWriter.WriteNumber(ARow1, ACol1, ARow2, ACol2, AMoney/100, cbtOuter, '#,##0.00')
  else
    FWriter.WriteText(ARow1, ACol1, ARow2, ACol2, EmptyStr, cbtOuter);
end;

constructor TSheetCustom.Create(const AWorksheet: TsWorksheet; const AGrid: TsWorksheetGrid = nil);
begin
  FFontName:= FontLikeToName(FONT_LIKE_DEFAULT);
  FFontSize:= FONT_SIZE_DEFAULT;
  FWriter:= TSheetWriter.Create(ColumnWidths, AWorksheet, AGrid);
  FZoomPercents:= 100;
  if FWriter.HasGrid then
    FWriter.Grid.OnMouseDown:= @MouseDown;
end;

destructor TSheetCustom.Destroy;
begin
  if Assigned(FWriter) then FreeAndNil(FWriter);
  inherited Destroy;
end;

procedure TSheetCustom.Update(const AUsers, ANotices: TStrVector;  const AMotors: TStrMatrix);
var
  i: Integer;
begin
  FUsers:= AUsers;
  FNotices:= ANotices;
  FMotors:= AMotors;

  if VIsNil(AUsers) then Exit;

  VDim(FSelRows1, Length(FUsers));
  VDim(FSelRows2, Length(FUsers));
  FSelRows1[0]:= HEADER_ROWS_COUNT + 1;
  FSelRows2[0]:= FSelRows1[0] + High(AMotors[0]);
  for i:= 1 to High(FUsers) do
  begin
    FSelRows1[i]:= FSelRows2[i-1] + 1;
    FSelRows2[i]:= FSelRows1[i] + High(AMotors[i]);
  end;
end;

procedure TSheetCustom.Draw;
var
  i, R: Integer;
begin
  FWriter.Clear;
  if FWriter.HasGrid then
  begin
    FWriter.Grid.Clear;
    FWriter.Grid.Visible:= False;
  end;

  try
    FWriter.SetZoom(FZoomPercents);
    FWriter.BeginEdit;
    DrawHeader;
    if not VIsNil(FUsers) then
    begin
      for i:= 0 to High(FUsers) do
        DrawLine(i);
      FWriter.SetBackgroundClear;
      R:= VLast(FSelRows2) + 1;
      for i:= 1 to FWriter.ColCount do
        FWriter.WriteText(R, i, EmptyStr, cbtTop);
      FWriter.SetFrozenRows(HEADER_ROWS_COUNT);
    end;

    FWriter.EndEdit;
  finally
    if FWriter.HasGrid then
      FWriter.Grid.Visible:= True;
  end;
end;

function TSheetCustom.IsFullSelectColIndex(const AColIndex: Integer): Boolean;
begin
  Result:= VIndexOf(FFullSelectColIndexes, AColIndex)>=0;
end;

end.

