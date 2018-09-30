IMPORT STD;

EXPORT dazz_register_util := MODULE

    SHARED myFileName := '~hpcc_das::config::super::charts';
		
	SHARED myArchiveFile := '~hpcc_das::config::archive::charts';

    EXPORT dashChartRec := Record
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

    SHARED currentFile := DATASET(DYNAMIC(myFileName), dashChartRec, FLAT,  OPT);

    SHARED charts := DATASET(DYNAMIC(myFileName), dashChartRec, FLAT ,  OPT);

    SHARED dashChartRec updateCurrentFileData(DATASET(dashChartRec) newFile) := FUNCTION

         return JOIN(currentFile, newFile,
                     Left.application_id = right.application_id And Left.dashboard_id = right.dashboard_id  and Left.chart_id = right.chart_id,
                     TRANSFORM(dashChartRec, 
			                   SELF := IF(Left.application_id = RIGHT.application_id And Left.dashboard_id = RIGHT.dashboard_id and Left.chart_id = RIGHT.chart_id, RIGHT,
					                   IF(Left.application_id = '' And Left.dashboard_id = '' and Left.chart_id = '', RIGHT, LEFT)
				                            );
			               ), FULL OUTER
                     );
    END;
    
 
    SHARED rewriteMyFile(Dataset(dashChartRec) newData, STRING chart_id) := Function
	    tempSubkeyPath := myFileName + '_temp';		
		
		createSubFile := OUTPUT(newData, , tempSubkeyPath, OVERWRITE);

        subkeyPath := myFileName + '::' + chart_id + '_' + (STRING)Std.Date.CurrentTimestamp() : INDEPENDENT;

        addSuperFile :=  SEQUENTIAL
               (
   			        STD.File.StartSuperFileTransaction();
					STD.File.PromoteSuperfileList( [myFilename, myArchiveFile], subkeyPath, true),
   					STD.File.FinishSuperFileTransaction()
   			    );
   				
        RETURN SEQUENTIAL
                (
   				     createSubFile,
					 Std.File.RenameLogicalFile(tempSubkeyPath, subkeyPath);
   					 addSuperFile
   			     );


    end;

    EXPORT register_chart_multi_rows(Dataset(dashChartRec) newRec) := FUNCTION

        joinedData := updateCurrentFileData(newRec);

        updateMyFile := rewriteMyFile(joinedData, newRec[1].chart_id);

        Return WHEN(updateMyFile, OUTPUT(charts));
 
    END;

    EXPORT register_chart_CSVFile(String fileName) := FUNCTION
        
        newRec := DATASET(filename, dashChartRec, thor, OPT);

        joinedData := updateCurrentFileData(newRec);

        updateMyFile := rewriteMyFile(joinedData, newRec[1].chart_id);

        Return WHEN(updateMyFile, OUTPUT(charts));
 
    END;

    EXPORT register_chart(STRING app_id,
                        STRING dashboard_id,
                        STRING chart_id,
                        STRING title,
                        STRING chart_type,
                        STRING query_name,
                        STRING dataset_name,
                        BOOLEAN is_drilldown = FALSE,
                        BOOLEAN has_drilldown=FALSE,
                        STRING drilldown_app_id='',
                        STRING drilldown_dashboard_id='') := FUNCTION

        newRec := DATASET([{app_id, dashboard_id, chart_id, title, chart_type, 
                     query_name, dataset_name, is_drilldown, has_drilldown, 
                     drilldown_app_id, drilldown_dashboard_id}], dashChartRec);

        RETURN register_chart_multi_rows(newRec);
    END;

END;
