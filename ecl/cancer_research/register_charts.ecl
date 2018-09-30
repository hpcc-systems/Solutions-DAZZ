IMPORT dazz.dazz_register_util;   
IMPORT cancer_research.files;  

#WORKUNIT('name', 'cancer_research_register_charts');

sites := DEDUP(SORT(files.allIncidents,site), site);

summary := NORMALIZE(sites, 2,
      TRANSFORM(
           dazz_register_util.dashChartRec,
                SELF.application_id := 'Cancer Research';
                SELF.dashboard_id := LEFT.site;
                SELF.chart_id := COUNTER + LEFT.site;
                SELF.title := LEFT.site;
                SELF.chart_type := CASE(COUNTER, 1=>'bar', 'line');
                SELF.query_name := CASE(COUNTER, 1=>'cancer_research_by_all_query.1', 'cancer_research_by_gender_query.1');
                SELF.dataset_name := LEFT.site;
                SELF.is_drilldown := false;
                SELF.has_drilldown := CASE(COUNTER, 1=>true,false);
                SELF.drilldown_application_id := 'Cancer Research';
                SELF.drilldown_dashboard_id := 'Drilldown ' + LEFT.site;
                SELF.is_active := true;
      )
);

drilldown := NORMALIZE(sites, 1,
      TRANSFORM(
           dazz_register_util.dashChartRec,
                SELF.application_id := 'Cancer Research';
                SELF.dashboard_id := 'Drilldown ' + LEFT.site;
                SELF.chart_id := COUNTER + ' Drilldown ' +  LEFT.site;
                SELF.title := LEFT.site;
                SELF.chart_type := CASE(COUNTER, 1=>'pie', 'pie');
                SELF.query_name := CASE(COUNTER, 1=>'cancer_research_by_age_query.1', 'cancer_research_by_age_query.1');
                SELF.dataset_name := LEFT.site;
                SELF.is_drilldown := true;
      )
);

                                                                                                     
dazz_register_util.register_chart_multi_rows(summary + drilldown);



