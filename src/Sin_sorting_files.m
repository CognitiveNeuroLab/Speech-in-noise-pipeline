% this script creates an excel file with the noise levels for each word and
% if they were correct or not. This data is used to do the stats with
clear variables
clc
tic
%finding the files
subject_id={'TheIDBeforeTheLogfiles'};
subject_name=subject_id;
name_sin_logfile = '-speech_and_noise_kids_'; %some logfiles are called "-speech_and_noise_kids_" others "speech_and_noise_kids_" or "-speech_in_noise_kids_" or "speech_in_noise_kids_"
Raw_response_file={'TheNameOfTheExcelResponseFile.xlsx'};
dir='FilePathToTheData\';
% Reads in word list
[A Word_List_temp]=xlsread('word list.xlsx');
Word_List= Word_List_temp(2:end,1);
% Reads Response excel
[A Response]=xlsread([dir Raw_response_file{:}]);
% converts response matrix to a list
Response_List=[];
for blocks=1:size(Response,2)
    Response_List=[Response_List; Response(:,blocks)];
end
%Finding noise levels
Stimulus_List=[];
Stimulus=[];
for blocks=1:15%size(Response,2)  
A=importPresentationLog([dir subject_name{:} name_sin_logfile num2str(blocks) '.log']);
No_of_Trials=length(A);
for i=1:No_of_Trials
 Code{i}=(A(:,i).code);
end
[INDEX_CODE]=find(strcmp(Code,'255')==1);
Stim1=Code(INDEX_CODE-1);
%6-15-2021 Update (Douwe), added line 44-49 (to stop 200 or 3 codes from showing up, these are caused by people clicking just between the video and the picture
for j=1:length(INDEX_CODE) % looks trhough all 20 index code 
    if strcmp(Stim1{j},'200')==1 || strcmp(Stim1{j},'3')==1 % if any of the index code have 200 or 3 (the clicking code)
       INDEX_CODE(j)= INDEX_CODE(j)-1; %take the one before that (its the stim code)
    end
end

Stimulus=Code(INDEX_CODE-1);
Stimulus=Stimulus(1:20);
Stimulus_List=[Stimulus_List,Stimulus];
Stimulus=[];
end
% finding correct answers
for i=1:size(Word_List)
   if strcmp( Word_List{i},Response_List{i})==1;
   correct(i)=Stimulus_List(i);
   else
   correct(i)={' '};
   end
end
%creating the Excel file with all the pre-processed data
% header for Scoring file
header={'Stimulus #','Word','Response','Stimulus','Correct'};
% writes header to excel file
xlswrite([dir subject_id{:} '_compileddata.xlsx'], header, 'Sheet1', 'A1');
% writes trial number to excel file -not sure how many yet
xlswrite([dir subject_id{:} '_compileddata.xlsx'], [1:300]', 'Sheet1', 'A2');
% writes word list to excel file
xlswrite([dir subject_id{:}  '_compileddata.xlsx'], Word_List, 'Sheet1', 'B2');
% writes response list to excel file
xlswrite([dir subject_id{:} '_compileddata.xlsx'], Response_List, 'Sheet1', 'C2');
% writes response list to excel file
xlswrite([dir subject_id{:} '_compileddata.xlsx'], Stimulus_List', 'Sheet1', 'D2');
% writes response list to excel file
xlswrite([dir subject_id{:} '_compileddata.xlsx'], correct', 'Sheet1', 'E2');
toc
disp(['SiN response file has been generated for subject ' subject_id{:} ] )
disp([subject_id{:} ' had ' num2str(size(Response_List,1)) ' Responses '] )