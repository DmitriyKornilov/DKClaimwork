unit ULetters;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpPDF, DateUtils, fpImage,

  DK_PDF, DK_Vector, DK_StrUtils, DK_DateUtils;

const
  LETTER_HEADER_FONT_NAME = 'SerifR';
  LETTER_HEADER_FONT_SIZE = 12;
  LETTER_HEADER_INTERVAL  = 0.8;

  PROXY_HEADER_FONT_NAME = 'SansR';
  PROXY_HEADER_FONT_SIZE = 12;
  PROXY_HEADER_INTERVAL  = 0.8;

  DESTINATION_FONT_NAME    = 'SansR';
  DESTINATION_FONT_SIZE    = 12;
  DESTINATION_INTERVAL     = 1.0;
  DESTINATION_BEFORE_SPACE = 5.0;

  APPEAL_FONT_NAME    = 'SansBI';
  APPEAL_FONT_SIZE    = 12;
  APPEAL_INTERVAL     = 1.0;
  APPEAL_BEFORE_SPACE = 5.0;

  PROXY_INFO_FONT_NAME    = 'SansB';
  PROXY_INFO_FONT_SIZE    = 12;
  PROXY_INFO_INTERVAL     = 1.0;
  PROXY_INFO_BEFORE_SPACE = 15.0;

  BODY_FONT_NAME    = 'SansR';
  BODY_FONT_SIZE    = 12;
  BODY_INTERVAL     = 1.5;
  BODY_INDENT       = 12.5;
  BODY_BEFORE_SPACE = 5.0;

  SIGNATURE_FONT_NAME = 'SansR';
  SIGNATURE_FONT_SIZE = 12;
  SIGNATURE_INTERVAL  =  1.0;
  SIGNATURE_INDENT    =  0.0;
  SIGNATURE_AFTER_SPACE  = 5.0;

  STAMP_IMAGE_WIDTH      = 40.0;
  SIGNATURE_IMAGE_WIDTH  = 30.0;

  PERFORMER_FONT_NAME    = 'SansR';
  PERFORMER_FONT_SIZE    = 10;
  PERFORMER_INTERVAL     = 0.7;
  PERFORMER_BEFORE_SPACE = 5.0;

  FOOTER_FONT_NAME    = 'SerifR';
  FOOTER_FONT_SIZE    = 10;
  FOOTER_INTERVAL     = 1.0;
  FOOTER_INDENT       = 5.0;
  FOOTER_BEFORE_SPACE = 5.0;
  FOOTER_HEIGHT       = 15; // image height=width

  STRING_VECTOR_DELIMITER = '&&&';

  FONT_FOLDER_NAME  = 'fonts';

  LETTER_LEFT_MARGIN   = 30.0;
  LETTER_RIGHT_MARGIN  = 15.0;
  LETTER_TOP_MARGIN    = 10.0;
  LETTER_BOTTOM_MARGIN = 10.0;

  PROXY_LEFT_MARGIN   = 22.5;
  PROXY_RIGHT_MARGIN  = 17.5;
  PROXY_TOP_MARGIN    = 10.0;
  PROXY_BOTTOM_MARGIN = 10.0;

