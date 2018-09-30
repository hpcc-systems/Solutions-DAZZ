import cancer_research.files;

#WORKUNIT('name', 'Cancer_Research_Job');

_site := 'All Cancer Sites Combined';

OUTPUT(files.rawDS, NAMED('raw')); 

allIncidents := files.rawDS(year != '2010-2014' 
                and (sex='Male' or sex='Female') 
                and (race='All Races')
                and (event_type='Incidence'));

filered := allIncidents(site=_site);
                           