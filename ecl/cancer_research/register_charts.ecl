IMPORT ecl.das.das_register_util;     

#WORKUNIT('name', 'cancer_research_register_charts');

                                                                                                     

das_register_util.register_chart_multi_rows
    (  DATASET(
    
        [   


            {
                    'Cancer Research',
                    'All Cancers',
                    '1_all_cancers_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'All Cancer Sites Combined'
            },
            {
                    'Cancer Research',
                    'All Cancers',
                    '2_all_cancers_by_gender',
                    '', 
                    'line', 
                    'cancer_research_by_gender_query.1',
                    'All Cancer Sites Combined'
            },
            {
                    'Cancer Research',
                    'Non-Hodgkin Lymphoma',
                    'non_hodgkin_lymphoma_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Non-Hodgkin Lymphoma'
            }, 

            {
                    'Cancer Research',
                    'Hodgkin Lymphoma',
                    'hodgkin_lymphoma_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Hodgkin Lymphoma'
            },                             

            {
                    'Cancer Research',
                    'Pancreas',
                    'pancreas_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Pancreas'
            },    

            {
                    'Cancer Research',
                    'Prostate',
                    'prostate_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Prostate'
            },        
            {           
                    'Cancer Research',
                    'Stomach',
                    'stomach_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Stomach'
            },         
            {
                    'Cancer Research',
                    'Thyroid',
                    'thyroid_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Thyroid'
            },  
            {
                    'Cancer Research',
                    'Urinary Bladder',
                    'urinary_bladder_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Urinary Bladder'
            },  
            {
                    'Cancer Research',
                    'Brain and Other Nervous System',
                    'brain_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Brain and Other Nervous System'
            },  

            {
                    'Cancer Research',
                    'Colon and Rectum',
                    'colon_and_rectum_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Colon and Rectum'
            },      
            {
                    'Cancer Research',
                    'Cervix',
                    'cervix_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Cervix'
            },                                                     
            {
                    'Cancer Research',
                    'Corpus and Uterus, NOS',
                    'uterus_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Corpus and Uterus, NOS'
            },
            {
                    'Cancer Research',
                    'Esophagus',
                    'esophagus_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Esophagus'
            },
            {
                    'Cancer Research',
                    'Female Breast',
                    'female_breast_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Female Breast'   
            },
            {
                    'Cancer Research',
                    'Kaposi Sarcoma',
                    'kaposi_sarcoma_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Kaposi Sarcoma'                
            },
            {
                    'Cancer Research',
                    'Kidney and Renal Pelvis',
                    'kidney_and_renal_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Kidney and Renal Pelvis'
            },
            {
                    'Cancer Research',
                    'Liver and Intrahepatic Bile Duct',
                    'liver_and_bile_duct_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Liver and Intrahepatic Bile Duct'
            },
            {
                    'Cancer Research',
                    'Leukemias',
                    'leukemias_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Leukemias'
            },
            {
                    'Cancer Research',
                    'Larynx',
                    'larynx_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Larynx'
            },
            {
                    'Cancer Research',
                    'Lung and Bronchus',
                    'lung_and_bronchus_by_year',
                    '', 
                    'bar', 
                    'cancer_research_by_all_query.1',
                    'Lung and Bronchus'
            }
        
        ], das_register_util.dashChartRec)
    );  