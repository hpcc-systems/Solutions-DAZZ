columnRec := RECORD
    STRING50 column_label;
    Real     value;
END;

rowRec := RECORD
    STRING50 series_label;
    DATASET(columnRec) column_data;
END;

dataset_name := 'allByYear' :STORED('dataset_name');
filter_1 := '':STORED('filter_1');
filter_2 := '':STORED('filter_2');

allByYear := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year.flat'), rowRec, THOR);
allByYearAndSex := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year_sex.flat'), rowRec, THOR);
allByYearAndAge := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year_age.flat'), rowRec, THOR);
allBy2014AndAge := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_2014_age.flat'), rowRec, THOR);

ds := CASE(dataset_name, 'allByYearAndSex' => allByYearAndSex, 'allByYear' => allByYear, 
         'allByYearAndAge' => allByYearAndAge, 'allBy2014AndAge' => allBy2014AndAge, allByYear);
OUTPUT(ds, , NAMED('chart_data'));
