STRING _dashboard_id := '': STORED('dashboard_id');

dashChartRec := RECORD
    STRING dashboard_id;
    STRING chart_id;
    STRING title;
    STRING chart_type;
    STRING query_name;
    STRING dataset_name;
    BOOLEAN has_drilldown := false;
    STRING drilldown_application_id := '';
    STRING drilldown_dashboard_id := '';
END;

// ds := DATASET([{'all_cancers','all_cancers_by_year','Trend By Year', 'bar', 'cancer_research_query.1','allByYear'},
//                {'all_cancers','all_cancers_by_year_sex','Trend By Year and Gender', 'line', 'cancer_research_query.1','allByYearAndSex'},
//                {'all_cancers','all_cancers_by_year_age','Trend By Year and Age', 'line', 'cancer_research_query.1','allByYearAndAge'},
//                {'sales_revenue','quarterly_revenue','Revenue By Quarter', 'bar', 'sales_query.1','quarterlyRevenue'}], dashChartRec);
_charts_file := '~hpcc_das::config::charts.flat' :STORED('charts_file');

ds := DATASET(DYNAMIC(_charts_file), dashChartRec, FLAT);               

OUTPUT(ds(dashboard_id=_dashboard_id),,NAMED('dashboard_charts_data')); 