type
  TPDFFloat = type fpPDF.TPDFFloat;

  { TBlank }

  TBlank = class (TPDFLetter)
  protected const
    BLANK_MAIL = 'info@ejdm.ru';
    BLANK_TEXT: array of String = (
      'ООО «Электрожелдормаш»',
      '125124, г. Москва, ул. 3-я Ямского Поля,',
      'д. 28, офис 319',
      'ИНН 7722719703 КПП 771401001'
    );
  public
    constructor Create;
    procedure WriteHeaderCustom(const AFontName: String;
                          const AFontSize: Integer;
                          const AInterval: TPDFFloat;
                          const AStream: TMemoryStream;
                          const AExtension: String);
    procedure WriteSign(const AText: TStrVector;
                             const AName: String;
                             const ASignImage: TMemoryStream = nil;
                             const ASignFileExtension: String = '';
                             const AStampImage: TMemoryStream = nil;
                             const AStampFileExtension: String = '');

  end;

  { TLetter }

  TLetter = class (TBlank)
  protected
    FNeedFooter: Boolean;
    FNeedPerformer: Boolean;
    function FooterHeight: TPDFFloat;
    function PerformerHeight: TPDFFloat;
    function BusyBottomSpace: TPDFFloat; override;
  public
    constructor Create;
    procedure WriteHeader(const AStream: TMemoryStream; const AExtension: String);
    procedure WriteInfo(const ANumber: String = ''; const ADate: String = '');
    procedure WriteDestination(const AText: TStrVector);
    procedure WriteAppeal(const AText: String);
    procedure WriteBody(const AText: TStrVector; const AFirstIndents: TDblVector = nil); // AFirstIndents: -1 = BODY_INDENT, >=0 = значение
    procedure WritePerformer(const AName, APhone, AMail: String);
    procedure WriteFooter(const AStream: TMemoryStream; const AExtension: String);

    property NeedFooter: Boolean read FNeedFooter write FNeedFooter;
    property NeedPerformer: Boolean read FNeedPerformer write FNeedPerformer;
  end;

  procedure LetterCreate(const AFileName: String;
                         const ALetterNum, ALetterDate: String;
                         const AReceiverPost, AReceiverName, AReceiverAppeal: String;
                         const ABody: TStrVector;
                         const ASenderPost, ASenderName: String;
                         const ASignImage: TMemoryStream;
                         const ASignFileExtension: String;
                         const ANeedStamp: Boolean;
                         const APerformerName, APerformerPhone, APerformerMail: String);


type

  //доверенность

  { TProxy }

  TProxy = class (TBlank)
  public
    constructor Create;
    procedure WriteHeader(const AStream: TMemoryStream; const AExtension: String);
    procedure WriteInfo(const AProxyNumber: String; const AProxyDate: TDate);  //дов-ть № ... от ...
    procedure WriteBody(const AIsSeveralMotors: Boolean;
                        const ADelegateNameR, ADelegatePassport: String;
                        const AMotorsName, APlaceName: String;
                        const ABeginDate, AEndDate: TDate);
  end;



  procedure ProxyCreate(const AFileName, AProxyNumber: String;
                      const ABeginDate, AEndDate: TDate;
                      const AIsSeveralMotors: Boolean;
                      const ADelegateNameR, ADelegatePassport: String;
                      const AMotorsName, APlaceName: String);

implementation

uses USQLite;

procedure LetterCreate(const AFileName: String;
                       const ALetterNum, ALetterDate: String;
                       const AReceiverPost, AReceiverName, AReceiverAppeal: String;
                       const ABody: TStrVector;
                       const ASenderPost, ASenderName: String;
                       const ASignImage: TMemoryStream;
                       const ASignFileExtension: String;
                       const ANeedStamp: Boolean;
                       const APerformerName, APerformerPhone, APerformerMail: String);
var
  Letter: TLetter;
  V: TStrVector;
  Stream: TMemoryStream;
  Ext: String;
begin
  Letter:= TLetter.Create;
  try
    Letter.NeedFooter:= True;
    Letter.NeedPerformer:= (not SEmpty(APerformerName)) and (not SEmpty(APerformerPhone)) and (not SEmpty(APerformerMail));

    Stream:= TMemoryStream.Create;
    try
      SQLite.ImageLoad(2, Ext, Stream);
      Letter.WriteHeader(Stream, Ext);
    finally
      FreeAndNil(Stream);
    end;

    Letter.WriteInfo(ALetterNum, ALetterDate);

    V:= VStrToVector(AReceiverPost, STRING_VECTOR_DELIMITER);
    VAppend(V, AReceiverName);
    Letter.WriteDestination(V);

    Letter.WriteAppeal(AReceiverAppeal);
    Letter.WriteBody(ABody);

    V:= VStrToVector(ASenderPost, STRING_VECTOR_DELIMITER);
    V:= VAdd(VCreateStr(['С уважением,']), V);


    if ANeedStamp then
    begin
      Stream:= TMemoryStream.Create;
      try
        SQLite.ImageLoad(1, Ext, Stream);
        Letter.WriteSign(V, ASenderName, ASignImage, ASignFileExtension, Stream, Ext);
      finally
        FreeAndNil(Stream);
      end;
    end
    else
      Letter.WriteSign(V, ASenderName, ASignImage, ASignFileExtension, nil, EmptyStr);


    Letter.WritePerformer(APerformerName, APerformerPhone, APerformerMail);

    Stream:= TMemoryStream.Create;
    try
      SQLite.ImageLoad(3, Ext, Stream);
      Letter.WriteFooter(Stream, Ext);
    finally
      FreeAndNil(Stream);
    end;
    Letter.SaveToFile(AFileName);
  finally
    FreeAndNil(Letter);
    FreeAndNil(Stream);
  end;
