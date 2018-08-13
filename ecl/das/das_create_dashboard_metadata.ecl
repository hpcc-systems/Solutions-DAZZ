appRec := RECORD
    STRING id;
    STRING title;
END;

apps := DATASET([{'cancer_research','Cancer Research'}, {'sales_demo','Sales Demo'}], appRec);

OUTPUT(apps,,'~hpcc_das::config::apps.flat',NAMED('application_data'), OVERWRITE);

dashRec := RECORD
    STRING application_id;
    STRING id;
    STRING title;
END;

dashboards := DATASET([{'cancer_research','all_cancers','All Cancers'}, {'cancer_research','bysite_cancers','Cancers By Site'},
               {'sales_demo','sales_revenue','Sales Revenue'}, {'sales_demo','sales_quantity','Sales Quantity'}], dashRec);

OUTPUT(dashboards,,'~hpcc_das::config::dashboards.flat',NAMED('dashboard_data'), OVERWRITE);

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

charts := DATASET([{'cancer_research','all_cancers','all_cancers_by_year','Trend By Year', 'bar', 'cancer_research_query.1','allByYear', true, 'cancer_research', 'drilldown_all_cancers_for_age'},
               {'cancer_research','all_cancers','all_cancers_by_year_sex','Trend By Year and Gender', 'line', 'cancer_research_query.1','allByYearAndSex'},
               {'cancer_research','all_cancers','all_cancers_by_year_age','Trend By Year and Age', 'line', 'cancer_research_query.1','allByYearAndAge'},
               {'sales_demo','sales_revenue','quarterly_revenue','Revenue By Quarter', 'bar', 'sales_query.1','quarterlyRevenue'},
               {'cancer_research','drilldown_all_cancers_for_age','by_current_year','Cancer distribution by Age', 'pie', 'cancer_research_drilldown_by_age_query.1','allByYearAndAge'},
               {'cancer_research','drilldown_all_cancers_for_age','by_current_year_previous_1','Cancer distribution by Age for current and prior year', 'bar', 'cancer_research_drilldown_by_age_query.1','previousYear'},
               {'cancer_research','drilldown_all_cancers_for_age','by_current_year_previous_2','Cancer distribution by Age for current and prior year', 'table', 'cancer_research_drilldown_by_age_query.1','previousYear'}], dashChartRec);


OUTPUT(charts,,'~hpcc_das::config::charts.flat',NAMED('dashboard_charts_data'), OVERWRITE); 