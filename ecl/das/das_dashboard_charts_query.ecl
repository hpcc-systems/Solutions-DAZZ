STRING _application_id := '': STORED('application_id'); 
STRING _dashboard_id := '': STORED('dashboard_id');

dashChartRec := RECORD
    STRING application_id;
    STRING dashboard_id;
    STRING chart_id;
    STRING title;
    STRING chart_type;
    STRING query_name;
    STRING dataset_name;
    BOOLEAN has_drilldown := false;
    STRING drilldown_application_id := '';
    STRING drilldown_dashboard_id := '';
    BOOLEAN is_active := true;
END;

_charts_file := '~hpcc_das::config::charts.flat' :STORED('charts_file');

ds := DATASET(DYNAMIC(_charts_file), dashChartRec, FLAT);               

OUTPUT(ds(dashboard_id=_dashboard_id AND application_id=_application_id),,NAMED('dashboard_charts_data')); 