end;

procedure ProxyCreate(const AFileName, AProxyNumber: String;
                      const ABeginDate, AEndDate: TDate;
                      const AIsSeveralMotors: Boolean;
                      const ADelegateNameR, ADelegatePassport: String;
                      const AMotorsName, APlaceName: String);
var
  Proxy: TProxy;
  V: TStrVector;
  Stream, SignStream: TMemoryStream;
  Ext, SignExt: String;
  SenderName, SenderPost: String;
begin
  Proxy:= TProxy.Create;
  Stream:= TMemoryStream.Create;
  try
    SQLite.ImageLoad(2, Ext, Stream);
    Proxy.WriteHeader(Stream, Ext);

    Proxy.WriteInfo(AProxyNumber, ABeginDate);
    Proxy.WriteBody(AIsSeveralMotors, ADelegateNameR, ADelegatePassport,
                    AMotorsName, APlaceName, ABeginDate, AEndDate);

    SQLite.SenderLoad(2, SenderName, SenderPost);
    V:= VStrToVector(SenderPost, STRING_VECTOR_DELIMITER);
    SQLite.ImageLoad(1, Ext, Stream);
    SignStream:= TMemoryStream.Create;
    try
      SQLite.SenderSignLoad(2, SignExt, SignStream);
      Proxy.WriteSign(V, SenderName, SignStream, SignExt, Stream, Ext);
    finally
      FreeAndNil(SignStream);
    end;

    Proxy.SaveToFile(AFileName);
  finally
    FreeAndNil(Proxy);
    FreeAndNil(Stream);
  end;
end;

{ TProxy }

constructor TProxy.Create;
begin
  inherited Create;
  AddPage(PROXY_LEFT_MARGIN, PROXY_RIGHT_MARGIN, PROXY_TOP_MARGIN, PROXY_BOTTOM_MARGIN);
end;

procedure TProxy.WriteHeader(const AStream: TMemoryStream; const AExtension: String);
begin
  WriteHeaderCustom(PROXY_HEADER_FONT_NAME,
                    PROXY_HEADER_FONT_SIZE,
                    PROXY_HEADER_INTERVAL,
                    AStream, AExtension);
end;

procedure TProxy.WriteInfo(const AProxyNumber: String; const AProxyDate: TDate);
var
  S: String;
begin
  WriteSpace(PROXY_INFO_BEFORE_SPACE);
  SetFont(PROXY_INFO_FONT_NAME, PROXY_INFO_FONT_SIZE);
  SetFontColor(clBlack);
  S:= 'ДОВЕРЕННОСТЬ № ' + AProxyNumber + ' от ';
  S:= S + FormatDateTime('dd.mm.yyyy', AProxyDate);
  WriteTextRow(S, saCenter, PROXY_INFO_INTERVAL);
end;

procedure TProxy.WriteBody(const AIsSeveralMotors: Boolean;
                           const ADelegateNameR, ADelegatePassport: String;
                           const AMotorsName, APlaceName: String;
                           const ABeginDate, AEndDate: TDate);
var
  S: String;
