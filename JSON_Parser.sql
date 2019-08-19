CREATE OR REPLACE PROCEDURE TRADE_PARSER
IS
type strArray IS VARRAY(90) OF VARCHAR2(2000);
type strArray2 IS VARRAY(200) OF VARCHAR2(2000);
nameStr strArray;
valueStr strArray;
parseStr strArray2;
op VARCHAR2(5);
fetchStr VARCHAR2(2000);
parseIndex INTEGER;
lengthJSON INTEGER;
currChar VARCHAR2(1);
prevChar VARCHAR2(1);
nullStr VARCHAR2(5);

BEGIN
nameStr := strArray('Accounts-Ended', 'ActionTimestamp', 'Address', 'AGM-Held-Date', 'AGM-Held-Place', 'AGM-Held-Time', 'Announce-Date','AnnouncementAction', 'AnnouncementId', 'AnnouncementTitle', 'AnnouncementType', 'Associated-Companies-Holdings','Attachment', 'Bonus-Held-Shares', 'Bonus-Percent', 'Bonus-Proportion', 'CDC-Available-Quantity', 'Closed-From', 'Closed-To', 'ClosedForm', 'ClosedTo', 'Company-Designation', 'Credited-Date', 'Designation','Dividend-Percent', 'Dividend-Warrants-PCT', 'Dividend-Warrants', 'Dividend', 'Effective-Date', 'Email', 'Enclosure', 'Entitlement-Paid-Date', 'Existing-Designation', 'Fax', 'FreeFloat-Date', 'FreeFloat-Quantity', 'General-Public-Holdings', 'Government-Holdings', 'Held-Date', 'Held-Place', 'Held-Time', 'HeldBy-Directors-Sponsors', 'In-Coming','In-Place-Of', 'Interim-Bonus-Held-Shares', 'Interim-Bonus-Percent', 'Interim-Bonus-Proportion', 'Interim-Bonus-Shares-PCT', 'Interim-Dividend-Already', 'Interim-Dividend-Percent', 'Interim-Dividend', 'Last-Date','Last-Receiving-Date', 'MaterialInfo', 'MiscellaneousInfo', 'Name', 'New-Board', 'New-Designation', 'New-Name', 'Number-Of-Months', 'OriginalAnnouncementId', 'Other-Price-Information', 'Outgoing', 'Period-Ended', 'Post-Date','PostingDate', 'PostingTime', 'Proportion-Shares-D', 'Proportion-Shares-N', 'Receiving-Address', 'Registrar', 'Resigned-Effective-Date', 'Revised', 'Right-Discount-Per-Share','Right-Proportion-Shares-D', 'Right-Proportion-Shares-N', 'Right-Shares-Percent', 'Subject', 'SymbolCode','Telephone', 'Total-Less-Quantity', 'Total-Outstanding-Shares', 'Total-Physical-Shares', 'Transfer-Received-Date', 'WebSite', 'From', 'Interim-Bonus-Issued-Already-PCT', 'Interim-Dividend-Percent-Already', 'OtherEntitlementOrCorporateAction', 'To');

