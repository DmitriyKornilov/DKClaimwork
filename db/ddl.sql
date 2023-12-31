PRAGMA ENCODING     = "UTF-8";
PRAGMA FOREIGN_KEYS = ON;

/* Список представителей производителя */
CREATE TABLE IF NOT EXISTS BUILDERDELEGATES (
    DelegateID       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    DelegateNameI    TEXT    NOT NULL,
    DelegateNameR    TEXT    NOT NULL,
    DelegatePhone    TEXT    NOT NULL,
    DelegatePassport TEXT    NOT NULL
);

/* Список производителей двигателей */
CREATE TABLE IF NOT EXISTS BUILDERS (
    BuilderID    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BuilderName  TEXT    NOT NULL,
    BuilderTitle TEXT    NOT NULL
);
INSERT OR IGNORE INTO  BUILDERS (BuilderID, BuilderName, BuilderTitle) VALUES (0, '<?>', '<?>');

/* Список адресатов у производителя */
CREATE TABLE IF NOT EXISTS BUILDERRECEIVERS (
    ReceiverID     INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BuilderID      INTEGER NOT NULL DEFAULT 0,
    ReceiverName   TEXT    NOT NULL,
    ReceiverPost   TEXT    NOT NULL,
    ReceiverAppeal TEXT    NOT NULL,
    CONSTRAINT FK_BUILDERRECEIVERS_BUILDERID FOREIGN KEY (BuilderID) REFERENCES BUILDERS(BuilderID) ON UPDATE CASCADE ON DELETE SET DEFAULT
);

/* Список представителей поставщика */
CREATE TABLE IF NOT EXISTS EJDMDELEGATES (
    DelegateID       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    DelegateNameI    TEXT    NOT NULL,
    DelegateNameR    TEXT    NOT NULL,
    DelegatePhone    TEXT    NOT NULL,
    DelegatePassport TEXT    NOT NULL
);

/* Изображения, используемые в бланках писем */
CREATE TABLE IF NOT EXISTS EJDMIMAGES (
    ImageID    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ImageName  TEXT    NOT NULL,
    ImageExt   TEXT   ,
    ImageValue BLOB   
);
INSERT OR IGNORE INTO  EJDMIMAGES (ImageID, ImageName) VALUES (1, 'Печать');
INSERT OR IGNORE INTO  EJDMIMAGES (ImageID, ImageName) VALUES (2, 'Верхний колонтитул');
INSERT OR IGNORE INTO  EJDMIMAGES (ImageID, ImageName) VALUES (3, 'Нижний колонтитул');

/* Список исполнителей для писем */
CREATE TABLE IF NOT EXISTS EJDMPERFORMERS (
    PerformerID    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    PerformerName  TEXT    NOT NULL,
    PerformerPhone TEXT    NOT NULL,
    PerformerMail  TEXT    NOT NULL
);

/* Список отправителей писем */
CREATE TABLE IF NOT EXISTS EJDMSENDERS (
    SenderID   INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    SenderName TEXT    NOT NULL,
    SenderPost TEXT    NOT NULL,
    SenderExt  TEXT   ,
    SenderSign BLOB   
);

/* Предприятия (депо), где обнаружен дефект двигателя */
CREATE TABLE IF NOT EXISTS LOCATIONS (
    LocationID    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    LocationName  TEXT    NOT NULL,
    LocationTitle TEXT    NOT NULL
);
INSERT OR IGNORE INTO  LOCATIONS (LocationID, LocationName, LocationTitle) VALUES (0, '<?>', '<?>');

/* Наименования двигателей */
CREATE TABLE IF NOT EXISTS MOTORNAMES (
    MotorNameID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    MotorName   TEXT    NOT NULL
);
INSERT OR IGNORE INTO  MOTORNAMES (MotorNameID, MotorName) VALUES (0, '<?>');

/* Список электродвигателей */
CREATE TABLE IF NOT EXISTS MOTORS (
    MotorID     INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    MotorNameID INTEGER  NOT NULL DEFAULT 0,
    MotorNum    TEXT     NOT NULL,
    MotorDate   DATETIME NOT NULL,
    CONSTRAINT FK_MOTORS_MOTORNAMEID FOREIGN KEY (MotorNameID) REFERENCES MOTORNAMES(MotorNameID) ON UPDATE CASCADE ON DELETE SET DEFAULT
);

