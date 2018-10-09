IMPORT dazz.dazz_register_util;

STRING _application_id := '': STORED('application_id'); 
STRING _dashboard_id := '': STORED('dashboard_id');


charts_file := '~hpcc_das::config::super::charts' ;

charts := DATASET(DYNAMIC(charts_file), dazz_register_util.dashChartRec, FLAT);              


OUTPUT(SORT(charts(dashboard_id=_dashboard_id AND application_id=_application_id),chart_id),,NAMED('dashboard_charts_data')); 