byAgeRec := RECORD
    STRING age;
    STRING ci_lower;
    STRING ci_upper;
    STRING total;
    STRING event_type;
    STRING population;
    STRING race;
    STRING rate;
    STRING sex;
    STRING site;
    STRING year;
END;

rawDS := DATASET('~training-samples::cancer-research::in::byage.txt', 
               byAgeRec, CSV(HEADING(1), SEPARATOR('|')));

OUTPUT(rawDS, NAMED('raw'));


allCancers := rawDS(site='All Cancer Sites Combined' 
                and year != '2010-2014' 
                and (sex='Male' or sex='Female') 
                and (race='All Races')
                and (event_type='Incidence'));

OUTPUT(allCancers, NAMED('all_cancers'));


allCancersByYear := TABLE(allCancers, {year, UNSIGNED4 total:=SUM(GROUP, (INTEGER)total)}, year);

allCancersByYearSex := TABLE(allCancers, {sex,year, UNSIGNED4 total:=SUM(GROUP, (INTEGER)total)}, sex,year);

allCancersByYearAge := TABLE(allCancers, {age,year, UNSIGNED4 total:=SUM(GROUP, (INTEGER)total)}, age,year);

OUTPUT(allCancersByYear,,'~training-samples::cancer-research::out::aggregate_all_cancers_by_year.flat',NAMED('aggregate_all_cancers_by_year'), OVERWRITE);
OUTPUT(allCancersByYearSex,,'~training-samples::cancer-research::out::aggregate_all_cancers_by_year_sex.flat', NAMED('aggregate_all_cancers_by_year_sex'), OVERWRITE);

//Record structures for shaping data for the charts
columnRec := RECORD
    STRING50 column_label;
    Real     value;
END;

rowRec := RECORD
    STRING50 series_label;
    DATASET(columnRec) column_data;
END;

//By Year
columnRec transYearCols({STRING year, UNSIGNED4 total} l) := TRANSFORM
    SELF.column_label := l.year;
    SELF.value := l.total;
END;

byYearCols := PROJECT(allCancersByYear, transYearCols(LEFT));

byYearRows := DATASET([{'All', byYearCols}], rowRec);

OUTPUT(byYearRows,,'~training-samples::cancer-research::out::all_by_year.flat', NAMED('by_year_chart'), OVERWRITE);

//By Year and Sex
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

byYearSexCols := PROJECT(allCancersByYearSex, transYearSexCols(LEFT));

byYearSexColsGroup := GROUP(byYearSexCols, sex);


rowRec doSexRollup(columnYearSexRec l, DATASET(columnYearSexRec) allRows) := TRANSFORM
    SELF.series_label := l.sex; 
    SELF.column_data := PROJECT(allRows(sex = l.sex), TRANSFORM(columnRec, SELF.column_label := (STRING50) LEFT.year, SELF.value := LEFT.value));
END;

byYearSexRows := ROLLUP(byYearSexColsGroup, GROUP, doSexRollup(LEFT,ROWS(LEFT)));

OUTPUT(byYearSexRows,,'~training-samples::cancer-research::out::all_by_year_sex.flat', NAMED('by_year_sex_chart'), OVERWRITE);

//By Year and Age
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

byYearAgeCols := PROJECT(allCancersByYearAge, transYearAgeCols(LEFT));

OUTPUT(byYearAgeCols,, '~training-samples::cancer-research::out::aggregate_all_cancers_by_year_age.flat', NAMED('aggregate_all_cancers_by_year_age'), OVERWRITE);




