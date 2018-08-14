STRING _application_id := '': STORED('application_id'); 
STRING _dashboard_id := '': STORED('dashboard_id');

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

charts_file := '~hpcc_das::config::super::charts.flat' ;

charts := DATASET(DYNAMIC(charts_file), dashChartRec, FLAT);              

OUTPUT(charts(dashboard_id=_dashboard_id AND application_id=_application_id),,NAMED('dashboard_charts_data')); 