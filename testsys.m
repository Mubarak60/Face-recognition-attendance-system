
% function for dataset traing accurancy
function recognition_rate = testsys(myDatabase,minmax)
%test images which are not in train images
ufft = [2 3 4 7 9 1];
total = 0;
%veriable for recognition_rate
recognition_rate = 0;
fprintf('Please Wait...\n');

%Define image data folder
data_folder_contents = dir ('./data');

%Define number of folder
number_of_folders_in_data_folder = size(data_folder_contents,1);
person_index = 0;

%for loop for folder in data
for person=1:number_of_folders_in_data_folder
    if (strcmp(data_folder_contents(person,1).name,'.') || ...
        strcmp(data_folder_contents(person,1).name,'..') || ...
        (data_folder_contents(person,1).isdir == 0))
        continue;
    end
    person_index = person_index+1;
    person_name = data_folder_contents(person,1).name;
    fprintf([person_name,'\n']);
    % Only Jpg formate
    person_folder_contents = dir(['./data/',person_name,'/*.jpg']);    
    for face_index=1:size(ufft,2)
        total = total + 1;
        filename = ['./data/',person_name,'/',person_folder_contents(ufft(face_index),1).name];        
        answer_person_index = facerectrain(filename,myDatabase,minmax);
        if (answer_person_index == person_index)
            recognition_rate = recognition_rate + 1;
        end        
    end
end
recognition_rate = recognition_rate/total*100;
fprintf(['\nRecognition Rate is ',num2str(recognition_rate),'%% for a total of ',num2str(total),' unseen faces.\n']);


% error log file incase if the  recognition_rate has gone below 50%
minVal = 50;
if ( recognition_rate >= minVal)
 
 disp('Value is above than minimum value.')
    
else
    
   fid = fopen('Error/errorFile','a+');

   fprintf(fid,'.\n' );
  
   fprintf(fid,'bad result');
 
end