begin
  WriteSpace(BODY_BEFORE_SPACE);
  SetFont(BODY_FONT_NAME, BODY_FONT_SIZE);
  SetFontColor(clBlack);

  S:= 'Общество с ограниченной ответственностью «Электрожелдормаш» ' +
      'в лице Генерального директора Виера Фуэнтеса Мигеля Анхела, ' +
      'действующего на основании Устава, ' +
      'настоящей доверенностью уполномочивает гражданина ' + ADelegateNameR +
      ' (паспорт: ' + ADelegatePassport +
      ') быть представителем ООО «Электрожелдормаш» при разборе ';
  if AIsSeveralMotors then
    S:= S + 'случаев '
  else
    S:= S + 'случая ';
  S:= S + 'выхода из строя ';
  if AIsSeveralMotors then
    S:= S + 'электродвигателей '
  else
    S:= S + 'электродвигателя ';
 S:=  S + AMotorsName + ' в ' + APlaceName +
      ' с правом подписи документов в рамках рекламационной работы.';

 WriteTextParagraph(S, saFit, BODY_INTERVAL, BODY_INDENT);

 WriteSpace(2*FontHeight);
 S:= 'Доверенность выдана ' + DateToStrGenitive(ABeginDate, True) + ' ' +
     'и действительна до '  + DateToStrGenitive(AEndDate, True)   +'.';
 WriteTextParagraph(S, saFit, BODY_INTERVAL, 0);

 WriteSpace(2*FontHeight);
 S:= 'Подпись доверенного лица _______________________ заверяю.';
 WriteTextParagraph(S, saLeft, BODY_INTERVAL, 0);

 WriteSpace(FontHeight);
end;

{ TBlank }


constructor TBlank.Create;
begin
  inherited Create(FONT_FOLDER_NAME);
  AddFont('LiberationSerif-Regular.ttf', 'Liberation Serif', 'SerifR', False, False);
  AddFont('LiberationSans-Regular.ttf', 'Liberation Sans', 'SansR', False, False);
  AddFont('LiberationSans-Bold.ttf', 'Liberation Sans', 'SansB', True, False);
  AddFont('LiberationSans-BoldItalic.ttf', 'Liberation Sans', 'SansBI', True, True);
end;

procedure TBlank.WriteHeaderCustom(const AFontName: String;
                             const AFontSize: Integer;
                             const AInterval: TPDFFloat;
                             const AStream: TMemoryStream;
                             const AExtension: String);
begin
  WriteImageFitWidth(AStream, AExtension, PageX1, PageX2);
  SetFont(AFontName, AFontSize);
  SetFontColor(clBlack);
  WriteTextRows(BLANK_TEXT, saLeft, AInterval);
  WriteHyperlink(BLANK_MAIL, 'mailto:' + BLANK_MAIL, saLeft, AInterval);
end;

procedure TBlank.WriteSign(const AText: TStrVector;
                             const AName: String;
                             const ASignImage: TMemoryStream = nil;
                             const ASignFileExtension: String = '';
                             const AStampImage: TMemoryStream = nil;
                             const AStampFileExtension: String = '');
begin
  SetFont(SIGNATURE_FONT_NAME, SIGNATURE_FONT_SIZE);
  WriteSignature(AText, AName,
                 SIGNATURE_INTERVAL, SIGNATURE_INDENT, SIGNATURE_AFTER_SPACE,
                 ASignImage, ASignFileExtension, SIGNATURE_IMAGE_WIDTH,
                 AStampImage, AStampFileExtension, STAMP_IMAGE_WIDTH);
end;

{ TLetter }

constructor TLetter.Create;
begin
  inherited Create;
  AddPage(LETTER_LEFT_MARGIN, LETTER_RIGHT_MARGIN, LETTER_TOP_MARGIN, LETTER_BOTTOM_MARGIN);
  FNeedFooter:= True;
  FNeedPerformer:= True;
end;

procedure TLetter.WriteHeader(const AStream: TMemoryStream; const AExtension: String);
begin
  WriteHeaderCustom(LETTER_HEADER_FONT_NAME,
                    LETTER_HEADER_FONT_SIZE,
                    LETTER_HEADER_INTERVAL,
                    AStream, AExtension);
end;

procedure TLetter.WriteInfo(const ANumber: String = ''; const ADate: String = '');
var
  S: String;
begin
  S:= EmptyStr;
  if (not SEmpty(ADate)) then
  begin
    if SEmpty(ANumber) then
      S:= 'Исх. № б/н от ' + ADate
    else
      S:= 'Исх. № ' + ANumber + ' от ' + ADate ;
  end;
  if not SEmpty(S) then
    WriteTextRow(S, saLeft, LETTER_HEADER_INTERVAL);
end;

procedure TLetter.WriteDestination(const AText: TStrVector);
begin
  WriteSpace(DESTINATION_BEFORE_SPACE);
  SetFont(DESTINATION_FONT_NAME, DESTINATION_FONT_SIZE);
  SetFontColor(clBlack);
  WriteTextRows(AText, saRight, DESTINATION_INTERVAL);
