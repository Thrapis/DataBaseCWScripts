CREATE OR REPLACE VIEW SERVICE_MINER_VIEW AS
SELECT CONTRACT_ID, CLIENT_ID, DESCRIPTION_ID as "SERVICE_DESCRIPTION_ID"
FROM CONTRACT C INNER JOIN SERVICE S on C.ID = S.CONTRACT_ID;

SELECT * FROM SERVICE_MINER_VIEW ORDER BY CONTRACT_ID;

CREATE OR REPLACE VIEW TARIFF_MINER_VIEW AS
SELECT C.ID "CONTRACT_ID", CLIENT_ID, TARIFF_ID
FROM CONTRACT C INNER JOIN TARIFF_PLAN T on C.TARIFF_ID = T.ID;