FOR json_rec IN (SELECT * FROM JSON_DATA) LOOP
	valueStr := strArray('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

	parseStr := strArray2('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

	parseIndex := 1;
	op := 'END';

	lengthJSON := LENGTH(json_rec.ORIGINAL_JSON);

	FOR ch IN 1 .. lengthJSON LOOP
		currChar := SUBSTR(json_rec.ORIGINAL_JSON, ch, 1);
		prevChar := SUBSTR(json_rec.ORIGINAL_JSON, ch-1, 1);
		nullStr := SUBSTR(json_rec.ORIGINAL_JSON, ch, 5);

		IF currChar = CHR(34) AND op != 'BEGIN' THEN
			IF prevChar != CHR(92) THEN
				op := 'BEGIN';
				fetchStr := '';
				CONTINUE;
			END IF;
		END IF;
		IF op = 'END' AND nullStr = ':null' THEN
			parseStr(parseIndex) := NULL;
			parseIndex := parseIndex + 1;
		END IF;
		IF currChar = CHR(34) AND op = 'BEGIN' THEN
			IF prevChar != CHR(92) THEN
				op := 'END';
				parseStr(parseIndex) := fetchStr;
				parseIndex := parseIndex + 1;
			END IF;
		END IF;
		IF op = 'BEGIN' THEN
		fetchStr := CONCAT(fetchStr, currChar);
		END IF;
	END LOOP;

	FOR l IN 1 .. 90 LOOP
		FOR k IN 1 .. parseIndex - 1 LOOP
			IF parseStr(k) = nameStr(l) THEN
				valueStr(l) := parseStr(k + 1);
			END IF;
		END LOOP;
	END LOOP;

	INSERT INTO PUCAR_ANNOUNCEMENT_DET (Accounts_Ended, ActionTimestamp, Address, AGM_Held_Date, AGM_Held_Place, AGM_Held_Time, Announce_Date, AnnouncementAction, AnnouncementId, AnnouncementTitle, AnnouncementType, Associated_Companies_Holdings, Attachment, Bonus_Held_Shares, Bonus_Percent, Bonus_Proportion, CDC_Available_Quantity, Closed_From, Closed_To, ClosedForm, ClosedTo, Company_Designation, Credited_Date, Designation, Dividend_Percent, Dividend_Warrants_PCT, Dividend_Warrants, Dividend, Effective_Date, Email, Enclosure, Entitlement_Paid_Date, Existing_Designation, Fax, FreeFloat_Date, FreeFloat_Quantity, General_Public_Holdings, Government_Holdings, Held_Date, Held_Place, Held_Time, HeldBy_Directors_Sponsors, In_Coming, In_Place_Of, Interim_Bonus_Held_Shares, Interim_Bonus_Percent, Interim_Bonus_Proportion, Interim_Bonus_Shares_PCT, Interim_Dividend_Already, Interim_Dividend_Percent, Interim_Dividend, Last_Date, Last_Receiving_Date, MaterialInfo, MiscellaneousInfo, Name, New_Board, New_Designation, New_Name, Number_Of_Months, OriginalAnnouncementId, Other_Price_Information, Outgoing, Period_Ended, Post_Date, PostingDate, PostingTime, Proportion_Shares_D, Proportion_Shares_N, Receiving_Address, Registrar, Resigned_Effective_Date, Revised, Right_Discount_Per_Share, Right_Proportion_Shares_D, Right_Proportion_Shares_N, Right_Shares_Percent, Subject, SymbolCode, Telephone, Total_Less_Quantity, Total_Outstanding_Shares, Total_Physical_Shares, Transfer_Received_Date, WebSite, From_field, Interim_Bonus_Issued_alr_PCT, Interim_Dividend_Percent_alr, OtherEntitleOrCorporateAction, To_field) VALUES (valueStr(1), valueStr(2), valueStr(3), valueStr(4), valueStr(5), valueStr(6), valueStr(7), valueStr(8), valueStr(9), valueStr(10), valueStr(11), valueStr(12), valueStr(13), valueStr(14), valueStr(15), valueStr(16), valueStr(17), valueStr(18), valueStr(19), valueStr(20), valueStr(21), valueStr(22), valueStr(23), valueStr(24), valueStr(25), valueStr(26), valueStr(27), valueStr(28), valueStr(29), valueStr(30), valueStr(31), valueStr(32), valueStr(33), valueStr(34), valueStr(35), valueStr(36), valueStr(37), valueStr(38), valueStr(39), valueStr(40), valueStr(41), valueStr(42), valueStr(43), valueStr(44), valueStr(45), valueStr(46), valueStr(47), valueStr(48), valueStr(49), valueStr(50), valueStr(51), valueStr(52), valueStr(53), valueStr(54), valueStr(55), valueStr(56), valueStr(57), valueStr(58), valueStr(59), valueStr(60), valueStr(61), valueStr(62), valueStr(63), valueStr(64), valueStr(65), valueStr(66), valueStr(67), valueStr(68), valueStr(69), valueStr(70), valueStr(71), valueStr(72), valueStr(73), valueStr(74), valueStr(75), valueStr(76), valueStr(77), valueStr(78), valueStr(79), valueStr(80), valueStr(81), valueStr(82), valueStr(83), valueStr(84), valueStr(85), valueStr(86), valueStr(87), valueStr(88), valueStr(89), valueStr(90));

END LOOP;

END TRADE_PARSER;