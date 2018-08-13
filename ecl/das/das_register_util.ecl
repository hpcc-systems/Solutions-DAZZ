IMPORT STD;

EXPORT das_register_util := MODULE

    myFileName := '~hpcc_das::config::charts.flat';

    dashChartRec := Record
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
    End;

    currentFile := DATASET(myFileName, dashChartRec, THOR, OPT);

    charts := DATASET(DYNAMIC(myFileName), dashChartRec, FLAT , __Compressed__, OPT);

    dashChartRec updateCurrentFileData(DATASET(dashChartRec) newFile) := FUNCTION

                    return JOIN(currentFile, newFile,
                        Left.application_id = right.application_id And Left.dashboard_id = right.dashboard_id  and Left.chart_id = right.chart_id,
                        TRANSFORM(dashChartRec, self := IF(Left.application_id = '' And Left.dashboard_id = '' and Left.chart_id = '', RIGHT, LEFT))
                            );
    END;

    rewriteMyFile(Dataset(dashChartRec) newData) := Function

        return  SEQUENTIAL(
                            Output(newData, ,myFileName[1..(LENGTH(myFileName) - 5)] + '_' + workunit, Compressed);
                          );
    end;

    EXPORT das_register_chart(STRING app_id,
                        STRING dashboard_id,
                        STRING chart_id,
                        STRING title,
                        STRING chart_type,
                        STRING query_name,
                        STRING dataset_name,
                        BOOLEAN has_drilldown=FALSE,
                        STRING drilldown_app_id='',
                        STRING drilldown_dashboard_id='') := FUNCTION

        newRec := DATASET([{app_id, dashboard_id, chart_id, title, chart_type, query_name, dataset_name, has_drilldown, drilldown_app_id, drilldown_dashboard_id}], dashChartRec);

        joinedData := updateCurrentFileData(newRec);

        updateMyFile := rewriteMyFile(joinedData);

        Return WHEN(updateMyFile, Output(charts));

    END;

END;