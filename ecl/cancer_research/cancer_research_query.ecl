columnRec := RECORD
    STRING50 column_label;
    Real     value;
END;

rowRec := RECORD
    STRING50 series_label;
    DATASET(columnRec) column_data;
END;

chartRec := RECORD
    STRING title;
    STRING description;    
    DATASET(rowRec) row_data;
END;


_dataset_name := 'allByYear' :STORED('dataset_name');
_filter_1 := '':STORED('filter_1');
_filter_2 := '':STORED('filter_2');

allByYear := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year.flat'), rowRec, THOR);
allByYearAndSex := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year_sex.flat'), rowRec, THOR);
allByYearAndAge := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year_age.flat'), rowRec, THOR);
allBy2014AndAge := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_2014_age.flat'), rowRec, THOR);

ds := CASE(_dataset_name, 'allByYearAndSex' => allByYearAndSex, 'allByYear' => allByYear, 
         'allByYearAndAge' => allByYearAndAge, 'allBy2014AndAge' => allBy2014AndAge, allByYear);

title := CASE
            (
                _dataset_name, 
                'allByYearAndSex' => 'All Cancer Cases by Years and Gender', 
                'allByYear' => 'All Cancer Cases by Years', 
                'allByYearAndAge' => 'All Cancer Cases by Years and Age', 
                'allBy2014AndAge' => 'All Cancers for 2014 by Age', 
                'All Cancer Cases by Years'
            );

description := '';

OUTPUT(DATASET([{title, description,ds}], chartRec), , NAMED('chart_data'));

