% This script opens the compileddata.xlsx file of each person and find how
% many null-responses each participant has. 
% created by Douwe Horsthuis & Rinaldys Castillo on 8/30/2021
clear variables

home_path       = '\\data.einsteinmed.org\users\CNL Lab\Analysis\SiN\DATA\Finished\';
subjects=dir(home_path); %load all the ID numbers based on folder name
subjects(1:2) = []; %first 2 are not IDs
subject_list= {subjects.name};
total_null_responses= num2cell(zeros(length(subject_list),3));
for s=1:length(subject_list)
    data_path = [home_path subject_list{s} '\'];
    % loading compileddata
    excel_path = dir([data_path '*_compileddata.xlsx']);
    rawdata = readtable([data_path excel_path(1).name]);
    %finding null_responses
    null_response = 0;
    responses = rawdata.Response;
    for i=1:height(rawdata)
        if strcmp(responses(i), '')
            null_response = null_response+1;
        end
    end
    %adding group type
    if strcmp(subject_list{s}(1:2),'18') || strcmp(subject_list{s}(1:2),'11')
        group='ASD';
    else
        group='Control';
    end
    total_null_responses(s,:)=[subject_list(s), null_response, group];
end

save([home_path 'total_null_responses'], 'total_null_responses')