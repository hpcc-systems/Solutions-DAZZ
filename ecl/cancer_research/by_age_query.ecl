IMPORT cancer_research.files;
IMPORT dazz.chart;


#WORKUNIT('name', 'cancer_research_by_age_query');


_filter_1 := '':STORED('filter_1');
_filter_2 := '':STORED('filter_2');
_dataset_name := 'All Cancer Sites Combined' :STORED('dataset_name');

allCancers := TABLE(files.allIncidents (site=_dataset_name), {age, year, UNSIGNED4 total:=SUM(GROUP, (INTEGER)total)}, age, year);

columnYearAgeRec := RECORD
    STRING6  age;
    UNSIGNED4 year;
    Real     value;
END;

columnYearAgeRec transYearAgeCols({STRING age, STRING year, UNSIGNED4 total} l) := TRANSFORM
    SELF.year := (UNSIGNED4)l.year;
    SELF.value := l.total;
    SELF.age := l.age;
END;

ds := If(_filter_1!='',allCancers(year=_filter_1),allCancers);

byYearAgeCols := PROJECT(ds, transYearAgeCols(LEFT));

byYearAgeColsGroup := GROUP(byYearAgeCols, age);

chart.RowRec doAgeRollup(columnYearAgeRec l, DATASET(columnYearAgeRec) allRows) := TRANSFORM
    SELF.series_label := l.age; 
    SELF.column_data := PROJECT(allRows(age = l.age), 
                TRANSFORM(chart.columnRec, SELF.column_label := (STRING50) LEFT.year, SELF.value := LEFT.value));
END;

chartRows := ROLLUP(byYearAgeColsGroup, GROUP, doAgeRollup(LEFT,ROWS(LEFT)));

title := _dataset_name + ', by Age for ' + If(_filter_1!='',_filter_1,'years');

OUTPUT(DATASET([{title, title, chartRows}], chart.rowColumnChartRec), , NAMED('chart_data'));