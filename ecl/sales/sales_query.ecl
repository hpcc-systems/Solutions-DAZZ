column_record := RECORD
    STRING50 column_label;
    Real     value;
END;

row_record := RECORD
    STRING50 series_label;
    DATASET(column_record) column_data;
END;

ds := DATASET([{'Accord',[{'Q1',100000}, {'Q2',120000}, {'Q3',90000}, {'Q4',150000}]}, 
                     {'CR-V',[{'Q1',150000}, {'Q2',170000}, {'Q3',190000}, {'Q4',250000}]},
                     {'Civic',[{'Q1',300000}, {'Q2',320000}, {'Q3',390000}, {'Q4',250000}]},
                     {'Pilot',[{'Q1',200000}, {'Q2',220000}, {'Q3',210000}, {'Q4',350000}]},
                     {'HR-V',[{'Q1',460000}, {'Q2',420000}, {'Q3',200000}, {'Q4',250000}]},
                     {'Odyssey',[{'Q1',300000}, {'Q2',350000}, {'Q3',150000}, {'Q4',370000}]}], row_record);

OUTPUT(ds,,NAMED('chart_data'));