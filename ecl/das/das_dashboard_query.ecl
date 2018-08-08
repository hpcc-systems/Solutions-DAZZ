dashRec := RECORD
    STRING application_id;
    STRING id;
    STRING title;
END;

_application_id := '' :STORED('application_id');
_dashboard_file := '~hpcc_das::config::dashboards.flat' :STORED('dashboard_file');

// ds := DATASET([{'cancer_research','all_cancers','All Cancers'}, {'cancer_research','bysite_cancers','Cancers By Site'},
//                {'sales_demo','sales_revenue','Sales Revenue'}, {'sales_demo','sales_quantity','Sales Quantity'}], dashRec);

ds := DATASET(DYNAMIC(_dashboard_file), dashRec, FLAT);               

OUTPUT(ds(application_id=_application_id),,NAMED('dashboard_data'));