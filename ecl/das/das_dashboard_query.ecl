_application_id := '':STORED('application_id');

dashRec := RECORD
    STRING application_id;
    STRING id;
    STRING title;
END;


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
End;

charts_file := '~hpcc_das::config::super::charts' ;

charts := DATASET(DYNAMIC(charts_file), dashChartRec, FLAT);

appIDs := DEDUP(SORT(charts, application_id, dashboard_id), application_id, dashboard_id);


dashRec trans(dashChartRec l) := TRANSFORM
    SELF.application_id := l.application_id;
    SELF.id := l.dashboard_id;
    SELF.title := l.dashboard_id;
END;

ds := PROJECT(appIDs(application_id=_application_id and is_drilldown=false), trans(LEFT));

OUTPUT(ds,,NAMED('dashboard_data'));