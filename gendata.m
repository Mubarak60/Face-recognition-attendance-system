
%Function for generation Database
function [myDatabase,minmax] = gendata()


eps=.000001;
%Below array file names will be train
ufft = [1 5 6 8 10];

%define number of person count 


numberOfDirectories =77;


fprintf ('Loading Faces ...\n');
try
    %person image folder path
data_folder_contents = dir ('./data');

%initial the database
myDatabase = cell(0,0);
person_index = 0;
max_coeffs = [-Inf -Inf -Inf]; % inf
min_coeffs = [ Inf  0  0];

%initial the folder name into person name

for person=1:size(data_folder_contents,1);
    if (strcmp(data_folder_contents(person,1).name,'.') || ...
        strcmp(data_folder_contents(person,1).name,'..') || ...
        (data_folder_contents(person,1).isdir == 0))
        continue;
        
 %for loop for image folder and person image array   
    end
    person_index = person_index+1;
    person_name = data_folder_contents(person,1).name;
    myDatabase{1,person_index} = person_name;
    fprintf([person_name,' ']);
    person_folder_contents = dir(['./data/',person_name,'/*.jpg']);  
    blk_cell = cell(0,0);
    %selected 5 images into loop
    for face_index=1:5
        I = imread(['./data/',person_name,'/',person_folder_contents(ufft(face_index),1).name]);
        I = imresize(I,[56 46]);
        I = ordfilt2(I,1,true(3));
        blk_index = 0;
        
        %extract the block into 52 HMM
        for blk_begin=1:52
            blk_index=blk_index+1;
            blk = I(blk_begin:blk_begin+4,:); %?     
 
                 %SVD extract the feature   
            [U,S,] = svd(double(blk));
            blk_coeffs = [U(1,1) S(1,1) S(2,2)];
            max_coeffs = max([max_coeffs;blk_coeffs]);
            min_coeffs = min([min_coeffs;blk_coeffs]);
            blk_cell{blk_index,face_index} = blk_coeffs;
        end
    end
    myDatabase{2,person_index} = blk_cell;
    %define 10 image per person
    if (mod(person_index,10)==0)
        fprintf('\n');
      
    end
end


delta = (max_coeffs-min_coeffs)./([18 10 7]-eps);
minmax = [min_coeffs;max_coeffs;delta];

%incres by image name folder
for person_index=1:numberOfDirectories
    for image_index=1:5
        for block_index=1:52
            blk_coeffs = myDatabase{2,person_index}{block_index,image_index};
            min_coeffs = minmax(1,:);
            delta_coeffs = minmax(3,:);
            qt = floor((blk_coeffs-min_coeffs)./delta_coeffs);
            myDatabase{3,person_index}{block_index,image_index} = qt;
            label = qt(1)*10*7+qt(2)*7+qt(3)+1;            
            myDatabase{4,person_index}{block_index,image_index} = label;
        end
        myDatabase{5,person_index}{1,image_index} = cell2mat(myDatabase{4,person_index}(:,image_index));
    end
end

TRGUESS = ones(7,7) * eps;
TRGUESS(7,7) = 1;
for r=1:6
        TRGUESS(r,r) = 0.6;
        TRGUESS(r,r+1) = 0.4;    
end

EMITGUESS = (1/1260)*ones(7,1260);

fprintf('\nTraining ...\n');
%increase by image data
for person_index=1:numberOfDirectories
    fprintf([myDatabase{1,person_index},' ']);
    seqmat = cell2mat(myDatabase{5,person_index})';
    [ESTTR,ESTEMIT]=hmmtrain(seqmat,TRGUESS,EMITGUESS,'Tolerance',.01,'Maxiterations',10,'Algorithm', 'BaumWelch');
    ESTTR = max(ESTTR,eps);
    ESTEMIT = max(ESTEMIT,eps);
    myDatabase{6,person_index}{1,1} = ESTTR;
    myDatabase{6,person_index}{1,2} = ESTEMIT;
    if (mod(person_index,10)==0)
        fprintf('\n');
           imshow(I) 
        
    end
end
fprintf('done.\n');
save DATABASE myDatabase minmax


%Error log for image missing and others

catch err
   %open file
   fid = fopen('Error/errorFile','a+');
   % write the error to file
   % first line: message
 fprintf(fid,'.\n');
   fprintf(fid,'%s\n',err.message );
   fprintf(fid,'Assinged users images are missing');

   % close file

end
