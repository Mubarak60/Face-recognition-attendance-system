
close all;
clc;

if (exist('DATABASE.mat','file'))
    load DATABASE.mat;
end
while (1==1)
    choice=menu('WelCome To Face Recognition Attandence system',...
                '1.Generate Database',...
                '2.Recognize from Image',...
                '3.Recognize from Webcam',...
                '4.Upload the Image',....
                '5.Exit');
            
    if (choice ==1)
        if (~exist('DATABASE.mat','file'))
            [myDatabase,minmax] = gendata();        
        else
            pause(0.1);    
            choice2 = questdlg('Generating a new database will remove any previous trained database. Are you sure?', ...
                               'Warning...',...
                               'Yes', ...
                               'No','No');            
            
        end        
    end
   
    if (choice == 2)
        if (~exist('myDatabase','var'))
            fprintf('Please generate database first!\n');
        else            
            pause(0.1);            
            [file_name ] = uigetfile ({'*.pgm';'*.jpg';'*.png'});
            if file_path ~= 0
                filename = [file_path,file_name];                
                facerec (filename,myDatabase,minmax);                        
            end
        end
    end
    if (choice == 3)
        
         
        I = getcam();
        if (~isempty(I))           
            filename = ['./Capture/',num2str(floor(rand()*10)+1),'.jpg'];
            imwrite(I,filename);
        

            if (exist('myDatabase','var'))
                facerec (filename,myDatabase,minmax);
            end
        end
    end
    
    
     if (choice == 4)
        I = getcam();
        H = FaceDetection();
        if (~isempty(I))           
            filename = ['./upload/',num2str(floor(rand()*10)+1),'.jpg'];
            imwrite(I,filename);
           % if (exist('myDatabase','var'))
              %  facerec (filename,myDatabase,minmax);
           % end
        end
     end
     
    if (choice == 5)
        clear choice choice2
        
        login();
    end    
end