/* Список потребителей продукции */
CREATE TABLE IF NOT EXISTS USERS (
    UserID    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    UserNameI TEXT    NOT NULL,
    UserNameR TEXT    NOT NULL,
    UserTitle TEXT    NOT NULL
);
INSERT OR IGNORE INTO  USERS (UserID, UserNameI, UserNameR, UserTitle) VALUES (0, '<?>', '<?>', '<?>');

CREATE TABLE IF NOT EXISTS PRETENSIONS (
    PretensionID          INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    UserID                INTEGER  NOT NULL DEFAULT 0,
    NoticeFromUserDate    DATETIME NOT NULL,
    NoticeFromUserNum     TEXT     NOT NULL,
    MoneyValue            INTEGER  NOT NULL,
    NoticeToBuilderDate   DATETIME,
    NoticeToBuilderNum    TEXT    ,
    AnswerFromBuilderDate DATETIME,
    AnswerFromBuilderNum  TEXT    ,
    AnswerToUserDate      DATETIME,
    AnswerToUserNum       TEXT    ,
    MoneySendDate         DATETIME,
    MoneySendValue        INTEGER ,
    MoneyGetInvDate       DATETIME,
    MoneyGetDate          DATETIME,
    MoneyGetValue         INTEGER ,
    Status                INTEGER  NOT NULL DEFAULT 0,
    Note                  TEXT    ,
    CONSTRAINT FK_PRETENSIONS_USERID FOREIGN KEY (UserID) REFERENCES USERS(UserID) ON UPDATE CASCADE ON DELETE SET DEFAULT
);

/* Список рекламаций */
CREATE TABLE IF NOT EXISTS RECLAMATIONS (
    ReclamationID      INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    LocationID         INTEGER  NOT NULL DEFAULT 0,
    UserID             INTEGER  NOT NULL DEFAULT 0,
    NoticeFromUserDate DATETIME NOT NULL,
    NoticeFromUserNum  TEXT     NOT NULL,
    CONSTRAINT FK_RECLAMATIONS_LOCATIONID FOREIGN KEY (LocationID) REFERENCES LOCATIONS(LocationID) ON UPDATE CASCADE ON DELETE SET DEFAULT,
    CONSTRAINT FK_RECLAMATIONS_USERID     FOREIGN KEY (UserID)     REFERENCES USERS(UserID)         ON UPDATE CASCADE ON DELETE SET DEFAULT
);

