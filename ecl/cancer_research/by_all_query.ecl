IMPORT ecl.cancer_research.files;
IMPORT ecl.das.chart;

#WORKUNIT('name', 'cancer_research_by_all_query');

_dataset_name := 'All Cancer Sites Combined' :STORED('dataset_name');

allCancersByYear := TABLE(files.allIncidents (site=_dataset_name), {year, UNSIGNED4 total:=SUM(GROUP, (INTEGER)total)}, year);

chart.columnRec transYearCols({STRING year, UNSIGNED4 total} l) := TRANSFORM
    SELF.column_label := l.year;
    SELF.value := l.total;
END;

chartColumns := PROJECT(allCancersByYear, transYearCols(LEFT));

chartRows := DATASET([{'All', chartColumns}], chart.rowRec);

title := _dataset_name + ', by year ';

OUTPUT(DATASET([{title, title, chartRows}], chart.rowColumnChartRec), , NAMED('chart_data'));