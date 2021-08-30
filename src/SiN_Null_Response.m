% This script opens the compileddata.xlsx file of each person and find how
% many null-responses each participant has. 
% created by Douwe Horsthuis & Rinaldys on 8/30/2021
clear variables

home_path       = 'C:\Users\dohorsth\Desktop\SiN_test\';
subject_list      = {'10385' '1151' '1830'};
total_null_responses= num2cell(zeros(length(subject_list),2));


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
    total_null_responses(s,:)=[subject_list(s), null_response];
end

