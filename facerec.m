%function for face recognition
function [person_index,maxlogpseq] = facerec(filename,myDatabase,minmax)

%read the selected image
I = imread(filename);
try
    
%Converted into grey
    I = rgb2gray(I);                
end
%Resize due to memory process
I = imresize(I,[56 46]);

    imshow(I)
%blured the image due to light effects
I = ordfilt2(I,1,true(3));

%verable for min and max coeffs
min_coeffs = minmax(1,:);
max_coeffs = minmax(2,:);
delta_coeffs = minmax(3,:);
seq = zeros(1,52);

%Vector formula 
for blk_begin=1:52    
    blk = I(blk_begin:blk_begin+4,:);    
    [U,S,~] = svd(double(blk));
    blk_coeffs = [U(1,1) S(1,1) S(2,2)];
    blk_coeffs = max([blk_coeffs;min_coeffs]);        
    blk_coeffs = min([blk_coeffs;max_coeffs]);                    
    qt = floor((blk_coeffs-min_coeffs)./delta_coeffs);
    label = qt(1)*7*10+qt(2)*7+qt(3)+1;                   
    seq(1,blk_begin) = label;
    imshow(I)
end     

%define number of persone in databas
number_of_persons_in_database = size(myDatabase,2);
results = zeros(1,number_of_persons_in_database);
for i=1:number_of_persons_in_database    
    TRANS = myDatabase{6,i}{1,1};
    EMIS = myDatabase{6,i}{1,2};
    [~,logpseq] = hmmdecode(seq,TRANS,EMIS);    
    P=exp(logpseq);
    results(1,i) = P;
end


[maxlogpseq,person_index] = max(results);
fprintf(['This person is ',myDatabase{1,person_index},'.\n']);


%verable for recognized person
reco_person=(myDatabase{1,person_index});


r=([myDatabase{1,person_index},'.html']);
url = ['file:///C:\xampp\htdocs\Attandence system\UserSite',r];


Input_folder = '.\Capture\'; % folder with big images
Output_folder = ['C:\xampp\htdocs\Attandence system\FaceReg\data\',reco_person,'\'];
Output_folder_Log ='C:\xampp\htdocs\Attandence system\FaceReg\CaptureLog\';
%D = dir([Input_folder '1.jpg']);
D = dir([Input_folder '*.jpg']);
Inputs = {D.name}';
Outputs = Inputs; % preallocate
OutputsLog = Inputs; 


for k = 1:length(Inputs)
    X = imread([Input_folder Inputs{k}]);
    idx = k; % index number
    Outputs{k} = regexprep(Outputs{k}, 'big', ['small_' num2str(idx)]);
    OutputsLog{k} = regexprep(OutputsLog{k}, 'big', ['small_' num2str(idx)]);
    imwrite(X, [Output_folder Outputs{k}],'jpg')
     fprintf('1.overright the database');
    imwrite(X, [Output_folder_Log OutputsLog{k}],'jpg')
     fprintf('2.Log file updated');
end


filenameLog = ['./CaptureLog/',reco_person,'.jpg'];
 fprintf('3.Log file updated real image');
imwrite(I,filenameLog);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%% Reading of a RGB image

l=imread('C:\xampp\htdocs\Attandence system\SourcePHP\images\1.jpg');
%I=rgb2gray(i);
BW=im2bw(l);
figure,imshow(BW)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% minimisation of background portion

[n1, n2]=size(BW);
r=floor(n1/10);
c=floor(n2/10);
x1=1;x2=r;
s=r*c;

for l=1:10
    y1=1;y2=c;
    for j=1:10
        if (y2<=c || y2>=9*c) || (x1==1 || x2==r*10)
            loc=find(BW(x1:x2, y1:y2)==0);
            [o , ~]=size(loc);
            pr=o*100/s;
            if pr<=100
                BW(x1:x2, y1:y2)=0;
                r1=x1;r2=x2;s1=y1;s2=y2;
                pr1=0;
            end
            imshow(BW);
        end
            y1=y1+c;
            y2=y2+c;
    end
    
 x1=x1+r;
 x2=x2+r;
end
 figure,imshow(BW)
 
 filenameLog = ['./CaptureLog/',reco_person,'DectectionBW.jpg'];
imwrite(BW,filenameLog);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% detection of face object

L = logical(BW,8);
BB  = regionprops(L, 'BoundingBox');
BB1=struct2cell(BB);
BB2=cell2mat(BB1);

[~, s2]=size(BB2);
mx=0;
for k=3:4:s2-1
    p=BB2(1,k)*BB2(1,k+1);
    if p>mx && (BB2(1,k)/BB2(1,k+1))<1.8
        mx=p;
        j=k;
    end
end

hold on;
rectangle('Position',[BB2(1,j-2),BB2(1,j-1),BB2(1,j),BB2(1,j+1)],'EdgeColor','r' )


figure,imshow(l);
filenameLog = ['./CaptureLog/',reco_person,'Dectection.jpg'];
imwrite(l,filenameLog);

end




