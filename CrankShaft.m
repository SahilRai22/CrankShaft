%Sahil Rai
%CrankShaft 
%First edit 20/04/2020
%Current date 07/05/2020

%% --- clear space ---
clear; % removes previous data and values from work space
clc; % clears the command window

disp('Crank shaft model');%prints title

%% --- Inputs of coefficient ---

l = input(" enter crank length (m)"); %input function which stores the value in variable l representing the crank length
while isempty(l) % when no value is inputted into variable u the following code runs
    disp('error, value for crank length is not given') % prints text
    l =input('enter crank length (m)'); % requires user to input value to variable again
end
r = input(" enter rotator arm radius(m)"); %input function which stores the value in variable r representing the crank lengt
while isempty(r) % when no value is inputted into variable u the following code runs
    disp('error, value for rotator arm is not given') % prints text
    r =input('enter rotator arm radius(m)'); % requires user to input value to variable again
end


%% --- error corrections  ---
if r <l %if r value is less than l value the loop below runs until requirements are satisfied, to ensure that rotator arm radius is always greater than the crank length
    disp("error rotator arm radius must be greater than crank length")%prints text 
    l= input("enter crank length (m) ");%stores input into the l variable and also prints text
    r= input("enter rotator arm radius(m)");%stores input into the r variable and also prints text
    
elseif l==r %if l value and r value are the same the loop below runs until requirements are satisfied 
    disp("error rotator arm radius must be greater than crank length")
    l= input("enter crank length (m) ");
    r= input("enter rotator arm radius(m)");

end 
%% ---  angular speed ---
w = input(" enter angular speed (rad/s)");
while isempty(w) % when no value is inputted into variable u the following code runs
    disp('error, value for angular speef is not given') % prints text
    w =input('enter angular speed'); % requires user to input value to variable again
end

%% --- limits and data arrangement --- 
range= 0:360; %0-360 deg rotation
angle_1 = asind(l*sind(range)/r); % angle for rotation

%% --- Velocty and acceleration ---
velocity=w*((sind(0+angle_1))./(sind(90-angle_1))); %equation to calculate velocity at certain point of the angle
acceleration = (velocity/r); % equation to work out acceleratioon
%% --- Graph ---
tiledlayout(2,1);%lay out to place two graph plots into one figure
nexttile;%seperates the different plots 
plot(range,velocity,'x');% plots a graph on x and y axis (range,velocity) (x,y)
hold on %allows another plot to be in the graph
plot(range,acceleration,'-');% plots a graph on x and y axis (range,acceleration) (x,y)
hold on
axis([0, l+360, -w*(1/2), w*(1/2)]);%axis is fitted to match one full circle rotation and scales against speed
        
grid on %grids the background
title('Graph')%labels title
xlabel('angle') % labels x axis 
ylabel('velocity(m/s) & acceleration(m/s^2)') % labels y axis
legend('velocity','acceleration')%data text label within the plot 
 
%% --- Crank shaft model loop --- 
nexttile;%second function use to plot the for loop below on the same figure       
for t=1:500 % for loop used to repeat the statements arranged below
    theta = w*(t/100); % t variable used for time, which is aranged to control the angular speed 
    
    K = [0 0]; % fixed point where the crank length begins 
    r_piston = r/10; % r is divided to 1/10 to original value in order to scale down the size of piston 
    X=[0 0 0]; % axis point of X value
            
    Y=[0 r r+l]; % axis point of Y value        
    set(gca,'DataAspectRatio',[1 1 1]) % sets 3 element vector which are equal towards all direction      
    grid on % creates a grid like background 
    hold on% use to retain previous plots made so there are no inconsistenty within the crank shaft model

    K1 = l*[cos(theta) sin(theta)]; % point K1, where the crank length is multiplied into cos and sin equation
    angle = asin(l*sin(theta)/r); % angle for rotation    
    K2 = [(l*cos(theta) + r*cos(angle)) 0];% the crank line which supports the piston pin  
    X_Piston=[K2(1)-r_piston K2(1)+r_piston K2(1)+r_piston K2(1)-r_piston K2(1)-r_piston]; % calcuates the iteration of x coordinates for the loop   
    Y_Piston=[0+r_piston 0+r_piston 0-r_piston 0-r_piston 0+r_piston];  % calcuates the iteration of y coordinates for the loop
    g = plot(X_Piston,Y_Piston,'r','LineWidth',4,'XDataSource','X_Piston','YDataSource','Y_Piston'); % line plots to produce square    
    axis(gca,'equal') %ensure the aspect ratio is equal when scaling across x and y axis
    axis([-l, 6*l, -r, r])%set axis range limits in terms of axis([xmin, xmax, ymin, ymax]), l variable are multiplied to ensure plots are large enough to see 
     
    crank = line([K(1), K1(1)],[K(2), K1(2)]); % the crank line 
    slider = line([K1(1), K2(1)], [K1(2), K2(2)]); % the slider line which is connected to different points 
    K1_traj = viscircles([0 0],l,'Color','blue'); % viscvircles(n/a,n/a)draws circles whith specified centre, and radii
   
    title('Crank shaft model')   
    xlabel('meters') % labels x axiss 
    ylabel('meters') % labels y axis
              
    K_circle = viscircles(K,0.1); % variable K_circle stores the command creating a circle with a centre of 'K' and radii of 0.1
    K1_circle = viscircles(K1,0.1); % same function as K_circle but used for K1_circ point 
        
    pause(0.001); % sets constant intervals
      
    %delete function used to remove the previous line, hence there are no    
    %overlapping movements of the variables below  
    delete(crank);
    delete(K_circle);   
    delete(K1_circle);    
    delete(slider);
    delete(g);
    
end
      

