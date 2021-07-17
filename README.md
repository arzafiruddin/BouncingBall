# BouncingBall

## Description
Takes video of bouncing ball, calculates it's coefficient of restitution, and plots it's kinematics, energy, and bounce heights over time.

## Methods
The ball is tracked at it's centroid by RGB thresholding each frame of the video into a binary frame (as shown in *FIGURE 1*) as a matrix (2-dimensional array). The custom function `Centroid.m` determines the binary row and column with the highest binary sums, of which it uses to determine the centroid of the ball in that frame. The height of the centroid is determined by subtracting it the minimum centroid height (the maximum row number) from the current centroid height (the current row number). This height is recorded over time, after which the first and second derivatives are taken to determine the velocity and acceleration, respectively, all of which are plotted (as seen in *FIGURE 2*). The distinct peaks in the height data are used to determine each bounces' height (as seen in *FIGURE 3*). The kinematics data is used to plot the potential, kinetic, and total energy of the system as it bounces (as seen in *FIGURE 4*). The average coefficient of restitution is printed to the MATLAB Command Window (as seen in *FIGURE 5*) using the maximum potential energy before and after each bounce as described below:

<img src="https://latex.codecogs.com/svg.image?e&space;=&space;\sqrt{\frac{PE_{after}}{PE_{before}}}" title="e = \sqrt{\frac{PE_{after}}{PE_{before}}}" />


*ORIGINAL VIDEO* and *FIGURE 1*

<img src="https://github.com/arzafiruddin/BouncingBall/blob/00c76fe21227c41f35e33384d53dd3c704b1b372/readme_assets/balloriginalgif.gif" width="224" height="390"> &nbsp; <img src="https://github.com/arzafiruddin/BouncingBall/blob/00c76fe21227c41f35e33384d53dd3c704b1b372/readme_assets/ballanalysisgif.gif" width="468" height="390">

*FIGURE 2*

<img src="https://github.com/arzafiruddin/BouncingBall/blob/00c76fe21227c41f35e33384d53dd3c704b1b372/readme_assets/ballkinematics.jpg" width="446" height="394">

*FIGURE 3*

<img src="https://github.com/arzafiruddin/BouncingBall/blob/00c76fe21227c41f35e33384d53dd3c704b1b372/readme_assets/ballheight.jpg" width="446" height="394">

*FIGURE 4*

<img src="https://github.com/arzafiruddin/BouncingBall/blob/00c76fe21227c41f35e33384d53dd3c704b1b372/readme_assets/balldynamics.jpg" width="446" height="394">

*FIGURE 5*

<img src="https://github.com/arzafiruddin/BouncingBall/blob/00c76fe21227c41f35e33384d53dd3c704b1b372/readme_assets/ballcor.jpg" width="557" height="118">

## Acknowledgments
- Dr. Naji Husseini, PhD (North Carolina State University - Department of Biomedical Engineering) aided in developed of `Centroid.m` program as part of BMME 201 course

