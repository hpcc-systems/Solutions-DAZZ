EXPORT chart := MODULE

    EXPORT columnRec := RECORD
        STRING50 column_label;
        Real     value;
    END;

    EXPORT rowRec := RECORD
        STRING50 series_label;
        DATASET(columnRec) column_data;
    END;

    EXPORT rowColumnChartRec := RECORD
        STRING title;
        STRING description;    
        DATASET(rowRec) row_data;
    END;

END;