end;

procedure TLetter.WriteAppeal(const AText: String);
begin
  WriteSpace(APPEAL_BEFORE_SPACE);
  SetFont(APPEAL_FONT_NAME, APPEAL_FONT_SIZE);
  SetFontColor(clBlack);
  WriteTextRow(AText, saCenter, APPEAL_INTERVAL);
end;

procedure TLetter.WriteBody(const AText: TStrVector; const AFirstIndents: TDblVector = nil);
var
  i: Integer;
  Indent: TPDFFloat;
begin
  WriteSpace(BODY_BEFORE_SPACE);
  SetFont(BODY_FONT_NAME, BODY_FONT_SIZE);
  SetFontColor(clBlack);
  if VIsNil(AFirstIndents) then
    for i:= 0 to High(AText) do
      WriteTextParagraph(AText[i], saFit, BODY_INTERVAL, BODY_INDENT)
  else begin
    if AFirstIndents[i]>=0 then
      Indent:= AFirstIndents[i]
    else
      Indent:= BODY_INDENT;
    WriteTextParagraph(AText[i], saFit, BODY_INTERVAL, Indent);
  end;
end;

function TLetter.PerformerHeight: TPDFFloat;
var
  Index, Size: Integer;
begin
  Result:= 0;
  if not NeedPerformer then Exit;
  Index:= FontIndex;
  Size:= FontSize;
  SetFont(PERFORMER_FONT_NAME, PERFORMER_FONT_SIZE);
  Result:= PERFORMER_BEFORE_SPACE + 3*FontHeight*(1+PERFORMER_INTERVAL);
  SetFont(Index, Size);
end;

function TLetter.BusyBottomSpace: TPDFFloat;
begin
  Result:= PerformerHeight + FooterHeight;
end;

procedure TLetter.WritePerformer(const AName, APhone, AMail: String);
var
  S: String;
  X, Y, H, W: TPDFFloat;
const
  MIDDLE_INDENT = 2.0; // отступ для выравнивания значений
begin
  if not NeedPerformer then Exit;
  SetFont(PERFORMER_FONT_NAME, PERFORMER_FONT_SIZE);
  H:= FontHeight * (1 + PERFORMER_INTERVAL);

  X:= PageX1;
  Y:= PageY2 - FooterHeight + H - FOOTER_BEFORE_SPACE;
  S:= 'E-mail:';
  WriteString(X, PageX2, Y, S, saLeft);
  W:= FontWidth(S) + MIDDLE_INDENT;
  S:= AMail;
  WriteURL(X+W, PageX2, Y, S, 'mailto:'+S, saLeft);

  Y:= Y - H;
  S:= 'Тел.:';
  WriteString(X, PageX2, Y, S, saLeft);
  S:= APhone;
  WriteString(X+W, PageX2, Y, S, saLeft);

  Y:= Y - H;
  S:= 'Исп.:';
  WriteString(X, PageX2, Y, S, saLeft);
  S:= AName;
  WriteString(X+W, PageX2, Y, S, saLeft);
end;

function TLetter.FooterHeight: TPDFFloat;
begin
  Result:= 0;
  if not NeedFooter then Exit;
  Result:= FOOTER_HEIGHT + FOOTER_BEFORE_SPACE;
end;

procedure TLetter.WriteFooter(const AStream: TMemoryStream; const AExtension: String);
var
  S: String;
  W, H, X, Y: TPDFFloat;
begin
  if not NeedFooter then Exit;
  SetFont(FOOTER_FONT_NAME, FOOTER_FONT_SIZE);
  X:= PageX1;
  Y:= PageY2;
  W:= FOOTER_HEIGHT; // height=width
  WriteImageBottomLeftFitWidth(AStream, AExtension, X, Y, W, H);
  X:= X + W + FOOTER_INDENT;
  Y:= Y - H/2 - FontHeight/2;
  S:= 'Система менеджмента предприятия сертифицирована на соответствие требованиям:';
  WriteString(X, PageX2, Y, S, saLeft);
  Y:= Y + FontHeight * (1 + FOOTER_INTERVAL);
  S:= 'ГОСТ Р ИСО 9001-2015 (ISO 9001-2015)';
  WriteString(X, PageX2, Y, S, saLeft);
end;



end.

