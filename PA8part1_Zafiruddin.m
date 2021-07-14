% Ameen Rasheed Zafiruddin
% ameenrz@email.unc.edu
% 06/18/2021
% PA8part1_Zafiruddin.m
%
% Takes video of bouncing ball and calculates the coefficient of 
% restitution and plots the vertical kinematics, energy, and bounce heights
% of the ball. (Part 1: Naji's Video)

clear
close all
clc 

%% Declarations

% CONSTANTS AND INITIALIZATIONS
G = -9.81; % acceleration of sgravity (m/s^2)
pX = []; % initializes x position array
pY = []; % initializes y position array

% BALL PROPERTIES
ballMass = 0.03; % ball mass (kg)
ballDIn = 4; % ball diameter (in)
ballDPx = 130; % ball diameter (px)
px2m = (ballDIn*0.0254) / ballDPx; % pixel to meter conversion factor
bounceCount = 4; % Number of clearly observed bounces

% VIDEO INFORMATION
vidFile = 'bounce.avi'; % file name of video (w/ extension)
frameStart = 10; % starting frame for analysis
frameStop = 85; % ending frame for analysis

% LOAD VIDEO
vid = VideoReader(vidFile); % reads in .avi file

% VIDEO CROPPING DIMENSIONS
xCropO = 725; % top-left x (col) point of crop
yCropO = 1; % top-left y (row) point of crop
xCropL = 375; % horizontal length of crop
yCropL = 720; % vertical length of crop

% RGB THRESHOLDING VALUES
thUR = 255; % red upper threshold (0-255)
thLR = 120; % red lower threshold (0-255)
thUG = 170; % green upper threshold (0-255)
thLG = 20; % green lower threshold (0-255)
thUB = 130; % blue upper threshold (0-255)
thLB = 0; % blue lower threshold (0-255)

%% Threshold Video

% % Reports the binary width and height of the ball at a specific frame
% % along with the binary and original image. Used to determine pixel
% % diameter of the ball by finding a clear frame w/o motion blur.
% dVid = read(vid, 35);
% dVid = imcrop(dVid, [xCropO,yCropO,xCropL,yCropL]);
% dR = dVid(:,:,1);
% dG = dVid(:,:,2);
% dB = dVid(:,:,3);
% dTh = (dR <= thUR) & (dR >= thLR) & (dG <= thUG) & ...
%         (dG >= thLG) & (dB <= thUB) & (dB >= thLB);
% [dCntrRow, dCntrCol] = Centroid(dTh);
% dSumRow = sum(dTh,2)';
% dSumCol = sum(dTh);
% max(dSumRow)
% max(dSumCol)
% figure(5)
% subplot(1,2,1)
% imshow(dVid)
% subplot(1,2,2)
% imshow(dTh)

% steps through each frame of video (from 'frameStart' to 'frameStop')
for k = frameStart:frameStop

    frameSlice = read(vid, k); % loads frame 'k' into 'frameSlice'
    
    % crops image
    frameSlice = imcrop(frameSlice, [xCropO, yCropO, xCropL, yCropL]);
    
    % assigns each color layer to a separate variable
    frameR = frameSlice(:,:,1);
    frameG = frameSlice(:,:,2);
    frameB = frameSlice(:,:,3);
    
    % creates a binary frame based on the RBG threshold values
    frameTh = (frameR <= thUR) & (frameR >= thLR) & (frameG <= thUG) & ...
        (frameG >= thLG) & (frameB <= thUB) & (frameB >= thLB);
    
    % uses custom function 'Centroid' to return x (col) and y (row) 
    % coordinates of ball's center (centroid) given the binary image file
    % 'frameTh'
    [cntrRow, cntrCol] = Centroid(frameTh);
    
    % adds x and y coordinate to their respective position arrays
    pY = [pY, cntrRow]; %#ok<AGROW> supresses error
    pX = [pX, cntrCol]; %#ok<AGROW> supresses error
    
    figure(1)
    subplot(1,2,1) % displays the binary image of frame 'k'
        imshow(frameTh)
        % titles binary image
        title('Binary Video')
    subplot(1,2,2) % plots centroid movement dynamically
        plot(pX, (vid.Height - pY), 'b-', ...
            cntrCol, (vid.Height - cntrRow), 'rx', 'MarkerSize', 10)
        % fixes/locks x and y axes' limits
        axis([1, xCropL, 1, yCropL])
        % removes x and y axes
        set(gca, 'xtick', [])
        set(gca, 'ytick', [])
        % sets aspect ratio of plot to that of video
        pbaspect([1, 1.9, 1])
        % titles centroid plot
        title('Centroid')
        
    drawnow % forces figure to appear and quickly pauses 
end

%% Kinematics (Position, Velocity, and Acceleration)

% calculates the time length of cut video
time = [0:(frameStop - frameStart)] ./ vid.FrameRate; %#ok<NBRAK> supresses error

% corrects centroid y position (mirrors over horizontal axis and converts 
% units from px to m)
pY = (vid.Height - pY) * px2m;

% calculates velocity and acceleration
vY = gradient(pY, time);
aY = gradient(vY, time);

figure(2)
subplot(3,1,1) % plots position versus time
    plot(time, (pY - pY(end)), 'LineWidth', 1, 'Color', '#0072BD')
    % labels axes and titles position plot
    xlabel('Time (s)')
    ylabel('Height (m)')
    title('Height of Ball over Time')
subplot(3,1,2) % plots velocity versus time
    plot(time, vY, 'LineWidth', 1, 'Color', '#77AC30')
    % labels axes and titles velocity plot
    xlabel('Time (s)')
    ylabel('Velocity (m/s)')
    title('Velocity of Ball over Time')
subplot(3,1,3) % plots acceleration versus time
    hold on
    plot(time, aY, 'LineWidth', 1, 'Color', '#D95319')
    % plot([time(1), time(end)], [G, G], 'r--') % plots 'G' as line
    hold off
    % labels axes and titles acceleration plot
    xlabel('Time (s)')
    ylabel('Acceleration (m/s^2)')
    title('Acceleration of Ball over Time')
    
%% Bounce Heights & Coefficient of Restitution

% finds maximum height after each bounce
[pks, idx] = findpeaks(pY);

figure(3) % plots peak heights as a stem plot
    stem(0:bounceCount, pks(1:bounceCount+1))
    % sets x axis limits
    xlim([-0.9, bounceCount+0.9])
    % labels axes and titles bounce plot
    xlabel('Number of Bounces')
    ylabel('Max Height (m)')
    title('Max Bounce Height after Each Bounce')
    % removes all uncessary ticks on x axis
    set(gca, 'XTick', 0:bounceCount)

% calculates coefficient of restitution
e = mean( sqrt( pks(2:bounceCount+1) ./ pks(1:bounceCount) ) );

% prints coefficient of restitution to Command Window
fprintf("Average Coefficient of Restitution: %.3f\n", e)

%% Energy

% calculates total, potential, kinentic energy (J) from position & velocity
PE = ballMass * -G .* (pY - pY(end));
KE = (1/2) * ballMass .* (vY.^2);
totalE = PE + KE;

figure(4) % plots total, potential, and kinetic energy vs time
    plot(time, PE, time, KE, time, totalE, '--', 'LineWidth', 1)
    % adds legend descriptions
    legend('Potential Energy', 'Kinetic Energy', 'Total Energy')
    % labels axes and titles energy plot
    xlabel('Time (s)')
    ylabel('Energy (J)')
    title('Energy of Ball over Time')