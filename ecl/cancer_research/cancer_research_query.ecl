import dazz.chart; 


_dataset_name := 'allByYear' :STORED('dataset_name');
_filter_1 := '':STORED('filter_1');
_filter_2 := '':STORED('filter_2');

allByYear := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year.flat'), chart.rowRec, THOR);
allByYearAndSex := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year_sex.flat'), chart.rowRec, THOR);
allByYearAndAge := DATASET(DYNAMIC('~training-samples::cancer-research::out::all_by_year_age.flat'), chart.rowRec, THOR);

ds := CASE(_dataset_name, 'allByYearAndSex' => allByYearAndSex, 'allByYear' => allByYear, 
         'allByYearAndAge' => allByYearAndAge, allByYear);

title := CASE
            (
                _dataset_name, 
                'allByYearAndSex' => 'All Cancer Cases by Years and Gender', 
                'allByYear' => 'All Cancer Cases by Years', 
                'allByYearAndAge' => 'All Cancer Cases by Years and Age',
                'All Cancer Cases by Years'
            );

description := '';

OUTPUT(DATASET([{title, description,ds}], chart.rowColumnChartRec), , NAMED('chart_data'));

