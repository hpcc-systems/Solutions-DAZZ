appRec := RECORD
    STRING id;
    STRING title;
END;

_application_file := '~hpcc_das::config::apps.flat' :STORED('application_file');

ds := DATASET(DYNAMIC(_application_file), appRec, FLAT);

OUTPUT(ds,,NAMED('application_data'));