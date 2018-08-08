_dataset_name := '' :STORED('dataset_name');
_filter_1 := '':STORED('filter_1');
_filter_2 := '':STORED('filter_2');


columnRec := RECORD
    STRING50 column_label;
    Real     value;
END;

rowRec := RECORD
    STRING50 series_label;
    DATASET(columnRec) column_data;
END;

columnYearAgeRec := RECORD
    STRING6  age;
    UNSIGNED4 year;
    Real     value;
END;

byYearAgeCols := DATASET(DYNAMIC('~training-samples::cancer-research::out::aggregate_all_cancers_by_year_age.flat'), columnYearAgeRec, THOR);

rowYearAgeRec := RECORD
    STRING50 series_label;
    DATASET(columnYearAgeRec) column_data;
END;

UNSIGNED4 year_filter := (UNSIGNED4)_filter_1;

ds := CASE(_dataset_name, 'previousYear' => byYearAgeCols(year=year_filter OR year=year_filter-1 ), byYearAgeCols (year = year_filter));

byYearAgeColsGroup := GROUP(SORT(ds, age, year), age);

rowRec doAgeRollup(columnYearAgeRec l, DATASET(columnYearAgeRec) allRows) := TRANSFORM
    SELF.series_label := l.age; 
    SELF.column_data := PROJECT(allRows(age = l.age), TRANSFORM(columnRec, SELF.column_label := (STRING50) LEFT.year, SELF.value := LEFT.value));
END;

byYearAgeRows := ROLLUP(byYearAgeColsGroup, GROUP, doAgeRollup(LEFT,ROWS(LEFT)));

OUTPUT(byYearAgeRows, , NAMED('chart_data'));

