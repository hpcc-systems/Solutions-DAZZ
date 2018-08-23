EXPORT files := MODULE

    EXPORT rawRec := RECORD
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

    EXPORT rawDS := DATASET('~training-samples::cancer-research::in::byage.txt', 
                        rawRec, CSV(HEADING(1), SEPARATOR('|')));

    EXPORT allIncidents := rawDS(year != '2010-2014' 
                and (sex='Male' or sex='Female') 
                and (race='All Races')
                and (event_type='Incidence')
                and (site != 'Female Breast, <i>in situ</i>'));                        

    EXPORT byAllRec := RECORD
        STRING year;
        UNSIGNED4 total;
    END;

    EXPORT bySexRec := RECORD
        STRING sex;
        STRING year;
        UNSIGNED4 total;
    END;

    EXPORT byAgeRec := RECORD
        STRING age;
        STRING year;
        UNSIGNED4 total;
    END;
END;