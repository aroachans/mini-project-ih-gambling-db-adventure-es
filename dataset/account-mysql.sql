CREATE TABLE account (
    AccountNo VARCHAR(255),
    CustId INT,
    AccountLocation VARCHAR(255),
    CurrencyCode VARCHAR(255),
    DailyDepositLimit DECIMAL(10,2),
    StakeScale DECIMAL(10,2),
    SourceProd VARCHAR(255)
);

INSERT INTO account (AccountNo, CustId, AccountLocation, CurrencyCode, DailyDepositLimit, StakeScale, SourceProd) VALUES
('00357DG   ', 3531845, 'GIB', 'GBP', 0, 1.0, 'GM'),
('00497XG   ', 4188499, 'GIB', 'GBP', 0, 1.0, 'SB'),
('00692VS   ', 4704925, 'GIB', 'USD', 0, 2.0, 'SB'),
('00775SM   ', 2815836, 'GIB', 'USD', 0, 1.0, 'SB'),
('00C017    ', 889782, 'GIB', 'GBP', 1500, 0.41, 'XX'),
('00J381    ', 1191874, 'GIB', 'GBP', 500, 8.0, 'XX'),
('01148BP   ', 1569944, 'GIB', 'GBP', 0, 8.0, 'XX'),
('01152SJ   ', 1965214, 'GIB', 'USD', 0, 1.0, 'PO'),
('01196ZZ   ', 3042166, 'GIB', 'EUR', 0, 8.0, 'SB'),
('01284UW   ', 5694730, 'GIB', 'GBP', 0, 1.0, 'SB');