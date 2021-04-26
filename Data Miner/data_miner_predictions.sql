
declare
    cur sys_refcursor;
begin
    Contract_Package.GetServiceRecommendationsByContract(6, 3, cur);
    dbms_sql.return_result(cur);
end;

declare
    cur sys_refcursor;
begin
    Client_Package.GetTariffRecommendationsByClientId(23, 3, cur);
    dbms_sql.return_result(cur);
end;

SELECT SD.* FROM CONTRACT C
    INNER JOIN SERVICE S ON C.ID = S.CONTRACT_ID
    INNER JOIN SERVICE_DESCRIPTION SD on S.DESCRIPTION_ID = SD.ID
    WHERE C.ID = 6;

SELECT CL.* FROM CLIENT CL INNER JOIN CONTRACT C ON CL.ID = C.CLIENT_ID WHERE C.ID = 6;

SELECT C.* FROM CONTRACT C WHERE CLIENT_ID = 5489;

SELECT * FROM DM$P4TARIFF_ASSOC_MODEL WHERE ITEMSET_ID = 12;

SELECT * FROM CLIENT CL INNER JOIN CONTRACT C ON CL.ID = C.CLIENT_ID
    WHERE CL.ID = 23;

SELECT CLIENT_ID, TARIFF_ID FROM CLIENT CL INNER JOIN CONTRACT C ON CL.ID = C.CLIENT_ID
WHERE TARIFF_ID in (12) GROUP BY CLIENT_ID, TARIFF_ID;

SELECT CONSEQUENT_ITEMSET_ID FROM (SELECT * FROM DM$P0TARIFF_ASSOC_MODEL
            WHERE ANTECEDENT_ITEMSET_ID = 2 ORDER BY LIFT DESC);

SELECT ITEM_ID FROM DM$P4TARIFF_ASSOC_MODEL WHERE ITEMSET_ID IN
                (SELECT CONSEQUENT_ITEMSET_ID FROM (SELECT * FROM DM$P0TARIFF_ASSOC_MODEL
                WHERE ANTECEDENT_ITEMSET_ID = 2 ORDER BY LIFT DESC));

SELECT * FROM TARIFF_PLAN WHERE ID IN
            (SELECT ITEM_ID FROM DM$P4TARIFF_ASSOC_MODEL WHERE ITEMSET_ID IN
            (SELECT CONSEQUENT_ITEMSET_ID FROM (SELECT * FROM DM$P0TARIFF_ASSOC_MODEL
            WHERE ANTECEDENT_ITEMSET_ID = 108 ORDER BY LIFT DESC) WHERE ROWNUM <= 3));