/* Список двигателей рекламации */
CREATE TABLE IF NOT EXISTS RECLAMATIONMOTORS (
    LogID                 INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    ReclamationID         INTEGER  NOT NULL,
    MotorID               INTEGER  NOT NULL,
    Mileage               INTEGER  NOT NULL DEFAULT -1,
    NoticeToBuilderDate   DATETIME,
    NoticeToBuilderNum    TEXT    ,
    AnswerFromBuilderDate DATETIME,
    AnswerFromBuilderNum  TEXT    ,
    AnswerToUserDate      DATETIME,
    AnswerToUserNum       TEXT    ,
    CancelDate            DATETIME,
    CancelNum             TEXT    ,
    ReportDate            DATETIME,
    ReportNum             TEXT    ,
    Status                INTEGER  NOT NULL DEFAULT 0,
    Note                  TEXT    ,
    CONSTRAINT FK_RECLAMATIONMOTORS_RECLAMATIONID FOREIGN KEY (ReclamationID) REFERENCES RECLAMATIONS(ReclamationID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_RECLAMATIONMOTORS_MOTORID       FOREIGN KEY (MotorID)       REFERENCES MOTORS(MotorID)             ON UPDATE CASCADE ON DELETE CASCADE
);

/* Список претензий на возмещение затрат */
CREATE TABLE IF NOT EXISTS PRETENSIONMOTORS (
    LogID        INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    PretensionID INTEGER NOT NULL,
    MotorID      INTEGER NOT NULL,
    RecLogID     INTEGER NOT NULL,
    CONSTRAINT FK_PRETENSIONMOTORS_PRETENSIONID FOREIGN KEY (PretensionID) REFERENCES PRETENSIONS(PretensionID)       ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_PRETENSIONMOTORS_MOTORID      FOREIGN KEY (MotorID)      REFERENCES MOTORS(MotorID)                 ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_PRETENSIONMOTORS_RECLOGID     FOREIGN KEY (RecLogID)     REFERENCES RECLAMATIONMOTORS(LogID)        ON UPDATE CASCADE ON DELETE CASCADE
);

/* Приложения к рекламации */
CREATE TABLE IF NOT EXISTS RECLAMATIONATTACHMENTS (
    ID                  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    LogID               INTEGER NOT NULL,
    AttachmentName      TEXT    NOT NULL,
    AttachmentExtension TEXT    NOT NULL,
    CONSTRAINT FK_RECLAMATIONATTACHMENTS_LOGID FOREIGN KEY (LogID) REFERENCES RECLAMATIONMOTORS(LogID) ON UPDATE CASCADE ON DELETE CASCADE
);

/* Список запросов о ремонте */
CREATE TABLE IF NOT EXISTS REPAIRS (
    RepairID           INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    UserID             INTEGER  NOT NULL DEFAULT 0,
    NoticeFromUserDate DATETIME NOT NULL,
    NoticeFromUserNum  TEXT     NOT NULL,
    CONSTRAINT FK_REPAIRS_USERID FOREIGN KEY (UserID) REFERENCES USERS(UserID) ON UPDATE CASCADE ON DELETE SET DEFAULT
);

/* Список ремонтов */
CREATE TABLE IF NOT EXISTS REPAIRMOTORS (
    LogID                 INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
    RepairID              INTEGER  NOT NULL,
    MotorID               INTEGER  NOT NULL,
    NoticeToBuilderDate   DATETIME,
    NoticeToBuilderNum    TEXT    ,
    AnswerFromBuilderDate DATETIME,
    AnswerFromBuilderNum  TEXT    ,
    AnswerToUserDate      DATETIME,
    AnswerToUserNum       TEXT    ,
    BeginDate             DATETIME,
    EndDate               DATETIME,
    Status                INTEGER  NOT NULL DEFAULT 0,
    Note                  TEXT    ,
    RecLogID              INTEGER  NOT NULL,
    CONSTRAINT FK_REPAIRMOTORS_REPAIRID FOREIGN KEY (RepairID) REFERENCES REPAIRS(RepairID)           ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_REPAIRMOTORS_MOTORID  FOREIGN KEY (MotorID)  REFERENCES MOTORS(MotorID)             ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_REPAIRMOTORS_RECLOGID FOREIGN KEY (RecLogID) REFERENCES RECLAMATIONMOTORS(LogID)    ON UPDATE CASCADE ON DELETE CASCADE
);

/* Приложения к гарантийному ремонту */
CREATE TABLE IF NOT EXISTS REPAIRATTACHMENTS (
    ID                  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    LogID               INTEGER NOT NULL,
    AttachmentName      TEXT    NOT NULL,
    AttachmentExtension TEXT    NOT NULL,
    CONSTRAINT FK_REPAIRATTACHMENTS_LOGID FOREIGN KEY (LogID) REFERENCES REPAIRMOTORS(LogID) ON UPDATE CASCADE ON DELETE CASCADE
);

/* Список адресатов у потребителя */
CREATE TABLE IF NOT EXISTS USERRECEIVERS (
    ReceiverID     INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    UserID         INTEGER NOT NULL DEFAULT 0,
    ReceiverName   TEXT    NOT NULL,
    ReceiverPost   TEXT    NOT NULL,
    ReceiverAppeal TEXT    NOT NULL,
    CONSTRAINT FK_USERRECEIVERS_USERID FOREIGN KEY (UserID) REFERENCES USERS(UserID) ON UPDATE CASCADE ON DELETE SET DEFAULT
);

/* Приложения к претензионной работе */
CREATE TABLE IF NOT EXISTS PRETENSIONATTACHMENTS (
    ID                  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    LogID               INTEGER NOT NULL,
    AttachmentName      TEXT    NOT NULL,
    AttachmentExtension TEXT    NOT NULL,
    CONSTRAINT FK_PRETENSIONATTACHMENTS_LOGID FOREIGN KEY (LogID) REFERENCES PRETENSIONMOTORS(LogID) ON UPDATE CASCADE ON DELETE CASCADE
);
