IMPORT ecl.das.das_register_util;

das_register_util.register_chart('cancer_research',
                             'all_cancers',
                             'all_cancers_by_year',
                             '', 
                             'bar', 
                             'cancer_research_query.1',
                             'allByYear',
                             false,
                             true,
                             'cancer_research',
                             'drilldown_all_cancers_for_age');

das_register_util.register_chart('cancer_research',
                             'all_cancers',
                             'all_cancers_by_year_sex',
                             '', 
                             'line', 
                             'cancer_research_query.1',
                             'allByYearAndSex');

das_register_util.register_chart('cancer_research',
                             'all_cancers',
                             'all_cancers_by_year_age',
                             '', 
                             'line', 
                             'cancer_research_query.1',
                             'allByYearAndAge');


das_register_util.register_chart('cancer_research',
                             'drilldown_all_cancers_for_age',
                             'by_current_year_previous_1',
                             '', 
                             'pie', 
                             'cancer_research_drilldown_by_age_query.1',
                             '', true);

das_register_util.register_chart('cancer_research',
                             'drilldown_all_cancers_for_age',
                             'by_current_year_previous_2',
                             '', 
                             'bar', 
                             'cancer_research_drilldown_by_age_query.1',
                             'previousYear', true);

das_register_util.register_chart('cancer_research',
                             'drilldown_all_cancers_for_age',
                             'by_current_year_previous_3',
                             '', 
                             'table', 
                             'cancer_research_drilldown_by_age_query.1',
                             'previousYear', true);