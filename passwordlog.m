clc

userdef='5';

passdef='5';
for n = 1:3
    
userin=input('Username: ','s');

passin=input('Password: ','s');

a=length(userin); a1=length(userdef);

b=length(passin); b1=length(passdef);




if(a==a1 && b==b1)

    if(userin==admin && passin==admin) 
        fprintf('Correct!');
         mainmenu();
    else
      
        fprintf('Wrong! Please try again' );
    end
else

    fprintf('Wrong! Please try again');
     
end
end