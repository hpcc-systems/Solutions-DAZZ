IMPORT ecl.cancer_research.files;
IMPORT ecl.das.chart;

#WORKUNIT('name', 'cancer_research_by_gender_query');

_dataset_name := 'All Cancer Sites Combined' :STORED('dataset_name');

allCancers := TABLE(files.allIncidents (site=_dataset_name), {sex, year, UNSIGNED4 total:=SUM(GROUP, (INTEGER)total)}, sex, year);

columnYearSexRec := RECORD
    UNSIGNED4  year;
    STRING6  sex;
    Real     value;
END;

rowYearSexRec := RECORD
    STRING50 series_label;
    DATASET(columnYearSexRec) column_data;
END;

columnYearSexRec transYearSexCols({STRING sex, STRING year, UNSIGNED4 total} l) := TRANSFORM
    SELF.year := (UNSIGNED4)l.year;
    SELF.value := l.total;
    SELF.sex := l.sex;
END;

byYearSexCols := PROJECT(allCancers, transYearSexCols(LEFT));

byYearSexColsGroup := GROUP(byYearSexCols, sex);

chart.RowRec doSexRollup(columnYearSexRec l, DATASET(columnYearSexRec) allRows) := TRANSFORM
    SELF.series_label := l.sex; 
    SELF.column_data := PROJECT(allRows(sex = l.sex), 
                TRANSFORM(chart.columnRec, SELF.column_label := (STRING50) LEFT.year, SELF.value := LEFT.value));
END;

chartRows := ROLLUP(byYearSexColsGroup, GROUP, doSexRollup(LEFT,ROWS(LEFT)));

title := _dataset_name + ', by year and gender ';

OUTPUT(DATASET([{title, title, chartRows}], chart.rowColumnChartRec), , NAMED('chart_data'));