dashChartRec := Record
    STRING application_id;
    STRING dashboard_id;
    STRING chart_id;
    STRING title;
    STRING chart_type;
    STRING query_name;
    STRING dataset_name;
    BOOLEAN is_drilldown := false;
    BOOLEAN has_drilldown := false;
    STRING drilldown_application_id := '';
    STRING drilldown_dashboard_id := '';
    BOOLEAN is_active := true;
END;

charts_file := '~hpcc_das::config::super::charts' ;

charts := DATASET(DYNAMIC(charts_file), dashChartRec, FLAT);

appIDs := DEDUP(SORT(charts, application_id), application_id);


appRec := RECORD
    STRING id;
    STRING title;
END;

appRec trans(dashChartRec l) := TRANSFORM
    SELF.id := l.application_id;
    SELF.title := l.application_id;
END;

ds := PROJECT(appIDs, trans(LEFT));

OUTPUT(ds,,NAMED('application_data'));